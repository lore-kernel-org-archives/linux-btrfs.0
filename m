From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Mon, 18 Aug 2008 22:52:22 +0100
Message-ID: <1219096342.3184.453.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218980439.3184.304.camel@pmac.infradead.org>
	 <1219087412.14063.22.camel@think.oraclecorp.com>
	 <1219088029.3184.413.camel@pmac.infradead.org>
	 <1219088859.14063.35.camel@think.oraclecorp.com>
	 <1219090839.3184.436.camel@pmac.infradead.org>
	 <1219091550.14063.44.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219091550.14063.44.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 16:32 -0400, Chris Mason wrote:
> On Mon, 2008-08-18 at 21:20 +0100, David Woodhouse wrote:
> > On Mon, 2008-08-18 at 15:47 -0400, Chris Mason wrote:
> > > Lets pretend I had put in commments something like the code below.
> > > The important part is that directories have only one link, so they
> > > have only one backref.
> > 
> > OK. Now can I rip that code out anyway? The VFS will never call
> > btrfs_lookup() for ".." -- not since the 2.2 kernel :)
> > 
> > I'm still a little confused about precisely what btrfs_search_slot()
> > returns when it doesn't find a match -- that's probably where the
> > documentation would be more useful.
> > 
> 
> if btrfs_search_slot returns < 0, there was an error
> if btrfs_search_slot returns > 1, path->slots[0] is the spot in the tree
> where you'd want to insert the item.

What if the parent inode actually _is_ inode #0xffffffffffffffff? Can
that happen? In that case it would return zero, and I shouldn't subtract
1 from the slot number -- I've actually found what I'm looking for?

> In this case, if path->slots[0] == 0, there are no keys in the tree
> smaller than your search key.                                  ^^^^

OK... what if the place I'd want to insert the item is the first slot in
some node? There are keys in the _tree_ which are smaller, but just not
in this node? I think that's where the root of my confusion lies.

> If path->slots[0] == btrfs_header_nritems(path->nodes[0]), there are
> no items in this node that have a key > than your search key.
                   ^^^^
Not in this node, but maybe in the next one? That's why my own fix for
the bug involved using btrfs_next_leaf() and using the first item from
that one?

> > +	if (ret < 0 && slot == 0) {
> 
>               ^^^^^^^^^^^^^ should be ||, and should set ret to
> something bad if slot == 0

Er, yes. Moment of stupidity there :)

We were ignoring 'ret' anyway -- none of this stuff should ever happen,
and it's all just 'return ERR_PTR(-EINVAL)' at the out: label.

I've tested this, and added it to my tree:

From: David Woodhouse <David.Woodhouse@intel.com>
Date: Mon, 18 Aug 2008 22:50:22 +0100
Subject: [PATCH] Simplify btrfs_get_parent(), fix use-after-free bug

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 export.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/export.c b/export.c
index 797b4cb..a913b9b 100644
--- a/export.c
+++ b/export.c
@@ -147,7 +147,6 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	struct btrfs_key key;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	u32 nritems;
 	int slot;
 	u64 objectid;
 	int ret;
@@ -156,27 +155,24 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 
 	key.objectid = dir->i_ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
-	key.offset = 0;
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	BUG_ON(ret == 0);
-	ret = 0;
+	key.offset = (u64)-1;
 
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	leaf = path->nodes[0];
 	slot = path->slots[0];
-	nritems = btrfs_header_nritems(leaf);
-	if (slot >= nritems) {
-		ret = btrfs_next_leaf(root, path);
-		if (ret) {
-			btrfs_free_path(path);
-			goto out;
-		}
-		leaf = path->nodes[0];
-		slot = path->slots[0];
+	if (ret < 0 || slot == 0) {
+		btrfs_free_path(path);
+		goto out;
 	}
+	/* btrfs_search_slot() returns the slot where we'd want to insert
+	   an INODE_REF_KEY for parent inode #0xFFFFFFFFFFFFFFFF. The _real_
+	   one, telling us what the parent inode _actually_ is, will be in
+	   the slot _before_ the one that btrfs_search_slot() returns. */
+	slot--;
 
+	btrfs_item_key_to_cpu(leaf, &key, slot);
 	btrfs_free_path(path);
 
-	btrfs_item_key_to_cpu(leaf, &key, slot);
 	if (key.objectid != dir->i_ino || key.type != BTRFS_INODE_REF_KEY)
 		goto out;
 
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



