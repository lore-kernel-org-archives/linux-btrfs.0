Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:37501 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbbFVJJB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 05:09:01 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 6/7] Btrfs: incremental send, don't send utimes for non-existing directory
Date: Mon, 22 Jun 2015 17:08:47 +0800
Message-Id: <1434964128-31757-7-git-send-email-robbieko@synology.com>
In-Reply-To: <1434964128-31757-1-git-send-email-robbieko@synology.com>
References: <1434964128-31757-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's one case where we can't issue a utimes operation for a directory.
First, 261 can't move to d/item1 without the rename of inode 265. So as 262.
Thus 261 and 262 need to wait for rename.
Second, since 263 will be deleted and there are two waiting sub-directory
261 and 262, rmdir_ino of 261 will set to 263 and rmdir_ino of 262 is not set.
If 262 is processed earlier than 261, utime of both 263 and 264 will be
updated. However, 263 should not update since it will vanish.

I've found that the following case is the main cause of such error
and it's fs tree is shown via btrfs-debug-tress as below.

file tree key (459 ROOT_ITEM 20487)
node 132988928 level 1 items 3 free 490 generation 20487 owner 459
fs uuid b451ae42-3b03-4003-b0a4-45dce324557f
chunk uuid d8831db3-2e42-4b32-9a5c-3efdf50d36bc
        key (256 INODE_ITEM 0) block 132710400 (8100) gen 20486
        key (264 INODE_ITEM 0) block 130695168 (7977) gen 20480
        key (266 XATTR_ITEM 952319794) block 126042112 (7693) gen 20464
leaf 132710400 items 166 free space 3639 generation 20486 owner 455
fs uuid b451ae42-3b03-4003-b0a4-45dce324557f
chunk uuid d8831db3-2e42-4b32-9a5c-3efdf50d36bc
        item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
                inode generation 20425 transid 20442 size 32 block
group 0 mode 40755 links 1 uid 0 gid 0 rdev 0 flags 0x0
        item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
                inode ref index 0 namelen 2 name: ..
...
        item 165 key (262 XATTR_ITEM 1100961104) itemoff 7789 itemsize 39
                location key (0 UNKNOWN.0 0) type XATTR
                namelen 8 datalen 1 name: user.a78
                data a
                binary 61
leaf 130695168 items 133 free space 7332 generation 20480 owner 455
fs uuid b451ae42-3b03-4003-b0a4-45dce324557f
chunk uuid d8831db3-2e42-4b32-9a5c-3efdf50d36bc
        item 0 key (264 INODE_ITEM 0) itemoff 16123 itemsize 160
                inode generation 20428 transid 20434 size 10 block
group 0 mode 40755 links 1 uid 0 gid 0 rdev 0 flags 0x0
        item 1 key (264 INODE_REF 256) itemoff 16112 itemsize 11
                inode ref index 11 namelen 1 name: c
...

We can see that inode 262 is right at the end of leaf. Then send_utime() will
use btrfs_search_slot() to find a appropriate place to put 262 where is at the
back of 262. However, that place is uninitialized on disk. Suppose we read
atime tv_sec:576469548413222912, tv_nsec:1919251317 and then send it out.
Receiving side will  got EINVAL since tv_nsec:1919251317 is greater
than 999,999,999.

So fix this by don't send utimes for non-existing directory for this case.

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

Signed-off-by: Robbie Ko <robbieko@synology.com>
---

V2:don't send utimes for non-existing directory

 fs/btrfs/send.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index cd22f7d..579a4c8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3243,8 +3243,18 @@ finish:
 	 * and old parent(s).
 	 */
 	list_for_each_entry(cur, &pm->update_refs, list) {
-		if (cur->dir == rmdir_ino)
+		/*
+		 * don't send utimes for non-existing directory
+		 */
+		ret = get_inode_info(sctx->send_root, cur->dir, NULL,
+			     NULL , NULL, NULL, NULL, NULL);
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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
