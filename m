Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:38130 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2HAK2E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Aug 2012 06:28:04 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp1) (RZmta 30.2 OK) with ESMTP id X025a8o6VMhBtN
	for <linux-btrfs@vger.kernel.org>;
	Wed, 1 Aug 2012 12:28:01 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND] Btrfs: fix that error value is changed by mistake
Date: Wed,  1 Aug 2012 12:28:01 +0200
Message-Id: <1343816881-23438-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In iterate_inodes_from_logical() the error result from
extent_from_logical() is patched by mistake. Typically ENOENT is
patched to EINVAL because (-ENOENT & BTRFS_EXTENT_FLAG_TREE_BLOCK)
evaluates to true.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
Resent because of the previously forgotten Signed-off-by line.

 fs/btrfs/backref.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a256f3b..ff6475f 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1438,10 +1438,10 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	ret = extent_from_logical(fs_info, logical, path,
 					&found_key);
 	btrfs_release_path(path);
-	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK)
-		ret = -EINVAL;
 	if (ret < 0)
 		return ret;
+	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+		return -EINVAL;
 
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
-- 
1.7.11.4

