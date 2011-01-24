From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 22:04:54 +0100
Message-ID: <20110124210454.GB2554@scooter>
References: <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
 <20110124130104.GA7354@scooter>
 <20110124131341.GA3403@carfax.org.uk>
 <20110124135305.GB7354@scooter>
 <20110124142936.GB3403@carfax.org.uk>
 <20110124143448.GC3403@carfax.org.uk>
 <20110124144414.GD7354@scooter>
 <20110124165258.GA2562@scooter>
 <20110124170023.GA7576@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110124170023.GA7576@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

it is getting interesting :)


If I'm using the debian util-linux (with the patches) I'm getting an error while
executing losetup:

ioctl: LOOP_SET_STATUS: Invalid argument


Now the interesting part: The strace of the debian util-linux shows:

readlink("/dev", 0x7fffcea2a0a0, 4096)  = -1 EINVAL (Invalid argument)
readlink("/dev/disk", 0x7fffcea2a0a0, 4096) = -1 EINVAL (Invalid argument)
readlink("/dev/disk/by-id", 0x7fffcea2a0a0, 4096) = -1 EINVAL (Invalid argument)
readlink("/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3",
"../../sda3", 4096) = 10
readlink("/dev/sda3", 0x7fffcea2a0a0, 4096) = -1 EINVAL (Invalid argument)


But in the gentoo util-linux there is no readlink in the strace. There are also those
readlinks with the unpatched source from that debian package.

If I use the tarball of gentoo and compile it by my own there are readlinks. I'll
take a look if there are any gentoo-patches applied during the build.

Felix

On 24. January 2011 - 17:00, Hugo Mills wrote:
> Date: Mon, 24 Jan 2011 17:00:24 +0000
> From: Hugo Mills <hugo-lkml@carfax.org.uk>
> To: Felix Blanke <felixblanke@gmail.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Bug in mkfs.btrfs?!
> Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>, Felix Blanke
>  <felixblanke@gmail.com>, linux-btrfs@vger.kernel.org
> 
> On Mon, Jan 24, 2011 at 05:52:58PM +0100, Felix Blanke wrote:
> > util-linux-2.18-r1 and still no symlink following.
> > 
> > I'll ask for that at the kernel mailing list in the next days. If your (Hugo)
> > util-linux doesn't include any kind of patches that behaviour is really strange.
> 
>    Just for reference:
> 
> Package description page:
> http://packages.debian.org/squeeze/util-linux
> 
> Original upstream sources Debian are using:
> http://ftp.de.debian.org/debian/pool/main/u/util-linux/util-linux_2.17.2.orig.tar.gz
> 
> Debian patches on top of that source (mostly to the build system):
> http://ftp.de.debian.org/debian/pool/main/u/util-linux/util-linux_2.17.2-5.diff.gz
> 
>    Hugo.
> 
> > 
> > Felix
> > 
> > On 24. January 2011 - 15:44, Felix Blanke wrote:
> > > Date: Mon, 24 Jan 2011 15:44:14 +0100
> > > From: Felix Blanke <felixblanke@gmail.com>
> > > To: Hugo Mills <hugo-lkml@carfax.org.uk>
> > > Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org
> > > Subject: Re: Bug in mkfs.btrfs?!
> > > 
> > > > On Mon, Jan 24, 2011 at 02:29:36PM +0000, Hugo Mills wrote:
> > > > >    If, instead, the initial losetup call tracked the symlinks back to
> > > > > the original device node (i.e. something like "/dev/sdb3", or
> > > > > "/dev/mapper/ruthven-btest" in my example), then the name that's
> > > > > stored in the kernel would be shorter, and we'd be less likely to see
> > > > > the truncation. This is what my copy of losetup seems to be doing. I
> > > > > can't see any distribution-specific patches in the source for
> > > > > util-linux that would do this, though.
> > > > 
> > > >    Hmm... Just had a thought: is
> > > > /dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-part3 on
> > > > your system a symlink or a device node? What does ls -l say?
> > > 
> > > It is a symlink created by udev:
> > > 
> > > ls -l /dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-part3 
> > > lrwxrwxrwx 1 root root 10 Jan 23 23:39
> > > /dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-part3 -> ../../sdb3
> > > 
> > > Following that link should work :)
> > > 
> > > 
> > > Felix
> > > 
> > > > 
> > > >    Hugo.
> > > > 
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>     --- Turning,  pages turning in the widening bath, / The spine ---    
>         cannot bear the humidity. / Books fall apart; the binding        
>             cannot hold. / Page 129 is loosed upon the world.            


---end quoted text---
