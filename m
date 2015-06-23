Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:37811 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbbFWKj7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 06:39:59 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v3 6/7] Btrfs: incremental send, don't send utimes for non-existing directory
Date: Tue, 23 Jun 2015 18:39:50 +0800
Message-Id: <1435055991-10109-7-git-send-email-robbieko@synology.com>
In-Reply-To: <1435055991-10109-1-git-send-email-robbieko@synology.com>
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's one where we attempt to get utimes from a directory that
doesn't exist in the send snapshot.

Example:

Parent snapshot:
|---- a/ (ino 259)
    |---- c (ino 264)
|---- b/ (ino 260)
    |---- d (ino 265)
|---- del/ (ino 263)
    |---- item1/ (ino 261)
    |---- item2/ (ino 262)

Send snapshot:
|---- a/ (ino 259)
|---- b/ (ino 260)
|---- c/ (ino 264)
    |---- item2 (ino 262)
|---- d/ (ino 265)
    |---- item1/ (ino 261)

First, 261 can't move to d/item1 without the rename of inode 265.
So as 262. Thus 261 and 262 need to wait for rename.
Second, since 263 will be deleted and there are two waiting
sub-directory 261 and 262, rmdir_ino of 261 will set to 263 and
rmdir_ino of 262 is not set. If 262 is processed earlier than 261,
utime of both 263 and 264 will be updated. However, 263 should not
update since it will vanish.

We're trying to send utimes for a directory/inode that doesn't exist
in the send snapshot. That send_utimes() will use part of a leaf
beyond its boundaries or a wrong slot (belonging to some other
unrelated inode), because btrfs_search_slot() returns 1 when we call
it to find the inode item to extract a utimes value from, and
send_utimes() is not prepared to deal with such case because it
assumes no one calls it for an inode that doesn't exist in the send
root. And that we fix the problem in the offending caller.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---

V3:modify comment

 fs/btrfs/send.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 838abf4..dcf384d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3241,8 +3241,18 @@ finish:
 	 * and old parent(s).
 	 */
 	list_for_each_entry(cur, &pm->update_refs, list) {
-		if (cur->dir == rmdir_ino)
+		/*
+		 * don't send utimes for non-existing directory
+		 */
+		ret = get_inode_info(sctx->send_root, cur->dir, NULL,
+			     NULL, NULL, NULL, NULL, NULL);
+		if (ret == -ENOENT) {
+			ret = 0;
 			continue;
+		}
+		if (ret < 0)
+			goto out;
+
 		ret = send_utimes(sctx, cur->dir, cur->dir_gen);
 		if (ret < 0)
 			goto out;
-- 
1.9.1

