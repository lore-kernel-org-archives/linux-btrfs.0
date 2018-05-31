Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49274 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbeEaGVd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 02:21:33 -0400
Date: Thu, 31 May 2018 09:21:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Btrfs: checking for NULL instead of IS_ERR
Message-ID: <20180531062111.374pq6lxrmdffun6@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

memdup_user() returns error pointers, it doesn't return NULL.

Fixes: 01141b08dee5 ("btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ff5018587bd9..d8dd4504bdab 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2791,9 +2791,9 @@ static noinline int btrfs_ioctl_get_subvol_rootref(struct file *file,
 		return -ENOMEM;
 
 	rootrefs = memdup_user(argp, sizeof(*rootrefs));
-	if (!rootrefs) {
+	if (IS_ERR(rootrefs)) {
 		btrfs_free_path(path);
-		return -ENOMEM;
+		return PTR_ERR(rootrefs);
 	}
 
 	inode = file_inode(file);
