use [nbndata]
go

set ansi_nulls on
go

set quoted_identifier on
go

select
    tao.taxon_occurrence_key as taxon_occurrence_key,
    tao.comment as taxon_occurrence_comment,
    ns.recommended_scientific_name as nameserver_recommended_scientific_name, 
    ns.recommended_name_authority as nameserver_recommended_name_authority, 
    ns.recommended_name_rank as nameserver_recommended_name_rank, 
    convert(datetime, sa.vague_date_start) as sample_vague_date_start, 
    convert(datetime, sa.vague_date_end) as sample_vague_date_end,
    sa.vague_date_type as sample_vague_date_type,
    inbo.ufn_RtfToPlaintext (sue.comment) as survey_event_comment, 
    sue.comment as survey_event_comment, 
    ln.item_name as location_name_item_name,
    sue.location_name as survey_event_location_name,
    sa.lat as sample_lat,
    sa.long as sample_long,
    sa.spatial_ref as sample_spatial_ref,
    sa.spatial_ref_system as sample_spatial_ref_system,
    sa.spatial_ref_qualifier as sample_spatial_ref_qualifier

from 
    dbo.survey su
    inner join dbo.survey_event sue on sue.survey_key = su.survey_key
    inner join dbo.sample sa on sa.survey_event_key = sue.survey_event_key
    inner join dbo.taxon_occurrence tao on tao.sample_key = sa.sample_key
    inner join dbo.taxon_determination td on td.taxon_occurrence_key = tao.taxon_occurrence_key
    inner join dbo.taxon_list_item tli on tli.taxon_list_item_key = td.taxon_list_item_key 
    left outer join inbo.nameserver ns on ns.inbo_taxon_version_key = tli.taxon_version_key
    left outer join dbo.taxon_version tv on tv.taxon_version_key = tli.taxon_version_key
    left outer join dbo.taxon t on t.taxon_key = tv.taxon_key
    inner join dbo.location l on l.location_key = sa.location_key
    inner join dbo.location_name ln on ln.location_key = l.location_key
    left join dbo.individual i on i.name_key = td.determiner

where
    su.item_name = 'alien macro-invertebrates in flanders'
    and ln.preferred = 1

go

