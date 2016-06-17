Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbcFQQW3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 12:22:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DE7E4AAF4
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 16:22:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: remove build fixup for qgroup_account_snapshot
Date: Fri, 17 Jun 2016 18:23:04 +0200
Message-Id: <5734a1c349939152ee5e990f85136feb9355236d.1466180408.git.dsterba@suse.com>
In-Reply-To: <cover.1466180408.git.dsterba@suse.com>
References: <cover.1466180408.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduced in 2c1984f244838477aab ("btrfs: build fixup for
qgroup_account_snapshot") as temporary bisectability build fixup.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4e74b5733030..765845742fde 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1311,11 +1311,6 @@ int btrfs_defrag_root(struct btrfs_root *root)
 	return ret;
 }
 
-/* Bisesctability fixup, remove in 4.8 */
-#ifndef btrfs_std_error
-#define btrfs_std_error btrfs_handle_fs_error
-#endif
-
 /*
  * Do all special snapshot related qgroup dirty hack.
  *
-- 
2.7.1

