Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLSRiq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 12:38:46 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D05F3AC18
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 17:38:44 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/4] btrfs: update message levels after checksum errors
Date: Fri, 19 Dec 2014 18:38:44 +0100
Message-Id: <6a9c3d503399cd57821509de23a6eb7bc15feb5e.1419010347.git.dsterba@suse.cz>
In-Reply-To: <cover.1419010347.git.dsterba@suse.cz>
References: <cover.1419010347.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The errors are worth noting and might get missed with INFO level.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/inode.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3b694192a4a9..6e986a34f9a1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -318,7 +318,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			memcpy(&found, result, csum_size);
 
 			read_extent_buffer(buf, &val, 0, csum_size);
-			printk_ratelimited(KERN_INFO
+			printk_ratelimited(KERN_WARNING
 				"BTRFS: %s checksum verify failed on %llu wanted %X found %X "
 				"level %d\n",
 				root->fs_info->sb->s_id, buf->start,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff6d98d8dc20..a91d9ff3293b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2945,7 +2945,7 @@ static int __readpage_endio_check(struct inode *inode,
 	return 0;
 zeroit:
 	if (__ratelimit(&_rs))
-		btrfs_info(BTRFS_I(inode)->root->fs_info,
+		btrfs_warn(BTRFS_I(inode)->root->fs_info,
 			   "csum failed ino %llu off %llu csum %u expected csum %u",
 			   btrfs_ino(inode), start, csum, csum_expected);
 	memset(kaddr + pgoff, 1, len);
-- 
2.1.3

