Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:44564 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbeEQG6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 02:58:32 -0400
From: Ethan Lien <ethanlien@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Ethan Lien <ethanlien@synology.com>
Subject: [PATCH v2] btrfs: Skip some btrfs_cross_ref_exist() check in nocow path
Date: Thu, 17 May 2018 14:58:29 +0800
Message-Id: <20180517065829.24906-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In nocow path, we check if the extent is snapshotted in
btrfs_cross_ref_exist(). We can do the similar check earlier and avoid
unnecessary search into extent tree.

A fio test on a Intel D-1531, 16GB RAM, SSD RAID-5 machine as follows:

[global]
group_reporting
time_based
thread=1
ioengine=libaio
bs=4k
iodepth=32
size=64G
runtime=180
numjobs=8
rw=randwrite

[file1]
filename=/mnt/nocow/testfile

IOPS result:   unpatched     patched

1 fio round:     46670        46958
snapshot
2 fio round:     51826        54498
3 fio round:     59767        61289

After snapshot, the first fio get about 5% performance gain. As we
continually write to the same file, all writes will resume to nocow mode
and eventually we have no performance gain.

Signed-off-by: Ethan Lien <ethanlien@synology.com>
---

V2:
 Add comment and performance test.

 fs/btrfs/inode.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d241285a0d2a..177630337108 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1373,6 +1373,13 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			    btrfs_file_extent_encryption(leaf, fi) ||
 			    btrfs_file_extent_other_encoding(leaf, fi))
 				goto out_check;
+			/*
+			 * We can skip the checking of generation of
+			 * extent item in btrfs_cross_ref_exist().
+			 */
+			if (btrfs_file_extent_generation(leaf, fi) <=
+			    btrfs_root_last_snapshot(&root->root_item))
+				goto out_check;
 			if (extent_type == BTRFS_FILE_EXTENT_REG && !force)
 				goto out_check;
 			if (btrfs_extent_readonly(fs_info, disk_bytenr))
@@ -7368,6 +7375,14 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	    btrfs_file_extent_other_encoding(leaf, fi))
 		goto out;
 
+	/*
+	 * We can skip the checking of generation of
+	 * extent item in btrfs_cross_ref_exist().
+	 */
+	if (btrfs_file_extent_generation(leaf, fi) <=
+	    btrfs_root_last_snapshot(&root->root_item))
+		goto out;
+
 	backref_offset = btrfs_file_extent_offset(leaf, fi);
 
 	if (orig_start) {
-- 
2.17.0

