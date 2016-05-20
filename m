Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:49291 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbcETDpg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 23:45:36 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 20 May 2016 05:45:12 +0200
Message-Id: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
Subject: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Only btrfs currently implements dedupe_file_range.)

Instead of checking the mode of the file descriptor, let's check whether
it could have been opened rw.  This allows fixing failures when deduping
a live system: anyone trying to exec a file currently being deduped gets
ETXTBSY.

Issuing this ioctl on a ro file was already allowed for root/cap.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index cf377cf..6c414d8 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1736,7 +1736,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 
 		if (info->reserved) {
 			info->status = -EINVAL;
-		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
+		} else if (!(is_admin || !inode_permission(dst, MAY_WRITE))) {
 			info->status = -EINVAL;
 		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
 			info->status = -EXDEV;
-- 
2.8.1

