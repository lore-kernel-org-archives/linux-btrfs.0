Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876AbcCQKrr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 06:47:47 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2FC67AB12
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 10:47:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: subvol sync: fix memory corruption, undersized array
Date: Thu, 17 Mar 2016 11:47:19 +0100
Message-Id: <1458211640-13106-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subvol sync command crashed randomly at the end with

*** glibc detected *** btrfs: double free or corruption (out): 0x00000000006ab040 ***

This is caused by running out of the ids array in case there are more
than 128 subvolumes. The array is increased in steps but does not
account the size of the item, so there was room for 1024 / 8 = 128
subvolume ids.

Fixes: c9f885ec8963 ("btrfs-progs: subvol: let sync check only current deletions")
Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-subvolume.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 02e1dec18ed2..32caaa5db9ec 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1204,7 +1204,8 @@ static int enumerate_dead_subvols(int fd, u64 **ids)
 					u64 *newids;
 
 					count += SUBVOL_ID_BATCH;
-					newids = (u64*)realloc(*ids, count);
+					newids = (u64*)realloc(*ids,
+							count * sizeof(u64));
 					if (!newids)
 						return -ENOMEM;
 					*ids = newids;
-- 
2.7.1

