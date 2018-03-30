Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbeC3AQi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 20:16:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2U04fWr007781
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:16:37 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2h1abwr215-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:16:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07gep002474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:42 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07gd8007445
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 5/7] btrfs: verify superblock checksum during scan
Date: Fri, 30 Mar 2018 08:09:21 +0800
Message-Id: <20180330000924.11148-6-anand.jain@oracle.com>
In-Reply-To: <20180330000924.11148-1-anand.jain@oracle.com>
References: <20180330000924.11148-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the scan context, we aren't verifying the superblock-
checksum when read.
This patch fixes it by adding the checksum verification function
btrfs_check_super_csum() in the function btrfs_read_disk_super().
And makes device scan to error fail if the primary superblock csum
is wrong, whereas if the copy-superblock csum is wrong it will just
just report mismatch and continue mount/scan as usual. When the
mount is successful We anyway overwrite all superblocks upon unmount.

The context in which this will be called is - device scan, device ready,
and mount -o device option.

Test script:
 Corrupt primary superblock and check if device scan and mount
 fails:
  mkfs.btrfs -fq /dev/sdc
  dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
  btrfs dev scan /dev/sdc
  mount /dev/sdc /btrfs

 Corrupt secondary superblock and check if device scan and mount
 is succcessful, check for the dmesg for errors.
  mkfs.btrfs -fq /dev/sdc
  dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=67108864
  btrfs dev scan /dev/sdc
  mount /dev/sdc /btrfs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v3->v4:
  Update changelog
v2->v3:
  squash 4/8 in here.
  4/8: btrfs: make btrfs_check_super_csum() non-static
v1->v2:
 changed title.
 use explicit (< 0) check for %errr.
 Un-split pr_err() string.
 Fix typo in the git commit log.
 Move the csum check after bytenr and btrfs magic verified.

 fs/btrfs/disk-io.c |  2 +-
 fs/btrfs/disk-io.h |  1 +
 fs/btrfs/volumes.c | 13 +++++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c3a9407fc3a5..37b0cf489fdd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -395,7 +395,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
  * Otherwise:	-EINVAL  if csum type is not found
  *		-EUCLEAN if csum does not match
  */
-static int btrfs_check_super_csum(char *raw_disk_sb)
+int btrfs_check_super_csum(char *raw_disk_sb)
 {
 	struct btrfs_super_block *disk_sb =
 		(struct btrfs_super_block *)raw_disk_sb;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 70a88d61b547..c400cc68f913 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -69,6 +69,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 			struct buffer_head **bh_ret);
+int btrfs_check_super_csum(char *raw_disk_sb);
 int btrfs_commit_super(struct btrfs_fs_info *fs_info);
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 				      struct btrfs_key *location);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 035affa447fa..760c6650e11b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1149,6 +1149,7 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 				 struct page **page,
 				 struct btrfs_super_block **disk_super)
 {
+	int err;
 	void *p;
 	pgoff_t index;
 
@@ -1183,6 +1184,18 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 		return -EINVAL;
 	}
 
+	err = btrfs_check_super_csum((char *) *disk_super);
+	if (err < 0) {
+		if (err == -EINVAL)
+			pr_err("BTRFS error (device %pg): unsupported checksum type, bytenr=%llu",
+				bdev, bytenr);
+		else if (err == -EUCLEAN)
+			pr_err("BTRFS error (device %pg): superblock checksum failed, bytenr=%llu",
+				bdev, bytenr);
+		btrfs_release_disk_super(*page);
+		return err;
+	}
+
 	if ((*disk_super)->label[0] &&
 		(*disk_super)->label[BTRFS_LABEL_SIZE - 1])
 		(*disk_super)->label[BTRFS_LABEL_SIZE - 1] = '\0';
-- 
2.7.0

