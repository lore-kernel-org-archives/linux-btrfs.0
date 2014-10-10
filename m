Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35151 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886AbaJJU5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:38 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKu9r6028584
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:38 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pxprq81na-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:38 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/12] Btrfs-progs: re-search tree root if it changes
Date: Fri, 10 Oct 2014 16:57:12 -0400
Message-ID: <1412974637-31334-8-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we change something while scanning fs-roots we need to redo our search so
that we get valid root items and have valid root cache.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e81a26c..9522077 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2171,7 +2171,7 @@ static int check_fs_roots(struct btrfs_root *root,
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct walk_control wc;
-	struct extent_buffer *leaf;
+	struct extent_buffer *leaf, *tree_node;
 	struct btrfs_root *tmp_root;
 	struct btrfs_root *tree_root = root->fs_info->tree_root;
 	int ret;
@@ -2186,13 +2186,19 @@ static int check_fs_roots(struct btrfs_root *root,
 	memset(&wc, 0, sizeof(wc));
 	cache_tree_init(&wc.shared);
 	btrfs_init_path(&path);
-
+again:
 	key.offset = 0;
 	key.objectid = 0;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
 	BUG_ON(ret < 0);
+	tree_node = tree_root->node;
 	while (1) {
+		if (tree_node != tree_root->node) {
+			free_root_recs_tree(root_cache);
+			btrfs_release_path(&path);
+			goto again;
+		}
 		leaf = path.nodes[0];
 		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(tree_root, &path);
-- 
1.8.3.1

