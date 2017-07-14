Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49333 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754568AbdGNRgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 13:36:35 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3ABAAAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 17:36:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/5] btrfs: use GFP_KERNEL in btrfs_defrag_file
Date: Fri, 14 Jul 2017 19:35:20 +0200
Message-Id: <6d877b2948a9d157158dedf8ef118f58b5329578.1500053599.git.dsterba@suse.com>
In-Reply-To: <cover.1500053599.git.dsterba@suse.com>
References: <cover.1500053599.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can safely use GFP_KERNEL, the function is called from two contexts:

- ioctl handler, called directly, no locks taken
- cleaner thread, running all queued defrag work, outside of any locks

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78cf25f6..d260c4c57338 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1308,7 +1308,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	 * context
 	 */
 	if (!file) {
-		ra = kzalloc(sizeof(*ra), GFP_NOFS);
+		ra = kzalloc(sizeof(*ra), GFP_KERNEL);
 		if (!ra)
 			return -ENOMEM;
 		file_ra_state_init(ra, inode->i_mapping);
@@ -1316,8 +1316,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		ra = &file->f_ra;
 	}
 
-	pages = kmalloc_array(max_cluster, sizeof(struct page *),
-			GFP_NOFS);
+	pages = kmalloc_array(max_cluster, sizeof(struct page *), GFP_KERNEL);
 	if (!pages) {
 		ret = -ENOMEM;
 		goto out_ra;
-- 
2.13.0

