From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] Btrfs: fix build errors of extent_io.c
Date: Wed, 24 Dec 2008 17:56:40 +0900 (JST)
Message-ID: <20081224.175640.119553873.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I've started to read and try btrfs, and soon met the following build
errors.  The attached patch fixes the problem.

Could you check this?

Regards,
Ryusuke Konishi
--
Btrfs: fix build errors of extent_io.c

This will fix the following compile-time errors:

fs/btrfs/extent_io.c: At top level:
fs/btrfs/extent_io.c:815: error: __ksymtab_set_extent_bit causes a section type conflict
fs/btrfs/extent_io.c:815: error: __ksymtab_set_extent_bit causes a section type conflict
fs/btrfs/extent_io.c:156: error: __ksymtab_free_extent_state causes a section type conflict
fs/btrfs/extent_io.c:156: error: __ksymtab_free_extent_state causes a section type conflict
fs/btrfs/extent_io.c:137: error: __ksymtab_alloc_extent_state causes a section type conflict
fs/btrfs/extent_io.c:137: error: __ksymtab_alloc_extent_state causes a section type conflict
make[2]: *** [fs/btrfs/extent_io.o] Error 1
make[1]: *** [fs/btrfs] Error 2

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/btrfs/extent_io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 25ce2d1..b6c69ef 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -112,7 +112,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 }
 EXPORT_SYMBOL(extent_io_tree_init);
 
-static struct extent_state *alloc_extent_state(gfp_t mask)
+struct extent_state *alloc_extent_state(gfp_t mask)
 {
 	struct extent_state *state;
 #ifdef LEAK_DEBUG
@@ -136,7 +136,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 }
 EXPORT_SYMBOL(alloc_extent_state);
 
-static void free_extent_state(struct extent_state *state)
+void free_extent_state(struct extent_state *state)
 {
 	if (!state)
 		return;
@@ -661,7 +661,7 @@ static void set_state_bits(struct extent_io_tree *tree,
  * [start, end] is inclusive
  * This takes the tree lock.
  */
-static int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
+int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
 		   int exclusive, u64 *failed_start, gfp_t mask)
 {
 	struct extent_state *state;
-- 
1.5.6.5

