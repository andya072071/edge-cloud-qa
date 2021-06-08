*** Settings ***
Documentation   Cloudlet Edge Event Metrics Tests

Library  MexMasterController  mc_address=%{AUTOMATION_MC_ADDRESS}
Library  MexDme  dme_address=%{AUTOMATION_DME_ADDRESS}
Library  Collections

Resource  metrics_dme_library.robot

Suite Setup	Setup
Suite Teardown	Teardown Settings  ${settings_pre}

Test Timeout    240s

*** Variables ***
${region}=  US
${device_os}=  Android
${device_model}=  platos S20
${data_network_type}=  5G
${signal_strength}=  5
${signal_strength_2}=  2
${carrier_name}=  mycarrier

${cloudlet1}=  ${cloudlet_name_fake}
${cloudlet2_name}=  tmocloud-2

${cloud1_lat}=  31
${cloud1_long}=  -91
${cloud2_lat}=  35
${cloud2_long}=  -95
${cloudlet1_tile}=  -90.998922,30.984896_-91.016888,31.002985_2
${cloudlet2_tile}=  -94.987424,34.982364_-95.005390,35.000452_2
${cloudlet12_tile}=  -94.987424,30.984896_-95.005390,31.002985_2

${dme_conn_lat}=  ${cloud1_lat}
${dme_conn_long}=  ${cloud1_long}

*** Test Cases ***
# ECQ-3476
DMEMetrics - Shall be able to get the last DME Client Cloudlet Latency metric
   [Documentation]
   ...  request latency clientappusage metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get the last client cloudlet usage metric  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get the last DME Client Cloudlet DeviceInfo metric
   [Documentation]
   ...  request deviceinfo clientappusage metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get the last client cloudlet usage metric  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${metrics} 

DMEMetrics - Shall be able to get DME Client Cloudlet Latency metrics with cloudletorg only
   [Documentation]
   ...  request latency clientappusage metrics with apporg only
   ...  verify info is correct

   ${metrics}=  Get all client cloudlet usage metrics  operator_org_name=${operator_name_fake}  selector=latency

   Latency Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6 
   Latency Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  2

   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
      FOR  ${v}  IN  @{m['values']}
          Should Be True  '${v[2]}' == '${operator_name_fake}'
      END
   END

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with cloudletorg only
   [Documentation]
   ...  request deviceinfo clientappusage metrics with apporg only
   ...  verify info is correct

   ${metrics}=  Get all client cloudlet usage metrics  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
      FOR  ${v}  IN  @{m['values']}
          Should Be True  '${v[2]}' == '${operator_name_fake}'
      END
   END

DMEMetrics - Shall be able to get all DME Client Cloudlet Latency metric
   [Documentation]
   ...  request all latency clientappusage metrics
   ...  verify info is correct

   ${metrics}=  Get all client cloudlet usage metrics  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6
   Latency Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  2

   Latency Values Should Be Correct  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get all DME Client Cloudlet DeviceInfo metric
   [Documentation]
   ...  request all deviceinfo clientappusage metrics
   ...  verify info is correct

   ${metrics}=  Get all client cloudlet usage metrics  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   DeviceInfo Values Should Be Correct  ${metrics}

DMEMetrics - Shall be able to get DME Client Cloudlet Latency metrics with starttime
   [Documentation]
   ...  request latency clientappusage metrics with starttime
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with starttime   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6
   Latency Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  2

   Latency Values Should Be Correct  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with starttime
   [Documentation]
   ...  request deviceinfo clientappusage metrics with starttime
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with starttime   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   DeviceInfo Values Should Be Correct  ${metrics}

DMEMetrics - Shall be able to get DME Client Cloudlet Latency metrics with endtime
   [Documentation]
   ...  request latency clientappusage metrics with endtime
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with endtime   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with endtime
   [Documentation]
   ...  request deviceinfo clientappusage metrics with endtime
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with endtime   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   DeviceInfo Values Should Be Correct  ${metrics}

DMEMetrics - Shall be able to get DME Client Cloudlet Latency metrics with starttime and endtime
   [Documentation]
   ...  request latency clientappusage metrics with startime and endtime
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with starttime and endtime   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with starttime and endtime
   [Documentation]
   ...  request deviceinfo clientappusage metrics with startime and endtime
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with starttime and endtime   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   DeviceInfo Values Should Be Correct  ${metrics}

