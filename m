From: Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] Btrfs-progs: satisfy compiler and change printf modifier
Date: Mon, 14 Nov 2011 16:24:10 +0100
Message-ID: <1321284250-15265-1-git-send-email-arnd@arndnet.de>
Cc: chris.mason@oracle.com, Arnd Hannemann <arnd@arndnet.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

One-liner which fixes the gcc warning:
warning: format '%u' expects argument of type 'unsigned int',
but argument 3 has type 'long unsigned int' [-Wformat]

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 5bed3c2..5211bee 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1067,7 +1067,7 @@ static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	}
 #endif
 	if (item_size < sizeof(*ei)) {
-		printf("Size is %u, needs to be %u, slot %d\n", item_size,
+		printf("Size is %u, needs to be %zu, slot %d\n", item_size,
 		       sizeof(*ei), path->slots[0]);
 		btrfs_print_leaf(root, leaf);
 		return -EINVAL;
-- 
1.7.5.4

