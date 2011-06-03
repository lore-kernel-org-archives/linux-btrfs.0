From: Greg KH <greg@kroah.com>
Subject: Re: linux-next: build warninga in Linus' tree
Date: Fri, 3 Jun 2011 22:16:28 +0900
Message-ID: <20110603131628.GB7355__25517.1809615151$1307108625$gmane$org@kroah.com>
References: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
 <20110531175709.GC12709@twin.jikos.cz>
 <BANLkTi=t5H8sAc_0sHyFt_xJgbeVibO3KQ@mail.gmail.com>
 <20110603111048.GR12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Mitch Harder <mitch.harder@sabayonlinux.org>, dave@jikos.cz,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Chris Mason <chris.mason@oracle.com>,
	linux-next@vger.kernel.org, linux-kernel@vg
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110603111048.GR12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2011 at 01:10:49PM +0200, David Sterba wrote:
> On Wed, Jun 01, 2011 at 10:16:48AM -0500, Mitch Harder wrote:
> > I've been playing around with resurrecting the basic sysfs
> > capabilities that had been previously incorporated into btrfs.
> > 
> > As it stands right now, it was relatively easy to re-implement sysfs
> > as it was originally.  However, that implementation of sysfs wasn't
> > populated with much information (only total_blocks, blocks_used, and
> > blocksize).
> 
> Goffredo Baroncelli (CCed) posted a patch to enhance sysfs interface:
> 
> https://patchwork.kernel.org/patch/308902/
> (http://www.spinics.net/lists/linux-btrfs/msg06777.html)
> 
> > I also had to reverse a small portion of code that was in the last
> > clean-up.
> 
> Restoring the code should not be a problem, the cleanup was too eager
> and I think a sysfs inteface would be good, not only for debugging
> purposes or tuning.
> 
> > If a CONFIG_BTRFS_DEBUG type configuration flag is ever introduced, it
> > would be interesting to resurrect btrfs' sysfs capabilities.
> 
> Hearing about CONFIG_BTRFS_DEBUG again, seems worth to add it.

For debugging stuff, please use debugfs instead of sysfs, as that is
what it is there for.

thanks,

greg k-h