DMEMetrics - Shall be able to get DME Client Cloudlet Latency metrics with starttime and endtime and last
   [Documentation]
   ...  request latency clientappusage metrics with startime and endtime and last
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with starttime and endtime and last   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with starttime and endtime and last
   [Documentation]
   ...  request deviceinfo clientappusage metrics with startime and endtime and last
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with starttime and endtime and last   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   DeviceInfo Values Should Be Correct  ${metrics}

DMEMetrics - Shall be able to get DME Client Cloudlet Latency metrics with locationtile
   [Documentation]
   ...  request latency clientappusage metrics with locationtile
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with locationtile   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=latency  location_tile=${cloudlet1_tile}

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client Cloudlet Latency metrics with rawdata
   [Documentation]
   ...  request deviceinfo clientappusage metrics with locationtile
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with rawdata   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}  raw=${True}

   Latency Values Should Be Correct  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6  raw=${True}

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with rawdata
   [Documentation]
   ...  request latency clientappusage metrics with rawdata
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with rawdata   cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}  raw=${True}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   DeviceInfo Values Should Be Correct  ${metrics}  raw=${True}

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with deviceos
   [Documentation]
   ...  request deviceinfo clientappusage metrics with deviceos
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with deviceinfo   operator_org_name=${operator_name_fake}  selector=deviceinfo  device_os=${device_os}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}  

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
      FOR  ${v}  IN  @{m['values']}
          Should Be True  '${v[3]}' == '${device_os}'
      END
   END

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with devicemodel
   [Documentation]
   ...  request deviceinfo clientappusage metrics with devicemodel
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with deviceinfo   operator_org_name=${operator_name_fake}  selector=deviceinfo  device_model=${device_model}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
      FOR  ${v}  IN  @{m['values']}
          Should Be True  '${v[4]}' == '${device_model}'
      END
   END

DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with devicecarrier
   [Documentation]
   ...  request deviceinfo clientappusage metrics with datanetworktype
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with deviceinfo   operator_org_name=${operator_name_fake}  selector=deviceinfo  device_carrier=${carrier_name}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
      FOR  ${v}  IN  @{m['values']}
          Should Be True  '${v[5]}' == '${carrier_name}'
      END
   END


DMEMetrics - Shall be able to get DME Client Cloudlet DeviceInfo metrics with all deviceinfo
   [Documentation]
   ...  request deviceinfo clientappusage metrics with all deviceinfo
   ...  verify info is correct

   ${metrics}=  Get client cloudlet usage metrics with deviceinfo   operator_org_name=${operator_name_fake}  selector=deviceinfo  device_os=${device_os}  device_model=${device_model}  device_carrier=${carrier_name}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
      FOR  ${v}  IN  @{m['values']}
          Should Be True  '${v[5]}' == '${carrier_name}'
      END
   END

DMEMetrics - DeveloperManager shall not be able to get DME Client Cloudlet Latency metrics
   [Documentation]
   ...  request latency clientappusage metrics as DeveloperManager
   ...  verify metrics are returned

   DeveloperManager shall not be able to get client cloudlet usage metrics  selector=latency  operator_org_name=${operator_name_fake}  cloudlet_name=${cloudlet2_name}

DMEMetrics - DeveloperManager shall not be able to get DME Client Cloudlet DeviceInfo metrics
   [Documentation]
   ...  request deviceinfo clientappusage metrics as DeveloperManager
   ...  verify metrics are returned

   DeveloperManager shall not be able to get client cloudlet usage metrics  selector=deviceinfo  operator_org_name=${operator_name_fake}  cloudlet_name=${cloudlet2_name}

DMEMetrics - DeveloperContributor shall not be able to get DME Client Cloudlet Latency metrics
   [Documentation]
   ...  request latency clientappusage metrics as DeveloperContributor
   ...  verify metrics are returned

   DeveloperContributor shall not be able to get client cloudlet usage metrics  selector=latency  operator_org_name=${operator_name_fake}  cloudlet_name=${cloudlet2_name}

