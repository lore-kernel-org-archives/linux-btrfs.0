Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 17.mo1.mail-out.ovh.net ([87.98.179.142]:58919 "EHLO
	17.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbcBVKSY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 05:18:24 -0500
Received: from mail690.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id EE692FFBDF8
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 11:18:22 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH 3/3] Btrfs: disk-io: fixed a comment block coding style issue
Date: Mon, 22 Feb 2016 11:18:08 +0100
Message-Id: <1456136288-4718-3-git-send-email-phil@philippeloctaux.com>
In-Reply-To: <1456136288-4718-1-git-send-email-phil@philippeloctaux.com>
References: <1456136288-4718-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Makes the comment block start with /* on a separate line, and end
with */ on a separate line as well.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f642b30..2545d01 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4416,9 +4416,9 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	wake_up(&cur_trans->commit_wait);
 
 	/*
-	memset(cur_trans, 0, sizeof(*cur_trans));
-	kmem_cache_free(btrfs_transaction_cachep, cur_trans);
-	*/
+	 * memset(cur_trans, 0, sizeof(*cur_trans));
+	 * kmem_cache_free(btrfs_transaction_cachep, cur_trans);
+	 */
 }
 
 static int btrfs_cleanup_transaction(struct btrfs_root *root)
-- 
2.7.1

