Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35241 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaDYSMO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 14:12:14 -0400
Received: by mail-ig0-f181.google.com with SMTP id h18so2519748igc.14
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 11:12:14 -0700 (PDT)
Message-ID: <535AA581.1080301@gmail.com>
Date: Fri, 25 Apr 2014 14:12:17 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>, Steve Leung <sjleung@shaw.ca>
CC: linux-btrfs@vger.kernel.org
Subject: Re: safe/necessary to balance system chunks?
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung> <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
In-Reply-To: <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-04-25 13:24, Chris Murphy wrote:
> 
> On Apr 25, 2014, at 8:57 AM, Steve Leung <sjleung@shaw.ca> wrote:
> 
>>
>> Hi list,
>>
>> I've got a 3-device RAID1 btrfs filesystem that started out life as single-device.
>>
>> btrfs fi df:
>>
>> Data, RAID1: total=1.31TiB, used=1.07TiB
>> System, RAID1: total=32.00MiB, used=224.00KiB
>> System, DUP: total=32.00MiB, used=32.00KiB
>> System, single: total=4.00MiB, used=0.00
>> Metadata, RAID1: total=66.00GiB, used=2.97GiB
>>
>> This still lists some system chunks as DUP, and not as RAID1.  Does this mean that if one device were to fail, some system chunks would be unrecoverable?  How bad would that be?
> 
> Since it's "system" type, it might mean the whole volume is toast if the drive containing those 32KB dies. I'm not sure what kind of information is in system chunk type, but I'd expect it's important enough that if unavailable that mounting the file system may be difficult or impossible. Perhaps btrfs restore would still work?
> 
> Anyway, it's probably a high penalty for losing only 32KB of data.  I think this could use some testing to try and reproduce conversions where some amount of "system" or "metadata" type chunks are stuck in DUP. This has come up before on the list but I'm not sure how it's happening, as I've never encountered it.
>
As far as I understand it, the system chunks are THE root chunk tree for
the entire system, that is to say, it's the tree of tree roots that is
pointed to by the superblock. (I would love to know if this
understanding is wrong).  Thus losing that data almost always means
losing the whole filesystem.
>>
>> Assuming this is something that needs to be fixed, would I be able to fix this by balancing the system chunks?  Since the "force" flag is required, does that mean that balancing system chunks is inherently risky or unpleasant?
> 
> I don't think force is needed. You'd use btrfs balance start -sconvert=raid1 <mountpoint>; or with -sconvert=raid1,soft although it's probably a minor distinction for such a small amount of data.
The kernel won't allow a balance involving system chunks unless you
specify force, as it considers any kind of balance using them to be
dangerous.  Given your circumstances, I'd personally say that the safety
provided by RAID1 outweighs the risk of making the FS un-mountable.
> 
> The metadata looks like it could use a balance, 66GB of metadata chunks allocated but only 3GB used. So you could include something like -musage=50 at the same time and that will balance any chunks with 50% or less usage.
> 
> 
> Chris Murphy
> 

Personally, I would recommend making a full backup of all the data (tar
works wonderfully for this), and recreate the entire filesystem from
scratch, but passing all three devices to mkfs.btrfs.  This should
result in all the chunks being RAID1, and will also allow you to benefit
from newer features.
