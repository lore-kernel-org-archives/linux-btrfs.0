From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.35-rc6 patch] correct item insert accounting...
Date: Fri, 23 Jul 2010 23:46:45 +0100
Message-ID: <AANLkTinZo_nM2RZGPuNJD=jdLRqHEfVV76ra3tSDFBT1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

It looks like this was the intent - if not, perhaps drop the redundant
'nr = i' assignment?

---

Limit the number of items to insert (nr) to the available space in the BTRFS
leaf as intended.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c3df14c..fb7e20d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3544,8 +3544,8 @@ int btrfs_insert_some_items(struct
btrfs_trans_handle *trans,
 	for (i = 0; i < nr; i++) {
 		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
 		    BTRFS_LEAF_DATA_SIZE(root)) {
-			break;
 			nr = i;
+			break;
 		}
 		total_data += data_size[i];
 		total_size += data_size[i] + sizeof(struct btrfs_item);
-- 
Daniel J Blueman
