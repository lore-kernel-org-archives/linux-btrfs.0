From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 00:04:30 +0000
Message-ID: <4D05630E.7070809@bobich.net>
References: <1292174654.11248.10.camel@paddy-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: jarktasaa@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292174654.11248.10.camel@paddy-desktop>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2010 17:24, Paddy Steed wrote:
> In a few weeks parts for my new computer will be arriving. The storage
> will be a 128GB SSD. A few weeks after that I will order three large
> disks for a RAID array. I understand that BTRFS RAID 5 support will be
> available shortly. What is the best possible way for me to get the
> highest performance out of this setup. I know of the option to optimize
> for SSD's

BTRFS is hardly the best option for SSDs. I typically use ext4 without a 
journal on SSDs, or ext2 if that is not available. Journalling causes 
more writes to hit the disk, which wears out flash faster. Plus, SSDs 
typically have much slower writes than reads, so avoiding writes is a 
good thing. AFAIK there is no way to disable journaling on BTRFS.

> but wont that affect all the drives in the array, not to
> mention having the SSD in the raid array will make the usable size much
> smaller as RAID 5 goes by the smallest disk.

If you are talking about BTRFS' parity RAID implementation, it is hard 
to comment in any way on it before it has actually been implemented. 
Especially if you are looking for something stable for production use, 
you should probably avoid features that immature.

> Is there a way to use it as
> a cache the works even on power down.

You want to use the SSD as a _write_ cache? That doesn't sound too 
sensible at all.

What you are looking for is hierarchical/tiered storage. I am not aware 
of existance of such a thing for Linux. BTRFS has no feature for it. You 
might be able to cobble up a solution that uses aufs or mhddfs (both 
fuse based) with some cron jobs to shift most recently used files to 
your SSD, but the fuse overheads will probably limit the usefulness of 
this approach.

> My current plan is to have
> the /tmp directory in RAM on tmpfs

Ideally, quite a lot should really be on tmpfs, in addition to /tmp and 
/var/tmp.
Have a look at my patches here:
https://bugzilla.redhat.com/show_bug.cgi?id=223722

My motivation for this was mainly to improve performance on slow flash 
(when running off a USB stick or an SD card), but it also removes the 
most write-heavy things off the flash and into RAM. Less flash wear and 
more speed.

If you are putting a lot onto tmpfs, you may also want to look at the 
compcache project which provides a compressed swap RAM disk. Much faster 
than actual swap - to the point where it actually makes swapping feasible.

> the /boot directory on a dedicated
> partition on the SSD along with a 12GB swap partition also on the SSD
> with the rest of the space (on the SSD) available as a cache.

Swap on SSD is generally a bad idea. If your machine starts swapping 
it'll grind to a halt anyway, regardless of whether it's swapping to 
SSD, and heavy swapping to SSD will just kill the flash prematurely.

> The three
> mechanical hard drives will be on a RAID 5 array using BTRFS. Can anyone
> suggest any improvements to my plan and also how to implement the cache?

A very "soft" solution using aufs and cron jobs for moving things with 
the most recent atime to the SSD is probably as good as it's going to 
get at the moment, but bear in mind that fuse overheads will probably 
offset any performance benefit you gain from the SSD. You could get 
clever and instead of just using atime set up inotify logging and put 
the most frequently (as opposed to most recently) accessed files onto 
your SSD. This would, in theory, give you more benefit. You also have to 
bear in mind that the most frequently accessed files will be cached in 
RAM anyway, so your pre-caching onto SSD is only really going to be 
relevant when your working set size is considerably bigger than your RAM 
- at which point your performance is going to take a significant 
nosedive anyway (especially if you then hit a fuse file system).

In either case, you should not put the frequently written files onto 
flash (recent mtime).

Also note that RAID5 is potentially very slow on writes, especially 
small writes. It is also unsuitable for arrays over about 4TB (usable) 
in size for disk reliability reasons.

Gordan
