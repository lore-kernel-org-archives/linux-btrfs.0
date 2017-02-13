Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752405AbdBMJfF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:35:05 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA5F6ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:35:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 24/29] btrfs: remove unused parameters from btrfs_cmp_data
Date: Mon, 13 Feb 2017 10:34:35 +0100
Message-Id: <aea50515c7c0bc63f5a40eb125f904b85e420b98.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After the page locking has been reworked, we get all pages prepared via
cmp_pages.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 91188a2ac5a1..1f13f8416d29 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3053,8 +3053,7 @@ static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
 	return 0;
 }
 
-static int btrfs_cmp_data(struct inode *src, u64 loff, struct inode *dst,
-			  u64 dst_loff, u64 len, struct cmp_pages *cmp)
+static int btrfs_cmp_data(u64 len, struct cmp_pages *cmp)
 {
 	int ret = 0;
 	int i;
@@ -3221,7 +3220,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	}
 
 	/* pass original length for comparison so we stay within i_size */
-	ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
+	ret = btrfs_cmp_data(olen, &cmp);
 	if (ret == 0)
 		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
 
-- 
2.10.1