DMEMetrics - DeveloperContributor shall not be able to get DME Client Cloudlet DeviceInfo metrics
   [Documentation]
   ...  request deviceinfo clientappusage metrics as DeveloperContributor
   ...  verify metrics are returned

   DeveloperContributor shall not be able to get client cloudlet usage metrics  selector=deviceinfo  operator_org_name=${operator_name_fake}  cloudlet_name=${cloudlet2_name}

DMEMetrics - DeveloperViewer shall not be able to get DME Client Cloudlet Latency metrics
   [Documentation]
   ...  request latency clientappusage metrics as DeveloperViewer
   ...  verify metrics are returned

   DeveloperViewer shall not be able to get client cloudlet usage metrics  selector=latency  operator_org_name=${operator_name_fake}  cloudlet_name=${cloudlet2_name}

DMEMetrics - DeveloperViewer shall not be able to get DME Client Cloudlet DeviceInfo metrics
   [Documentation]
   ...  request deviceinfo clientappusage metrics as DeveloperViewer
   ...  verify metrics are returned

   DeveloperViewer shall not be able to get client cloudlet usage metrics  selector=deviceinfo  operator_org_name=${operator_name_fake}  cloudlet_name=${cloudlet2_name} 

DMEMetrics - OperatorManager shall be able to get DME Client Cloudlet Latency metrics
   [Documentation]
   ...  request latency clientappusage metrics as OperatorManager
   ...  verify metrics are returned

   ${metrics}=  OperatorManager shall be able to get client cloudlet usage metrics  selector=latency  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${metrics}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2  cloudlet=${cloudlet_name}

DMEMetrics - OperatorManager shall be able to get DME Client Cloudlet DeviceInfo metrics
   [Documentation]
   ...  request deviceinfo clientappusage metrics as OperatorManager
   ...  verify metrics are returned

   ${metrics}=  OperatorManager shall be able to get client cloudlet usage metrics  selector=deviceinfo  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   DeviceInfo Values Should Be Correct  ${metrics}

DMEMetrics - OperatorContributor shall be able to get DME Client Cloudlet Latency metrics
   [Documentation]
   ...  request latency clientappusage metrics as OperatorContributor
   ...  verify metrics are returned

   ${metrics}=  OperatorContributor shall be able to get client cloudlet usage metrics  selector=latency  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${metrics}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2  cloudlet=${cloudlet_name}

DMEMetrics - OperatorContributor shall be able to get DME Client Cloudlet DeviceInfo metrics
   [Documentation]
   ...  request deviceinfo clientappusage metrics as OperatorContributor
   ...  verify metrics are returned

   ${metrics}=  OperatorContributor shall be able to get client cloudlet usage metrics  selector=deviceinfo  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}

   DeviceInfo Values Should Be Correct  ${metrics}

DMEMetrics - OperatorViewer shall be able to get DME Client Cloudlet Latency metrics
   [Documentation]
   ...  request latency clientappusage metrics as OperatorViewer
   ...  verify metrics are returned

   ${metrics}=  OperatorViewer shall be able to get client cloudlet usage metrics  selector=latency  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${metrics}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2  cloudlet=${cloudlet_name}

