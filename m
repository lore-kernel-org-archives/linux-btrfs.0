Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab2IMWEn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 18:04:43 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 2AF12A2111
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 00:04:42 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: return EPERM upon rmdir on a subvolume
Date: Fri, 14 Sep 2012 00:04:34 +0200
Message-Id: <1347573874-10808-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A subvolume cannot be deleted via rmdir, but the error code ENOTEMPTY
is confusing. Return EPERM instead, as this is not permitted.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a4167ef..a67dadd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3815,9 +3815,10 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct btrfs_trans_handle *trans;
 	unsigned long nr = 0;
 
-	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
-	    btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID)
+	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
+	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID)
+		return -EPERM;
 
 	trans = __unlink_start_trans(dir, dentry);
 	if (IS_ERR(trans))
-- 
1.7.9

