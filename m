Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53251 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750732AbdGYNNE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 09:13:04 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, josef@toxicpanda.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Deprecate userspace transaction ioctls
Date: Tue, 25 Jul 2017 16:12:58 +0300
Message-Id: <1500988378-16318-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Userspace transactions were introduced in commit
6bf13c0cc833 ("Btrfs: transaction ioctls") to provide semantics that Ceph's
object store required. However, things have changed significantly since then,
to the point where btrfs is no longer suitable as a backend for ceph and in fact
it's actively advised against such usages. Considering this, there doesn't
seem to be a widespread, legit use case of userspace transaction. They also
clutter the file->private pointer.

So to end the agony let's nuke the userspace transaction ioctls. As a first
step let's give time for people to voice their objection by just WARN()ining
when the userspace transaction are used.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78cf25f6..5ddbacf67e95 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4000,6 +4000,8 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
+	WARN_ON_ONCE(1);
+
 	ret = -EPERM;
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
@@ -4280,6 +4282,8 @@ long btrfs_ioctl_trans_end(struct file *file)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
 
+	WARN_ON_ONCE(1);
+
 	trans = file->private_data;
 	if (!trans)
 		return -EINVAL;
-- 
2.7.4

