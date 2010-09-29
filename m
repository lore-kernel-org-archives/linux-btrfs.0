From: Jan Kara <jack@suse.cz>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Date: Thu, 30 Sep 2010 01:38:07 +0200
Message-ID: <20100929233806.GB12707@quack.suse.cz>
References: <4C9AA546.6050201@cesarb.net>
 <20100923123849.8975fe47.akpm@linux-foundation.org>
 <20100927222548.GG3610@quack.suse.cz>
 <20100927225452.GG4270@think>
 <20100929081936.GA23322@lst.de>
 <20100929121808.GB3290@quack.suse.cz>
 <20100929141006.GB7439@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
	linux-btrfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, stable@kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Micha?? Piotrowski <mkkp4x4@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	kernel@lists.fedoraproject.org, linux-mtd@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100929141006.GB7439@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 29-09-10 16:10:06, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 02:18:08PM +0200, Jan Kara wrote:
> > On Wed 29-09-10 10:19:36, Christoph Hellwig wrote:
> > > ---
> > > From: Christoph Hellwig <hch@lst.de>
> > > Subject: [PATCH] writeback: always use sb->s_bdi for writeback purposes
> > > 
> > ...
> > > The one exception for now is the block device filesystem which really
> > > wants different writeback contexts for it's different (internal) inodes
> > > to handle the writeout more efficiently.  For now we do this with
> > > a hack in fs-writeback.c because we're so late in the cycle, but in
> > > the future I plan to replace this with a superblock method that allows
> > > for multiple writeback contexts per filesystem.
> >   Another exception I know about is mtd_inodefs filesystem
> > (drivers/mtd/mtdchar.c).
> 
> No, it's not.  MTD only has three different backing_dev_info instances
> which have different flags in the mapping-relevant portion of the
> backing_dev. 
  In the end I agree I was probably wrong but it's not that simple ;)

> >   So at least here you'd need also add a similar exception for
> > "mtd_inodefs".
> 
> No.  For one thing we don't need any exception for correctnes alone -
> even the block device variant would work fine with the default case.
Here I don't agree. If you don't have some kind of exception, sb->s_bdi
for both "block" and "mtd_inodefs" filesystems points to
noop_backing_dev_info and you get no writeback for that one. So it isn't
just a performance issue but also a correctness one.

Regarding mtd_inodefs I now looked in more detail what MTD actually does
and it seems to me that MTD device inodes do not seem to carry any
cached state that flusher threads could write back. So returning
noop_backing_dev_info might be the right thing for them after all...
(added David Woodhouse and MTD list to CC so that they can shout if it's
not the case). Coming to this conclusion, I'm happy with your patch going
in as is...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
