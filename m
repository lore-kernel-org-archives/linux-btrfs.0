From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Problem during implementing NFS support
Date: Mon, 21 Jul 2008 08:58:23 -0400
Message-ID: <1216645103.6932.92.camel@think.oraclecorp.com>
References: <200807210041.10609.balajirrao@gmail.com>
	 <1216572230.2475.106.camel@shinybook.infradead.org>
	 <20080721081037.GA24230@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: David Woodhouse <dwmw2@infradead.org>,
	Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080721081037.GA24230@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-21 at 04:10 -0400, Christoph Hellwig wrote:
> On Sun, Jul 20, 2008 at 09:43:50AM -0700, David Woodhouse wrote:
> > The way GFS1 (and also XFS iirc) handles it is to build up a complete
> > list of responses to readdir() in a buffer, drop the lock, and then
> > iterate over that buffer calling filldir(). I don't much like that
> > version either.
> 
> Yes.  My prefered mid-term solution would to simply lift that code from
> XFS (where it's nicely isolated and all code is prefixed with hack_) to
> nfsd so that local users don't aren't penalized for this.
> 

Reiserfs also uses the local buffer and lock dropping trick, and that's
what I would do for now in btrfs.

But, the extent allocation tree also needs recursive locking, so I'm
going to take a stab at that as soon as I get the pending patch list
merged.

-chris


