From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs/extent_io.c: remove the useless assignment to entry
 in tree_insert
Date: Sun, 01 Apr 2012 10:13:41 +0800
Message-ID: <4F77B9D5.2030608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In tree_insert, entry is used in the loop only, and is useless
out of the loop. Remove the useless assignment after the loop.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9ed9d2c..6099261 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -186,7 +186,6 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 			return parent;
 	}
 
-	entry = rb_entry(node, struct tree_entry, rb_node);
 	rb_link_node(node, parent, p);
 	rb_insert_color(node, root);
 	return NULL;
-- 
1.7.1
