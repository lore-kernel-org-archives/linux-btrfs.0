Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37986 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752598Ab3KDVhA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:37:00 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] btrfs: replace path->slots[0] with otherwise unused variable 'slot'
Date: Mon,  4 Nov 2013 22:34:28 +0100
Message-Id: <1383600869-10085-9-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/backref.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0552a59..5418435 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1681,8 +1681,8 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 		btrfs_release_path(path);
 
 		leaf = path->nodes[0];
-		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+		item_size = btrfs_item_size_nr(leaf, slot);
+		ptr = btrfs_item_ptr_offset(leaf, slot);
 		cur_offset = 0;
 
 		while (cur_offset < item_size) {
-- 
1.7.10.4

