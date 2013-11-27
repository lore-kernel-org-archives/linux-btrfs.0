Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16590 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3K0QIc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 11:08:32 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rARG8VOr000993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 16:08:32 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rARG8Uv9026251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 16:08:31 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rARG8UYr026239
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 16:08:30 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix the mismatch of extent buffer's space
Date: Thu, 28 Nov 2013 00:08:24 +0800
Message-Id: <1385568504-22364-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now we set @refs to 2 on creating a new extent buffer, meanwhile we
allocate the needed free space, but we don't give enough free_extent_buffer()
to reduce the eb's references to zero so that the eb can finally be freed,
so the problem is we has decrease the referene count of backrefs to zero, which
ends up releasing the space occupied by the eb, and this space can be allocated
again for something else(another eb or disk), usually a crash(core dump) will
occur, I've hit a crash in rb_insert() because another eb re-use the space while
the original one is floating around.

We should do the same thing as the kernel code does, it's necessary to initialize
@refs to 1 instead of 2, this helps us get rid of the above problem.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-convert.c | 1 +
 extent_io.c     | 2 +-
 mkfs.c          | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index ae10eed..cb6ddd0 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1634,6 +1634,7 @@ static int init_btrfs(struct btrfs_root *root)
 	ret = create_subvol(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
 	BUG_ON(ret);
 
+	extent_buffer_get(fs_info->csum_root->node);
 	ret = __btrfs_cow_block(trans, fs_info->csum_root,
 				fs_info->csum_root->node, NULL, 0, &tmp, 0, 0);
 	BUG_ON(ret);
diff --git a/extent_io.c b/extent_io.c
index ad07b9c..a127e54 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -580,7 +580,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 
 	eb->start = bytenr;
 	eb->len = blocksize;
-	eb->refs = 2;
+	eb->refs = 1;
 	eb->flags = 0;
 	eb->tree = tree;
 	eb->fd = -1;
diff --git a/mkfs.c b/mkfs.c
index cd0af9e..482e4df 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -163,6 +163,7 @@ static void __recow_root(struct btrfs_trans_handle *trans,
 	struct extent_buffer *tmp;
 
 	if (trans->transid != btrfs_root_generation(&root->root_item)) {
+		extent_buffer_get(root->node);
 		ret = __btrfs_cow_block(trans, root, root->node,
 					NULL, 0, &tmp, 0, 0);
 		BUG_ON(ret);
-- 
1.8.2.1

