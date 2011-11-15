From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Introduce option to rebalance only metadata
Date: Tue, 15 Nov 2011 11:45:35 +0200
Message-ID: <20111115094535.GD8597@zambezi.lan>
References: <orr51fpxyv.fsf@livre.localdomain>
 <20111110194307.GL28749@carfax.org.uk>
 <20111115094004.GC8597@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>,
	Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111115094004.GC8597@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 15, 2011 at 11:40:04AM +0200, Ilya Dryomov wrote:
> On Thu, Nov 10, 2011 at 07:43:07PM +0000, Hugo Mills wrote:
> > On Thu, Nov 10, 2011 at 05:40:56PM -0200, Alexandre Oliva wrote:
> > > Experimental patch to be able to compact only the metadata after
> > > clustered allocation allocated lots of unnecessary metadata block
> > > groups.  It's also useful to measure performance differences between
> > > -o cluster and -o nocluster.
> > > 
> > > I guess it should be implemented as a balance option rather than a
> > > separate ioctl, but this was good enough for me to try it.
> > 
> >    This should be covered by the restriper work. (And was also covered
> > by my balance-management patches, which were superseded by restriper).
> 
> Hugo is right, this is covered by restriper (both kernel and userspace
> sides).  The exact command would be
> 
> btrfs fi restripe start -mconvert=PROFILE <mount point>

And the exact command to mimic your patch is

btrfs fi restripe start -m <mount point>

It simply balances metadata, whereas the one in the previous mail would
convert it to a specified profile.

Thanks,

		Ilya
