From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Wed, 19 Aug 2009 10:52:08 +0200
Message-ID: <20090819085208.GF25721@wotan.suse.de>
References: <20090818164542.GB30325@wotan.suse.de> <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com> <20090818211910.GR12579@kernel.dk> <20090819084530.GD25721@wotan.suse.de> <20090819084658.GT12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yan, Zheng " <yanzheng@21cn.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090819084658.GT12579@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2009 at 10:46:59AM +0200, Jens Axboe wrote:
> On Wed, Aug 19 2009, Nick Piggin wrote:
> > See my other reply. It *can* work with key aliases, but this particular
> > code does not.
> > 
> > It is pretty easy obviously to put in duplicates because the rbtree
> > code doesn't know about keys, but if we do this then it looks like
> > it might cause the search code to miss some valid inodes and instead
> > return freeing inodes -- so you'd also have to look at that and update
> > it which is why I didn't go down this route..
> 
> Mine was just a generic statement, I didn't read the btrfs code (hence
> my comment about potential lookup bug, if you allow aliases you have to
> be careful).

Ah ok. Well yeah in this case btrfs is definitely wrong in the way it
tried to insert aliases.

