From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 10/16] Btrfs: clean up search_extent_mapping()
Date: Thu, 14 Jul 2011 11:18:03 +0800
Message-ID: <4E1E5FEB.7000804@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

rb_node returned by __tree_search() can be a valid pointer or NULL,
but won't be some errno.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 2d04103..911a9db 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -379,23 +379,12 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 		em = rb_entry(next, struct extent_map, rb_node);
 		goto found;
 	}
-	if (!rb_node) {
-		em = NULL;
-		goto out;
-	}
-	if (IS_ERR(rb_node)) {
-		em = ERR_CAST(rb_node);
-		goto out;
-	}
-	em = rb_entry(rb_node, struct extent_map, rb_node);
-	goto found;
-
-	em = NULL;
-	goto out;
+	if (!rb_node)
+		return NULL;
 
+	em = rb_entry(rb_node, struct extent_map, rb_node);
 found:
 	atomic_inc(&em->refs);
-out:
 	return em;
 }
 
-- 
1.7.3.1
