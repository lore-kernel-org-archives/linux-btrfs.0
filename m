Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbbBYSY7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:24:59 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 26429AAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:24:58 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 08/11] btrfs: remove shadowing variables in __btrfs_buffered_write
Date: Wed, 25 Feb 2015 19:24:57 +0100
Message-Id: <a11665db813ca271ef4fdcc4f9852aba6fcbb761.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are lockstart and lockend defined in the function and not used
after their duplicate definition scope ends, it's safe to reuse them.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e74abb3018d4..a3c2bd77c74b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1631,8 +1631,8 @@ again:
 			btrfs_end_write_no_snapshoting(root);
 
 		if (only_release_metadata && copied > 0) {
-			u64 lockstart = round_down(pos, root->sectorsize);
-			u64 lockend = lockstart +
+			lockstart = round_down(pos, root->sectorsize);
+			lockend = lockstart +
 				(dirty_pages << PAGE_CACHE_SHIFT) - 1;
 
 			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-- 
2.1.3

