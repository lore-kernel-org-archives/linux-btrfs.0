Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36392 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2IUEmC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 00:42:02 -0400
Received: by qaas11 with SMTP id s11so976327qaa.19
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 21:42:02 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 12:42:02 +0800
Message-ID: <CAPgLHd-ikKq2V2aZ-u1AJAdaxma19DEifui+q+FxmX0pAh_mLA@mail.gmail.com>
Subject: [PATCH] Btrfs: fix return value check in btrfs_ioctl_send()
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

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/btrfs/send.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

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


