Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60461 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751078AbdGZI0c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 04:26:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A95ADAB9B
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 08:26:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@susze.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Deprecate userspace transaction ioctls
Date: Wed, 26 Jul 2017 11:26:28 +0300
Message-Id: <1501057588-7542-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20170725154623.GB2866@suse.cz>
References: <20170725154623.GB2866@suse.cz>
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
when the userspace transaction is used.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78cf25f6..10d78d71df96 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4000,6 +4000,12 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
+	btrfs_warn(fs_info, "Userspace transaction mechanism is considered
+		   deprecated and slated to be removed in the near future "
+		   "(1 or 2 releases). If you have a valid use case please
+		   speak up on the mailing list");
+	WARN_ON_ONCE(1);
+
 	ret = -EPERM;
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
-- 
2.7.4

