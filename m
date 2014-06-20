Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966759AbaFTLCT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:02:19 -0400
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/8] btrfs: clenaup: don't call btrfs_release_path before free_path
Date: Fri, 20 Jun 2014 13:02:17 +0200
Message-Id: <b480dc2e1154a662f14e161930660005f170e226.1403260619.git.dsterba@suse.cz>
In-Reply-To: <cover.1403260619.git.dsterba@suse.cz>
References: <cover.1403260619.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/relocation.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 65245a07275b..b3329ad34522 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4096,7 +4096,6 @@ static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_flags(leaf, item, BTRFS_INODE_NOCOMPRESS |
 					  BTRFS_INODE_PREALLOC);
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(path);
 out:
 	btrfs_free_path(path);
 	return ret;
-- 
1.7.9

