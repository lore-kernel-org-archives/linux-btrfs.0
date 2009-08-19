From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Wed, 19 Aug 2009 10:45:30 +0200
Message-ID: <20090819084530.GD25721@wotan.suse.de>
References: <20090818164542.GB30325@wotan.suse.de> <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com> <20090818211910.GR12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yan, Zheng " <yanzheng@21cn.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090818211910.GR12579@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 18, 2009 at 11:19:10PM +0200, Jens Axboe wrote:
> On Wed, Aug 19 2009, Yan, Zheng  wrote:
> > 2009/8/19 Nick Piggin <npiggin@suse.de>:
> > > Hi,
> > >
> > > Ran into a problem stress testing my btrfs truncate conversion attempt...
> > > Unfortunately it was an existing btrfs problem. Fortunately I think I
> > > was able to fix it.
> > >
> > > Thanks,
> > > Nick
> > >
> > > --
> > > btrfs: fix inode rbtree corruption
> > >
> > > Node may not be inserted over existing node. This causes inode tree
> > > corruption and I was seeing crashes in inode_tree_del which I can not
> > > reproduce after this patch.
> > >
> > > The other way to fix this would be to tie inode lifetime in the rbtree
> > > with inode while not in freeing state. I had a look at this but it is
> > > not so trivial at this point. At least this patch gets things working again.
> > >
> > 
> > I'm not quite understand this. rbtree allows entries having the same keys.
> > I guess your problem is because of some nodes get inserted into the tree
> > twice. But I have no idea how can it happen.
> 
> It can work with key aliases, if it's a problem then it's likely due to
> another problem in related lookup code.

See my other reply. It *can* work with key aliases, but this particular
code does not.

It is pretty easy obviously to put in duplicates because the rbtree
code doesn't know about keys, but if we do this then it looks like
it might cause the search code to miss some valid inodes and instead
return freeing inodes -- so you'd also have to look at that and update
it which is why I didn't go down this route..

---
 fs/btrfs/inode.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/btrfs/inode.c
===================================================================
--- linux-2.6.orig/fs/btrfs/inode.c
+++ linux-2.6/fs/btrfs/inode.c
@@ -3108,13 +3108,14 @@ static void inode_tree_add(struct inode
 		entry = rb_entry(parent, struct btrfs_inode, rb_node);
 
 		if (inode->i_ino < entry->vfs_inode.i_ino)
-			p = &(*p)->rb_left;
-		else if (inode->i_ino > entry->vfs_inode.i_ino)
-			p = &(*p)->rb_right;
+			p = &parent->rb_left;
 		else {
-			WARN_ON(!(entry->vfs_inode.i_state &
-				  (I_WILL_FREE | I_FREEING | I_CLEAR)));
-			break;
+			p = &parent->rb_right;
+			if (inode->i_ino == entry->vfs_inode.i_ino) {
+				/* tolerate duplicates */
+				WARN_ON(!(entry->vfs_inode.i_state &
+					  (I_WILL_FREE | I_FREEING | I_CLEAR)));
+			}
 		}
 	}
 	rb_link_node(&BTRFS_I(inode)->rb_node, parent, p);
