From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 1/4 RESEND] Btrfs: remove the useless assignment to *entry
 in function tree_insert of file extent_io.c
Date: Fri, 06 Apr 2012 14:35:05 +0800
Message-ID: <4F7E8E99.3080306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In tree_insert, var *entry is used in the loop only, and is useless
out of the loop. Remove the useless assignment after the loop.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8d904dd..7b679e2 100644
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

