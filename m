Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab2JPJel (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 05:34:41 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] btrfs: Return EINVAL when length to trim is less than FSB
Date: Tue, 16 Oct 2012 11:34:36 +0200
Message-Id: <1350380076-15997-1-git-send-email-lczerner@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently if len argument in btrfs_ioctl_fitrim() is smaller than
one FSB we will continue and finally return 0 bytes discarded.
However if the length to discard is smaller then file system block
we should really return EINVAL.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6116880..3b8b509 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -343,7 +343,8 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 		return -EOPNOTSUPP;
 	if (copy_from_user(&range, arg, sizeof(range)))
 		return -EFAULT;
-	if (range.start > total_bytes)
+	if (range.start > total_bytes ||
+	    range.len < fs_info->sb->s_blocksize)
 		return -EINVAL;
 
 	range.len = min(range.len, total_bytes - range.start);
-- 
1.7.7.6

