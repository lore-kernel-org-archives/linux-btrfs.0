Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24448 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389AbaDOCk1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 22:40:27 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3F2drGh020036
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 10:39:54 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Change the hole range to a more accurate value.
Date: Tue, 15 Apr 2014 10:41:00 +0800
Message-ID: <1397529660-28107-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 3ac0d7b96a268a98bd474cab8bce3a9f125aaccf fixed the btrfs expanding
write problem but the hole punched is sometimes too large for some
iovec, which has unmapped data ranges.
This patch will change to hole range to a more accurate value using the
counts checked by the write check routines.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index eb742c0..a4ce634 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1777,7 +1777,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	start_pos = round_down(pos, root->sectorsize);
 	if (start_pos > i_size_read(inode)) {
 		/* Expand hole size to cover write data, preventing empty gap */
-		end_pos = round_up(pos + iov->iov_len, root->sectorsize);
+		end_pos = round_up(pos + count, root->sectorsize);
 		err = btrfs_cont_expand(inode, i_size_read(inode), end_pos);
 		if (err) {
 			mutex_unlock(&inode->i_mutex);
-- 
1.9.2

