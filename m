Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57948 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3F3LxA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 07:53:00 -0400
Received: by mail-wi0-f179.google.com with SMTP id hj3so2234821wib.0
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 04:52:59 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/3] Btrfs-progs: add missing write check for mkfs
Date: Sun, 30 Jun 2013 12:51:44 +0100
Message-Id: <1372593106-6593-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Assert that the write of the device tree root succeeds.
This verification is currently done for all other tree
roots, however it was missing for the device tree root.

Would this tree root write fail, but all others succeed,
it would lead to a corrupted/incomplete btrfs filesystem.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 utils.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/utils.c b/utils.c
index 7b4cd74..43d93f1 100644
--- a/utils.c
+++ b/utils.c
@@ -381,6 +381,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_nritems(buf, nritems);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
+	BUG_ON(ret != leafsize);
 
 	/* create the FS root */
 	memset(buf->data+sizeof(struct btrfs_header), 0,
-- 
1.7.9.5

