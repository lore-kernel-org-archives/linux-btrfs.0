Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:23141 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3EMOm7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 10:42:59 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp1) (RZmta 31.27 OK)
	with ESMTP id X01ee0p4D7UIcp for <linux-btrfs@vger.kernel.org>;
	Mon, 13 May 2013 16:42:57 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] Btrfs: cleanup, btrfs_read_fs_root_no_name() doesn't return NULL
Date: Mon, 13 May 2013 16:42:57 +0200
Message-Id: <ccd02993e73d688c0292ee8ea77c77490b709fb2.1368455876.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368455876.git.sbehrens@giantdisaster.de>
References: <cover.1368455876.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to check for NULL in send.c and disk-io.c.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
v1 -> v2:
One more place where the check for NULL can be deleted.

 fs/btrfs/disk-io.c | 2 --
 fs/btrfs/send.c    | 8 ++------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e8b5027..4904d7f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2757,8 +2757,6 @@ retry_root_backup:
 	location.offset = (u64)-1;
 
 	fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
-	if (!fs_info->fs_root)
-		goto fail_qgroup;
 	if (IS_ERR(fs_info->fs_root)) {
 		err = PTR_ERR(fs_info->fs_root);
 		goto fail_qgroup;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ff40f1c..f075c82 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4663,10 +4663,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 			key.type = BTRFS_ROOT_ITEM_KEY;
 			key.offset = (u64)-1;
 			clone_root = btrfs_read_fs_root_no_name(fs_info, &key);
-			if (!clone_root) {
-				ret = -EINVAL;
-				goto out;
-			}
 			if (IS_ERR(clone_root)) {
 				ret = PTR_ERR(clone_root);
 				goto out;
@@ -4682,8 +4678,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		key.type = BTRFS_ROOT_ITEM_KEY;
 		key.offset = (u64)-1;
 		sctx->parent_root = btrfs_read_fs_root_no_name(fs_info, &key);
-		if (!sctx->parent_root) {
-			ret = -EINVAL;
+		if (IS_ERR(sctx->parent_root)) {
+			ret = PTR_ERR(sctx->parent_root);
 			goto out;
 		}
 	}
-- 
1.8.2.2

