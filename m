From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Wed, 19 Aug 2009 10:32:26 +0200
Message-ID: <20090819083226.GC25721@wotan.suse.de>
References: <20090818164542.GB30325@wotan.suse.de> <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2009 at 02:56:54AM +0800, Yan, Zheng  wrote:
> 2009/8/19 Nick Piggin <npiggin@suse.de>:
> > Hi,
> >
> > Ran into a problem stress testing my btrfs truncate conversion attempt...
> > Unfortunately it was an existing btrfs problem. Fortunately I think I
> > was able to fix it.
> >
> > Thanks,
> > Nick
> >
> > --
> > btrfs: fix inode rbtree corruption
> >
> > Node may not be inserted over existing node. This causes inode tree
> > corruption and I was seeing crashes in inode_tree_del which I can not
> > reproduce after this patch.
> >
> > The other way to fix this would be to tie inode lifetime in the rbtree
> > with inode while not in freeing state. I had a look at this but it is
> > not so trivial at this point. At least this patch gets things working again.
> >
> 
> I'm not quite understand this. rbtree allows entries having the same keys.

No it doesn't. Well it *does* -- that's completely a choice of your
insert routine. But what you are not allowed to do is just pass in
a pointer to a non-null left/right pointer to link your new node into
because then the old node just gets lost.

So the tree is probably not corrupt as such, but when you try to delete
one of these old nodes then it crashes because it is not attached in
the tree.

> I guess your problem is because of some nodes get inserted into the tree
> twice. But I have no idea how can it happen.

No, the problem is 2 different nodes with the same key get inserted.

