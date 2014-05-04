Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-lesia.wadns.net ([196.220.39.109]:3519 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbaEDHov (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 03:44:51 -0400
Message-ID: <5365EFE9.8000300@swiftspirit.co.za>
Date: Sun, 04 May 2014 09:44:41 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
References: <20140503232702.GC9061@merlins.org> <5365E4CF.3050405@swiftspirit.co.za> <20140504072420.GJ9061@merlins.org>
In-Reply-To: <20140504072420.GJ9061@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/04 09:24 AM, Marc MERLIN wrote:
> On Sun, May 04, 2014 at 08:57:19AM +0200, Brendan Hide wrote:
>> Hi, Marc
>>
>> Raid0 is not redundant in any way. See inline below.
>   
> Thanks for clearing things up.
>
>>> But now I have 2 questions
>>> 1) btrfs has two copies of all metadata on even a single drive, correct?
>> Only when *specifically* using -m dup (which is the default on a
>> single non-SSD device), will there be two copies of the metadata
>> stored on a single device. This is not recommended when using
> Ah, so -m dup is default like I thought, but not on SSD?
> Ooops, that means that my laptop does not have redundant metadata on its
> SSD like I thought. Thanks for the heads up.
> Ah, I see the man page now "This is because SSDs can remap blocks
> internally so duplicate blocks could end up in the same erase block
> which negates the benefits of doing metadata duplication."

You can force dup but, per the man page, whether or not that is 
beneficial is questionable.
>
>> multiple devices as it means one device failure will likely cause
>> critical loss of metadata.
> That's the part where I'm not clear:
>
> What's the difference between -m dup and -m raid1
> Don't they both say 2 copies of the metadata?
> Is -m dup only valid for a single drive, while -m raid1 for 2+ drives?

The issue is that -m dup will always put both copies on a single device. 
If you lose that device, you've lost both (all) copies of that metadata. 
With -m raid1 the second copy is on a *different* device.

I believe dup *can* be used with multiple devices but mkfs.btrfs might 
not let you do it from the get-go. The way most have gotten there is by 
having dup on a single device and then, after adding another device, 
they didn't convert the metadata to raid1.
>
>>> If so, and I have a -d raid0 -m raid0 filesystem, are both copies of the
>>> metadata on the same drive or is btrfs smart enough to spread out
>>> metadata copies so that they're not on the same drive?
>> This will mean there is only a single copy, albeit striped across
>> the drives.
> Ok, so -m raid0 only means a single copy of metadata, thanks for
> explaining.
>
>> good for redundancy. A total failure of a single device will mean
>> any large files will be lost and only files smaller than the default
>> per-disk stripe width (I believe this used to be 4K and is now 16K -
>> I could be wrong) stored only on the remaining disk will be
>> available.
>   
> Gotcha, thanks for confirming, so -m raid1 -d raid0 really only protects
> against metadata corruption or a single block loss, but otherwise if you
> lost a drive in a 2 drive raid0, you'll have lost more than just half
> your files.
>
>> The scenario you mentioned at the beginning, "if I lose a drive,
>> I'll still have full metadata for the entire filesystem and only
>> missing files" is more applicable to using "-m raid1 -d single".
>> Single is not geared towards performance and, though it doesn't
>> guarantee a file is only on a single disk, the allocation does mean
>> that the majority of all files smaller than a chunk will be stored
>> on only one disk or the other - not both.
> Ok, so in other words:
> -d raid0: if you one 1 drive out of 2, you may end up with small files
> and the rest will be lost
>
> -d single: you're more likely to have files be on one drive or the
> other, although there is no guarantee there either.
>
> Correct?

Correct
>
> Thanks,
> Marc


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

