Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:59440 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756684AbdDQSY1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 14:24:27 -0400
Date: Mon, 17 Apr 2017 23:24:19 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs/SSD
Message-ID: <20170417232419.04474015@natsu>
In-Reply-To: <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 17 Apr 2017 07:53:04 -0400
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> General info (not BTRFS specific):
> * Based on SMART attributes and other factors, current life expectancy 
> for light usage (normal desktop usage) appears to be somewhere around 
> 8-12 years depending on specifics of usage (assuming the same workload, 
> F2FS is at the very top of the range, BTRFS and NILFS2 are on the upper 
> end, XFS is roughly in the middle, ext4 and NTFS are on the low end 
> (tested using Windows 7's NTFS driver), and FAT32 is an outlier at the 
> bottom of the barrel).

Life expectancy for an SSD is defined not in years, but in TBW (terabytes
written), and AFAICT that's not "from host", but "to flash" (some SSDs will
show you both values in two separate SMART attributes out of the box, on some
it can be unlocked). Filesystem may come into play only by the amount of write
amplification they cause (how much "to flash" is greater than "from host").
Do you have any test data to show that FSes are ranked in that order by WA
they cause, or is it all about "general feel" and how they are branded (F2FS
says so, so it must be the best)

> * Queued DISCARD support is still missing in most consumer SATA SSD's, 
> which in turn makes the trade-off on those between performance and 
> lifetime much sharper.

My choice was to make a script to run from crontab, using "fstrim" on all
mounted SSDs nightly, and aside from that all FSes are mounted with
"nodiscard". Best of the both worlds, and no interference with actual IO
operation.

> * Modern (2015 and newer) SSD's seem to have better handling in the FTL 
> for the journaling behavior of filesystems like ext4 and XFS.  I'm not 
> sure if this is actually a result of the FTL being better, or some 
> change in the hardware.

Again, what makes you think this, did you observe the write amplification
readings and now those are demonstrably lower than on "2014 and older" SSDs?
So, by how much, and which models did you compare?

> * In my personal experience, Intel, Samsung, and Crucial appear to be 
> the best name brands (in relative order of quality).  I have personally 
> had bad experiences with SanDisk and Kingston SSD's, but I don't have 
> anything beyond circumstantial evidence indicating that it was anything 
> but bad luck on both counts.

Why not think in terms not of "name brands" but platforms, i.e. a controller
model + flash combination. For instance Intel have been using some other
companies' controllers in their SSDs. Kingston uses tons of various
controllers (Sandforce/Phison/Marvell/more?) depending on the model and range.

> * Files with NOCOW and filesystems with 'nodatacow' set will both hurt 
> performance for BTRFS on SSD's, and appear to reduce the lifetime of the 
> SSD.

"Appear to"? Just... what. So how many SSDs did you have fail under nocow?

Or maybe can we get serious in a technical discussion? Did you by any chance
mean cause more writes to the SSD and more "to flash" writes (resulting in a
higher WA). If so, then by how much, and what was your test scenario comparing
the same usage with and without nocow?

> * Compression should help performance and device lifetime most of the 
> time, unless your CPU is fully utilized on a regular basis (in which 
> case it will hurt performance, but still improve device lifetimes).

Days are long gone since the end user had to ever think about device lifetimes
with SSDs. Refer to endurance studies such as 
http://techreport.com/review/27909/the-ssd-endurance-experiment-theyre-all-dead
http://ssdendurancetest.com/
https://3dnews.ru/938764/
It has been demonstrated that all SSDs on the market tend to overshoot even
their rated TBW by several times, as a result it will take any user literally
dozens of years to wear out the flash no matter which filesystem or what
settings used. And most certainly it's not worth it changing anything
significant in your workflow (such as enabling compression if it's otherwise
inconvenient or not needed) just to save the SSD lifetime.

On Mon, 17 Apr 2017 13:13:39 -0400
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> > What is a high end SSD these days? Built-in NVMe?
> One with a good FTL in the firmware.  At minimum, the good Samsung EVO 
> drives, the high quality Intel ones

As opposed to bad Samsung EVO drives and low-quality Intel ones?

> and the Crucial MX series, but 
> probably some others.  My choice of words here probably wasn't the best 
> though.

Again, which controller? Crucial does not manufacture SSD controllers on their
own, they just pack and brand stuff manufactured by someone else. So if you
meant Marvell based SSDs, then that's many brands, not just Crucial.

> For a normal filesystem or BTRFS with nodatacow or NOCOW, the block gets 
> rewritten in-place.  This means that cheap FTL's will rewrite that erase 
> block in-place (which won't hurt performance but will impact device 
> lifetime), and good ones will rewrite into a free block somewhere else 
> but may not free that original block for quite some time (which is bad 
> for performance but slightly better for device lifetime).

> Overall, this boils down to the fact that most FTL's get slower if they 
> can't wear-level the device properly, and in-place rewrites make it 
> harder for them to do proper wear-leveling.

"Cheap FTL" in your description would be an USB flash stick, or maybe an old
CompactFlash card. Even the 2010 era mass market SandForce controllers will do
none of the stupid shit you describe.

Sorry but with your superficial understanding of the topic (and confidently
sounding verbose posts) all you do is spreading common SSD myths and
misconceptions, i.e. just being downright harmful to whoever reads this
discussion or discovers it later.


-- 
With respect,
Roman
