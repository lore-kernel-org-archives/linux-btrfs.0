From: Richard Kennedy <richard@rsk.demon.co.uk>
Subject: btrfs: remove 64bit alignment padding to allow extent_buffer to fit
 into one fewer cacheline
Date: Tue, 07 Jun 2011 11:46:32 +0100
Message-ID: <1307443592.2076.7.camel@castor.rsk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: lkml <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: "chris.mason" <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Reorder extent_buffer to remove 8 bytes of alignment padding on 64 bit
builds. This shrinks its size to 128 bytes allowing it to fit into one
fewer cache lines and allows more objects per slab in its kmem_cache.
    
slabinfo extent_buffer reports :-
    
 before:-
    Sizes (bytes)     Slabs
    ----------------------------------
    Object :     136  Total  :     123
    SlabObj:     136  Full   :     121
    SlabSiz:    4096  Partial:       0
    Loss   :       0  CpuSlab:       2
    Align  :       8  Objects:      30
    
 after :-
    Object :     128  Total  :       4
    SlabObj:     128  Full   :       2
    SlabSiz:    4096  Partial:       0
    Loss   :       0  CpuSlab:       2
    Align  :       8  Objects:      32
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against v3.0-rc2
compiled & tested on x86_64

This has only had a little light testing on a scratch volume but it
still seems to work.

regards
Richard


diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4e8445a..a11a92e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -126,9 +126,9 @@ struct extent_buffer {
 	unsigned long map_len;
 	struct page *first_page;
 	unsigned long bflags;
-	atomic_t refs;
 	struct list_head leak_list;
 	struct rcu_head rcu_head;
+	atomic_t refs;
 
 	/* the spinlock is used to protect most operations */
 	spinlock_t lock;
