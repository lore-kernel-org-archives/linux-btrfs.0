From: Chris Samuel <chris@csamuel.org>
Subject: [PATCH] kmem_cache_alloc doesn't return ERR_PTR so no need to check
 for it.
Date: Sat, 13 Nov 2010 13:07:11 +1100
Message-ID: <4CDDF2CF.9060605@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

According to scripts/coccinelle/null/eno.cocci "The various basic
memory allocation functions don't return ERR_PTR" so there's no
point in calling IS_ERR() on the return value from them, the
existing test is good enough.

Signed-off-by: Chris Samuel <chris@csamuel.org>
---
 fs/btrfs/extent_map.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 23cb8da..8797704 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -50,7 +50,7 @@ struct extent_map *alloc_extent_map(gfp_t mask)
 {
        struct extent_map *em;
        em = kmem_cache_alloc(extent_map_cache, mask);
-       if (!em || IS_ERR(em))
+       if (!em)
                return em;
        em->in_tree = 0;
        em->flags = 0;
-- 
1.7.0.4

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
