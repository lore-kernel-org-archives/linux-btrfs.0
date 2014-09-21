Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52499 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751326AbaIURFt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 13:05:49 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:52097 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XVka3-001GaB-Nm
	for linux-btrfs@vger.kernel.org; Sun, 21 Sep 2014 11:05:48 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: deleting a dead device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201409211139.17295.russell@coker.com.au>
Date: Sun, 21 Sep 2014 11:05:46 -0600
Message-Id: <32D903D8-EF64-4456-BD66-3425D7F7B6DE@colorremedies.com>
References: <201409211139.17295.russell@coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 20, 2014, at 7:39 PM, Russell Coker <russell@coker.com.au> wrote:
> 
> Anyway the new drive turned out to have some errors, writes failed and I've 
> got a heap of errors such as the above.

I'm curious if smartctl -t conveyance reveals any problems, it's not a full surface test but is designed to be a test for (typical?) problems drives have due to shipment damage, and doesn't take very long.

>  The errors started immediately after 
> adding the drive and the system wasn't actively writing to the filesystem.  So 
> very few (if any) writes made it to the device.
> 
> # btrfs device delete /dev/sdc3 /
> ERROR: error removing the device '/dev/sdc3' - Invalid argument
> 
> It seems that I can't remove the device because removing requires writing.

What kernel message do you get associated with this? Try using the devid instead of /dev/.

For future reference, btrfs replace start is better to use than add+delete. It's an optimization but it also makes it possible to ignore the device being replaced for reads; and you can also get a status on the progress with "btrfs replace status". And it looks like it does some additional error checking.

> 
> # btrfs device delete /dev/sdc3 /
> ERROR: error removing the device '/dev/sdc3' - No such file or directory
> # btrfs device stats /
> [/dev/sda3].write_io_errs   0
> [/dev/sda3].read_io_errs    0
> [/dev/sda3].flush_io_errs   0
> [/dev/sda3].corruption_errs 57
> [/dev/sda3].generation_errs 0
> [/dev/sdb3].write_io_errs   0
> [/dev/sdb3].read_io_errs    0
> [/dev/sdb3].flush_io_errs   0
> [/dev/sdb3].corruption_errs 0
> [/dev/sdb3].generation_errs 0
> [/dev/sdc3].write_io_errs   267
> [/dev/sdc3].read_io_errs    0
> [/dev/sdc3].flush_io_errs   0
> [/dev/sdc3].corruption_errs 0
> [/dev/sdc3].generation_errs 0
> 
> The drive is attached by USB so I turned off the USB device and then got the 
> above result.  So it still seems impossible to remove the device even though 
> it's physically not present.  I've connected a new USB disk which is now 
> /dev/sdd, so it seems that BTRFS is keeping the name /dev/sdc locked.

Pretty sure kernel assignment is major:minor, and anything under /dev/ is udev. What do you get for
btrfs fi show

Unfortunately this won't show devid for missing devices, so you might have to infer this. But you can use btrfs replace start -r <devid> /dev/sddX <mountpoint>

> 
> Also as an aside, while the stats about write errors are useful, in this case 
> it would be really good if there was a count of successful writes, it would be 
> useful to know if the successful write count was close to 0.

I think this is for other tools. Btrfs is a file system its responsible for the integrity of the data it writes, I don't think it's responsible for prequalifying drives.

Even a simple dd if=/dev/zero of=/dev/sdc bs=64k count=1600 will write out 100MB, and dmesg will show if there are any controller or drive problems on writes. You may have to do more than 100MB for problems to show up but you get the idea.

You can also use badblocks -swv (progress, destructive write/read, verbose) which will also show writes the drive says succeeded but are actually corrupt.

Use smartctl -t conveyance/short/long to isolate the drive mechanism itself. This obviously doesn't test writes.

Consumer drives should fairly quickly report persistent write failures, which libata will report in dmesg. A common problem though, is they try to do reads much longer than the linux SCSI layer default timeout. Either the SCT ERC timeout of the drive needs to be reduced below 30 seconds; or the linux SCSI layer timeout needs to be raised above the drive SCT ERC timeout. Otherwise the drive keeps trying to do reads, the linux SCSI layer gives up on the non-communicating drive (which is busy recovering) and resets the link. Now the read error doesn't actually happen, doesn't report the offending sector, and Btrfs can't fix the problem.


Chris Murphy

