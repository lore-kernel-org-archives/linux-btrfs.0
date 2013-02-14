Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:29552 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756353Ab3BNIlH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 03:41:07 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com>
Date: Thu, 14 Feb 2013 01:41:04 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com> <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com> <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com> <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com>
To: Fredrik Tolf <fredrik@dolda2000.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 14, 2013, at 12:58 AM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
> 
> Feb 14 08:32:30 nerv kernel: [180511.760850] lost page write due to I/O error on /dev/sdd1

Well, someone else might comment on what that is exactly, I'm not getting conclusive google hits on this. Sometimes it's fixed by going to a newer kernel. Sometimes it's bad hardware. But it's apparently not a btrfs error. But it's causing subsequent errors which are btrfs errors. So whatever it is, it seems like btrfs doesn't like it.


> Feb 14 08:32:30 nerv kernel: [180511.764690] btrfs: bdev /dev/sdd1 errs: wr 288650, rd 26, flush 1, corrupt 0, gen 0

So there continue to be write errors. Unsurprising as sdd1 seems to be dropping pages.

>> 
>> Scrubbing does not balance the volume. Based on the information you supplied I don't really see the reason for a rebalance.
> 
> Maybe my terminology is wrong again, then, because I do see a reason to get the data properly replicated across the drives, which it doesn't seem to be now. That's what I meant by "rebalancing".

How much data was copied to the drives? I'm continuously confused by how btrfs reports data usage. What I have is this from fi show and fi df:

Data, RAID1: total=2.66TB, used=2.66TB
Total devices 2 FS bytes used 1.64TB
devid    1 size 2.73TB used 1.64TB path /dev/sdi1
devid    2 size 2.73TB used 2.67TB path /dev/sde1

So I can't tell if it's ~1.64TB copied or 2.6TB.

At this point I wish these two could just report the GB/TB equivalent of non-free LBA's in use for the file system and on each device.

I can see why you want to rebalance but you have WRITE ERRORS still occurring. That needs to get figured out before you expect a rebalance to work.


> I mean, with md, I can easily handle a device failure and fix it up without having to remount or reboot;

That's speculative. You have continuing write failures for one drive for unknown reasons. md will kick devices out of an array in such a case; so it too gets out of sync and needs resyncing.

What's not clear right now is why you keep getting this kernel I/O error. It's not unreasonable to power off the computer, check all the cables, and that the controller is seated - after all you did get multiple indications that a UDMA CRC error occurred. And that's a hardware error. I don't know how well the kernel or the hardware recovers from this. That's a separate question from btrfs recovering from such a problem.

> 
>> Btrfs is stable on stable hardware. Your hardware most definitely was not stable during a series of writes. So I'd say all bets are off. That doesn't mean it can't be fixed, but the very fact you're still getting errors indicates something is still wrong.
> 
> Isn't btrfs' RAID1 supposed to be stable as long as only one disk fails, though?

OK but this isn't a drive failure. You have other problems occurring.


> 
>> This:
>> Feb 12 22:57:45 nerv kernel: [59626.644110] lost page write due to I/O error on /dev/sdd1
>> Are not btrfs errors.
> 
> I see. I thought that was a btrfs error, but I was wrong then. Since I'm not actually getting any driver errors, though, and it's referring to sdd, doesn't that just mean, as I suspect, that btrfs is still trying to use the old defunct sdd instead of sdi as the drive became named after it was redetected?

Btrfs uses UUIDs to identify drives, not /dev/sdX. So if a particular drive vanished for a bit, came back and was assigned a new /dev/sdX letter, but has the UUID btrfs is expecting, it very well may re-add it. It's an open question if it should do that in the face of hardware problems that it's not designed to manage.


> 
>> This:
>> Feb 12 16:36:51 nerv kernel: [36769.574831] ata6.00: status: { DRDY ERR }
>> Feb 12 16:36:52 nerv kernel: [36769.578867] ata6.00: error: { ICRC ABRT }
> 
> Just to be overly redundant: I'm not getting those anymore, and I only ever got them before the drive was redetected as sdi.

I'd poweroff, check things, power back up. Seems to me either the hardware is confused, the kernel is confused, or both. I'm not sure why.


Chris Murphy