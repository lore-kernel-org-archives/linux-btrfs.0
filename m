Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35312 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbcBHMZK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Feb 2016 07:25:10 -0500
Received: by mail-io0-f175.google.com with SMTP id d63so192683280ioj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Feb 2016 04:25:10 -0800 (PST)
Subject: Re: Use fast device only for metadata?
To: Martin Steigerwald <martin@lichtvoll.de>,
        Kai Krakow <hurikhan77@gmail.com>
References: <874mdktk4t.fsf@vostro.rath.org>
 <20160207210713.7e4661a8@jupiter.sol.kaishome.de>
 <1507413.RERLDqpHyU@merkaba>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56B888FF.5080605@gmail.com>
Date: Mon, 8 Feb 2016 07:24:31 -0500
MIME-Version: 1.0
In-Reply-To: <1507413.RERLDqpHyU@merkaba>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-07 15:59, Martin Steigerwald wrote:
> Am Sonntag, 7. Februar 2016, 21:07:13 CET schrieb Kai Krakow:
>> Am Sun, 07 Feb 2016 11:06:58 -0800
>>
>> schrieb Nikolaus Rath <Nikolaus@rath.org>:
>>> Hello,
>>>
>>> I have a large home directory on a spinning disk that I regularly
>>> synchronize between different computers using unison. That takes ages,
>>> even though the amount of changed files is typically small. I suspect
>>> most if the time is spend walking through the file system and checking
>>> mtimes.
>>>
>>> So I was wondering if I could possibly speed-up this operation by
>>> storing all btrfs metadata on a fast, SSD drive. It seems that
>>> mkfs.btrfs allows me to put the metadata in raid1 or dup mode, and the
>>> file contents in single mode. However, I could not find a way to tell
>>> btrfs to use a device *only* for metadata. Is there a way to do that?
>>>
>>> Also, what is the difference between using "dup" and "raid1" for the
>>> metadata?
>>
>> You may want to try bcache. It will speedup random access which is
>> probably the main cause for your slow sync. Unfortunately it requires
>> you to reformat your btrfs partitions to add a bcache superblock. But
>> it's worth the efforts.
>>
>> I use a nightly rsync to USB3 disk, and bcache reduced it from 5+ hours
>> to typically 1.5-3 depending on how much data changed.
>
> An alternative is using dm-cache, I think it doesn´t need to recreate the
> filesystem.
That's correct, dm-cache can use a regular underlying storage device. 
This of course has potential implications for a multi-device filesystem 
(it can seriously confuse BTRFS and cause data corruption), but it works 
just fine for a single device filesystem.  This makes it a bit easier to 
test run, but also means you need more devices (internally, it uses 3, 
one backing device, one cache device, and a metadata device for 
persistently mapping between the two).  It's really easy to set up 
though if you have a recent version of LVM built with dm-cache support.

In general, bcache takes a bit more setup, but avoids the multi-device 
issues, and importantly, doesn't require LVM or dmsetup (which are 
usually pretty big packages on many distros).  The caveat with bcache 
though is that there have been issues in the past with data integrity 
when used with BTRFS, but if you're on a recent kernel (at least 4.0 if 
you're using BTRFS for actual data storage), you should have no issues.

