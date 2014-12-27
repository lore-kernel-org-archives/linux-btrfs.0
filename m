Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:43072 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaL0Ntv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 08:49:51 -0500
Message-ID: <549EB8FC.9040101@pobox.com>
Date: Sat, 27 Dec 2014 05:49:48 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <3538352.CI4nobbHtu@merkaba> <549E9D98.7010102@pobox.com> <9534911.qSQhRgc3Jg@merkaba>
In-Reply-To: <9534911.qSQhRgc3Jg@merkaba>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2014 05:16 AM, Martin Steigerwald wrote:
> Am Samstag, 27. Dezember 2014, 03:52:56 schrieb Robert White:
>>> My theory from watching the Windows XP defragmentation case is this:
>>>
>>> - For writing into the file BTRFS needs to actually allocate and use free
>>> space in the current tree allocation, or, as we seem to misunderstood
>>> from the words we use, it needs to fit data in
>>>
>>> Data, RAID1: total=144.98GiB, used=140.94GiB
>>>
>>> between 144,98 GiB and 140,94 GiB given that total space of this tree, or
>>> if its not a tree, but the chunks in that the tree manages, in these
>>> chunks can *not* be extended anymore.
>>
>> If your file was actually COW (and you have _not_ been taking snapshots)
>> then there is no extenting to be had. But if you are using snapper
>> (which I believe you mentioned previously) then the snapshots cause a
>> write boundary and a layer of copying. Frequently taking snapshots of a
>> COW file is self defeating. If you are going to take snapshots then you
>> might as well turn copy on write back on and, for the love of pete, stop
>> defragging things.
>
> I don´t use any snapshots on the filesystems. None, zero, zilch, nada.
>
> And as I understand it copy on write means: It has to write the new write
> requests to somewhere else. For this it needs to allocate space. Either
> withing existing chunks or in a newly allocated one.
>
> So for COW when writing to a file it will always need to allocate new space
> (although it can forget about the old space afterwards unless there isn´t a
> snapshot holding it)

It can _only_ forget about the space if absolutely _all_ of the old 
extent is overwritten. So if you write 1MiB, then you go back and 
overwrite 1MiB-4Kib, then you go back and write 1MiB-8KiB, you've now 
got 3MiB-12KiB to represent 1MiB of data. No snapshots involved. The 
worst case is quite well understood.

[...--------------] 1MiB
[...-------------]  1MiB-4KiB
[...------------]   1MiB-8KiB


BTRFS will _NOT_ reclaim the "part" of any extent. So if this kept going 
it would take 250 diminishing overwrites, each 4k less than the prior:

1MiB == 250 4k blocks.
(250*(250+1))/2 = 31375 4K blocks or 125.5MiB of storage allocated and 
dedicated to representing 1MiB of accessible data.

This is a worst case, of course, but it exists and it's _horrible_.

And such a file can be "burped" by doing a copy-and-rename, resulting in 
returning it to a single 1MiB extent. (I don't know if a "btrfs defrag" 
would have identical results, but I think it would.)

The problem is that there isn't (yet) a COW safe way to discard partial 
extents. That is, there is no universally safe way (yet implemented) to 
turn that first 1MiB into two extents of 1MiB-4K and one 4K extent "in 
place" so there is no way (yet) to prevent this worst case.

Doing things like excessive defragging at the BTRFS level, and 
defragging inside of a VM, and using certain file types can lead to 
pretty awful data wastage. YMMV.

e.g. "too much tidying up and you make a mess".

I offered a pseudocode example a few days back on how this problem might 
be dealt with in future, but I've not seen any feedback on it.

>
> Anyway, I got it reproduced. And am about to write a lengthy mail about.

Have fun with that lengthy email, but the devs already know about the 
data waste profile of the system. They just don't have a good solution yet.

Practical use cases involving _not_ defragging and _not_ packing files, 
or disabling COW and using raw image formats for VM disk storage are, 
meanwhile, also well understood.

>
> It can easily be reproduced without even using Virtualbox, just by a nice
> simple fio job.
>

Yep. As I've explained twice now.
