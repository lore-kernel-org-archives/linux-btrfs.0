Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39505 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755293AbaE1UkC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 16:40:02 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Failed Disk RAID10 Problems
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKZK7uy6Y7_+JQGrZp5yTpZ2kCsH8wGDhz+Oq4oGidYkQNcq1g@mail.gmail.com>
Date: Wed, 28 May 2014 14:40:00 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B46E9BEF-086C-4B7E-8FCC-4A5F957303D5@colorremedies.com>
References: <CAKZK7uwZOZEjQ-T9z-KGSRpW1xpY911_QoDM26SBdmSViRtrZA@mail.gmail.com> <08C16AE5-02A8-413B-B95C-EC2B5A1D32EC@colorremedies.com> <CAKZK7ux1Cm0tQFqFJtTPbL089DQR+4Ekv5Ef8L3BgUkyY+bLQA@mail.gmail.com> <CAKZK7uy6Y7_+JQGrZp5yTpZ2kCsH8wGDhz+Oq4oGidYkQNcq1g@mail.gmail.com>
To: Justin Brown <justin.brown@fandingo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 28, 2014, at 12:39 PM, Justin Brown <justin.brown@fandingo.org> wrote:

> Chris,
> 
> Thanks for the tip. I was able to mount the drive as degraded and
> recovery. Then, I deleted the faulty drive, leaving me with the
> following array:
> 
> 
> Label: media  uuid: 7b7afc82-f77c-44c0-b315-669ebd82f0c5
> 
> Total devices 6 FS bytes used 2.40TiB
> 
> devid    1 size 931.51GiB used 919.88GiB path
> /dev/mapper/SAMSUNG_HD103SI_499431FS734755p1
> 
> devid    2 size 931.51GiB used 919.38GiB path /dev/dm-8
> 
> devid    3 size 1.82TiB used 1.19TiB path /dev/dm-6
> 
> devid    4 size 931.51GiB used 919.88GiB path /dev/dm-5
> 
> devid    5 size 0.00 used 918.38GiB path /dev/dm-11
> 
> devid    6 size 1.82TiB used 3.88GiB path /dev/dm-9
> 
> 
> /dev/dm-11 is the failed drive. I take it that size 0 is a good sign.
> I'm not really sure where to go from here. I tried rebooting the
> system with the failed drive attached, and Btrfs re-adds it to the
> array. Should I physically remove the drive now? Is a balance
> recommended?

I'm going to guess at what I think has happened. You had a 5 device raid10. devid 5 is the failed device, but at the time you added new device devid 6, it was not considered failed by btrfs. Your first btrfs fi show does not show size 0 for devid 5. So I think btrfs made you a 6 device raid10 volume.

But now devid 5 has failed, shows up as size 0. The reason you have to mount degraded still is because you have a 6 device raid10 now, and 1 device has failed. And you can't remove the failed device because you've mounted degraded. So actually it was a mistake to add a new device first, but it's an easy mistake to make because right now btrfs really tolerates a lot of error conditions that it probably should give up on and outright fail the device.

So I think you might have to get a 7th device to fix this with btrfs replace start. You can later delete devices once you're not mounted degraded. Or you can just do a backup now while you can mount degraded, and then blow away the btrfs volume and start over.

If you have a current backups and are willing to lose data on this volume, you can try the following

1. Poweroff, remove the failed drive, boot, and do a normal mount. That probably won't work but it's worth a shot. If it doesn't work try mount -o degraded. [That might not work either, in which case stop here, I think you'll need to go with a 7th device and use 'btrfs replace start 5 /dev/newdevice7 /mp' That will explicitly replace failed device 5 with new device.]

2. Assuming mount -o degraded works, take a btrfs fi show. There should be a missing device listed. Now try btrfs device delete missing /mp and see what happens. If it at least doesn't complain, it means it's working and might take hours to replicate data that was on the missing device onto the new one. So I'd leave it alone until iotop or something like that tells you it's not busy anymore.

3. Unmount the file system. Try to mount normally (not degraded).



Chris Murphy