Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52578 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab3BAQxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 11:53:43 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id u6Feu1D5GWg9ZvJy (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 01 Feb 2013 09:53:42 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: use btrfs_lookup_first_block_group when fixing accounting
Date: Fri, 1 Feb 2013 12:00:32 -0500
Message-ID: <1359738032-8943-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was a bug from long time ago that never actually got fixed.  We start
with bytenr 0 when looping through all of the block groups, but
btrfs_lookup_block_group will bail out since it couldn't find a block group
with 0 as the bytenr.  Btrfs_lookup_first_block_group will be nice and
adjust the start up to the right value, so this way we reset all the block
groups properly and not screw up the users block group accounting.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 20cdffa..10cc995 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3406,7 +3406,7 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 	}
 
 	while(1) {
-		cache = btrfs_lookup_block_group(fs_info, start);
+		cache = btrfs_lookup_first_block_group(fs_info, start);
 		if (!cache)
 			break;
 		start = cache->key.objectid + cache->key.offset;
-- 
1.7.7.6

