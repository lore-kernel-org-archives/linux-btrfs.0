Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab3GKNlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 09:41:24 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 46C1BA52BF
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 15:41:23 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: make errors in btrfs_num_copies less noisy
Date: Thu, 11 Jul 2013 15:41:11 +0200
Message-Id: <1373550071-12702-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The log message level 'critical' is verbose enough, 'emergency' beeps on
all terminals.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b2d1eac..1fd7b5d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4194,13 +4194,13 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	 * and exit, so return 1 so the callers don't try to use other copies.
 	 */
 	if (!em) {
-		btrfs_emerg(fs_info, "No mapping for %Lu-%Lu\n", logical,
+		btrfs_crit(fs_info, "No mapping for %Lu-%Lu\n", logical,
 			    logical+len);
 		return 1;
 	}
 
 	if (em->start > logical || em->start + em->len < logical) {
-		btrfs_emerg(fs_info, "Invalid mapping for %Lu-%Lu, got "
+		btrfs_crit(fs_info, "Invalid mapping for %Lu-%Lu, got "
 			    "%Lu-%Lu\n", logical, logical+len, em->start,
 			    em->start + em->len);
 		return 1;
-- 
1.7.9

