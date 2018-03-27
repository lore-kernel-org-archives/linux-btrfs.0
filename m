Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbeC0XiU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 19:38:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2RNXqXr153754
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2gyyr3r0fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:18 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2RNcIkF023983
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:18 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2RNcHai000333
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/8] btrfs: make btrfs_check_super_csum() non-static
Date: Wed, 28 Mar 2018 07:39:55 +0800
Message-Id: <20180327234000.23656-5-anand.jain@oracle.com>
In-Reply-To: <20180327234000.23656-1-anand.jain@oracle.com>
References: <20180327234000.23656-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation to add the superblock csum verification for the
scan context, make btrfs_check_super_csum() non-static.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/disk-io.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4c573602480c..35dbbdc613cd 100644
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
-- 
2.7.0

