Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:32995 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaDYTHh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 15:07:37 -0400
Received: by mail-ie0-f182.google.com with SMTP id tp5so868163ieb.13
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 12:07:36 -0700 (PDT)
Message-ID: <535AB27C.6070205@gmail.com>
Date: Fri, 25 Apr 2014 15:07:40 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Steve Leung <sjleung@shaw.ca>, Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: safe/necessary to balance system chunks?
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung> <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com> <535AA581.1080301@gmail.com> <535AACC0.2000600@shaw.ca>
In-Reply-To: <535AACC0.2000600@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-04-25 14:43, Steve Leung wrote:
> On 04/25/2014 12:12 PM, Austin S Hemmelgarn wrote:
>> On 2014-04-25 13:24, Chris Murphy wrote:
>>>
>>> On Apr 25, 2014, at 8:57 AM, Steve Leung <sjleung@shaw.ca> wrote:
>>>
>>>> I've got a 3-device RAID1 btrfs filesystem that started out life as
>>>> single-device.
>>>>
>>>> btrfs fi df:
>>>>
>>>> Data, RAID1: total=1.31TiB, used=1.07TiB
>>>> System, RAID1: total=32.00MiB, used=224.00KiB
>>>> System, DUP: total=32.00MiB, used=32.00KiB
>>>> System, single: total=4.00MiB, used=0.00
>>>> Metadata, RAID1: total=66.00GiB, used=2.97GiB
>>>>
>>>> This still lists some system chunks as DUP, and not as RAID1.  Does
>>>> this mean that if one device were to fail, some system chunks would
>>>> be unrecoverable?  How bad would that be?
>>>>
>>>> Assuming this is something that needs to be fixed, would I be able
>>>> to fix this by balancing the system chunks?  Since the "force" flag
>>>> is required, does that mean that balancing system chunks is
>>>> inherently risky or unpleasant?
>>>
>>> I don't think force is needed. You'd use btrfs balance start
>>> -sconvert=raid1 <mountpoint>; or with -sconvert=raid1,soft although
>>> it's probably a minor distinction for such a small amount of data.
>> The kernel won't allow a balance involving system chunks unless you
>> specify force, as it considers any kind of balance using them to be
>> dangerous.  Given your circumstances, I'd personally say that the safety
>> provided by RAID1 outweighs the risk of making the FS un-mountable.
> 
> Agreed, I'll attempt the system balance shortly.
> 
>> Personally, I would recommend making a full backup of all the data (tar
>> works wonderfully for this), and recreate the entire filesystem from
>> scratch, but passing all three devices to mkfs.btrfs.  This should
>> result in all the chunks being RAID1, and will also allow you to benefit
>> from newer features.
> 
> I do have backups of the really important stuff from this filesystem,
> but they're offsite.  As this is just for a home system, I don't have
> enough temporary space for a full backup handy (which is related to how
> I ended up in this situation in the first place).
> 
> Once everything gets rebalanced though, I don't think I'd be missing out
> on any features, would I?
> 
> Steve
In general, it shouldn't be an issue, but it might get you slightly
better performance to recreate it.  I actually have a similar situation
 with how I have my desktop system set up, when I go about recreating
the filesystem (which I do every time I upgrade either the tools or the
kernel), I use the following approach:

1. Delete one of the devices from the filesystem
2. Create a new btrfs file system on the device just removed from the
filesystem
3. Copy the data from the old filesystem to the new one
4. one at a time, delete the remaining devices from the old filesystem
and add them to the new one, re-balancing the new filesystem after
adding each device.

This seems to work relatively well for me, and prevents the possibility
that there is ever just one copy of the data.  It does, however, require
that the amount of data that you are storing on the filesystem is less
than the size of one of the devices (although you can kind of work
around this limitation by setting compress-force=zlib on the new file
system when you mount it, then using defrag to decompress everything
after the conversion is done), and that you have to drop to single user
mode for the conversion (unless it's something that isn't needed all the
time, like the home directories or /usr/src, in which case you just log
everyone out and log in as root on the console to do it).
