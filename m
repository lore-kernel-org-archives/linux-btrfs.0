Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49264 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3HSSVE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 14:21:04 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 573C59A0364
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 12:21:04 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id ya9MhqETLX65kRSe (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 12:21:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix some basic sparse errors
Date: Mon, 19 Aug 2013 14:21:01 -0400
Message-ID: <1376936461-8285-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running sparse I found a few small things where we should have static functions
that aren't used externally and we should be using unsigned values for bit
fields.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |    8 ++++----
 fs/btrfs/send.c    |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3b12c26..f51cd95 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1432,8 +1432,8 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
-					struct btrfs_key *key)
+static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
+					       struct btrfs_key *key)
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info = tree_root->fs_info;
@@ -1533,8 +1533,8 @@ fail:
 	return ret;
 }
 
-struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
-					u64 root_id)
+static struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
+					       u64 root_id)
 {
 	struct btrfs_root *root;
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fc03a57..db7da68 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -54,8 +54,8 @@ struct fs_path {
 
 			char *buf;
 			int buf_len;
-			int reversed:1;
-			int virtual_mem:1;
+			unsigned int reversed:1;
+			unsigned int virtual_mem:1;
 			char inline_buf[];
 		};
 		char pad[PAGE_SIZE];
-- 
1.7.7.6

