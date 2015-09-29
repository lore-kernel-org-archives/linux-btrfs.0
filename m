Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38041 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934406AbbI2RLG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:06 -0400
Received: by wiclk2 with SMTP id lk2so25983384wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:05 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 05/11] btrfs-progs: use calloc instead of malloc+memset for disk-io.c
Date: Tue, 29 Sep 2015 19:10:40 +0200
Message-Id: <19237d46fea5d75d61062b1911544ed431f3daff.1443546001.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443546000.git.silvio.fricke@gmail.com>
References: <cover.1443546000.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443546000.git.silvio.fricke@gmail.com>
References: <cover.1443459879.git.silvio.fricke@gmail.com> <cover.1443546000.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch is generated from a coccinelle semantic patch:

	identifier t;
	expression e;
	statement s;
	@@
	-t = malloc(e);
	+t = calloc(1, e);
	(
	if (!t) s
	|
	if (t == NULL) s
	|
	)
	-memset(t, 0, e);

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 disk-io.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 2469a84..f7e6c41 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -698,10 +698,9 @@ struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 	u32 blocksize;
 	int ret = 0;
 
-	root = malloc(sizeof(*root));
+	root = calloc(1, sizeof(*root));
 	if (!root)
 		return ERR_PTR(-ENOMEM);
-	memset(root, 0, sizeof(*root));
 	if (location->offset == (u64)-1) {
 		ret = find_and_setup_root(tree_root, fs_info,
 					  location->objectid, root);
@@ -829,12 +828,10 @@ struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr)
 {
 	struct btrfs_fs_info *fs_info;
 
-	fs_info = malloc(sizeof(struct btrfs_fs_info));
+	fs_info = calloc(1, sizeof(struct btrfs_fs_info));
 	if (!fs_info)
 		return NULL;
 
-	memset(fs_info, 0, sizeof(struct btrfs_fs_info));
-
 	fs_info->tree_root = calloc(1, sizeof(struct btrfs_root));
 	fs_info->extent_root = calloc(1, sizeof(struct btrfs_root));
 	fs_info->chunk_root = calloc(1, sizeof(struct btrfs_root));
-- 
2.5.3

