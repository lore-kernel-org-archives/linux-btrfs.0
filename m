Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaJBQuM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4EF46AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:11 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 06/14] btrfs: fix error labels in init_btrfs_fs
Date: Thu,  2 Oct 2014 18:50:10 +0200
Message-Id: <af13b4922b057b4ebc7e2315a6f666ecb65890e4.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_interface_init rarely fails but we could leak the prelim_ref slab.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b1d2a42f379d..b915d7704f19 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1999,11 +1999,11 @@ static int __init init_btrfs_fs(void)
 
 	err = btrfs_prelim_ref_init();
 	if (err)
-		goto free_prelim_ref;
+		goto free_delayed_ref;
 
 	err = btrfs_interface_init();
 	if (err)
-		goto free_delayed_ref;
+		goto free_prelim_ref;
 
 	btrfs_init_lockdep();
 
-- 
1.8.4.5

