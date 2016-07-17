Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:36746 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbcGQWOQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 18:14:16 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Mon, 18 Jul 2016 00:13:38 +0200
Message-Id: <1468793618-10496-1-git-send-email-kilobyte@angband.pl>
Subject: [PATCH] vfs: allow FILE_EXTENT_SAME (dedupe_file_range) on a file opened ro
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of checking the mode of the file descriptor, let's check whether it
could have been opened rw.  This allows fixing intermittent exec failures
when deduping a live system: anyone trying to exec a file currently being
deduped gets ETXTBSY.

Issuing this ioctl on a ro file was already allowed for root/cap.

Tested on btrfs and not-yet-merged xfs, as only them implement this ioctl.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 933b53a..df59dc6 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1723,7 +1723,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 
 		if (info->reserved) {
 			info->status = -EINVAL;
-		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
+		} else if (!(is_admin || !inode_permission(dst, MAY_WRITE))) {
 			info->status = -EINVAL;
 		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
 			info->status = -EXDEV;
-- 
2.8.1

