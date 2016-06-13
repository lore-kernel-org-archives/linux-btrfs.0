Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34519 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422882AbcFMMZA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jun 2016 08:25:00 -0400
Received: by mail-io0-f178.google.com with SMTP id 5so118115107ioy.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jun 2016 05:24:59 -0700 (PDT)
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
To: boli <btrfs@bueechi.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
 <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net>
 <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e4c67cb3-b5f3-5dbb-1fb1-4d9a3b9a2f60@gmail.com>
Date: Mon, 13 Jun 2016 08:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-12 06:35, boli wrote:
>> It has now been doing "btrfs device delete missing /mnt" for about 90 hours.
>>
>> These 90 hours seem like a rather long time, given that a rebalance/convert from 4-disk-raid5 to 4-disk-raid1 took about 20 hours months ago, and a scrub takes about 7 hours (4-disk-raid1).
>>
>> OTOH the filesystem will be rather full with only 3 of 4 disks available, so I do expect it to take somewhat "longer than usual".
>>
>> Would anyone venture a guess as to how long it might take?
>
> It's done now, and took close to 99 hours to rebalance 8.1 TB of data from a 4x6TB raid1 (12 TB capacity) with 1 drive missing onto the remaining 3x6TB raid1 (9 TB capacity).
>
> Now I made sure quotas were off, then started a screen to fill the new 8 TB disk with zeros, detached it and and checked iotop to get a rough estimate on how long it will take (I'm aware it will become slower in time).
>
> After that I'll add this 8 TB disk to the btrfs raid1 (for yet another rebalance).
>
> The next 3 disks will be replaced with "btrfs replace", so only one rebalance each is needed.
>
> I assume each "btrfs replace" would do a full rebalance, and thus assign chunks according to the normal strategy of choosing the two drives with the most free space, which in this case would be a chunk to the new drive, and a mirrored chunk to that existing 3 drive with most free space.
Replace doesn't need to do a balance, it's largely just a block level 
copy of the device being replaced, but with some special handling so 
that the filesystem is consistent throughout the whole operation.  This 
is most of why it's so much more efficient than add/delete.
>
> What I'm wondering is this:
> If the goal is to replace 4x 6TB drive (raid1) with 4x 8TB drive (still raid1), is there a way to remove one 6 TB drive at a time, recreate its exact contents from the other 3 drives onto a new 8 TB drive, without doing a full rebalance? That is: without writing any substantial amount of data onto the remaining 3 drives.
The most efficient way of converting the array online without adding any 
more disks than you have to begin with is:
1. Delete one device from the array with device delete.
2. Physically switch the now unused device with one of the new devices.
3. Use btrfs replace to replace one of the devices in the array with the 
newly connected device (and make sure to resize to the full size of the 
new device).
4. Repeat from step 2 until you aren't using any of the old devices in 
the array.
5. You should have one old device left unused, physically switch it for 
a new device.
6. Use btrfs device add to add the new device to the array, then run a 
full balance.

This will result in only two balances being needed (one implicit in the 
device delete, and the explicit final one to restripe across the full 
array), and will result in the absolute minimum possible data transfer.