DMEMetrics - OperatorViewer shall be able to get DME Client Cloudlet DeviceInfo metrics
   [Documentation]
   ...  request deviceinfo clientappusage metrics as OperatorViewer
   ...  verify metrics are returned

   ${metrics}=  OperatorViewer shall be able to get client cloudlet usage metrics  selector=deviceinfo  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=2  tile=${cloudlet1_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${operator_name_fake}  numsessions=1  tile=${cloudlet2_tile}
   DeviceInfo Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  device_carrier=${carrier_name}        numsessions=1  tile=${cloudlet1_tile}

   DeviceInfo Values Should Be Correct  ${metrics}

*** Keywords ***
Setup
    ${epoch}=  Get Time  epoch

    ${app_name}=  Get Default App Name

    Create Flavor  region=${region}

    ${cloudlet}=  Create Cloudlet  region=${region}  operator_org_name=${operator_name_fake}  latitude=${cloud1_lat}  longitude=${cloud1_long}
    ${cloudlet_name}=  Set Variable  ${cloudlet['data']['key']['name']}
    Set Suite Variable  ${cloudlet_name}

    @{cloudlet_list}=  Create List  tmocloud-2
    ${pool_return}=  Create Cloudlet Pool  region=${region}  operator_org_name=${operator_name_fake}  cloudlet_list=${cloudlet_list}
    Create Cloudlet Pool Access Invitation  region=${region}  cloudlet_pool_name=${pool_return['data']['key']['name']}  cloudlet_pool_org_name=${operator_name_fake}  developer_org_name=${developer_org_name_automation}
    Create Cloudlet Pool Access Response    region=${region}  cloudlet_pool_name=${pool_return['data']['key']['name']}  cloudlet_pool_org_name=${operator_name_fake}  developer_org_name=${developer_org_name_automation}  decision=accept

    Create App  region=${region}  app_name=${app_name}1  access_ports=tcp:1
    Create App Instance  region=${region}  app_name=${app_name}1  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster
    Create App Instance  region=${region}  app_name=${app_name}1  cloudlet_name=tmocloud-2  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster

    Create App  region=${region}  app_name=${app_name}2  access_ports=tcp:1
    Create App Instance  region=${region}  app_name=${app_name}2  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster

    Create App  region=${region}  app_name=${app_name}3  access_ports=tcp:1
    Create App Instance  region=${region}  app_name=${app_name}3  cloudlet_name=tmocloud-2  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster

    Set Suite Variable  ${app_name}

    ${settings_pre}=   Show Settings  region=${region}
    Set Suite Variable  ${settings_pre}

    @{collection_intervals}=  Create List  10s  1m10s  2m10s
    Update Settings  region=${region}  edge_events_metrics_collection_interval=10s  edge_events_metrics_continuous_queries_collection_intervals=@{collection_intervals}

    ${r1}=  Register Client  app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}	
    ${cloudlet1}=  Find Cloudlet   carrier_name=${operator_name_fake}  latitude=${cloud1_lat}  longitude=${cloud1_long}
    #${cloudlet1}=  Find Cloudlet   carrier_name=${operator_name_fake}  latitude=${cloud1_lat}  longitude=${cloud2_long}
    Should Be Equal As Numbers  ${cloudlet1.status}  1  #FIND_FOUND
    Should Be True  len('${cloudlet1.edge_events_cookie}') > 100
    Should Be Equal  ${cloudlet1.fqdn}  ${cloudlet_name}.dmuus.mobiledgex.net

    ${r2}=  Register Client  app_name=${app_name}2  app_version=1.0  developer_org_name=${developer_org_name_automation}
    ${cloudlet2}=  Find Cloudlet  carrier_name=${operator_name_fake}  latitude=${cloud1_lat}  longitude=${cloud1_long}
    Should Be Equal As Numbers  ${cloudlet2.status}  1  #FIND_FOUND
    Should Be True  len('${cloudlet2.edge_events_cookie}') > 100
    Should Be Equal  ${cloudlet2.fqdn}  ${cloudlet_name}.dmuus.mobiledgex.net

    ${r3}=  Register Client  app_name=${app_name}3  app_version=1.0  developer_org_name=${developer_org_name_automation}
    ${cloudlet3}=  Find Cloudlet  carrier_name=${operator_name_fake}  latitude=${cloud2_lat}  longitude=${cloud2_long}
    Should Be Equal As Numbers  ${cloudlet3.status}  1  #FIND_FOUND
    Should Be True  len('${cloudlet3.edge_events_cookie}') > 100
    Should Be Equal  ${cloudlet3.fqdn}  ${cloudlet2_name}.dmuus.mobiledgex.net

    @{samples1}=  Create List  ${10.4}  ${4.20}  ${30}  ${440}  ${0.50}  ${6.00}  ${170.45}
    ${num_samples1}=  Get Length  ${samples1}

    # connect to cloud1
    Create DME Persistent Connection  carrier_name=${carrier_name}  session_cookie=${r1.session_cookie}  edge_events_cookie=${cloudlet1.edge_events_cookie}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}c1
    ${latency11}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency21}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency31}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency41}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency51}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency61}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    #Sleep  3s
    # this should return cloud2 
    ${lu}=  Send Location Update Edge Event  carrier_name=${operator_name_fake}  latitude=${cloud2_lat}  longitude=${cloud2_long}  signal_strength=${signal_strength}  data_network_type=${data_network_type}l1
    Should Be Equal As Numbers  ${lu.new_cloudlet.status}  1  #FIND_FOUND
    Should Be Equal  ${lu.new_cloudlet.fqdn}  tmocloud-2.dmuus.mobiledgex.net
    # connection to cloud2
    Create DME Persistent Connection  carrier_name=${carrier_name}  session_cookie=${r1.session_cookie}  edge_events_cookie=${lu.new_cloudlet.edge_events_cookie}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}c2
    # this should return cloud1
    ${lu3}=  Send Location Update Edge Event  carrier_name=${operator_name_fake}  latitude=${cloud1_lat}  longitude=${cloud1_long}  signal_strength=${signal_strength}  data_network_type=${data_network_type}l2
    Should Be Equal As Numbers  ${lu3.new_cloudlet.status}  1  #FIND_FOUND
    Should Be Equal  ${lu3.new_cloudlet.fqdn}  ${cloudlet_name}.dmuus.mobiledgex.net
    # connect back to cloud1 with same deviceinfo
    Create DME Persistent Connection  carrier_name=${carrier_name}  session_cookie=${r1.session_cookie}  edge_events_cookie=${lu3.new_cloudlet.edge_events_cookie}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}c1
    # this should return cloud2
    ${lu4}=  Send Location Update Edge Event  carrier_name=${operator_name_fake}  latitude=${cloud2_lat}  longitude=${cloud2_long}  signal_strength=${signal_strength_2}  data_network_type=${data_network_type}l3
    Should Be Equal As Numbers  ${lu4.new_cloudlet.status}  1  #FIND_FOUND
    Should Be Equal  ${lu4.new_cloudlet.fqdn}  tmocloud-2.dmuus.mobiledgex.net

