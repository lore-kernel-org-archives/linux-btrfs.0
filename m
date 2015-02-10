Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24217 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754576AbbBJK0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:43 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAPtT3000832
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:25:56 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/9] Btrfs: qgroup: part-1: bug fixes for qgroup inherit.
Date: Tue, 10 Feb 2015 18:23:12 +0800
Message-ID: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

[1/9] is a RESEND with a reviewed-by.

[2/9]-[6/9] are bug fixes about qgroup_inherit(), these patch make
user can set the limits when creating a subvolume with the related
patch in userspace applied.

[7/9]-[8/9] are a cleanup for qgroup.

[9/9] provides a way for btrfs-progs to get the quota status by ioctl(),
then btrfs-progs can warn user when they are using qgroup with quota_disabled.

With this series patch applied, both btrfs and btrfs-progs:

[root@atest-guest linux_btrfs]# btrfs quota enable /mnt
[root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child 
--------         ----         ----     --------     -------- ------  ----- 
0/5          16.00KiB     16.00KiB        0.00B        0.00B ---     ---  
[root@atest-guest linux_btrfs]# btrfs sub create /mnt/sub1
Create subvolume '/mnt/sub1'
[root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child 
--------         ----         ----     --------     -------- ------  ----- 
0/5          16.00KiB     16.00KiB        0.00B        0.00B ---     ---  
0/257        16.00KiB     16.00KiB        0.00B        0.00B ---     ---  
[root@atest-guest linux_btrfs]# btrfs sub create /mnt/sub2 -r 10M -e 5M
Create subvolume '/mnt/sub2'
Set qgroup arguments:
	max reference: 10485760
	max exclusive: 5242880
[root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child 
--------         ----         ----     --------     -------- ------  ----- 
0/5          16.00KiB     16.00KiB        0.00B        0.00B ---     ---  
0/257        16.00KiB     16.00KiB        0.00B        0.00B ---     ---  
0/258        16.00KiB     16.00KiB     10.00MiB      5.00MiB ---     --- 

Dongsheng Yang (8):
  btrfs: qgroup: move WARN_ON() to the correct location.
  btrfs: qgroup: inherit limit info from srcgroup in creating snapshot.
  btrfs: qgroup: update qgroup in memory at the same time when we update
    it in btree.
  btrfs: qgroup: consolidate the parameter of fucntion
    update_qgroup_limit_item().
  btrfs: qgroup: update limit info in function btrfs_run_qgroups().
  btrfs: qgroup: fix limit args override whole limit struct
  Btrfs: qgroup: make the btree for qgroup increase from left to right.
  Btrfs: qgroup: cleanup, remove an unsued parameter in
    btrfs_create_qgroup().

Fan Chengniang (1):
  btrfs: qgroup: obtain quota status

 fs/btrfs/ioctl.c              |   9 +++-
 fs/btrfs/qgroup.c             | 109 +++++++++++++++++++++++++++---------------
 fs/btrfs/qgroup.h             |   6 ++-
 fs/btrfs/tests/qgroup-tests.c |   4 +-
 include/uapi/linux/btrfs.h    |   3 ++
 5 files changed, 87 insertions(+), 44 deletions(-)

-- 
1.8.4.2

