Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32912 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbbJSLon (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:44:43 -0400
Received: by pabrc13 with SMTP id rc13so189426316pab.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:44:42 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 05/10] btrfs-progs: mute coverity warnings about deadcode
Date: Mon, 19 Oct 2015 19:37:55 +0800
Message-Id: <1445254680-11102-6-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Coverity reports execution cannot reach this statements. So put WARN_ON
in if-else conditions.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 backref.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/backref.c b/backref.c
index 9a2efca..8f41f82 100644
--- a/backref.c
+++ b/backref.c
@@ -323,9 +323,9 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 
 	eb = path->nodes[level];
 	while (!eb) {
-		WARN_ON(!level);
 		if (!level) {
 			ret = 1;
+			WARN_ON(1);
 			goto out;
 		}
 		level--;
@@ -1178,7 +1178,6 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 		 logical, logical - found_key->objectid, found_key->objectid,
 		 found_key->offset, flags, item_size);
 
-	WARN_ON(!flags_ret);
 	if (flags_ret) {
 		if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
 			*flags_ret = BTRFS_EXTENT_FLAG_TREE_BLOCK;
@@ -1187,9 +1186,10 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 		else
 			BUG_ON(1);
 		return 0;
+	} else {
+		WARN_ON(1);
+		return -EIO;
 	}
-
-	return -EIO;
 }
 
 /*
-- 
2.4.3