#    Terminate DME Persistent Connection

    Create DME Persistent Connection  carrier_name=${carrier_name}  session_cookie=${r2.session_cookie}  edge_events_cookie=${cloudlet2.edge_events_cookie}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency12}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency22}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
#    Terminate DME Persistent Connection
#
    Create DME Persistent Connection  carrier_name=${carrier_name}  session_cookie=${r3.session_cookie}  edge_events_cookie=${cloudlet3.edge_events_cookie}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency13}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    ${latency23}=  Send Latency Edge Event  carrier_name=${carrier_name}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    #Terminate DME Persistent Connection

    Sleep  20s
#    ${metrics1}=  Get Client App Metrics  region=${region}  app_name=${app_name}  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency

    Sleep  60s
#    ${metrics2}=  Get Client App Metrics  region=${region}  app_name=${app_name}  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency
    
    Sleep  70s
#    ${metrics31}=  Get Client App Metrics  region=${region}  app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency
#    ${metrics32}=  Get Client App Metrics  region=${region}  app_name=${app_name}2  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency
#    ${metrics33}=  Get Client App Metrics  region=${region}  app_name=${app_name}3  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency
#
#    Should Be Equal  ${metrics31['data'][0]['Series'][0]['name']}  latency-metric-2m10s
#    Should Be Equal  ${metrics31['data'][0]['Series'][1]['name']}  latency-metric-1m10s
#    Should Be Equal  ${metrics31['data'][0]['Series'][2]['name']}  latency-metric-10s
#    Should Be Equal  ${metrics32['data'][0]['Series'][0]['name']}  latency-metric-2m10s
#    Should Be Equal  ${metrics32['data'][0]['Series'][1]['name']}  latency-metric-1m10s
#    Should Be Equal  ${metrics32['data'][0]['Series'][2]['name']}  latency-metric-10s
#    Should Be Equal  ${metrics33['data'][0]['Series'][0]['name']}  latency-metric-2m10s
#    Should Be Equal  ${metrics33['data'][0]['Series'][1]['name']}  latency-metric-1m10s
#    Should Be Equal  ${metrics33['data'][0]['Series'][2]['name']}  latency-metric-10s
#    
#    Metrics Headings Should Be Correct  ${metrics31['data'][0]['Series'][0]['columns']}
#    Metrics Headings Should Be Correct  ${metrics32['data'][0]['Series'][1]['columns']}
#    Metrics Headings Should Be Correct  ${metrics33['data'][0]['Series'][2]['columns']}
#
#    Values Should Be Correct  ${app_name}1  ${metrics31['data'][0]['Series'][0]['values']}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6
#    Values Should Be Correct  ${app_name}2  ${metrics32['data'][0]['Series'][1]['values']}  ${latency12.statistics.max}  ${latency12.statistics.min}  ${latency12.statistics.avg}  ${latency12.statistics.std_dev}  ${latency12.statistics.variance}  ${num_samples1}  2
#    Values Should Be Correct  ${app_name}3  ${metrics33['data'][0]['Series'][2]['values']}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2

    Set Suite Variable  ${latency11}
    Set Suite Variable  ${latency13}
    Set Suite Variable  ${num_samples1}

