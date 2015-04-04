Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:20108 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbbDDTNp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Apr 2015 15:13:45 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH 05/16] btrfs: use is_xxx_kiocb instead of filp->fl_flags
Date: Sat,  4 Apr 2015 23:13:14 +0400
Message-Id: <1428174805-853-6-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1428174805-853-1-git-send-email-dmonakhov@openvz.org>
References: <1428174805-853-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/btrfs/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index aee18f8..4dc3856 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1747,7 +1747,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	mutex_lock(&inode->i_mutex);
 
 	current->backing_dev_info = inode_to_bdi(inode);
-	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
+	err = generic_write_checks(iocb, &pos, &count, S_ISBLK(inode->i_mode));
 	if (err) {
 		mutex_unlock(&inode->i_mutex);
 		goto out;
@@ -1800,7 +1800,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	if (sync)
 		atomic_inc(&BTRFS_I(inode)->sync_writers);
 
-	if (file->f_flags & O_DIRECT) {
+	if (is_direct_kiocb(iocb)) {
 		num_written = __btrfs_direct_write(iocb, from, pos);
 	} else {
 		num_written = __btrfs_buffered_write(file, from, pos);
-- 
1.7.1

