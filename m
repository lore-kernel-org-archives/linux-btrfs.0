Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39685 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbcDMGlO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Apr 2016 02:41:14 -0400
Date: Wed, 13 Apr 2016 09:40:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] btrfs: send: silence an integer overflow warning
Message-ID: <20160413064059.GB8092@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The "sizeof(*arg->clone_sources) * arg->clone_sources_count" expression
can overflow.  It causes several static checker warnings.  It's all
under CAP_SYS_ADMIN so it's not that serious but lets silence the
warnings.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 73dd5d6..6a8c860 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5979,6 +5979,12 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 		goto out;
 	}
 
+	if (arg->clone_sources_count >
+	    ULLONG_MAX / sizeof(*arg->clone_sources)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!access_ok(VERIFY_READ, arg->clone_sources,
 			sizeof(*arg->clone_sources) *
 			arg->clone_sources_count)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
