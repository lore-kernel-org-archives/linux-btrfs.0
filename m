Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49645 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaHNKuy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 06:50:54 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7EAoqek003684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 10:50:53 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7EAoq3o015275
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 10:50:52 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7EAoqgP015265
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 10:50:52 GMT
Message-ID: <53EC9555.80403@oracle.com>
Date: Thu, 14 Aug 2014 18:54:13 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: xfstest/btrfs  _require_scratch_dev_pool  runs  btrfsck
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Here below is a simple test script. I can't understand why
  _require_scratch_dev_pool should check consistency on the disk ?

-------------
#! /bin/bash
# Test case 060

seq=`basename $0`
seqres=$RESULT_DIR/$seq
echo "QA output created by $seq"

tmp=/tmp/$$
status=1    # failure is the default!
trap "_cleanup; exit \$status" 0 1 2 3 15

_cleanup()
{
     cd /
     rm -f $tmp.tmp
}

# get standard environment, filters and checks
. ./common/rc
. ./common/filter

_require_scratch_dev_pool 4

status=0
exit
-------------

./check btrfs/060

FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 OL 3.16.0-rc6+
MKFS_OPTIONS  -- /dev/sdc
MOUNT_OPTIONS -- /dev/sdc /mnt/scratch

btrfs/060 2s ... 1s
_check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent (see 
/usr/src/cli/xfstests/results//btrfs/060.full)   <-----
Ran: btrfs/060
Passed all 1 tests


_check_btrfs_filesystem()
{
::
         echo "_check_btrfs_filesystem: filesystem on $device is 
inconsistent" >>$seqres.full



check
::
           test -f ${RESULT_DIR}/require_scratch && _check_scratch_fs



