Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3CTNba (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 09:31:30 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 93374A51CA
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2013 14:31:29 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: make orphan cleanup less verbose
Date: Wed, 20 Mar 2013 14:31:27 +0100
Message-Id: <1363786287-615-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The messages

  btrfs: unlinked 123 orphans
  btrfs: truncated 456 orphans

are not useful to regular users and raise questions whether there are
problems with the filesystem.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 315a515..41a4d9c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3221,9 +3221,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 	}
 
 	if (nr_unlink)
-		printk(KERN_INFO "btrfs: unlinked %d orphans\n", nr_unlink);
+		printk(KERN_DEBUG "btrfs: unlinked %d orphans\n", nr_unlink);
 	if (nr_truncate)
-		printk(KERN_INFO "btrfs: truncated %d orphans\n", nr_truncate);
+		printk(KERN_DEBUG "btrfs: truncated %d orphans\n", nr_truncate);
 
 out:
 	if (ret)
-- 
1.7.9

