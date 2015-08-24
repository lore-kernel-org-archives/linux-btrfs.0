Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36942 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbHXS4o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 14:56:44 -0400
Date: Mon, 24 Aug 2015 21:56:28 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: Fixed declaration of old_len
Message-ID: <20150824215628.GA18871@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

old_len is used to store the return value of btrfs_item_size_nr().
The return value of btrfs_item_size_nr() is of type u32.
To improve code correctness and avoid mixing signed and unsigned
integers I've changed old_len to be of type u32 as well.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/root-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 360a728..024ea4f 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -141,7 +141,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	int ret;
 	int slot;
 	unsigned long ptr;
-	int old_len;
+	u32 old_len;
 
 	path = btrfs_alloc_path();
 	if (!path)
-- 
2.5.0

