Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:51797 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752492Ab3AaABh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:01:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/11] btrfs: remove unused fd in btrfs_ioctl_send()
Date: Wed, 30 Jan 2013 18:54:52 -0600
Message-Id: <1359593702-53056-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All we do is set it to NULL and test it :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/send.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 321b7fb..614da0d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4536,7 +4536,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_ioctl_send_args *arg = NULL;
 	struct btrfs_key key;
-	struct file *filp = NULL;
 	struct send_ctx *sctx = NULL;
 	u32 i;
 	u64 *clone_sources_tmp = NULL;
@@ -4673,8 +4672,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		goto out;
 
 out:
-	if (filp)
-		fput(filp);
 	kfree(arg);
 	vfree(clone_sources_tmp);
 
-- 
1.7.1

