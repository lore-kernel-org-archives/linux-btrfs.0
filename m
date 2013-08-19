Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:45260 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3HSQvP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 12:51:15 -0400
Received: from pizpot.store ([192.168.43.236])
 by joses.store (RZmta 31.43 OK) with ESMTP id X02c54p7JCAmi2
 for <linux-btrfs@vger.kernel.org>;
 Mon, 19 Aug 2013 18:51:13 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: don't allow the replace procedure on read only filesystems
Date: Mon, 19 Aug 2013 18:51:13 +0200
Message-Id: <1376931073-25320-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you start the replace procedure on a read only filesystem, at
the end the procedure fails to write the updated dev_items to the
chunk tree. The problem is that this error is not indicated except
for a WARN_ON(). If the user now thinks that everything was done
as expected and destroys the source device (with mkfs or with a
hammer). The next mount fails with "failed to read chunk root" and
the filesystem is gone.

This commit adds code to fail the attempt to start the replace
procedure if the filesystem is mounted read-only.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: <stable@vger.kernel.org> # 3.10+
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3e36626..bf42d41 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3653,6 +3653,9 @@ static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
 
 	switch (p->cmd) {
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
+		if (root->fs_info->sb->s_flags & MS_RDONLY)
+			return -EROFS;
+
 		if (atomic_xchg(
 			&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
-- 
1.8.3.4

