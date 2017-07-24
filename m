Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34078 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753628AbdGXSAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 14:00:35 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 51309AC6C
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 18:00:34 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: drop ancient page flag mappings
Date: Mon, 24 Jul 2017 19:59:08 +0200
Message-Id: <6ae681b586730a7feca63bcea15aa2b976b97897.1500919093.git.dsterba@suse.com>
In-Reply-To: <cover.1500919093.git.dsterba@suse.com>
References: <cover.1500919093.git.dsterba@suse.com>
In-Reply-To: <cover.1500919093.git.dsterba@suse.com>
References: <cover.1500919093.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's no PageFsMisc. Added by patch 4881ee5a2e995 in 2008, the flag is
not present in current kernels.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c651fb0034ec..128b7435e071 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3135,13 +3135,6 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
 			      u64 *ram_bytes);
 
-/* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
-#if defined(ClearPageFsMisc) && !defined(ClearPageChecked)
-#define ClearPageChecked ClearPageFsMisc
-#define SetPageChecked SetPageFsMisc
-#define PageChecked PageFsMisc
-#endif
-
 /* This forces readahead on a given range of bytes in an inode */
 static inline void btrfs_force_ra(struct address_space *mapping,
 				  struct file_ra_state *ra, struct file *file,
-- 
2.13.0

