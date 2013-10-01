Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45348 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3JAQHA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 12:07:00 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so5845456wid.3
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 09:06:59 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: remove unnecessary tree search when logging inode
Date: Tue,  1 Oct 2013 17:06:53 +0100
Message-Id: <1380643613-25579-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1380640163-12098-1-git-send-email-fdmanana@gmail.com>
References: <1380640163-12098-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In tree-log.c:btrfs_log_inode(), we keep calling btrfs_search_forward()
until it returns a key whose objectid is higher than our inode or until
the key's type is higher than our maximum allowed type.

At the end of the loop, we increment our mininum search key's objectid
and type regardless of our desired target objectid and maximum desired
type, which causes another loop iteration that will call again
btrfs_search_forward() just to figure out we've gone beyond our maximum
key and exit the loop. Therefore while incrementing our minimum key,
don't do it blindly and exit the loop immiediately if the next search
key's objectid or type is beyond what we seek.

Also after incrementing the type, set the key's offset to 0, which was
missing and could make us loose some of the inode's items.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Reset key offset to 0 after incrementing its type field.

 fs/btrfs/tree-log.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79f057c..7ae9e7d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3769,14 +3769,14 @@ next_slot:
 		}
 		btrfs_release_path(path);
 
-		if (min_key.offset < (u64)-1)
+		if (min_key.offset < (u64)-1) {
 			min_key.offset++;
-		else if (min_key.type < (u8)-1)
+		} else if (min_key.type < max_key.type) {
 			min_key.type++;
-		else if (min_key.objectid < (u64)-1)
-			min_key.objectid++;
-		else
+			min_key.offset = 0;
+		} else {
 			break;
+		}
 	}
 	if (ins_nr) {
 		ret = copy_items(trans, inode, dst_path, src, ins_start_slot,
-- 
1.7.9.5

