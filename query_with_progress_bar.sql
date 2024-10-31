WITH lot_stats AS (
  select 
    l.lot_number, 
    (
      select 
        count(s.*) 
      from 
        sample s 
      where 
        s.lot = l.lot_number 
        and s.status = 'U'
    ) as unreceived_samples, 
    (
      select 
        count(s.*) 
      from 
        sample s 
      where 
        s.lot = l.lot_number 
        and s.status = 'I'
    ) as incomplete_samples, 
    (
      select 
        count(s.*) 
      from 
        sample s 
      where 
        s.lot = l.lot_number 
        and s.status in ('P', 'C')
    ) as inprogress_samples, 
    (
      select 
        count(s.*) 
      from 
        sample s 
      where 
        s.lot = l.lot_number 
        and s.status in ('A', 'R', 'X')
    ) as reviewed_samples, 
    (
      select 
        count(s.*) 
      from 
        sample s 
      where 
        s.lot = l.lot_number
    ) as total_samples, 
    (
      select 
        count(lsp.*) 
      from 
        lot_sampling_point lsp 
      where 
        lsp.lot_number = l.lot_number
    ) as num_lots, 
    (
      select 
        count(lsp.*) 
      from 
        lot_sampling_point lsp 
      where 
        lsp.lot_number = l.lot_number 
        and lsp.disposition is not null
    ) as disp_lots 
  from 
    lot l
) 
select 
  l.lot_number, 
  l.lot_name, 
  case when ls.total_samples = 0 then '' else concat(
    '<div class=''progress'' style=''max-width: 100%; position: relative;''><svg width=''100%'' height=''24px''>', 
    case when ls.unreceived_samples = 0 then '' else concat(
      '<rect x=0% width=''', 
      ROUND(
        CAST(
          ls.unreceived_samples AS NUMERIC(18, 9)
        )/ CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '%'' height=''24px'' style=''fill:#9D9C9E''><title>', 
      ls.unreceived_samples, 
      ' Unreceived</title></rect>'
    ) end, 
    case when ls.incomplete_samples = 0 then '' else concat(
      '<rect x=', 
      ROUND(
        CAST(
          ls.unreceived_samples AS NUMERIC(18, 9)
        )/ CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '% width=''', 
      ROUND(
        CAST(
          ls.incomplete_samples AS NUMERIC(18, 9)
        )/ CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '%'' height=''24px'' style=''fill:#CED9E5''><title>', 
      ls.incomplete_samples, 
      ' Incomplete</title></rect>'
    ) end, 
    case when ls.inprogress_samples = 0 then '' else concat(
      '<rect x=', 
      ROUND(
        CAST(
          (
            ls.unreceived_samples + ls.incomplete_samples
          ) AS NUMERIC(18, 9)
        )/ CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '% width=''', 
      ROUND(
        CAST(
          ls.inprogress_samples AS NUMERIC(18, 9)
        )/ CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '%'' height=''24px'' style=''fill:#05868E''><title>', 
      ls.inprogress_samples, 
      ' In Progress</title></rect>'
    ) end, 
    case when ls.reviewed_samples = 0 then '' else concat(
      '<rect x=', 
      ROUND(
        CAST(
          (
            ls.unreceived_samples + ls.incomplete_samples + ls.inprogress_samples
          ) AS NUMERIC(18, 9)
        )/ CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '% width=''', 
      ROUND(
        (ls.reviewed_samples)/ CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '%'' height=''24px'' style=''fill:#135193''><title>', 
      ls.reviewed_samples, 
      ' Reviewed</title></rect>'
    ) end, 
    '</svg>', 
    '<div style=''top:0px; width:100%; height:24px;'' class=''position-absolute text-light''>', 
    case when ls.unreceived_samples = 0 then '' else concat(
      '<span style=''width:', 
      ROUND(
        ls.unreceived_samples / CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '%;height:24px;position: relative;float: left;text-align: center; margin-top:2px'' title=''', 
      ls.unreceived_samples, 
      ' Unreceived', 
      ' (', 
      ls.total_samples, 
      ' Total Lot Samples)''>', 
      ls.unreceived_samples, 
      '</span>'
    ) end, 
    case when ls.incomplete_samples = 0 then '' else concat(
      '<span style=''width:', 
      ROUND(
        ls.incomplete_samples / CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '%;height:24px;position: relative;float: left;text-align: center; margin-top:2px'' title=''', 
      ls.incomplete_samples, 
      ' Incomplete', 
      ' (', 
      ls.total_samples, 
      ' Total Lot Samples)''>', 
      ls.incomplete_samples, 
      '</span>'
    ) end, 
    case when ls.inprogress_samples = 0 then '' else concat(
      '<span style=''width:', 
      ROUND(
        ls.inprogress_samples / CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '%;height:24px;position: relative;float: left;text-align: center; margin-top:2px'' title=''', 
      ls.inprogress_samples, 
      ' In Progress', 
      ' (', 
      ls.total_samples, 
      ' Total Lot Samples)''>', 
      ls.inprogress_samples, 
      '</span>'
    ) end, 
    case when ls.reviewed_samples = 0 then '' else concat(
      '<span style=''width:', 
      ROUND(
        ls.reviewed_samples / CAST(
          ls.total_samples AS NUMERIC(18, 9)
        )* 100, 
        9
      ), 
      '%;height:24px;position: relative;float: left;text-align: center; margin-top:2px'' title=''', 
      ls.reviewed_samples, 
      ' In Progress', 
      ' (', 
      ls.total_samples, 
      ' Total Lot Samples)''>', 
      ls.reviewed_samples, 
      '</span>'
    ) end, 
    '</div></div>'
  ) end as sample_progress, 
  ic.description as product, 
  coalesce(
    c.COMPANY_NAME, '<span class=''mdi mdi-pencil-plus-outline''>'
  ) as customer, 
  l.FACILITY, 
  l.description, 
  to_char(l.date_created, 'YYYY/MM/DD') as date_created, 
  case when l.t_erp_code_group is not null then 'Yes' else 'No' end as is_erp, 
  concat (ls.disp_lots, '/', ls.num_lots) 
from 
  lot l 
  left join lot_stats ls on l.lot_number = ls.lot_number 
  left join t_ph_item_code ic on ic.name = l.t_ph_item_code 
  left outer join customer c on l.customer = c.name 
where 
  l.template in ('T0084_FP', 'T0084_RM') 
  and l.GROUP_NAME IN (
    'DEFAULT', 'AQL', 'OQ_SCRIPTS', 'USNC', 
    'SYSTEM', 'STABILITY'
  ) 
  and l.closed in ('F', 'T') 
  and (
    l.date_created between {ts '2023-01-01 00:00:00' } 
    and {ts '2024-12-07 11:59:59' }
  ) 
order by 
  l.lot_number
