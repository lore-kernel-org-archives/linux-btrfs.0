From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [patch 0/2] Control filesystem balances (kernel side)
Date: Sat, 30 Oct 2010 19:44:35 +0200
Message-ID: <201010301944.35962.kreijack@libero.it>
References: <20101030000726.286517546@carfax.org.uk>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101030000726.286517546@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 30 October, 2010, Hugo Mills wrote:
>    These two patches give a degree of control over balance operations.
> The first makes it possible to get an idea of how much work remains to
> do, by tracking the number of block groups (chunks) that need to be
> moved/rewritten. The second patch allows a running balance operation
> to be cancelled when the current block group has been moved.
> 
>    One fundamental question, though -- is the progress monitor
> function best implemented as an ioctl, as I've done here, or should it
> be two or three sysfs files? I'm thinking of /proc/mdstat...
> Obviously, /proc/mdstat would never get into /sys, but exposing the
> "expected" and "remaining" values as files has an attractive
> simplicity to it.


I like the idea that these info should be put under sysfs. Something like

/sys/btrfs/<filesystem-uuid>/
                             balance	-> info on balancing
                             devices	-> list of device (a directory of
                                           links or a file which contains 
                                           the list of devices)
                             subvolumes/ -> info on subvolume(s)
                             label       -> label of the filesystem
                             <other btrfs filesystem related knoba>

                                           


Obviously we need another btrfs command to extract an uuid from a btrfs 
filesystem like:

# btrfs filesystem get-uuid /path/to/a/btrfs/filesystem
f9b9c413-0dc8-4e3f-94f2-86faa702f519

> 
>    The user-space side of things are in a separate patch series, to
> follow.
> 
>    Please be gentle with me, this is my first (serious, non-trivial)
> kernel patch. :)
> 
>    Hugo.
> 
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>    --- "No!  My collection of rare, incurable diseases! Violated!" ---   
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
