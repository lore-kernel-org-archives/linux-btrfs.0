Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:39627 "EHLO
	4.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbcBVAgm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 19:36:42 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 1D07510A0051
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 01:27:48 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH 2/2] Btrfs: dev-replace: fixed comment blocks coding style issues
Date: Mon, 22 Feb 2016 01:27:36 +0100
Message-Id: <1456100856-15604-2-git-send-email-phil@philippeloctaux.com>
In-Reply-To: <1456100856-15604-1-git-send-email-phil@philippeloctaux.com>
References: <1456100856-15604-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Makes the comment blocks start with /* on separate lines, and end
with */ on separate lines as well.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/dev-replace.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index b89a8c6..0d817aa 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -650,8 +650,10 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 	struct btrfs_device *srcdev;
 
 	btrfs_dev_replace_lock(dev_replace);
-	/* even if !dev_replace_is_valid, the values are good enough for
-	 * the replace_status ioctl */
+	/*
+	 * even if !dev_replace_is_valid, the values are good enough for
+	 * the replace_status ioctl
+	 */
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	args->status.replace_state = dev_replace->replace_state;
 	args->status.time_started = dev_replace->time_started;
@@ -870,8 +872,10 @@ void btrfs_dev_replace_lock(struct btrfs_dev_replace *dev_replace)
 	/* the beginning is just an optimization for the typical case */
 	if (atomic_read(&dev_replace->nesting_level) == 0) {
 acquire_lock:
-		/* this is not a nested case where the same thread
-		 * is trying to acqurire the same lock twice */
+		/*
+		 * this is not a nested case where the same thread
+		 * is trying to acqurire the same lock twice
+		 */
 		mutex_lock(&dev_replace->lock);
 		mutex_lock(&dev_replace->lock_management_lock);
 		dev_replace->lock_owner = current->pid;
-- 
2.7.1

