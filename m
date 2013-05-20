Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47020 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3ETPtN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 11:49:13 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so5711072pad.8
        for <linux-btrfs@vger.kernel.org>; Mon, 20 May 2013 08:49:12 -0700 (PDT)
Date: Mon, 20 May 2013 23:48:54 +0800
Subject: Re: [PATCH] Btrfs: fix estale with btrfs send
Message-ID: <b187dmcaigs812gqdmx0i9qh.1369064934798@email.android.com>
From: Wang Shilong <wangshilong1991@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,
It seems you missed Reported-by in changelog~_~


Thanks,
Wang

Josef Bacik <jbacik@fusionio.com>ç¼–å†™ï¼š

>This fixes bugzilla 57491.  If we take a snapshot of a fs with a unlink ongoing
>and then try to send that root we will run into problems.  When comparing with a
>parent root we will search the parents and the send roots commit_root, which if
>we've just created the snapshot will include the file that needs to be evicted
>by the orphan cleanup.  So when we find a changed extent we will try and copy
>that info into the send stream, but when we lookup the inode we use the normal
>root, which no longer has the inode because the orphan cleanup deleted it.  The
>best solution I have for this is to check our otransid with the generation of
>the commit root and if they match just commit the transaction again, that way we
>get the changes from the orphan cleanup.  With this patch the reproducer I made
>for this bugzilla no longer returns ESTALE when trying to do the send.  Thanks,
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>---
> fs/btrfs/send.c |   35 +++++++++++++++++++++++++++++++++++
> 1 files changed, 35 insertions(+), 0 deletions(-)
>
>diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>index ff40f1c..ba9690b 100644
>--- a/fs/btrfs/send.c
>+++ b/fs/btrfs/send.c
>@@ -4579,6 +4579,41 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
> 	send_root = BTRFS_I(file_inode(mnt_file))->root;
> 	fs_info = send_root->fs_info;
> 
>+	/*
>+	 * This is done when we lookup the root, it should already be complete
>+	 * by the time we get here.
>+	 */
>+	WARN_ON(send_root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE);
>+
>+	/*
>+	 * If we just created this root we need to make sure that the orphan
>+	 * cleanup has been done and committed since we search the commit root,
>+	 * so check its commit root transid with our otransid and if they match
>+	 * commit the transaction to make sure everything is updated.
>+	 */
>+	down_read(&send_root->fs_info->extent_commit_sem);
>+	if (btrfs_header_generation(send_root->commit_root) ==
>+	    btrfs_root_otransid(&send_root->root_item)) {
>+		struct btrfs_trans_handle *trans;
>+
>+		up_read(&send_root->fs_info->extent_commit_sem);
>+
>+		trans = btrfs_attach_transaction_barrier(send_root);
>+		if (IS_ERR(trans)) {
>+			if (PTR_ERR(trans) != -ENOENT) {
>+				ret = PTR_ERR(trans);
>+				goto out;
>+			}
>+			/* ENOENT means theres no transaction */
>+		} else {
>+			ret = btrfs_commit_transaction(trans, send_root);
>+			if (ret)
>+				goto out;
>+		}
>+	} else {
>+		up_read(&send_root->fs_info->extent_commit_sem);
>+	}
>+
> 	arg = memdup_user(arg_, sizeof(*arg));
> 	if (IS_ERR(arg)) {
> 		ret = PTR_ERR(arg);
>-- 
>1.7.7.6
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
