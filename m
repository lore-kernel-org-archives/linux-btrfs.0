Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57950 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdEMLel (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 07:34:41 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d9VJf-0008H2-94
        for linux-btrfs@vger.kernel.org; Sat, 13 May 2017 13:34:31 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: [OT] SSD performance patterns (was: Btrfs/SSD)
Date: Sat, 13 May 2017 13:34:24 +0200
Message-ID: <20170513133424.05c461b4@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
        <20170512202756.16bd785f@jupiter.sol.kaishome.de>
        <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 13 May 2017 09:39:39 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Kai Krakow posted on Fri, 12 May 2017 20:27:56 +0200 as excerpted:
> 
> > In the end, the more continuous blocks of free space there are, the
> > better the chance for proper wear leveling.  
> 
> Talking about which...
> 
> When I was doing my ssd research the first time around, the going 
> recommendation was to keep 20-33% of the total space on the ssd
> entirely unallocated, allowing it to use that space as an FTL
> erase-block management pool.
> 
> At the time, I added up all my "performance matters" data dirs and 
> allowing for reasonable in-filesystem free-space, decided I could fit
> it in 64 GB if I had to, tho 80 GB would be a more comfortable fit,
> so allowing for the above entirely unpartitioned/unused slackspace 
> recommendations, had a target of 120-128 GB, with a reasonable range 
> depending on actual availability of 100-160 GB.
> 
> It turned out, due to pricing and availability, I ended up spending 
> somewhat more and getting 256 GB (238.5 GiB).  Of course that allowed
> me much more flexibility than I had expected and I ended up with
> basically everything but the media partition on the ssds, PLUS I
> still left them at only just over 50% partitioned, (using the gdisk
> figures, 51%- partitioned, 49%+ free).

I put by ESP (for UEFI) onto the SSD and also played with putting swap
onto it dedicated to hibernation. But I discarded the hibernation idea
and removed the swap because it didn't work well: It wasn't much faster
then waking from HDD, and hibernation is not that reliable anyways.
Also, hybrid hibernation is not yet integrated into KDE so I stick to
sleep mode currently.

The rest of my SSD (also 500GB) is dedicated to bcache. This fits my
complete work set of daily work with hit ratios going up to 90% and
beyond. My filesystem boots and feels like SSD, the HDDs are almost
silent and still my file system is 3TB on 3x 1TB HDD.


> Given that, I've not enabled btrfs trim/discard (which saved me from
> the bugs with it a few kernel cycles ago), and while I do have a
> weekly fstrim systemd timer setup, I've not had to be too concerned
> about btrfs bugs (also now fixed, I believe) when fstrim on btrfs was
> known not to be trimming everything it really should have been.

This is a good recommendation as TRIM is still a slow operation because
Queued TRIM is not used for most drives due to buggy firmware. So you
not only circumvent kernel and firmware bugs, but also get better
performance that way.


> Anyway, that 20-33% left entirely unallocated/unpartitioned 
> recommendation still holds, right?  Am I correct in asserting that if
> one is following that, the FTL already has plenty of erase-blocks
> available for management and the discussion about filesystem level
> trim and free space management becomes much less urgent, tho of
> course it's still worth considering if it's convenient to do so?
> 
> And am I also correct in believing that while it's not really worth 
> spending more to over-provision to the near 50% as I ended up doing,
> if things work out that way as they did with me because the
> difference in price between 30% overprovisioning and 50%
> overprovisioning ends up being trivial, there's really not much need
> to worry about active filesystem trim at all, because the FTL has
> effectively half the device left to play erase-block musical chairs
> with as it decides it needs to?

I think, things may have changed since long ago. See below. But it
certainly depends on which drive manufacturer you chose, I guess.

I can at least confirm that bigger drives wear their write cycles much
slower, even when filled up. My old 128MB Crucial drive was worn after
only 1 year (I swapped it early, I kept an eye on SMART numbers). My
500GB Samsung drive is around 1 year old now, I do write a lot more
data to it, but according to SMART it should work for at least 5 to 7
more years. By that time, I probably already swapped it for a bigger
drive.

So I guess you should maybe look at your SMART numbers and calculate
the expected life time:

Power_on_Hours(RAW) * WLC(VALUE) / (100-WLC(VALUE))
with WLC = Wear_Leveling_Count

should get you the expected remaining power on hours. My drive is
powered on 24/7 most of the time but if you power your drive only 8
hours per day, you can easily ramp up the life time by three times of
days vs. me. ;-)

There is also Total_LBAs_Written but that, at least for me, usually
gives much higher lifetime values so I'd stick with the pessimistic
ones.

Even when WLC goes to zero, the drive should still have reserved blocks
available. My drive sets the threshold to 0 for WLC which makes me
think that it is not fatal when it hits 0 because the drive still has
reserved blocks. And for reserved blocks, the threshold is 10%.

Now combine that with your planning of getting a new drive, and you can
optimize space efficiency vs. lifetime better.


> Of course the higher per-GiB cost of ssd as compared to spinning rust 
> does mean that the above overprovisioning recommendation really does 
> hurt, most of the time, driving per-usable-GB costs even higher, and
> as I recall that was definitely the case back then between 80 GiB and
> 160 GiB, and it was basically an accident of timing, that I was
> buying just as the manufactures flooded the market with newly
> cost-effective 256 GB devices, that meant they were only trivially
> more expensive than the 128 or 160 GB, AND unlike the smaller
> devices, actually /available/ in the 500-ish MB/sec performance range
> that (for SATA-based SSDs) is actually capped by SATA-600 bus speeds
> more than the chips themselves.  (There were lower cost 128 GB
> devices, but they were lower speed than I wanted, too.)

Well, I think that most modern drives have a huge fast write cache in
front of the FTL to combine writes and reduce rewrite patterns to the
flash storage. This should already help a lot. Otherwise I cannot
explain how endurance tests show multi-petabyte write endurance even
for TLC drives that are specified with only a few hundred terabytes
write endurance.

So, depending on your write patterns, overprovisioning may not be that
important these days. I.e., Samsung even removed the overprovisioning
feature from their most recent major update to the Magician software. I
believe that is for that reason. Plus, because modern Windows versions
do proper trimming (it is built into the defrag system tool which is
now enabled by default on SSD but only "optimizes" by trimming free
space, Windows Server versions even allow thinning the host disk images
that way when used in virtualization environments).

But overprovisioning should still get you a faster drive while you fill
up your FS because it can handle slow erase cycles in the background
easily.

But prices drop and technology improves, so we can optimize from both
sides and can lower overprovisioning while still staying with an optimal
lifetime and big storage size.

Regarding performance, it seems that only drives on and beyond the
500GB limit can saturate the SATA-600 bus both for reading and writing.
>From this I conclude I should get a PCIe SSD if I bought a drive beyond
500GB.


-- 
Regards,
Kai

Replies to list-only preferred.


