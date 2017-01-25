Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24529 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbdAYPLm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 10:11:42 -0500
Date: Wed, 25 Jan 2017 18:11:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>, kernel-janitors@vger.kernel.org
Subject: [patch] btrfs: white space cleanup in btrfs_log_inode()
Message-ID: <20170125151126.GA27572@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We accidentally deleted a new line in commit 0921910aa6fe ("btrfs: Make
btrfs_log_inode take btrfs_inode")

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f1dc36a181db..010cf7685677 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4824,7 +4824,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 				err = btrfs_log_inode(trans, root,
 						BTRFS_I(other_inode),
 						LOG_OTHER_INODE, 0, LLONG_MAX,
-						ctx); iput(other_inode);
+						ctx);
+				iput(other_inode);
 				if (err)
 					goto out_unlock;
 				else
