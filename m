Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:50317 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932241AbaLKIml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 03:42:41 -0500
Message-ID: <548958FE.7090607@pobox.com>
Date: Thu, 11 Dec 2014 00:42:38 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>	<20141122222606.GO8916@merlins.org>	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>	<20141123000503.GQ32735@carfax.org.uk>	<20141123010742.GA16599@merlins.org>	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>	<54878210.8030807@pobox.com>	<CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>	<548839EE.6080404@pobox.com> <CAA7pwKMsHdbKLz77kFKYD7cymOwpWL42kqzOU8cb3LEyJ0PDSg@mail.gmail.com>
In-Reply-To: <CAA7pwKMsHdbKLz77kFKYD7cymOwpWL42kqzOU8cb3LEyJ0PDSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 05:36 AM, Patrik Lundquist wrote:
> On 10 December 2014 at 13:17, Robert White <rwhite@pobox.com> wrote:
>> On 12/09/2014 11:19 PM, Patrik Lundquist wrote:
>>>
>> BUT FIRST UNDERSTAND: you do _not_ need to balance a newly converted
>> filesystem. That is, the recommended balance (and recursive defrag) is _not_
>> a useability issue, its an efficiency issue.
>
> But if I can't start with an efficient filesystem I'd rather start
> over now/soon. I intend to add four more old disks for a RAID1 and it
> will be problematic to start over later on (I'd have to buy new, large
> disks).

Nope, not an issue.

When you add the space and rebalance with the conversions by adding all 
those other disks and such it will _completely_ _obliterate_ the current 
balance.

You are cleaning the house before the maid comes.

PLUS:::

If you are going to add four more volumes, if those volumes are big 
enough just make a new filesystem on them then copy the files over. You 
wont have any freakish nonsense left over from the old drive and its 
foibles. Then just add the existing drive to the "new" filesystem and 
_then_ do the balance.

Right now you are at best trying to iron over cruft from the conversion 
with the larger-than-1G extents and stuff that would never happen on a 
fresh system.

PLUS:::

The whole "time saving" chance of doing a conversion? Well that window 
closed last freaking month... 8-)


> I deleted the subvolume after being satisfied with the conversion,
> defragged recursively, and balanced. In that order.

Yea, but your file system is full and you are out of space so get on 
with the adding space.

>> Because you made a backup and everything yes?
>
> Shh!


>> So anyway. Your system isn't "bugged" or "broken" it's "full" but its a
>> fragmented fullness that has lots of free sectors but insufficient contiguous
>> free sectors, so it cannot satisfy the request.
>
> It's a half full 3TB disk. There _is_ space, somewhere. I can't speak
> for contiguous space though.

Contiguous space is all that matters here. It's trying to swallow a 
brick that is _slightly_ larger than any extent ext4 would have likely 
left hanging about.

(looking back through my mail spool) You haven't sent the output of 
/bin/df or btrfs fi df yet, I'd like to see what those two commands say.

No Space (to allocate a storage extent)

is different than

No Space (to allocate file contents).

So the space may just be sitting there in the difference between your 
data total= and your data used=

I mean this could easily be "situation normal" if your output looks like 
"Data, single: total=3TiB, used=1.5TiB" or something.


>>> I don't know how to interpret the space_info error. Why is only
>>> 4773171200 (4,4GiB) free?
>>> Can I inspect block group 1821099687936 to try to find out what makes
>>> it problematic?
>>>
>>> BTRFS info (device sdc1): relocating block group 1821099687936 flags 1
>>> BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
>>> BTRFS: space_info 1 has 4773171200 free, is not full
>>> BTRFS: space_info total=1494648619008, used=1489775505408, pinned=0,
>>> reserved=99700736, may_use=2102390784, readonly=241664
>>
>>
>> So it was looking for a single chunk 2013265920 bytes long and it couldn't
>> find one because all the spaces were smaller and there was no room to make a
>> new suitable space.
>>
>> The problem is that it wanted 2013265920 bytes and while the system as a
>> whole had no way to satisfy that desire. It asked for something just shy of
>> two gigs as a single extent. That's a tough order on a full platter.
>>
>> Since your entire free size is 2102390784 that is an attempt to allocate
>> about 80% of your free space as one contiguous block. That's never going to
>> happen. 8-)
>
> What about "space_info 1 has 4773171200 free"? Besides the other 1,5TB
> free space.

The "1" is the drive. That 4773171200 is not contiguous. I didn't look 
much further in the code because it's a new code base to me. But its 
asking for one contiguous extent of size 2013265920 and that's a 
non-starter for me. With the odd sized chunks possible after a 
conversion ... well pshaw...


