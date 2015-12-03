Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbbLCQxm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:53:42 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 819BFADD6
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:53:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs: use GFP_KERNEL for allocations in ioctl handlers
Date: Thu,  3 Dec 2015 17:51:51 +0100
Message-Id: <8d2db7855e7b65c9eecc8789fc54d818ee281ac6.1449160585.git.dsterba@suse.com>
In-Reply-To: <cover.1449160585.git.dsterba@suse.com>
References: <cover.1449160585.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't have to use GFP_NOFS in the ioctl handlers because there's no
risk of looping through the allocators back to the filesystem. This
patch covers only allocations that are directly in the ioctl handlers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index da94138eb85e..2f4a5c26a14f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4147,7 +4147,7 @@ static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 		return -ENOMEM;
 
 	space_args.total_spaces = 0;
-	dest = kmalloc(alloc_size, GFP_NOFS);
+	dest = kmalloc(alloc_size, GFP_KERNEL);
 	if (!dest)
 		return -ENOMEM;
 	dest_orig = dest;
@@ -4673,7 +4673,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 		goto out_bargs;
 	}
 
-	bctl = kzalloc(sizeof(*bctl), GFP_NOFS);
+	bctl = kzalloc(sizeof(*bctl), GFP_KERNEL);
 	if (!bctl) {
 		ret = -ENOMEM;
 		goto out_bargs;
@@ -4759,7 +4759,7 @@ static long btrfs_ioctl_balance_progress(struct btrfs_root *root,
 		goto out;
 	}
 
-	bargs = kzalloc(sizeof(*bargs), GFP_NOFS);
+	bargs = kzalloc(sizeof(*bargs), GFP_KERNEL);
 	if (!bargs) {
 		ret = -ENOMEM;
 		goto out;
@@ -5019,7 +5019,7 @@ static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	qsa = kzalloc(sizeof(*qsa), GFP_NOFS);
+	qsa = kzalloc(sizeof(*qsa), GFP_KERNEL);
 	if (!qsa)
 		return -ENOMEM;
 
@@ -5149,7 +5149,7 @@ static long btrfs_ioctl_set_received_subvol_32(struct file *file,
 		goto out;
 	}
 
-	args64 = kmalloc(sizeof(*args64), GFP_NOFS);
+	args64 = kmalloc(sizeof(*args64), GFP_KERNEL);
 	if (!args64) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.6.2

