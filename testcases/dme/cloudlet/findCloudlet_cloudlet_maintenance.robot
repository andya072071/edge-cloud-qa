*** Settings ***
Documentation   RegisterClient/FindCloudlet with cloudlet maintenance failures

Library  MexMasterController  mc_address=%{AUTOMATION_MC_ADDRESS}   root_cert=%{AUTOMATION_MC_CERT}
Library  MexDmeRest         dme_address=%{AUTOMATION_DME_REST_ADDRESS}

Test Setup  Setup
Test Teardown  Teardown

*** Variables ***
${region}=  US

*** Test Cases ***
# ECQ-2533
FindCloudlet - request shall not return appinst for k8s/lb/shared app inst when cloudlet is maintenance mode
   [Documentation]
   ...  - create a k8s/lb/shared autocluster app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeDocker  deployment=kubernetes  app_version=1.0   access_type=loadbalancer
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name}  cluster_instance_name=autocluster${cluster1}  autocluster_ip_access=IpAccessShared
   App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=${cloudlet_name1}.${operator_name}.mobiledgex.net

# ECQ-2534
FindCloudlet - request shall not return appinst for k8s/lb/dedicated app inst when cloudlet is maintenance mode
   [Documentation]
   ...  - create a k8s/lb/dedicated autocluster app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeDocker  deployment=kubernetes  app_version=1.0   access_type=loadbalancer
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name}  cluster_instance_name=autocluster${cluster1}  autocluster_ip_access=IpAccessDedicated
   App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=autocluster${cluster1}.${cloudlet_name1}.${operator_name}.mobiledgex.net

# ECQ-2535
FindCloudlet - request shall not return appinst for docker/lb/dedicated app inst when cloudlet is maintenance mode
   [Documentation]
   ...  - create a docker/lb/dedicated autocluster app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeDocker  deployment=docker  app_version=1.0   access_type=loadbalancer
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name}  cluster_instance_name=autocluster${cluster1}  autocluster_ip_access=IpAccessDedicated
   App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=autocluster${cluster1}.${cloudlet_name1}.${operator_name}.mobiledgex.net

# ECQ-2536
FindCloudlet - request shall not return appinst for docker/lb/shared app inst when cloudlet is maintenance mode
   [Documentation]
   ...  - create a docker/lb/shared autocluster app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeDocker  deployment=docker  app_version=1.0   access_type=loadbalancer
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name}  cluster_instance_name=autocluster${cluster1}  autocluster_ip_access=IpAccessShared
   App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=${cloudlet_name1}.${operator_name}.mobiledgex.net

# ECQ-2537
FindCloudlet - request shall not return appinst for docker/direct/dedicated app inst when cloudlet is maintenance mode
   [Documentation]
   ...  - create a docker/direct/dedicated autocluster app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeDocker  deployment=docker  app_version=1.0   access_type=direct
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name}  cluster_instance_name=autocluster${cluster1}  autocluster_ip_access=IpAccessDedicated
   App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=autocluster${cluster1}.${cloudlet_name1}.${operator_name}.mobiledgex.net

# ECQ-2538
FindCloudlet - request shall not return appinst for vm/direct app inst when cloudlet is maintenance mode
   [Documentation]
   ...  - create a vm/direct app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  image_path=${qcow_centos_image}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeQcow  deployment=vm  app_version=1.0   access_type=direct
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name} 
   App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=${operator_name}${app_name_default}10.${cloudlet_name1}.${operator_name}.mobiledgex.net

# ECQ-2539
FindCloudlet - request shall not return appinst for vm/lb app inst when cloudlet is maintenance mode
   [Documentation]
   ...  - create a vm/lb app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  image_path=${qcow_centos_image}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeQcow  deployment=vm  app_version=1.0   access_type=loadbalancer
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name}  
   App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=${operator_name}${app_name_default}10.${cloudlet_name1}.${operator_name}.mobiledgex.net

