Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab3IPSWR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 14:22:17 -0400
Message-Id: <20130916182017.948593448@suse.com>
Date: Mon, 16 Sep 2013 14:19:12 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clmason@fusionio.com
Subject: [patch 2/9] btrfs: use btrfs_commit_transaction when setting fslabel
References: <20130916181910.799140428@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The set_fslabel ioctl uses btrfs_end_transaction, which means it's possible
that the change will be lost if the system crashes. Let's use
btrfs_commit_transaction instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c	2013-09-16 13:50:56.131324074 -0400
+++ b/fs/btrfs/ioctl.c	2013-09-16 13:56:46.415235886 -0400
@@ -4091,7 +4091,7 @@ static int btrfs_ioctl_set_fslabel(struc
 	}
 
 	strcpy(super_block->label, label);
-	ret = btrfs_end_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
 
 out_unlock:
 	mutex_unlock(&root->fs_info->volume_mutex);


