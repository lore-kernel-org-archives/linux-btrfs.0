Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49058 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab3JJRky (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 13:40:54 -0400
Received: by mail-ee0-f48.google.com with SMTP id l10so1336592eei.35
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2013 10:40:53 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH] Btrfs: disallow 'btrfs {balance,replace} cancel' on ro mounts
Date: Thu, 10 Oct 2013 20:40:21 +0300
Message-Id: <1381426821-31981-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For both balance and replace, cancelling involves changing the on-disk
state and committing a transaction, which is not a good thing to do on
read-only filesystems.

Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/dev-replace.c |    3 +++
 fs/btrfs/volumes.c     |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9efb94e..98df261 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -650,6 +650,9 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	u64 result;
 	int ret;
 
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
 	btrfs_dev_replace_lock(dev_replace);
 	switch (dev_replace->replace_state) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a306db9..2630f38 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3424,6 +3424,9 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
 
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 {
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	mutex_lock(&fs_info->balance_mutex);
 	if (!fs_info->balance_ctl) {
 		mutex_unlock(&fs_info->balance_mutex);
-- 
1.7.10.4

