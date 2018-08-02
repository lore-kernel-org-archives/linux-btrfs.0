Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbeHBKev (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 06:34:51 -0400
Date: Thu, 2 Aug 2018 11:44:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] btrfs: dereferencing error pointer in btrfs_quota_enable()
Message-ID: <20180802084428.k2uemow7k6j3us47@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error handling in "goto out;" expects that if "trans" is non-NULL
that means it's valid.  Unfortunately it could also be an error pointer.

Fixes: c9a6fe84fe43 ("btrfs: qgroups: Move transaction management inside btrfs_quota_enable/disable")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3a9019928329..380ff978defa 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -904,6 +904,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	trans = btrfs_start_transaction(tree_root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		trans = NULL;
 		goto out;
 	}
 
