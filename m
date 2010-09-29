From: Christoph Hellwig <hch@lst.de>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Date: Wed, 29 Sep 2010 16:10:06 +0200
Message-ID: <20100929141006.GB7439@lst.de>
References: <4C9AA546.6050201@cesarb.net> <20100923123849.8975fe47.akpm@linux-foundation.org> <20100927222548.GG3610@quack.suse.cz> <20100927225452.GG4270@think> <20100929081936.GA23322@lst.de> <20100929121808.GB3290@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
	linux-btrfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, stable@kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Micha?? Piotrowski <mkkp4x4@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	kernel@lists.fedoraproject.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100929121808.GB3290@quack.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 02:18:08PM +0200, Jan Kara wrote:
> On Wed 29-09-10 10:19:36, Christoph Hellwig wrote:
> > ---
> > From: Christoph Hellwig <hch@lst.de>
> > Subject: [PATCH] writeback: always use sb->s_bdi for writeback purposes
> > 
> ...
> > The one exception for now is the block device filesystem which really
> > wants different writeback contexts for it's different (internal) inodes
> > to handle the writeout more efficiently.  For now we do this with
> > a hack in fs-writeback.c because we're so late in the cycle, but in
> > the future I plan to replace this with a superblock method that allows
> > for multiple writeback contexts per filesystem.
>   Another exception I know about is mtd_inodefs filesystem
> (drivers/mtd/mtdchar.c).

No, it's not.  MTD only has three different backing_dev_info instances
which have different flags in the mapping-relevant portion of the
backing_dev. 

>   So at least here you'd need also add a similar exception for
> "mtd_inodefs".

No.  For one thing we don't need any exception for correctnes alone -
even the block device variant would work fine with the default case.
But for mtd specificly we don't need an exception for performance either
given that there are no per-device bdis in mtd.
