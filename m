From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 5/9] mkfs.btrfs: fix symlink names writing
Date: Tue, 31 May 2011 00:19:04 +0300
Message-ID: <1306790348-9553-6-git-send-email-slyfox@gentoo.org>
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

readlink(2) does not write '\0' for us, so make it manually.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 mkfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 9d7b792..8ff2b1e 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -709,11 +709,13 @@ static int add_symbolic_link(struct btrfs_trans_handle *trans,
 		fprintf(stderr, "readlink failed for %s\n", path_name);
 		goto fail;
 	}
-	if (ret > sectorsize) {
+	if (ret >= sectorsize) {
 		fprintf(stderr, "symlink too long for %s", path_name);
 		ret = -1;
 		goto fail;
 	}
+
+	buf[ret] = '\0'; /* readlink does not do it for us */
 	ret = btrfs_insert_inline_extent(trans, root, objectid, 0,
 					 buf, ret + 1);
 fail:
-- 
1.7.3.4

