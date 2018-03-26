Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53152 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeCZIZ7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 04:25:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q8HhCK018342
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2gxw7j813t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8PvSQ025220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:57 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8Pu78016365
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:57 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/8] btrfs: make btrfs_check_super_csum() non-static
Date: Mon, 26 Mar 2018 16:27:37 +0800
Message-Id: <20180326082742.9235-5-anand.jain@oracle.com>
In-Reply-To: <20180326082742.9235-1-anand.jain@oracle.com>
References: <20180326082742.9235-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation to add the superblock csum verification for the
scan context, make btrfs_check_super_csum() non-static.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/disk-io.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8b4e602ed60a..6299ab18da5f 100644
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
-- 
2.7.0