#*** Keywords ***
#Setup
#    ${epoch}=  Get Time  epoch
#
#    ${app_name}=  Get Default App Name
#
#    Create Flavor  region=${region}
#  
#    Create App  region=${region}  app_name=${app_name}1  access_ports=tcp:1
#    Create App Instance  region=${region}  app_name=${app_name}1  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster
# 
#    Create App  region=${region}  app_name=${app_name}2  access_ports=tcp:1
#    Create App Instance  region=${region}  app_name=${app_name}2  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster
#
#    Create App  region=${region}  app_name=${app_name}3  access_ports=tcp:1
#    Create App Instance  region=${region}  app_name=${app_name}3  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster
#   
#    Set Suite Variable  ${app_name}

Teardown Settings
   [Arguments]  ${settings}

   Login

   @{collection_intervals}=  Create List  ${settings['edge_events_metrics_continuous_queries_collection_intervals'][0]['interval']}  ${settings['edge_events_metrics_continuous_queries_collection_intervals'][1]['interval']}  ${settings['edge_events_metrics_continuous_queries_collection_intervals'][2]['interval']}
   Update Settings  region=${region}  edge_events_metrics_collection_interval=${settings['appinst_client_cleanup_interval']}  edge_events_metrics_continuous_queries_collection_intervals=@{collection_intervals}

   Teardown

Teardown
   Terminate DME Persistent Connection
   Cleanup Provisioning

Latency Metrics Headings Should Be Correct
  [Arguments]  ${metrics}  ${raw}=${False}

   Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][0]['name']}  latency-metric-2m10s
   Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][1]['name']}  latency-metric-1m10s
   Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][2]['name']}  latency-metric-10s
   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
   ...   ELSE  Set Variable  1

   Run Keyword If   ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][0]['name']}  latency-metric

   FOR  ${i}  IN RANGE  0  ${count} 
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][0]}  time
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][1]}  cloudlet
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][2]}  cloudletorg
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][3]}  signalstrength
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][4]}  0s
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][5]}  5ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][6]}  10ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][7]}  25ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][8]}  50ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][9]}  100ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][10]}  max
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][11]}  min
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][12]}  avg
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][13]}  variance
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][14]}  stddev
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][15]}  numsamples
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][16]}  locationtile
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][17]}  devicecarrier
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][18]}  datanetworktype
   END

DeviceInfo Metrics Headings Should Be Correct
  [Arguments]  ${metrics}  ${raw}=${False}

   Run Keyword If   not ${raw}  DeviceInfo Metrics Headings Should Contain Name  ${metrics}  device-metric-2m10s  #Should Be Equal  ${metrics['data'][0]['Series'][0]['name']}  device-metric-2m10s
   Run Keyword If   not ${raw}  DeviceInfo Metrics Headings Should Contain Name  ${metrics}  device-metric-1m10s  #Should Be Equal  ${metrics['data'][0]['Series'][1]['name']}  device-metric-1m10s
   Run Keyword If   not ${raw}  DeviceInfo Metrics Headings Should Contain Name  ${metrics}  device-metric-10s    #Should Be Equal  ${metrics['data'][0]['Series'][2]['name']}  device-metric-10s
   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
   ...   ELSE  Set Variable  1

   Run Keyword If   ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][0]['name']}  device-metric

   FOR  ${i}  IN RANGE  0  ${count}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][0]}  time
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][1]}  cloudlet
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][2]}  cloudletorg
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][3]}  deviceos
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][4]}  devicemodel
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][5]}  devicecarrier
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][6]}  numsessions
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][7]}  locationtile
   END

