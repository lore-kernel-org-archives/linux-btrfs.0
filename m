Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaLSRit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 12:38:49 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, <stable@vger.kernel.org>
Subject: [PATCH 4/4] btrfs: set proper message level for skinny metadata
Date: Fri, 19 Dec 2014 18:38:47 +0100
Message-Id: <ceb2dbfe24bd77d03524f3c94c8a287880483205.1419010347.git.dsterba@suse.cz>
In-Reply-To: <cover.1419010347.git.dsterba@suse.cz>
References: <cover.1419010347.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been confusing people for too long, the message is really just
informative.

CC: <stable@vger.kernel.org> # 3.10+
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6e986a34f9a1..d5e95ec60e12 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2499,7 +2499,7 @@ int open_ctree(struct super_block *sb,
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
-		printk(KERN_ERR "BTRFS: has skinny extents\n");
+		printk(KERN_INFO "BTRFS: has skinny extents\n");
 
 	/*
 	 * flag our filesystem as having big metadata blocks if
-- 
2.1.3

