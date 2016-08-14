Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36617 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbcHNULd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 16:11:33 -0400
Received: by mail-io0-f195.google.com with SMTP id y34so4767231ioi.3
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Aug 2016 13:11:33 -0700 (PDT)
Received: from hary-Aspire-X3400G.Belkin (174-84-246-201.res.bhn.net. [174.84.246.201])
        by smtp.googlemail.com with ESMTPSA id g100sm2973630ioj.1.2016.08.14.13.11.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 14 Aug 2016 13:11:31 -0700 (PDT)
From: Harinath Nampally <harinath922@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] code cleanup 
Date: Sun, 14 Aug 2016 16:11:31 -0400
Message-Id: <1471205491-27411-1-git-send-email-harinath922@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch checks ret value and jumps to clean up in case of
 btrs_add_systme_chunk call fails

Signed-off-by: Harinath Nampally <harinath922@gmail.com>
---
 fs/btrfs/volumes.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 366b335..fedb301 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4880,12 +4880,15 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_item(trans, chunk_root, &key, chunk, item_size);
 	if (ret == 0 && map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		/*
-		 * TODO: Cleanup of inserted chunk root in case of
-		 * failure.
-		 */
 		ret = btrfs_add_system_chunk(chunk_root, &key, chunk,
 					     item_size);
+		if (ret) {
+			/*
+			 * Cleanup of inserted chunk root in case of
+			 * failure.
+			 */
+			goto out;
+		}
 	}
 
 out:
-- 
2.7.4