DeviceInfo Metrics Headings Should Contain Name
   [Arguments]  ${metrics}  ${name}

   ${found}=  Set Variable  ${False}
   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
       IF  "${m['name']}" == "${name}"
           ${found}=  Set Variable  ${True}
           Exit For Loop
       END
   END

   Should Be True  ${found}

Latency Values Should Be Correct
   [Arguments]  ${metrics}  ${max}  ${min}  ${avg}  ${variance}  ${stddev}  ${numsamples}  ${numrequests}  ${cloudlet}=${cloudlet_name}  ${raw}=${False}

   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
   ...   ELSE  Set Variable  1

   FOR  ${i}  IN RANGE  0  ${count}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][1]}  ${cloudlet}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][2]}  ${operator_name_fake}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][8]}  75

      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][4]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][5]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][6]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][7]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][8]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][9]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][10]} > 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][11]} > 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][12]} > 0
#      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][13]} > 0
#      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][14]} > 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][15]} > 0
      Should Be True  len("${metrics['data'][0]['Series'][${i}]['values'][0][16]}") > 0
      Should Be True  len("${metrics['data'][0]['Series'][${i}]['values'][0][17]}") > 0
      Should Be True  len("${metrics['data'][0]['Series'][${i}]['values'][0][18]}") > 0

   END

#DeviceInfo Values Should Be Correct
#   [Arguments]  ${app_name}  ${metrics}  ${cloudlet}=${cloudlet2}  ${raw}=${False}
#
#   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
#   ...   ELSE  Set Variable  1
#
#   FOR  ${i}  IN RANGE  0  ${count}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][1]}  ${app_name}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][2]}  ${developer_org_name_automation}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][3]}  1.0
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][4]}  autocluster
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][5]}  MobiledgeX
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][6]}  ${cloudlet}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][7]}  ${operator_name_fake}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][8]}  ${device_os}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][9]}  ${device_model}
#      Should Be Equal As Integers  ${metrics['data'][0]['Series'][${i}]['values'][0][10]}  1
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][11]}  ${data_network_type}
#   END

DeviceInfo Values Should Be Correct
   [Arguments]  ${metrics}  ${raw}=${False}

   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
   ...   ELSE  Set Variable  1

   Length Should Be  ${metrics['data'][0]['Series']}  ${count}

   FOR  ${i}  IN RANGE  0  ${count}
      #Length Should Be  ${metrics['data'][0]['Series'][${i}]['values']}  2
      ${len}=  Get Length  ${metrics['data'][0]['Series'][${i}]['values']}
      #Should Be True  ${len} == 1 or ${len} == 2
      Should Be True  ${len} >= 1
   END

Cloudlet Should Be Found
   [Arguments]  ${cloudlet_name}  ${metrics}  ${totalrequests}=${None}  ${numsessions}=${None}  ${device_network_type}=${None}  ${carrier}=${None}  ${tile}=${None}

   ${metric_found}=  Set Variable  ${None}
   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
      FOR  ${v}  IN  @{m['values']}
          IF  '${v[1]}' == '${cloudlet_name}'
              ${metric_found}=  Set Variable  ${v}

              IF  '${totalrequests}' != '${None}' and '${v[4]}' != '${totalrequests}'
                  ${metric_found}=  Set Variable  ${None}
              END
              IF  '${numsessions}' != '${None}' and ${v[6]} != ${numsessions}
                  ${metric_found}=  Set Variable  ${None}
              END
              IF  '${device_network_type}' != '${None}'
                  IF  '${v[18]}' != '${device_network_type}'
                      ${metric_found}=  Set Variable  ${None}
                  END
              END
              IF  '${carrier}' != '${None}'
                  IF  '${device_network_type}' != '${None}'
                      IF  '${v[17]}' != '${carrier}'
                          ${metric_found}=  Set Variable  ${None}
                      END
                  ELSE
                      IF  '${v[5]}' != '${carrier}'
                          ${metric_found}=  Set Variable  ${None}
                      END
                  END
              END

              IF  '${tile}' != '${None}'
                  IF  '${device_network_type}' != '${None}'
                      IF  '${v[16]}' != '${tile}'
                          ${metric_found}=  Set Variable  ${None}
                      END
                  ELSE
                      IF  '${v[7]}' != '${tile}'
                          ${metric_found}=  Set Variable  ${None}
                      END
                  END
              END

              #IF  '${numsessions}' != '${None}' and '${device_network_type}' != '${None}'
              #    IF  ${v[6]} != ${numsessions} or '${v[12]}' != '${device_network_type}'
              #        ${metric_found}=  Set Variable  ${None}
              #    END
              #END
          END
          Exit For Loop If  ${metric_found} != ${None}
      END
      Exit For Loop If  ${metric_found} != ${None}
   END

   [Return]  ${metric_found}

