#!/usr/bin/python3

#
# send update cluster instance
# verify error of unsupported is retruned
#
 
import unittest
import grpc
import sys
import time
from delayedassert import expect, expect_equal, assert_expectations
import logging
import os

import MexController as mex_controller

controller_address = os.getenv('AUTOMATION_CONTROLLER_ADDRESS', '127.0.0.1:55001')

mex_root_cert = 'mex-ca.crt'
mex_cert = 'localserver.crt'
mex_key = 'localserver.key'

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

class tc(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        cluster_name = 'cluster' + str(time.time())
        operator_name = 'dmuus'
        cloud_name = 'tmocloud-1'
        flavor_name = 'c1.small'

        self.controller = mex_controller.MexController(controller_address = controller_address,
                                                    root_cert = mex_root_cert,
                                                    key = mex_key,
                                                    client_cert = mex_cert
                                                   )
        self.cluster_instance = mex_controller.ClusterInstance(cluster_name=cluster_name,
                                                             cloudlet_name=cloud_name,
                                                             operator_name=operator_name,
                                                             flavor_name=flavor_name)

    def test_UpdateClusterInst(self):
        # [Documentation] ClusterInst - User shall not be able to update an unsupported field in cluster instance
        # ... send update cluster instance
        # ... verify error of unsupported is retruned

        # create a new cluster and cluster instance
        resp = self.controller.update_cluster_instance(self.cluster_instance.cluster_instance)

        expect_equal(resp.code(), grpc.StatusCode.UNKNOWN, 'status code')
        expect_equal(resp.details(), 'nothing specified to update', 'error details')
        assert_expectations()

#    def tearDown(self):
#        self.controller.delete_cluster_instance(self.cluster_instance.cluster_instance)
#        self.controller.delete_cluster(self.cluster.cluster)

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(tc)
    sys.exit(not unittest.TextTestRunner().run(suite).wasSuccessful())

