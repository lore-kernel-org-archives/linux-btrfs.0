From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Is it possible to reclaim block groups once they are allocated
 to data or metadata?
Date: Sun, 6 May 2012 17:53:53 +0300
Message-ID: <20120506145353.GB1968@zambezi.lan>
References: <CALzgn9tppzTem57mD6ORK7SXCK2vM6hcsWxphdHLr4eNwFTPQg@mail.gmail.com>
 <20120505125238.GJ9860@carfax.org.uk>
 <CALzgn9vCcMSEDQXWEwdZJuSeuv9WbK3T=YkQr+y2V=B_-+bWCQ@mail.gmail.com>
 <20120506102645.GA1968@zambezi.lan>
 <20120506103727.GK9860@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>, Mike Sampson <mike@sambodata.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120506103727.GK9860@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 06, 2012 at 11:37:27AM +0100, Hugo Mills wrote:
> On Sun, May 06, 2012 at 01:26:45PM +0300, Ilya Dryomov wrote:
> > On Sun, May 06, 2012 at 01:07:06PM +1000, Mike Sampson wrote:
> > > There is now 8GB less in Metadata and I was able to delete some files
> > > as well to free up space. There is still a lot of wasted space in the
> > > metadata block groups. It seems that it allocates more metadata block
> > > groups than required for my filesystem. This will do until I am able
> > > to add a couple of devices to the system. Is there anyway to adjust
> > > the block group allocation strategy at filesystem creation?
> > 
> > No.  Chunk allocator currently allocates a lot more chunks than actually
> > needed, and it impacts both balancing and normal operation.  Try this:
> > 
> > # btrfs balance start -musage=10 /home
> > 
> > This is suboptimal, but it should get rid of more chunks.
> 
>    While we're talking about it, what is the parameter to the "usage"
> option? I'm assuming it selects chunks which are less than some amount
> full -- but is the value a percentage, or a quantity in megabytes
> (power-of-10 or power-of-2), or something else?

It's a percentage, so the command above will balance out chunks that are
less than 10 percent full.  I'll update btrfs man page and the wiki page
you started as soon as I can.

Thanks,

		Ilya
