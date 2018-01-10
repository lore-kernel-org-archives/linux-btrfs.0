Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934222AbeAJQcR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 11:32:17 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B61D7AE80
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 16:32:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH RESEND 3/4] btrfs: Remove transaction handle from btrfs_file_private
Date: Wed, 10 Jan 2018 18:32:12 +0200
Message-Id: <1515601933-27331-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1515601933-27331-1-git-send-email-nborisov@suse.com>
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
 <1515601933-27331-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we no longer support userspace transaction there is no need to
keep this member variable, so remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h | 1 -
 fs/btrfs/file.c  | 2 --
 2 files changed, 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6a4752177ad8..dc679246b8e8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1265,7 +1265,6 @@ struct btrfs_root {
 };
 
 struct btrfs_file_private {
-	struct btrfs_trans_handle *trans;
 	void *filldir_buf;
 };
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 291036513017..101e0c7fea92 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1996,8 +1996,6 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 {
 	struct btrfs_file_private *private = filp->private_data;
 
-	if (private && private->trans)
-		btrfs_ioctl_trans_end(filp);
 	if (private && private->filldir_buf)
 		kfree(private->filldir_buf);
 	kfree(private);
-- 
2.7.4

