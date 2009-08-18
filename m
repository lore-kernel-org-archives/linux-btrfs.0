From: Nick Piggin <npiggin@suse.de>
Subject: [patch] btrfs: fix inode rbtree corruption
Date: Tue, 18 Aug 2009 18:45:42 +0200
Message-ID: <20090818164542.GB30325@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Ran into a problem stress testing my btrfs truncate conversion attempt...
Unfortunately it was an existing btrfs problem. Fortunately I think I
was able to fix it.

Thanks,
Nick

--
btrfs: fix inode rbtree corruption

Node may not be inserted over existing node. This causes inode tree
corruption and I was seeing crashes in inode_tree_del which I can not
reproduce after this patch.

The other way to fix this would be to tie inode lifetime in the rbtree
with inode while not in freeing state. I had a look at this but it is
not so trivial at this point. At least this patch gets things working again.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/btrfs/inode.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -3099,8 +3099,12 @@ static void inode_tree_add(struct inode
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_inode *entry;
-	struct rb_node **p = &root->inode_tree.rb_node;
-	struct rb_node *parent = NULL;
+	struct rb_node **p;
+	struct rb_node *parent;
+
+again:
+	p = &root->inode_tree.rb_node;
+	parent = NULL;
 
 	spin_lock(&root->inode_lock);
 	while (*p) {
@@ -3108,13 +3112,16 @@ static void inode_tree_add(struct inode
 		entry = rb_entry(parent, struct btrfs_inode, rb_node);
 
 		if (inode->i_ino < entry->vfs_inode.i_ino)
-			p = &(*p)->rb_left;
+			p = &parent->rb_left;
 		else if (inode->i_ino > entry->vfs_inode.i_ino)
-			p = &(*p)->rb_right;
+			p = &parent->rb_right;
 		else {
 			WARN_ON(!(entry->vfs_inode.i_state &
 				  (I_WILL_FREE | I_FREEING | I_CLEAR)));
-			break;
+			rb_erase(parent, &root->inode_tree);
+			RB_CLEAR_NODE(parent);
+			spin_unlock(&root->inode_lock);
+			goto again;
 		}
 	}
 	rb_link_node(&BTRFS_I(inode)->rb_node, parent, p);
@@ -3126,12 +3133,12 @@ static void inode_tree_del(struct inode
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
+	spin_lock(&root->inode_lock);
 	if (!RB_EMPTY_NODE(&BTRFS_I(inode)->rb_node)) {
-		spin_lock(&root->inode_lock);
 		rb_erase(&BTRFS_I(inode)->rb_node, &root->inode_tree);
-		spin_unlock(&root->inode_lock);
 		RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
 	}
+	spin_unlock(&root->inode_lock);
 }
 
 static noinline void init_btrfs_i(struct inode *inode)
