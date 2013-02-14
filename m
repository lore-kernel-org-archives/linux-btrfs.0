Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:32870 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752176Ab3BNH12 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 02:27:28 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com>
Date: Thu, 14 Feb 2013 00:27:21 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com> <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com>
To: Fredrik Tolf <fredrik@dolda2000.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 13, 2013, at 11:42 PM, Fredrik Tolf <fredrik@dolda2000.com> wrote:

> 
> That's interesting to read. I haven't ever actually experienced missing a bad sector reported by a hard drive, though; and not for a lack of experience with bad sectors.

That experience is consistent with a consumer drive with an ECC timeout that's longer than linux. Well before the drive gives up, linux does (by default anyway.)

>> However, in your case, with both the kernel message ICRC ABRT, and the following SMART entry, this is your cable problem.
> 
> ... I'd still like to solve the problem as it is, so that I know what to do the next time I get some device error.

It depends on the error, but top on that list would be to stop writing to the disk. The last thing I'd do is a rebalance.

> 
>> So the question is whether the cable problem has actually been fixed, and if you're still getting ICRC errors from the kernel.
> 
> I'm not getting any block-layer errors from the kernel. The errors I posted originally are the only ones I'm getting.

Previously you reported:
Feb 12 16:36:51 nerv kernel: [36769.574831] ata6.00: status: { DRDY ERR }
Feb 12 16:36:52 nerv kernel: [36769.578867] ata6.00: error: { ICRC ABRT }

These are not block errors. You should not proceed until you're certain this isn't still intermittently occurring.


> With the general change, I actually decreased the number of drives in the system from 10 to 8, so unless the new drives are incredibly more power-hungry than the old ones, that shouldn't be a problem.

I'd find out and be certain. That ICRC error translates into low power as one of the causes, not just a cable problem.


>> Once that's solved, you should do a scrub, rather than a rebalance.
> 
> Oh, will scrubbing actually rebalance the array? I was under the impression that it only checked for bad checksums.

Scrubbing does not balance the volume. Based on the information you supplied I don't really see the reason for a rebalance.

What you do next depends on what your goal is for this data, on these two disks,  using btrfs. If the idea is to trust the data on the volume; you still have the source data so I'd mkfs.btrfs on the disks and start over. If the idea is to experiment and learn, you might want to do a btrfsck, followed by a scrub.


> I'm still wondering what those errors actually mean, though. I'm still getting them occasionally, even when I'm not rebalancing (just not as often). I'm also very curious about what it means that it's still complaining about sdd rather than sdi.

I have no idea what errors you're still getting, or in what context. This:

Feb 12 22:57:45 nerv kernel: [59626.644110] lost page write due to I/O error on /dev/sdd1

This:
Feb 12 16:36:51 nerv kernel: [36769.574831] ata6.00: status: { DRDY ERR }
Feb 12 16:36:52 nerv kernel: [36769.578867] ata6.00: error: { ICRC ABRT }

Are not btrfs errors. So if you're still getting them. You still have hardware problems to figure out.


> 
> It's worth noting that I still haven't un- and remounted the filesystem since the drive disconnected. I assumed that I shouldn't need to and that the multiple-device layer of btrfs should handle the situation correctly. Is that assumption correct?

Btrfs is stable on stable hardware. Your hardware most definitely was not stable during a series of writes. So I'd say all bets are off. That doesn't mean it can't be fixed, but the very fact you're still getting errors indicates something is still wrong.


Chris Murphy