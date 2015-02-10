Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27943 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755041AbbBJK1l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:41 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQsH1000942
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:54 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 0/7] Btrfs: qgroup: part-4: Add type to btrfs qgroup.
Date: Tue, 10 Feb 2015 18:24:11 +0800
Message-ID: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
	This patchset is based on [Btrfs: qgroup: part-3: bug fixes.]

I am introducing a type to qgroup, then we can get the numbers what we
only care about.

Easy way to get the code for testing:
	btrfs: https://yangdongsheng@github.com/yangdongsheng/linux.git qgroup_type
  btrfs-progs: https://yangdongsheng@github.com/yangdongsheng/btrfs-progs.git qgroup_type
with the patches applied in this series, both in btrfs and btrfs-progs:

[root@atest-guest linux_btrfs]# mkfs.btrfs -O qgroup-type /dev/sdc -f
Btrfs v3.18-76-ga900a61
See http://btrfs.wiki.kernel.org for more information.

Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
Turning ON incompat feature 'skinny-metadata': reduced-size metadata extent refs
Turning ON incompat feature 'qgroup-type': create qgroup in different type
fs created label (null) on /dev/sdc
	nodesize 16384 leafsize 16384 sectorsize 4096 size 10.00GiB
[root@atest-guest linux_btrfs]# mount /dev/sdc  /mnt/
[root@atest-guest linux_btrfs]# btrfs quota enable /mnt
[root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child type          
--------         ----         ----     --------     -------- ------  ----- ----          
0/5          16.00KiB     16.00KiB        0.00B        0.00B ---     ---   metadata,data
[root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child type          
--------         ----         ----     --------     -------- ------  ----- ----          
0/5          16.00KiB     16.00KiB        0.00B        0.00B ---     ---   metadata,data
0/257        16.00KiB     16.00KiB        0.00B        0.00B ---     ---   metadata,data <--- default type is mixed.
[root@atest-guest linux_btrfs]# btrfs sub create --qgroup-type data /mnt/sub1
Create subvolume '/mnt/sub1'
Set qgroup arguments:
	qgroup type: data
[root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child type          
--------         ----         ----     --------     -------- ------  ----- ----          
0/5          16.00KiB     16.00KiB        0.00B        0.00B ---     ---   metadata,data
0/257        16.00KiB     16.00KiB        0.00B        0.00B ---     ---   metadata,data
0/258           0.00B        0.00B        0.00B        0.00B ---     ---   data     	 <--- create a data qgroup
[root@atest-guest linux_btrfs]# btrfs qgroup limit -e 5M 0/258 /mnt
[root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child type          
--------         ----         ----     --------     -------- ------  ----- ----          
0/5          16.00KiB     16.00KiB        0.00B        0.00B ---     ---   metadata,data
0/257        16.00KiB     16.00KiB        0.00B        0.00B ---     ---   metadata,data
0/258           0.00B        0.00B        0.00B      5.00MiB ---     ---   data    
[root@atest-guest linux_btrfs]# dd if=/dev/zero of=/mnt/sub1/data bs=1024
dd: error writing \u2018/mnt/sub1/data\u2019: Disk quota exceeded
5121+0 records in
5120+0 records out
5242880 bytes (5.2 MB) copied, 0.0218646 s, 240 MB/s
[root@atest-guest linux_btrfs]# sync
[root@atest-guest linux_btrfs]# ll /mnt/sub1/data 
-rw-r--r--. 1 root root 5242880 Feb 10 16:17 /mnt/sub1/data
[root@atest-guest linux_btrfs]# btrfs qgroup show -prce --raw /mnt
qgroupid         rfer         excl     max_rfer     max_excl parent  child type          
--------         ----         ----     --------     -------- ------  ----- ----          
0/5             16384        16384            0            0 ---     ---   metadata,data
0/257           16384        16384            0            0 ---     ---   metadata,data
0/258         5242880      5242880            0      5242880 ---     ---   data   	<--- excl == max_excl == data_size == 5M == 5242880

Dongsheng Yang (7):
  Btrfs: qgroup: Add type to btrfs_qgroup.
  btrfs: qgroup: apply type to the recording and accounting.
  btrfs: qgroup: Apply type to btrfs_qgroup_inherit().
  btrfs: qgroup: Apply qgroup type to qgroup creating.
  btrfs: qgroup: Apply qgroup type to subvol creating.
  btrfs: qgroup: apply type to quota rescan.
  btrfs: qgroup: fix a bug when type of parent is different with
    child's.

 fs/btrfs/ctree.h              |  10 ++-
 fs/btrfs/extent-tree.c        |  48 ++++++-----
 fs/btrfs/ioctl.c              |  49 ++++++++---
 fs/btrfs/qgroup.c             | 186 ++++++++++++++++++++++++++++--------------
 fs/btrfs/qgroup.h             |  29 ++++++-
 fs/btrfs/tests/qgroup-tests.c |  19 +++--
 fs/btrfs/transaction.c        |  13 +--
 include/uapi/linux/btrfs.h    |   1 +
 8 files changed, 246 insertions(+), 109 deletions(-)

-- 
1.8.4.2

