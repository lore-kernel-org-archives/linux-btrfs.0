From: Andi Kleen <andi@firstfloor.org>
Subject: btrfs_tree_lock & trylock
Date: Mon, 8 Sep 2008 13:10:59 +0200
Message-ID: <20080908111059.GA8902@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I did some btrfs RTFS over the weeking and I have a hard time understanding 
what this code is attempting to do:

 28 int btrfs_tree_lock(struct extent_buffer *eb)
 29 {
 30         int i;
 31 
 32         if (mutex_trylock(&eb->mutex))
 33                 return 0;
 34         for (i = 0; i < 512; i++) {
 35                 cpu_relax();
 36                 if (mutex_trylock(&eb->mutex))
 37                         return 0;
 38         }
 39         cpu_relax();
 40         mutex_lock_nested(&eb->mutex, BTRFS_MAX_LEVEL - btrfs_header_level(e    b));
 41         return 0;
 42 }

The trylocks seem pretty pointless.
I presume it can be all replaced with the mutex_lock_nested() in line 40.
Also the return value seems pointless because noone checks it. Like
in the appended patch. Or do I miss something?

---

Remove unneeded trylocking and unused return value in btrfs_tree_lock

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff -r 417d87e57364 locking.c
--- a/locking.c	Wed Aug 20 13:39:41 2008 -0400
+++ b/locking.c	Mon Sep 08 13:09:21 2008 +0200
@@ -25,20 +25,9 @@
 #include "extent_io.h"
 #include "locking.h"
 
-int btrfs_tree_lock(struct extent_buffer *eb)
+void btrfs_tree_lock(struct extent_buffer *eb)
 {
-	int i;
-
-	if (mutex_trylock(&eb->mutex))
-		return 0;
-	for (i = 0; i < 512; i++) {
-		cpu_relax();
-		if (mutex_trylock(&eb->mutex))
-			return 0;
-	}
-	cpu_relax();
 	mutex_lock_nested(&eb->mutex, BTRFS_MAX_LEVEL - btrfs_header_level(eb));
-	return 0;
 }
 
 int btrfs_try_tree_lock(struct extent_buffer *eb)
diff -r 417d87e57364 locking.h
--- a/locking.h	Wed Aug 20 13:39:41 2008 -0400
+++ b/locking.h	Mon Sep 08 13:09:21 2008 +0200
@@ -19,7 +19,7 @@
 #ifndef __BTRFS_LOCKING_
 #define __BTRFS_LOCKING_
 
-int btrfs_tree_lock(struct extent_buffer *eb);
+void btrfs_tree_lock(struct extent_buffer *eb);
 int btrfs_tree_unlock(struct extent_buffer *eb);
 int btrfs_tree_locked(struct extent_buffer *eb);
 int btrfs_try_tree_lock(struct extent_buffer *eb);

-- 
ak@linux.intel.com
