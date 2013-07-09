Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3GIQi4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jul 2013 12:38:56 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 16846A51FE
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jul 2013 18:38:56 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: use accessor macro for otime
Date: Tue,  9 Jul 2013 18:38:55 +0200
Message-Id: <1373387935-30983-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_item->otime value must be accessed via the macro otherwise the
value is incorrect on big endian machines.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index c3d35de..7f34237 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1059,7 +1059,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 				flags = btrfs_root_flags(ri);
 				if(sh.len >
 				   sizeof(struct btrfs_root_item_v0)) {
-					t = ri->otime.sec;
+					t = btrfs_stack_timespec_sec(&ri->otime);
 					ogen = btrfs_root_otransid(ri);
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
 					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
-- 
1.8.2

