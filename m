Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37907 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaDUFdA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 01:33:00 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size Drives
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5354A4EA.3000209@aeb.io>
Date: Sun, 20 Apr 2014 23:32:57 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <E27860FA-740D-46FA-9137-A00D50FEE5C7@colorremedies.com>
References: <53540367.4050707@aeb.io> <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com> <5354A4EA.3000209@aeb.io>
To: Adam Brenner <adam@aeb.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 20, 2014, at 10:56 PM, Adam Brenner <adam@aeb.io> wrote:

> On 04/20/2014 01:54 PM, Chris Murphy wrote:
>> 
>> This is expected. And although I haven't tested it, I think you'd get
>> the same results with multiple threads writing at the same time: the
>> allocation would aggregate the threads to one chunk at a time until
>> full, which means writing to one device at a time, then writing a new
>> chunk on a different device until full, and so on in round robin
>> fashion.
> 
> Interesting and some what shocked -- if I am reading this correctly!
> 
> So ... BTRFS at this point in time, does not actually "stripe" the data across N number of devices/blocks for aggregated performance increase (both read and write)?

Not for the single profile.

> The WiKi page[1] clearly shows that the command I used to create my current setup (-m single) will *not* stripe the data which should have been the first _red_ flag for me! However, if I go ahead and create using
> 
>   mkfs.btrfs -d raid0 /dev/sda3 /dev/sdb /dev/sdc
> 
> This *should* stripe the data and improve read and write performance?

It does.


> But according to what Chris wrote above, this is not true?

What I wrote above applies to single profile because I had just quoted your mkfs command which used -d single.

>>> 
>>> So my question is, should I have setup the BTRFS filesystem with -d
>>> raid0? Would this have worked with multiple devices with different
>>> sizes?
>> 
>> raid0 does work with multiple devices of different sizes, but it
>> won't use the full capacity of the last drive with the most space.
>> 
>> For example: 2GB, 3GB, and 4GB devices as raid0.
>> 
>> The first 2GB copies using 3 stripes, one per device, until the 2GB
>> device is full. The next 1GB copies using 2 stripes, one per
>> remaining device (the 3GB and 4GB ones) until the 3GB device is full.
>> Additional copying results in "cp: error writing ‘./IMG_2892.dng’: No
>> space left on device"
> 
> I am sorry, I do not quite understand this. If I read this correctly, we are copying a file that is larger then the total raid0 filesystem (9GB?).

The size of the file doesn't matter. I was copying a bunch of DNGs that are ~20MB each.

> The point at which writes fail is at the magic number of 5GB -- which is where the two devices are full?

No, actually I described it incorrectly. The first 6GB copies using 3 stripes. The smallest device is 2GB. Each device can accept at least 2GB. So that's 6GB. Anything after 6GB is striped across two devices until the 2nd device is full, and then at that point there's failure to write data since single stripe raid0 is apparently disallowed. And as I reported btrfs fi show, it became full at ~8GB (7.33GB of data): 3GB + 3GB + 2GB = 8GB. Thus the extra 1GB on sdd was not usable (except for some metadata).


> So going back to the setup I currently have:
> 
>    Label: none  uuid: 63d51c9b-f851-404f-b0f2-bf84d07df163
>        Total devices 3 FS bytes used 3.03TiB
>        devid    1 size 3.61TiB used 1.01TiB path /dev/sda3
>        devid    2 size 3.64TiB used 1.04TiB path /dev/sdb
>        devid    3 size 3.64TiB used 1.04TiB path /dev/sdc
> 
> If /dev/sda3 and /dev/sdb are full, but room is still left on /dev/sdc, writes file -- but the metadata will continue to succeed taking up ionodes and creating zero length files?

I don't see how your example can happen. sda3 will become full before either sdb or sdc because it's the smallest device in the volume. sdb and sdc are the same size, but might have slightly different amounts of data chunks if the raid1 metadata allocation differs between the two. So yeah one of them probably will fill up before the other, but from a practical standpoint they will fill up at the same time. And at that point, user space reports write errors, but yes I do see zero length files being created, that's limited by the fact metadata is raid1 so with all devices except one full, once all but one metadata chunk is full, then metadata writes would fail too.

And just FYI, if you care about your data or time, I wouldn't try filling up the volume to the brim. Btrfs still gets pretty fussy when that happens, with varying degrees of success in unwinding it.


Chris Murphy

