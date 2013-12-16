Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3LPQeR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 11:34:17 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5DC40ABE7
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 16:34:16 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/3] btrfs: remove unused mnt from send_ctx
Date: Mon, 16 Dec 2013 17:34:14 +0100
Message-Id: <31f0b819201c1ae4c5a5d141f9a6b0a05f95ac7f.1387211246.git.dsterba@suse.cz>
In-Reply-To: <cover.1387211245.git.dsterba@suse.cz>
References: <cover.1387211245.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unused since ed2590953bd06b892f0411fc94e19175d32f197a
"Btrfs: stop using vfs_read in send".

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 2c1dcab7420d..95f0fae4ce59 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -88,8 +88,6 @@ struct send_ctx {
 	u64 cmd_send_size[BTRFS_SEND_C_MAX + 1];
 	u64 flags;	/* 'flags' member of btrfs_ioctl_send_args is u64 */
 
-	struct vfsmount *mnt;
-
 	struct btrfs_root *send_root;
 	struct btrfs_root *parent_root;
 	struct clone_root *clone_roots;
@@ -4711,8 +4709,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		goto out;
 	}
 
-	sctx->mnt = mnt_file->f_path.mnt;
-
 	sctx->send_root = send_root;
 	sctx->clone_roots_cnt = arg->clone_sources_count;
 
-- 
1.7.9

