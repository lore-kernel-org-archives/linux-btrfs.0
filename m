Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33077 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbHWNBz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Aug 2015 09:01:55 -0400
Date: Sun, 23 Aug 2015 16:01:42 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: Fixed dsize and last_off declarations
Message-ID: <20150823160142.GA4041@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The return values of btrfs_item_offset_nr and btrfs_item_size_nr are of
type u32. To avoid mixing signed and unsigned integers we should also
declare dsize and last_off to be of type u32.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/ctree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 54114b4..4ff739e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4938,8 +4938,8 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 {
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
-	int last_off;
-	int dsize = 0;
+	u32 last_off;
+	u32 dsize = 0;
 	int ret = 0;
 	int wret;
 	int i;
-- 
2.5.0

