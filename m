Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32119 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3AJI5X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 03:57:23 -0500
Date: Thu, 10 Jan 2013 11:57:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Btrfs: fix access_ok() check in btrfs_ioctl_send()
Message-ID: <20130110085725.GA23063@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The closing parenthesis is in the wrong place.  We want to check
"sizeof(*arg->clone_sources) * arg->clone_sources_count" instead of
"sizeof(*arg->clone_sources * arg->clone_sources_count)".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is also vulnerable to integer overflows.  It's only done under
root, but these days we are trying to restrict what root can do without
configuring Secure Boot in UEFI.

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5445454..4be3832 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4553,8 +4553,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	}
 
 	if (!access_ok(VERIFY_READ, arg->clone_sources,
-			sizeof(*arg->clone_sources *
-			arg->clone_sources_count))) {
+			sizeof(*arg->clone_sources) *
+			arg->clone_sources_count)) {
 		ret = -EFAULT;
 		goto out;
 	}
