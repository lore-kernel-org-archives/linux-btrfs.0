Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 20.mo4.mail-out.ovh.net ([46.105.33.73]:44333 "EHLO
	20.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbcBVA1r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 19:27:47 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 361FF10A0029
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 01:27:46 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH 1/2] Btrfs: dev-replace: Fixed indentation coding style issues
Date: Mon, 22 Feb 2016 01:27:35 +0100
Message-Id: <1456100856-15604-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use tabs instead of spaces, fixing 3 checkpatch errors.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/dev-replace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index cbb7dbf..b89a8c6 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -378,7 +378,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	btrfs_info_in_rcu(root->fs_info,
 		      "dev_replace from %s (devid %llu) to %s started",
 		      src_device->missing ? "<missing disk>" :
-		        rcu_str_deref(src_device->name),
+		      rcu_str_deref(src_device->name),
 		      src_device->devid,
 		      rcu_str_deref(tgt_device->name));
 
@@ -525,7 +525,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		btrfs_err_in_rcu(root->fs_info,
 			      "btrfs_scrub_dev(%s, %llu, %s) failed %d",
 			      src_device->missing ? "<missing disk>" :
-			        rcu_str_deref(src_device->name),
+			      rcu_str_deref(src_device->name),
 			      src_device->devid,
 			      rcu_str_deref(tgt_device->name), scrub_ret);
 		btrfs_dev_replace_unlock(dev_replace);
@@ -542,7 +542,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	btrfs_info_in_rcu(root->fs_info,
 		      "dev_replace from %s (devid %llu) to %s finished",
 		      src_device->missing ? "<missing disk>" :
-		        rcu_str_deref(src_device->name),
+		      rcu_str_deref(src_device->name),
 		      src_device->devid,
 		      rcu_str_deref(tgt_device->name));
 	tgt_device->is_tgtdev_for_dev_replace = 0;
-- 
2.7.1

