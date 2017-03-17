Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38262 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbdCQUww (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 16:52:52 -0400
Date: Fri, 17 Mar 2017 23:51:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Btrfs: fix an integer overflow check
Message-ID: <20170317205120.GE16505@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This isn't super serious because you need CAP_ADMIN to run this code.

I added this integer overflow check last year but apparently I am
rubbish at writing integer overflow checks...  There are two issues.
First, access_ok() works on unsigned long type and not u64 so on 32 bit
systems the access_ok() could be checking a truncated size.  The other
issue is that we should be using a stricter limit so we don't overflow
the kzalloc() setting ctx->clone_roots later in the function after the
access_ok():

	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);

Fixes: f5ecec3ce21f ("btrfs: send: silence an integer overflow warning")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 030d592ed1fe..ad9508e67384 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6306,7 +6306,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	}
 
 	if (arg->clone_sources_count >
-	    ULLONG_MAX / sizeof(*arg->clone_sources)) {
+	    ULONG_MAX / sizeof(struct clone_root) - 1) {
 		ret = -EINVAL;
 		goto out;
 	}
