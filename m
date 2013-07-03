Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:39170 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3GCRhL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 13:37:11 -0400
Received: by mail-we0-f178.google.com with SMTP id u53so353593wes.23
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 10:37:10 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2 1/3] Btrfs-progs: add missing write check for mkfs
Date: Wed,  3 Jul 2013 18:30:41 +0100
Message-Id: <1372872641-17998-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Assert that the writes of the device and chunk tree
roots succeed. This verification is currently done
for all other tree roots, however it was missing for
those 2 trees.

Would these tree root writes fail, but all others succeed,
it would lead to a corrupted/incomplete btrfs filesystem,
or, more likely some weird failure later on in mkfs.btrfs
inside open_ctree().

V2: Added check for the chunk tree root write.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 utils.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/utils.c b/utils.c
index 7b4cd74..702a0b1 100644
--- a/utils.c
+++ b/utils.c
@@ -346,6 +346,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[3]);
+	BUG_ON(ret != leafsize);
 
 	/* create the device tree */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
@@ -381,6 +382,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
+	BUG_ON(ret != leafsize);
 
 	/* create the FS root */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
-- 
1.7.9.5

