Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbaC0SKA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 14:10:00 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1328DACCC
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 18:09:59 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fix listing deleted subvolumes
Date: Thu, 27 Mar 2014 19:09:53 +0100
Message-Id: <1395943793-14042-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The real check whether to show deleted or live subvolumes was skipped if
just '-d' was specified without other filters. The 'deleted' filter was
not accounted.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-list.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 912b27c3deca..c34f85e9991f 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1218,6 +1218,7 @@ int btrfs_list_setup_filter(struct btrfs_list_filter_set **filter_set,
 
 	if (filter == BTRFS_LIST_FILTER_DELETED) {
 		set->only_deleted = 1;
+		set->nfilters++;
 		return 0;
 	}
 
-- 
1.7.9