>> I don't even know if 2GiB is normally a legal size for an extent. My
>> understanding is that data is allocated in 1G chunks, so I'd expect all
>> extents to be smaller than 1G.
>
> The 'summary' after the failed balances is always something like "98
> enospc errors" which now makes me suspect that I have 98 files with
> extents larger than 1GiB that the defrag didn't take care of.

Files? No extents. a.k.a. "chunks" whatever those are after a 
conversion. Room for extents is different than room for files.


> So if I can find out which files have >1GiB extents I can then copy
> them back and forth to solve the problem.

Deck Chairs. You are playing a game of musical deck chairs. Don't 
obsess. 8-)

> Maybe running defrag more times can also solve it? Can I get a list of
> fragmented files?

I wouldn't expect defrag to do a thing about this. The extents in the 
extent tree are not necessarily for single files. (they might _never_ be 
for single files.)


> Suppose an old file with 2GiB extent isn't fragmented, will btrfs
> defrag still try to defrag it?

No idea. I'd think it would not move something that is already 
contiguous. This isn't windows where the defrager itself leaves 
micro-fragments after each file. (Don't get me started on that nonsense. 8-)

>> After a quick glance at the btrfs-convert, it looks like it might make some
>> pretty atypical extents if the underlying donor filesystem needed needed
>> them. It wouldn't have had a choice. So it's easily within the realm of
>> reason that you'd have some really fascinating data as a result of
>> converting a nearly full EXT4 file system of the Terabyte+ size.
>
> It was about half full at conversion.

Being the opposite of an expert on btrfs-convert I cant help wonder 
where the threshold of discrimination is. I mean did it just take every 
single block group and toss it into a separate extent with no eye to the 
actual contents? That would be valid and fast. Then the allocation maps 
per-file would handle you re-using the referenced space etc.


>> This would
>> be quadruply true if you'd tweaked the block group ratios when you made the
>> original file system.
>
> Ext4 created with defaults, but I think it has been completely full at one time.

Did you use e4defrag before you did the conversion or is this the result 
of converting chaos most profound?

>> So since you have nice backups... you should probably drop the ext2_saved
>> subvolume and then get on with your life for good or ill.
>
> Done before defrag and balance attempts.

Good job.


>> Think of the time and worry you'd have saved if you'd copied the thing in
>> the first place. 8-)
>
> But then I wouldn't learn as much. :-)

Learning not to cut corners is a lesson... 8-)

>>>> P.S. you should re-balance your System and Metadata as "DUP" for now. Two
>>>> copies of that stuff is better than one as right now you have no real
>>>> recovery path for that stuff. If you didn't make that change on purpose
>>>> it
>>>> probably got down-revved from DUP automagically when you tired to RAID
>>>> it.
>>>
>>>
>>> Good point. Maybe btrfs-convert should do that by default? I don't
>>> think it has ever been DUP.
>>
>> Eyup.
>
> And the metadata is now DUP. That's ~1.5GB extra metadata that was
> allocated just fine after the failed balance.

More evidence that you are just trying to swallow a brick. Metadata is 
done in like 256Mb chunks I think, so yea, lots of room for that left 
sitting around on a typical EXT4 etc.


TRUTH BE TOLD :: After two very "eventful" conversions not too long ago 
I just don't do those any more. The total amount of time I "saved" by 
not copying the files was in the negative numbers before I just copied 
the files onto an external media and reformatted and restored.

Additionally I got the chance to lay out my subvolumes and decide about 
compression and such before doing the restore.

With a new filesystem I knew exactly what I was getting for a layout and 
I've had no mysteries since.

I don't know if thats politic to say in this list but really, most 
format conversions I've ever done (hearkening all the way back to some 
9-track tape excitement in the eighties) usually leave me feeling like 
maybe I hacked the corners off a cardboard box with a machete to make it 
fit in under a sofa.

Then again I am getting old and sometimes its easier to just chase kids 
off your lawn. 8-)


SO .....

What I'd do, most to least likely.

(0) look at df and btrfs fi df output and see if I could account for the 
free space I expected. If it's there I'd post a "oh hey, look at that" 
message on the list and then move on to one of the latter options.

then

(1) Make an New FS on those other drives and copy my working set onto 
it, that way I got all the defaults in sizes and extents and it will all 
be nice round numbers like 1G and 256Mb, cause some day I might be 
adding in SSDs or something. I like a nice orderly system.

(1a) Then I could maybe keep the old drive and dissect it's contents for 
fun and knowledge.

(1b) Then I could just add the old drive into the new array once I 
needed the storage.

or else

(2) Hook up the new drives and add them into the existing filesystem. 
Then balance the everything.

(2a) Look at the extent maps after that and discover that I still had 
odd 2-ish gig extents and silently fume at the assemetry.

or else

(3) Keep fiddling with it till I got frustrated then go back to one of 
the prior options. 8-)


It's like a choose-your-own-adventure book! 8-)


