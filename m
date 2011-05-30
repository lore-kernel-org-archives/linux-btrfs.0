From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 6/9] mkfs.btrfs: write zeroes instead on uninitialized data.
Date: Tue, 31 May 2011 00:19:05 +0300
Message-ID: <1306790348-9553-7-git-send-email-slyfox@gentoo.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Found by valgrind:
==8968== Use of uninitialised value of size 8
==8968==    at 0x41CE7D: crc32c_le (crc32c.c:98)
==8968==    by 0x40A1D0: csum_tree_block_size (disk-io.c:82)
==8968==    by 0x40A2D4: csum_tree_block (disk-io.c:105)
==8968==    by 0x40A7D6: write_tree_block (disk-io.c:241)
==8968==    by 0x40ACEE: __commit_transaction (disk-io.c:354)
==8968==    by 0x40AE9E: btrfs_commit_transaction (disk-io.c:385)
==8968==    by 0x42CF66: make_image (mkfs.c:1061)
==8968==    by 0x42DE63: main (mkfs.c:1410)
==8968==  Uninitialised value was created by a stack allocation
==8968==    at 0x42B5FB: add_inode_items (mkfs.c:493)

1. On-disk inode format has reserved (and thus, random at alloc time) fields:
   btrfs_inode_item: __le64 reserved[4]
2. Sometimes extents are created on disk without writing data there.
   (Or at least not all data is written there). Kernel code always had
   it kzalloc'ed.
Zero them all.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 extent_io.c |    1 +
 mkfs.c      |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index 069c199..a93d4d6 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -572,6 +572,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 		BUG();
 		return NULL;
 	}
+	memset (eb, 0, sizeof(struct extent_buffer) + blocksize);
 
 	eb->start = bytenr;
 	eb->len = blocksize;
diff --git a/mkfs.c b/mkfs.c
index 8ff2b1e..32f25f5 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -411,6 +411,13 @@ static int fill_inode_item(struct btrfs_trans_handle *trans,
 	u64 blocks = 0;
 	u64 sectorsize = root->sectorsize;
 
+	/*
+	 * btrfs_inode_item has some reserved fields
+	 * and represents on-disk inode entry, so
+	 * zero everything to prevent information leak
+	 */
+	memset (dst, 0, sizeof (*dst));
+
 	btrfs_set_stack_inode_generation(dst, trans->transid);
 	btrfs_set_stack_inode_size(dst, src->st_size);
 	btrfs_set_stack_inode_nbytes(dst, 0);
-- 
1.7.3.4

