Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63537 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754AbaC1VQE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 17:16:04 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s2SLEmmS023199
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 14:16:04 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1jw7bw9x3n-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 14:16:04 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: hold the commit_root_sem when getting the commit root during send
Date: Fri, 28 Mar 2014 17:16:01 -0400
Message-ID: <1396041361-7082-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We currently rely too heavily on roots being read-only to save us from just
accessing root->commit_root.  We can easily balance blocks out from underneath a
read only root, so to save us from getting screwed make sure we only access
root->commit_root under the commit root sem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ctree.c | 6 ++++++
 fs/btrfs/ctree.h | 1 +
 fs/btrfs/send.c  | 1 +
 3 files changed, 8 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 71bbafe..0e9569c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2769,9 +2769,13 @@ again:
 		 * the commit roots are read only
 		 * so we always do read locks
 		 */
+		if (p->need_commit_sem)
+			down_read(&root->fs_info->commit_root_sem);
 		b = root->commit_root;
 		extent_buffer_get(b);
 		level = btrfs_header_level(b);
+		if (p->need_commit_sem)
+			up_read(&root->fs_info->commit_root_sem);
 		if (!p->skip_locking)
 			btrfs_tree_read_lock(b);
 	} else {
@@ -5436,6 +5440,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	 *   the right if possible or go up and right.
 	 */
 
+	down_read(&left_root->fs_info->commit_root_sem);
 	left_level = btrfs_header_level(left_root->commit_root);
 	left_root_level = left_level;
 	left_path->nodes[left_level] = left_root->commit_root;
@@ -5445,6 +5450,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	right_root_level = right_level;
 	right_path->nodes[right_level] = right_root->commit_root;
 	extent_buffer_get(right_path->nodes[right_level]);
+	up_read(&left_root->fs_info->commit_root_sem);
 
 	if (left_level == 0)
 		btrfs_item_key_to_cpu(left_path->nodes[left_level],
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2277006..453d859 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -609,6 +609,7 @@ struct btrfs_path {
 	unsigned int skip_locking:1;
 	unsigned int leave_spinning:1;
 	unsigned int search_commit_root:1;
+	unsigned int need_commit_sem:1;
 };
 
 /*
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6f035ee..7e7552c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -493,6 +493,7 @@ static struct btrfs_path *alloc_path_for_send(void)
 		return NULL;
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
+	path->need_commit_sem = 1;
 	return path;
 }
 
-- 
1.8.3.1

