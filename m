Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43244 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750770AbaEVBet (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 21:34:49 -0400
Message-ID: <537D5468.3040808@cn.fujitsu.com>
Date: Thu, 22 May 2014 09:35:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: Should btrfs reuse the src_dev's dev UUID when doing dev replacing?
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[Current dev replace]
As kernel codes show, 'btrfs dev replace' will swap tgt_dev's uuid with 
src_dev's uuid.
This method works fine most of the time, since it doesn't need to change 
the chunk tree.

[Problem with re-appear missing device]
(Anand Jain reported the problem in Jan 2014)
Take the following suitiuation as example:
/dev/sda, /dev/sdb, /dev/sdc as btrfs RAID1.
1, 2, 3 as their dev id.

1)/dev/sdb is missing,
Mount them in degraded mode.

2) 'btrfs dev replace start 2 /dev/sdd' will replace missing /dev/sdb.

3) /dev/sdb is online again.

4) umount /BTRFS/MOUNT/POINT; mount /dev/sda
After mount, btrfs will still use /dev/sdb but not /dev/sdd

[Cause of the bug]
When this comes to missing device, since the src_dev is missing, neither 
UUID swap nor superblock wipe will
work. So if the device reappears, next mount will scan the the fsid and 
dev uuid, and if btrfs scan the re-appeared
device first, it will use the re-appeared device.

[Method to fix]
IMO there are 2 possible method to fix the bug.
1) Don't reuse the src_dev's dev UUID.
I don't think any of the UUID in btrfs should be reused, so if every 
device in btrfs has its own UUID,
it is quite easy to distinguish different devices, and even don't need 
to wipe the superblock of src_dev.
(But superblock wipe is still needed for other reasons)

2) Do generation check in device_list_add.
When multiple devices with same dev UUID is found, only add the one 
whose generation is the same with
other deivces.
IMO this is just a workaround.

I think it is better to be decided before any related patch sent.

Any suggestions?

Thanks,
Qu