Latency Cloudlet Should Be Found
   [Arguments]  ${cloudlet_name}  ${metrics}  ${max}  ${min}  ${avg}  ${variance}  ${stddev}  ${numsamples}  ${numrequests}  ${cloudlet}=${cloudlet2_name}  ${raw}=${False}

   ${numrequests_find}=  Evaluate  ${2}*${numrequests}
   ${metric_found}=  Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  totalrequests=${numrequests_find}

   Should Be Equal  ${metric_found[1]}  ${cloudlet_name}
   Should Be Equal  ${metric_found[2]}  ${operator_name_fake}
   #Should Be Equal  ${metric_found[3]}  signal strength

   ${r9}=  Evaluate  ${2}*${numrequests}
   ${r10}=  Evaluate  ${1}*${numrequests}
   ${r11}=  Evaluate  ${1}*${numrequests}
   ${r12}=  Evaluate  ${1}*${numrequests}
   ${r13}=  Evaluate  ${0}*${numrequests}
   ${r14}=  Evaluate  ${2}*${numrequests}
   ${r20}=  Evaluate  ${numsamples}*${numrequests}

   Should Be Equal As Numbers  ${metric_found[4]}   ${r9}
   Should Be Equal As Numbers  ${metric_found[5]}  ${r10}
   Should Be Equal As Numbers  ${metric_found[6]}  ${r11}
   Should Be Equal As Numbers  ${metric_found[7]}  ${r12}
   Should Be Equal As Numbers  ${metric_found[8]}  ${r13}
   Should Be Equal As Numbers  ${metric_found[9]}  ${r14}

   ${latency_avg}=  Evaluate  round(${avg})
   ${metrics_avg}=  Evaluate  round(${metric_found[12]})

   Should Be Equal  ${metric_found[10]}  ${max}
   Should Be Equal  ${metric_found[11]}  ${min}
   Should Be Equal  ${metrics_avg}  ${latency_avg}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][18]}  ${variance}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][19]}  ${stddev}
   Should Be Equal  ${metric_found[15]}  ${r20}
   Should Be Equal  ${metric_found[16]}  ${cloudlet1_tile}
   Should Be Equal  ${metric_found[17]}  ${carrier_name}
   Should Be Equal  ${metric_found[18]}  5G

#   IF  '${cloudlet}' == '${cloudlet2}'
#      Should Be Equal  ${metric_found[21]}  ${cloudlet2_tile}
#   ELSE
#      Should Be Equal  ${metric_found[21]}  ${cloudlet1_tile}
#   END

DeviceInfo Cloudlet Should Be Found
   [Arguments]  ${cloudlet_name}  ${metrics}  ${numsessions}=1  ${raw}=${False}  ${device_carrier}=${operator_name_fake}  ${tile}=${None}

   ${metric_found}=  Cloudlet Should Be Found  ${cloudlet_name}  ${metrics}  numsessions=${numsessions}  carrier=${device_carrier}  tile=${tile}

   Should Be Equal  ${metric_found[1]}  ${cloudlet_name}
   Should Be Equal  ${metric_found[2]}  ${operator_name_fake}
   Should Be Equal  ${metric_found[3]}  ${device_os}
   Should Be Equal  ${metric_found[4]}  ${device_model}
   Should Be Equal  ${metric_found[5]}  ${device_carrier}
   Should Be Equal As Integers  ${metric_found[6]}  ${numsessions} 
   Should Be Equal  ${metric_found[7]}  ${tile}
