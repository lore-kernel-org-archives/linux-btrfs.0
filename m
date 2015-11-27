Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbbK0PdZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 10:33:25 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 07D13AB13
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 15:31:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: use smaller type for btrfs_path reada
Date: Fri, 27 Nov 2015 16:31:38 +0100
Message-Id: <8522e3cac7fe9aafcc913440dbb674876a013937.1448637387.git.dsterba@suse.com>
In-Reply-To: <cover.1448637387.git.dsterba@suse.com>
References: <cover.1448637387.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The possible values for reada are all positive and bounded, we can later
save some bytes by storing it in u8.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 20579f6aa959..64c1d96d9bf9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -596,7 +596,7 @@ struct btrfs_path {
 	int slots[BTRFS_MAX_LEVEL];
 	/* if there is real range locking, this locks field will change */
 	int locks[BTRFS_MAX_LEVEL];
-	int reada;
+	u8 reada;
 	/* keep some upper locks as we walk down */
 	int lowest_level;
 
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
