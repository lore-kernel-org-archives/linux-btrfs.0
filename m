From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs-progs: fix compiler warning of extent-tree.c
Date: Tue, 01 Nov 2011 12:20:42 +0900
Message-ID: <201111010320.AA00036@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In recovery-beta, following compiler warning was displayed.

 gcc -Wp,-MMD,./.extent-tree.o.d,-MT,extent-tree.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -O0 -c extent-tree.c
 extent-tree.c: In function 'lookup_inline_extent_backref':
 extent-tree.c:1071: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'long unsigned int'

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 5bed3c2..5144d57 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1068,7 +1068,7 @@ static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 #endif
 	if (item_size < sizeof(*ei)) {
 		printf("Size is %u, needs to be %u, slot %d\n", item_size,
-		       sizeof(*ei), path->slots[0]);
+		       (u32)sizeof(*ei), path->slots[0]);
 		btrfs_print_leaf(root, leaf);
 		return -EINVAL;
 	}


