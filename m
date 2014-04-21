Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from noc.netops.me ([50.22.23.10]:24799 "EHLO noc.netops.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbaDUE4L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 00:56:11 -0400
Message-ID: <5354A4EA.3000209@aeb.io>
Date: Sun, 20 Apr 2014 21:56:10 -0700
From: Adam Brenner <adam@aeb.io>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size
 Drives
References: <53540367.4050707@aeb.io> <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com>
In-Reply-To: <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/20/2014 01:54 PM, Chris Murphy wrote:
>
> This is expected. And although I haven't tested it, I think you'd get
> the same results with multiple threads writing at the same time: the
> allocation would aggregate the threads to one chunk at a time until
> full, which means writing to one device at a time, then writing a new
> chunk on a different device until full, and so on in round robin
> fashion.

Interesting and some what shocked -- if I am reading this correctly!

So ... BTRFS at this point in time, does not actually "stripe" the data 
across N number of devices/blocks for aggregated performance increase 
(both read and write)?

Essentially running mdadm with ext4 or XFS would offer better 
performance then BTRFS right now (and possible the ZFS on Linux project)?

I think I may be missing a keypoint here (or not RTFM)?



The WiKi page[1] clearly shows that the command I used to create my 
current setup (-m single) will *not* stripe the data which should have 
been the first _red_ flag for me! However, if I go ahead and create using

    mkfs.btrfs -d raid0 /dev/sda3 /dev/sdb /dev/sdc

This *should* stripe the data and improve read and write performance? 
But according to what Chris wrote above, this is not true? Just want 
some clarification on this.

>
>>
>> So my question is, should I have setup the BTRFS filesystem with -d
>> raid0? Would this have worked with multiple devices with different
>> sizes?
>
> raid0 does work with multiple devices of different sizes, but it
> won't use the full capacity of the last drive with the most space.
>
> For example: 2GB, 3GB, and 4GB devices as raid0.
>
> The first 2GB copies using 3 stripes, one per device, until the 2GB
> device is full. The next 1GB copies using 2 stripes, one per
> remaining device (the 3GB and 4GB ones) until the 3GB device is full.
> Additional copying results in "cp: error writing ‘./IMG_2892.dng’: No
> space left on device"

I am sorry, I do not quite understand this. If I read this correctly, we 
are copying a file that is larger then the total raid0 filesystem 
(9GB?). The point at which writes fail is at the magic number of 5GB -- 
which is where the two devices are full?

So going back to the setup I currently have:

     Label: none  uuid: 63d51c9b-f851-404f-b0f2-bf84d07df163
         Total devices 3 FS bytes used 3.03TiB
         devid    1 size 3.61TiB used 1.01TiB path /dev/sda3
         devid    2 size 3.64TiB used 1.04TiB path /dev/sdb
         devid    3 size 3.64TiB used 1.04TiB path /dev/sdc

If /dev/sda3 and /dev/sdb are full, but room is still left on /dev/sdc, 
writes file -- but the metadata will continue to succeed taking up 
ionodes and creating zero length files?

[1]: 
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

-- 
Adam Brenner <adam@aeb.io>
