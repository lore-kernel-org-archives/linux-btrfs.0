From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Tue, 18 Aug 2009 23:19:10 +0200
Message-ID: <20090818211910.GR12579@kernel.dk>
References: <20090818164542.GB30325@wotan.suse.de> <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@suse.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19 2009, Yan, Zheng  wrote:
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
> I guess your problem is because of some nodes get inserted into the tree
> twice. But I have no idea how can it happen.

It can work with key aliases, if it's a problem then it's likely due to
another problem in related lookup code.

-- 
Jens Axboe

