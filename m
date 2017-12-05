Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdLEIj4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:39:56 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7088ABFA
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 08:39:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/7] btrfs-progs: Fix super-recovery
Date: Tue,  5 Dec 2017 10:39:49 +0200
Message-Id: <1512463189-24724-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-1-git-send-email-nborisov@suse.com>
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 3296d058b7ce ("btrfs-progs: super-recover: Reuse
 btrfs_read_dev_super function") changed the logic when a superblock
is added to the bad block list to depend on -EIO. However currently
btrfs_read_dev_super doesn't return -EIO when the fist super block
is broken. Instead it returns -1. This causes the super-recovery
logic to miss the fact that the first super block is completely broken.

Fix this by considering any error code from btrfs_read_dev_super other
than -ENOENT to mean that the super block is corrupted. -ENOENT
means that the superblock copy is not part of the fs i.e. it's smaller
than the offset of the block. This can only occur for the 2nd copy at
256gb mark.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 super-recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super-recover.c b/super-recover.c
index e12513100f17..880fd7712546 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -136,7 +136,7 @@ read_dev_supers(char *filename, struct btrfs_recover_superblock *recover)
 			max_gen = btrfs_super_generation(sb);
 			if (max_gen > recover->max_generation)
 				recover->max_generation = max_gen;
-		} else if (ret == -EIO){
+		} else if (ret != -ENOENT){
 			/*
 			 * Skip superblock which doesn't exist, only adds
 			 * really corrupted superblock
-- 
2.7.4

