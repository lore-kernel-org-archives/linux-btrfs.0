Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51119 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbbCSGEv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:51 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/7 V2] Btrfs: qgroup: part-4: Add type to btrfs qgroup.
Date: Thu, 19 Mar 2015 14:00:53 +0800
Message-ID: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
	Okey, this is the V2 for the qgroup type. In this version, we
account both of the data and metadata in a qgroup and you can limit
data or metadata or mixed. You can limit them at the same time.

(a). I restructed the btrfs_qgroup in memory:

btrfs_qgroup:                                     |-------------|
-----------------                                 |rfer         |
|data_info      |--------------->btrfs_qgroup_info|rfer_cmpr    |
|metadata_info  |                                 |excl         |
|               |                                 |excl_cmpr    |
|data_limits    |                                 ---------------
|metadata_limits|
|mixed_limits   |--------------->btrfs_qgroup_limits|-------------
|-------------- |                                   |lim_flags  |
                                                    |max_rfer   |
                                                    |max_excl   |
                                                    |rsv_rfer   |
                                                    |rsv_excl   |
                                                    ------------
In this way, we can store the information for data and metadata separately.
And we can limit then in three ways: data_limits, metadata_limits and mixed_limits.

(b). I have to add a incompatability feature for it.
I reuse the objectid to search btrfs_qgroup_info_item.

------------------------------------              ------------------------------------------------
|0 |BTRFS_QGROUP_INFO_KEY |qgroupid| ------------>|TYPE_OBJECTID |BTRFS_QGROUP_INFO_KEY |qgroupid|
------------------------------------              ------------------------------------------------

And introduce two macros for different type of infos.

	#define BTRFS_QGROUP_DATA_INFO_OBJECTID 1ULL
	#define BTRFS_QGROUP_METADATA_INFO_OBJECTID 2ULL
There is a similar change for limits.

(c). Testing.
	Hi Chris and David, as what I mentioned in a offline mail, there is a url for merging or
testing.
	btrfs: https://yangdongsheng@github.com/yangdongsheng/linux.git qgroup_type_v2
  btrfs-progs: https://yangdongsheng@github.com/yangdongsheng/btrfs-progs.git qgroup_type_v2


(1). btrfs/022 and btrfs/042
				kernel.v4.0-4c1		kernel.qgroup_type.patched
v3.19-rc2(progs)		 pass				pass
Patched(progs)			 pass				pass

(2). No qgroup type.
Script:
	# mkfs.btrfs  /dev/sdc -f
	# mount /dev/sdc /mnt
	# btrfs quota enable /mnt
	# btrfs quota rescan -w /mnt
	# btrfs sub create /mnt/sub
	# btrfs qgroup limit -e 10M 0/257 /mnt
	# dd if=/dev/zero of=/mnt/sub/data bs=1024 count=1000000
	# sync
	# btrfs qgroup show -prce --raw /mnt
Expected:
	dd: error writing '/mnt/sub/data': Disk quota exceeded
	10145+0 records in
	10144+0 records out
	10387456 bytes (10 MB) copied, 0.0368423 s, 282 MB/s
	qgroupid         rfer         excl     max_rfer     max_excl parent  child 
	--------         ----         ----     --------     -------- ------  ----- 
	0/5             16384        16384            0            0 ---     ---  
	0/257        10403840     10403840            0            0 ---     ---  


			kernel.v4.0-4c1.bugfix_patched		kernel.qgroup_type.patched
v3.19-rc2(progs)		 pass					pass
Patched(progs)			 pass					pass

(3) qgroup type.
Script:
	# mkfs.btrfs -O qgroup-type /dev/sdc -f
	# mount /dev/sdc /mnt
	# btrfs quota enable /mnt
	# btrfs quota rescan -w /mnt
	# btrfs sub create /mnt/sub
	# btrfs qgroup limit --type data -e 10M 0/257 /mnt
	# dd if=/dev/zero of=/mnt/sub/data bs=1024 count=1000000
	# sync
	# btrfs qgroup show -prce --raw --type data /mnt
	# btrfs qgroup show -prce --raw --type metadata /mnt
	# btrfs qgroup show -prce --raw --type mixed /mnt

			kernel.v4.0-4c1.bugfix_patched		kernel.qgroup_type.patched
v3.19-rc2(progs)	mkfs fail(no feature for qgroup-type)	mkfs fail(no feature for qgroup-type)
Patched(progs)		open_ctree failed. (Expected)			result as below. (pass)

Result:
	dd: error writing '/mnt/sub/data': Disk quota exceeded
	10241+0 records in
	10240+0 records out							  <------10240 means 10M
	10485760 bytes (10 MB) copied, 0.0331533 s, 316 MB/s
	qgroupid         rfer         excl     max_rfer     max_excl parent  child 
	--------         ----         ----     --------     -------- ------  ----- 
	0/5                 0            0            0            0 ---     ---  
	0/257        10485760     10485760            0     10485760 ---     ---  <------DATA info and limits
	qgroupid         rfer         excl     max_rfer     max_excl parent  child 
	--------         ----         ----     --------     -------- ------  ----- 
	0/5             16384        16384            0            0 ---     ---  
	0/257           16384        16384            0            0 ---     ---  <------METADATA info and limits
	qgroupid         rfer         excl     max_rfer     max_excl parent  child 
	--------         ----         ----     --------     -------- ------  ----- 
	0/5             16384        16384            0            0 ---     ---  
	0/257        10502144     10502144            0            0 ---     ---  <------MIXED info and limits

After all, you can use btrfs-debug-tree tool to show the details for each items.

Any comment or test are welcome !!!

Thanx
Yang

Dongsheng Yang (7):
  Btrfs: qgroup: split information and limits in qgroup to other
    structures.
  Btrfs: qgroup: add incompatability feature for QGROUP_TYPE.
  Btrfs: qgroup: record and account ref for qgroup in different type.
  Btrfs: qgroup: update all infos and limits to disk.
  Btrfs: qgroup: update quota numbers in btrfs_qgroup_inherit.
  Btrfs: qgroup: account data and metadata separately in rescan.
  Btrfs: qgroup: allow user to limit qgroup in different type.

 fs/btrfs/ctree.h              |  20 +-
 fs/btrfs/extent-tree.c        |  48 ++--
 fs/btrfs/qgroup.c             | 536 +++++++++++++++++++++++++++++++++---------
 fs/btrfs/qgroup.h             |  52 +++-
 fs/btrfs/tests/qgroup-tests.c |  15 +-
 fs/btrfs/transaction.c        |  11 +-
 6 files changed, 534 insertions(+), 148 deletions(-)

-- 
1.8.4.2