# ECQ-2540
FindCloudlet - request shall not return appinst for helm/shared/lb app inst when cloudlet is maintenance mode
    [Documentation]
   ...  - create a helm/shared/lb app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeHelm  deployment=helm  app_version=1.0   access_type=loadbalancer
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name}  cluster_instance_name=autocluster${cluster1}  autocluster_ip_access=IpAccessShared
   App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=${cloudlet_name1}.${operator_name}.mobiledgex.net

# ECQ-2541
FindCloudlet - request shall not return appinst for helm/dedicated/lb app inst when cloudlet is maintenance mode
    [Documentation]
   ...  - create a helm/dedicated/lb app instance on the cloudlet
   ...  - send RegisterClient/FindCloudlet and verify appinst is returned
   ...  - put cloudlet in maintenance mode
   ...  - send RegisterClient/FindCloudlet and verify appinst is not returned

   Create App  region=${region}  access_ports=tcp:2015,tcp:2016,udp:2015,udp:2016  image_type=ImageTypeHelm  deployment=helm  app_version=1.0   access_type=loadbalancer
   Create App Instance  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  developer_org_name=${operator_name}  cluster_instance_name=autocluster${cluster1}  autocluster_ip_access=IpAccessDedicated
    App Instance Should Exist  region=${region}  app_name=${app_name_default}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}

   Register Client And Find Cloudlet  fqdn=autocluster${cluster1}.${cloudlet_name1}.${operator_name}.mobiledgex.net

*** Keywords ***
Setup
   Create Flavor  region=${region}

   ${cluster_name}=  Get Default Cluster Name
   ${cluster1}=  Catenate  SEPARATOR=  ${cluster_name}  1

   ${cloudlet_name}=  Get Default Cloudlet Name
   ${cloudlet_name1}=  Catenate  SEPARATOR=  ${cloudlet_name}  1

   Create Org
   Create Cloudlet  region=${region}  cloudlet_name=${cloudlet_name1}

   ${operator_name}=  Get Default Organization Name
   ${flavor_name_default}=  Get Default Flavor Name
   ${app_name_default}=  Get Default App Name

   Set Suite Variable  ${flavor_name_default}
   Set Suite Variable  ${operator_name}
   Set Suite Variable  ${cloudlet_name1}
   Set Suite Variable  ${cluster1}
   Set Suite Variable  ${app_name_default}

Teardown
   Update Cloudlet  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  maintenance_state=NormalOperation
   Cleanup Provisioning

Register Client and Find Cloudlet
   [Arguments]  ${fqdn}

   # verify it returns the appinst on the 1st cloudlet
   Register Client  app_name=${app_name_default}  developer_org_name=${operator_name}
   ${cloudlet_1}=  Find Cloudlet      latitude=31  longitude=-91
   Should Be Equal  ${cloudlet_1['status']}  FIND_FOUND
   Should Be Equal  ${cloudlet_1['fqdn']}  ${fqdn}

   # put cloudlet in maintenance mode
   Update Cloudlet  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  maintenance_state=MaintenanceStart

   # verify not found
   ${cloudlet_2}=  Run Keyword and Expect Error  *  Find Cloudlet      latitude=31  longitude=-91
   Should Contain  ${cloudlet_2}  FIND_NOTFOUND

   # put cloudlet back online
   Update Cloudlet  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  maintenance_state=NormalOperation

   ${cloudlet_3}=  Find Cloudlet      latitude=31  longitude=-91
   Should Be Equal  ${cloudlet_3['status']}  FIND_FOUND
   Should Be Equal  ${cloudlet_3['fqdn']}  ${fqdn}

   Should Be True  len('${cloudlet.edge_events_cookie}') > 100

   # put cloudlet in maintenance mode
   Update Cloudlet  region=${region}  cloudlet_name=${cloudlet_name1}  operator_org_name=${operator_name}  maintenance_state=MaintenanceStartNoFailover

   # verify not found
   ${cloudlet_4}=  Run Keyword and Expect Error  *  Find Cloudlet      latitude=31  longitude=-91
   Should Contain  ${cloudlet_4}  FIND_NOTFOUND
