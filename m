Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64062 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaFLW5v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 18:57:51 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so839062pab.4
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 15:57:50 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH] Properly size the leafsize field in the mdrestore_struct struct.
Date: Thu, 12 Jun 2014 15:57:33 -0700
Message-Id: <1402613853-14956-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's 32 bits as defined in ctree.h, but the struct had it as 64 bits.

Found using MemorySanitizer.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 btrfs-image.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index cf1fe2d..98d765a 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -128,7 +128,7 @@ struct mdrestore_struct {
 	struct rb_root chunk_tree;
 	struct list_head list;
 	size_t num_items;
-	u64 leafsize;
+	u32 leafsize;
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
 	u8 fsid[BTRFS_FSID_SIZE];
-- 
2.0.0.526.g5318336

