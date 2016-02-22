Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 5.mo1.mail-out.ovh.net ([178.33.45.107]:54879 "EHLO
	5.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbcBVKSU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 05:18:20 -0500
Received: from mail690.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id 2ED86FFB48E
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 11:18:19 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH 2/3] Btrfs: disk-io: fixed an assignment error
Date: Mon, 22 Feb 2016 11:18:07 +0100
Message-Id: <1456136288-4718-2-git-send-email-phil@philippeloctaux.com>
In-Reply-To: <1456136288-4718-1-git-send-email-phil@philippeloctaux.com>
References: <1456136288-4718-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added spaces required around the equal sign, fixing a checkpatch error.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 84cbf16..f642b30 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4412,7 +4412,7 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	btrfs_destroy_pinned_extent(root,
 				    root->fs_info->pinned_extents);
 
-	cur_trans->state =TRANS_STATE_COMPLETED;
+	cur_trans->state = TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
 
 	/*
-- 
2.7.1

