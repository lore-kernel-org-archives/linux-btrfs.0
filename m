From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 5/8] fs/btrfs: Use ERR_CAST
Date: Sat, 22 May 2010 12:00:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005221200210.13021@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
clear what is the purpose of the operation, which otherwise looks like a
no-op.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T x;
identifier f;
@@

T f (...) { <+...
- ERR_PTR(PTR_ERR(x))
+ x
 ...+> }

@@
expression x;
@@

- ERR_PTR(PTR_ERR(x))
+ ERR_CAST(x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/extent_map.c |    4 ++--
 fs/btrfs/super.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -335,7 +335,7 @@ struct extent_map *lookup_extent_mapping
 		goto out;
 	}
 	if (IS_ERR(rb_node)) {
-		em = ERR_PTR(PTR_ERR(rb_node));
+		em = ERR_CAST(rb_node);
 		goto out;
 	}
 	em = rb_entry(rb_node, struct extent_map, rb_node);
@@ -384,7 +384,7 @@ struct extent_map *search_extent_mapping
 		goto out;
 	}
 	if (IS_ERR(rb_node)) {
-		em = ERR_PTR(PTR_ERR(rb_node));
+		em = ERR_CAST(rb_node);
 		goto out;
 	}
 	em = rb_entry(rb_node, struct extent_map, rb_node);
diff -u -p a/fs/btrfs/super.c b/fs/btrfs/super.c
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -378,7 +378,7 @@ static struct dentry *get_default_root(s
 find_root:
 	new_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
 	if (IS_ERR(new_root))
-		return ERR_PTR(PTR_ERR(new_root));
+		return ERR_CAST(new_root);
 
 	if (btrfs_root_refs(&new_root->root_item) == 0)
 		return ERR_PTR(-ENOENT);
