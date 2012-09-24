Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37256 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab2IXNm0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 09:42:26 -0400
Received: by qadc26 with SMTP id c26so821562qad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 06:42:26 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Sep 2012 21:42:26 +0800
Message-ID: <CAPgLHd8F8r4i5HpAaDR_GKwxuw6At4nyKJKCp2Tk4k2xUG14fg@mail.gmail.com>
Subject: [PATCH v2] Btrfs: fix return value check
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris.mason@fusionio.com
Cc: yongjun_wei@trendmicro.com.cn, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function btrfs_read_fs_root_no_name() returns
ERR_PTR() and never returns NULL pointer. The NULL test in the return
value check should be replaced with IS_ERR(), and remove useless
NULL test.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
v1 -> v2: remove null test from fs/btrfs/disk-io.c 
---
 fs/btrfs/disk-io.c | 2 --
 fs/btrfs/send.c    | 8 ++------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 22e98e0..1405620 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2593,8 +2593,6 @@ retry_root_backup:
 	location.offset = (u64)-1;
 
 	fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
-	if (!fs_info->fs_root)
-		goto fail_qgroup;
 	if (IS_ERR(fs_info->fs_root)) {
 		err = PTR_ERR(fs_info->fs_root);
 		goto fail_qgroup;

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fb5ffe9..a617451 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4501,10 +4501,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
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
@@ -4520,8 +4516,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
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


