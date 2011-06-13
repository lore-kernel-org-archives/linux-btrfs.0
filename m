From: David Sterba <dsterba@suse.cz>
Subject: [PATCH][RFC] btrfs: fix potential overflow in leafsize accounting
Date: Mon, 13 Jun 2011 19:31:04 +0200
Message-ID: <1307986264-5707-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

smatch reported a dead code. It seems to allow wrong item size counting
in leaves, as the first for loop does not adjust the maximum number for
items that would fit in BTRFS_LEAF_DATA_SIZE, and the rest of the code
works with the wrong value. The value of 'nr' is accompanied with
accumulating total_data and total_size, which are compared to the leaf
size and probably prevent this bug to do more harm, but the errorneously
computed value of 'nr' is later used in moving existing items and lastly
for setting up the item for new data.

The bug has a potential to silently corrupt data when leaves are near to
full, though I'm not aware of any related reports so far.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

I haven't tested this yet (thoug I will) because I want to let it out ASAP.


 fs/btrfs/ctree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d840893..c4407a6 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3433,8 +3433,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
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
1.7.5.2.353.g5df3e

