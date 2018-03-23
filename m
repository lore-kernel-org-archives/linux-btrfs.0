Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46320 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbeCWMwE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 08:52:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2NCgbiN066894
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:03 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2gw1txg172-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:03 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2NCq21N022886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:03 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2NCq2cs017722
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:02 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: verify checksum when superblock is read for scan
Date: Fri, 23 Mar 2018 20:53:49 +0800
Message-Id: <20180323125349.26893-3-anand.jain@oracle.com>
In-Reply-To: <20180323125349.26893-1-anand.jain@oracle.com>
References: <20180323125349.26893-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the scan context, we aren't verifying if the superblock-
checksum is correct for the primary and its copies.
This patch fixes it by adding the checksum verification function
btrfs_check_super_csum() in the function btrfs_read_disk_super().

It would fail the scan only if the primary SB csum is wrong,
whereas if the copy-SB csum is wrong it would just warn and
still makes the scan successful. Since because the mount reads
only primary SB. And further, all SB gets overwritten. Thus
fixing the bad SB.

The context in which this will be called are, scan, ready,
for the device in the mount argument, for the devices in the
mount -o device option.

Test script:
mkfs.btrfs -fq /dev/sdc
dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
btrfs dev scan

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c |  2 +-
 fs/btrfs/disk-io.h |  1 +
 fs/btrfs/volumes.c | 32 +++++++++++++++++++++++---------
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c4600d5eca9c..3cc50041c0b9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -395,7 +395,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
  * Otherwise: -EINVAL  if csum type is not found
  * 	      -EUCLEAN if csum does not match
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
index 3e2dae4e8ccb..e15d19d04722 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1149,38 +1149,53 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 				 struct page **page,
 				 struct btrfs_super_block **disk_super)
 {
+	int err;
 	void *p;
 	pgoff_t index;
 
 	/* make sure our super fits in the device */
 	if (bytenr + PAGE_SIZE >= i_size_read(bdev->bd_inode))
-		return 1;
+		return -EINVAL;
 
 	/* make sure our super fits in the page */
 	if (sizeof(**disk_super) > PAGE_SIZE)
-		return 1;
+		return -EINVAL;
 
 	/* make sure our super doesn't straddle pages on disk */
 	index = bytenr >> PAGE_SHIFT;
 	if ((bytenr + sizeof(**disk_super) - 1) >> PAGE_SHIFT != index)
-		return 1;
+		return -EINVAL;
 
 	/* pull in the page with our super */
 	*page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
 				   index, GFP_KERNEL);
 
 	if (IS_ERR_OR_NULL(*page))
-		return 1;
+		return -EINVAL;
 
 	p = kmap(*page);
 
 	/* align our pointer to the offset of the super block */
 	*disk_super = p + (bytenr & ~PAGE_MASK);
 
+	err = btrfs_check_super_csum((char *) *disk_super);
+	if (err) {
+		if (err == -EINVAL)
+			pr_err("BTRFS error (device %pg): "\
+				"unsupported checksum type, bytenr=%llu",
+				bdev, bytenr);
+		else
+			pr_err("BTRFS error (device %pg): "\
+				"superblock checksum failed, bytenr=%llu",
+				bdev, bytenr);
+		btrfs_release_disk_super(*page);
+		return err;
+	}
+
 	if (btrfs_super_bytenr(*disk_super) != bytenr ||
 	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
 		btrfs_release_disk_super(*page);
-		return 1;
+		return -EINVAL;
 	}
 
 	if ((*disk_super)->label[0] &&
@@ -1229,11 +1244,10 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		u64 bytenr = btrfs_sb_offset(i);
 
-		if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
-			if (i == 0) {
-				ret = -EINVAL;
+		ret = btrfs_read_disk_super(bdev, bytenr, &page, &disk_super);
+		if (ret) {
+			if (i == 0)
 				goto error_kfree;
-			}
 			continue;
 		} else if (i == 0) {
 			memcpy(disk_super_primary, disk_super,
-- 
2.15.0

