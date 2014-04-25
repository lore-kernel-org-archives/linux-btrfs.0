Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-02.shaw.ca ([64.59.136.138]:15631 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDYSnN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 14:43:13 -0400
Message-ID: <535AACC0.2000600@shaw.ca>
Date: Fri, 25 Apr 2014 12:43:12 -0600
From: Steve Leung <sjleung@shaw.ca>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: safe/necessary to balance system chunks?
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung> <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com> <535AA581.1080301@gmail.com>
In-Reply-To: <535AA581.1080301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2014 12:12 PM, Austin S Hemmelgarn wrote:
> On 2014-04-25 13:24, Chris Murphy wrote:
>>
>> On Apr 25, 2014, at 8:57 AM, Steve Leung <sjleung@shaw.ca> wrote:
>>
>>> I've got a 3-device RAID1 btrfs filesystem that started out life as single-device.
>>>
>>> btrfs fi df:
>>>
>>> Data, RAID1: total=1.31TiB, used=1.07TiB
>>> System, RAID1: total=32.00MiB, used=224.00KiB
>>> System, DUP: total=32.00MiB, used=32.00KiB
>>> System, single: total=4.00MiB, used=0.00
>>> Metadata, RAID1: total=66.00GiB, used=2.97GiB
>>>
>>> This still lists some system chunks as DUP, and not as RAID1.  Does this mean that if one device were to fail, some system chunks would be unrecoverable?  How bad would that be?
>>>
>>> Assuming this is something that needs to be fixed, would I be able to fix this by balancing the system chunks?  Since the "force" flag is required, does that mean that balancing system chunks is inherently risky or unpleasant?
>>
>> I don't think force is needed. You'd use btrfs balance start -sconvert=raid1 <mountpoint>; or with -sconvert=raid1,soft although it's probably a minor distinction for such a small amount of data.
> The kernel won't allow a balance involving system chunks unless you
> specify force, as it considers any kind of balance using them to be
> dangerous.  Given your circumstances, I'd personally say that the safety
> provided by RAID1 outweighs the risk of making the FS un-mountable.

Agreed, I'll attempt the system balance shortly.

> Personally, I would recommend making a full backup of all the data (tar
> works wonderfully for this), and recreate the entire filesystem from
> scratch, but passing all three devices to mkfs.btrfs.  This should
> result in all the chunks being RAID1, and will also allow you to benefit
> from newer features.

I do have backups of the really important stuff from this filesystem, 
but they're offsite.  As this is just for a home system, I don't have 
enough temporary space for a full backup handy (which is related to how 
I ended up in this situation in the first place).

Once everything gets rebalanced though, I don't think I'd be missing out 
on any features, would I?

Steve
