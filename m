Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33264 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbbIMLaH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Sep 2015 07:30:07 -0400
Date: Sun, 13 Sep 2015 14:29:48 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, 00moses.alexander00@gmail.com
Subject: [PATCH 2/2] btrfs: declare rsv_count as u64 instead of int
Message-ID: <20150913142948.GA7163@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch completes the 2-patches patch series which modifies
btrfs_start_transaction() to receive an u64 as its "num_items"
parameter thus avoiding to pass an int to start_transaction()
which actually takes an u64.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b823fac..92f6060 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2266,7 +2266,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	u64 drop_end;
 	int ret = 0;
 	int err = 0;
-	int rsv_count;
+	u64 rsv_count;
 	bool same_page;
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
 	u64 ino_size;
-- 
2.5.1

