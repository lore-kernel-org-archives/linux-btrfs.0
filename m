From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 15:44:14 +0100
Message-ID: <20110124144414.GD7354@scooter>
References: <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
 <20110122155612.GA3664@scooter>
 <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
 <20110124130104.GA7354@scooter>
 <20110124131341.GA3403@carfax.org.uk>
 <20110124135305.GB7354@scooter>
 <20110124142936.GB3403@carfax.org.uk>
 <20110124143448.GC3403@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110124143448.GC3403@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

> On Mon, Jan 24, 2011 at 02:29:36PM +0000, Hugo Mills wrote:
> >    If, instead, the initial losetup call tracked the symlinks back to
> > the original device node (i.e. something like "/dev/sdb3", or
> > "/dev/mapper/ruthven-btest" in my example), then the name that's
> > stored in the kernel would be shorter, and we'd be less likely to see
> > the truncation. This is what my copy of losetup seems to be doing. I
> > can't see any distribution-specific patches in the source for
> > util-linux that would do this, though.
> 
>    Hmm... Just had a thought: is
> /dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-part3 on
> your system a symlink or a device node? What does ls -l say?

It is a symlink created by udev:

ls -l /dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-part3 
lrwxrwxrwx 1 root root 10 Jan 23 23:39
/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-part3 -> ../../sdb3

Following that link should work :)


Felix

> 
>    Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- But people have always eaten people,  / what else is there to ---  
>          eat?  / If the Juju had meant us not to eat people / he         
>                      wouldn't have made us of meat.                      


---end quoted text---
