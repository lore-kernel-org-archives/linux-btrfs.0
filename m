Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout013.mail.hostpoint.ch ([217.26.49.173]:15392 "EHLO
	mxout013.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbcFNT3B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 15:29:01 -0400
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
	by mxout013.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bCu1C-000HlN-LZ
	for linux-btrfs@vger.kernel.org; Tue, 14 Jun 2016 21:28:58 +0200
Received: from 217-162-125-82.dynamic.hispeed.ch ([217.162.125.82] helo=imac.lan)
	by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bCu1C-000163-FS
	for linux-btrfs@vger.kernel.org; Tue, 14 Jun 2016 21:28:58 +0200
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
From: boli <btrfs@bueechi.net>
In-Reply-To: <e4c67cb3-b5f3-5dbb-1fb1-4d9a3b9a2f60@gmail.com>
Date: Tue, 14 Jun 2016 21:28:57 +0200
Message-Id: <E0C7FC1F-AEEE-4A79-9031-51FF616D027B@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net> <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net> <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net> <e4c67cb3-b5f3-5dbb-1fb1-4d9a3b9a2f60@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Replace doesn't need to do a balance, it's largely just a block level copy of the device being replaced, but with some special handling so that the filesystem is consistent throughout the whole operation.  This is most of why it's so much more efficient than add/delete.

Thanks for this correction. In the mean time I experienced myself that replace is pretty fast…

Last time I wrote I thought the initial 4 day "remove missing" was successful/complete, but as it turned out that device was still missing. Maybe that Ctrl+C I tried after a few days did work after all. I only checked/noticed this after the 8 TB drive was zeroed and encrypted.

Luckily, most of the "missing" data was already rebuilt onto the remaining 2 drives, and only 1.27 TiB were still "missing".

In hindsight I should probably have repeated "remove missing" here, but to completion. What I did instead was a "replace -r" onto the 8 TB drive. This did successfully rebuild the missing 1.27 TiB of data onto the 8 TB drive, at a speedy ~144 MiB/s no less!

So I was back to a 4-drive raid1, with 3x 6 TB drives and 1x 8 TB drive (though that 8 TB drive had very little data on it). Then I tried to "remove" (without "-r" this time) the 6 TB drive with the least amount of data on it (one had 4.0 TiB, where the other two had 5.45 TiB each). This failed after a few minutes because of "no space left on device". 

Austin's mail reminded me to resize due to the larger disk, which I then did, but that device still couldn't be removed, same error message.
I then consulted the wiki, which mentions that space for metadata might be rather full (11.91 used of 12.66 GiB total here), and to try a "balance" with a low "dusage" in such cases.

For now I avoided that by removing one of the other two (rather full) 6 TB drives at random, and this has been going on for the last 20 hours or so. Thanks to running it in a screen I can check the progress this time around, and it's doing its thing at ~41 MiB/s, or ~7 hours per TiB, on average.

Maybe the "no data left on device" will sort itself out during this "remove"'s balance, otherwise I'll do it manually later.

> The most efficient way of converting the array online without adding any more disks than you have to begin with is:
> 1. Delete one device from the array with device delete.
> 2. Physically switch the now unused device with one of the new devices.
> 3. Use btrfs replace to replace one of the devices in the array with the newly connected device (and make sure to resize to the full size of the new device).
> 4. Repeat from step 2 until you aren't using any of the old devices in the array.
> 5. You should have one old device left unused, physically switch it for a new device.
> 6. Use btrfs device add to add the new device to the array, then run a full balance.
> 
> This will result in only two balances being needed (one implicit in the device delete, and the explicit final one to restripe across the full array), and will result in the absolute minimum possible data transfer.

Thank you for these very explicit/succinct instructions! Also thanks to Henk and Duncan! I will definitely do a full balance when all disks are replaced.

