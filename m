Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:48154 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933770AbaLKLBq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 06:01:46 -0500
Message-ID: <54897995.5010206@pobox.com>
Date: Thu, 11 Dec 2014 03:01:41 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>	<20141122222606.GO8916@merlins.org>	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>	<20141123000503.GQ32735@carfax.org.uk>	<20141123010742.GA16599@merlins.org>	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>	<54878210.8030807@pobox.com>	<CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>	<548839EE.6080404@pobox.com>	<CAA7pwKMsHdbKLz77kFKYD7cymOwpWL42kqzOU8cb3LEyJ0PDSg@mail.gmail.com>	<548958FE.7090607@pobox.com> <CAA7pwKOMqTmSDDB_whOzKK3d092sumB_FN_LcRAVuc=wfKR9Cw@mail.gmail.com>
In-Reply-To: <CAA7pwKOMqTmSDDB_whOzKK3d092sumB_FN_LcRAVuc=wfKR9Cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2014 01:55 AM, Patrik Lundquist wrote:
> On 11 December 2014 at 09:42, Robert White <rwhite@pobox.com> wrote:
>> On 12/10/2014 05:36 AM, Patrik Lundquist wrote:
>>>
>>> On 10 December 2014 at 13:17, Robert White <rwhite@pobox.com> wrote:
>>>>
>>>> On 12/09/2014 11:19 PM, Patrik Lundquist wrote:
>>>>>
>>>>>
>>>> BUT FIRST UNDERSTAND: you do _not_ need to balance a newly converted
>>>> filesystem. That is, the recommended balance (and recursive defrag) is
>>>> _not_
>>>> a useability issue, its an efficiency issue.
>>>
>>>
>>> But if I can't start with an efficient filesystem I'd rather start
>>> over now/soon. I intend to add four more old disks for a RAID1 and it
>>> will be problematic to start over later on (I'd have to buy new, large
>>> disks).
>>
>>
>> Nope, not an issue.
>>
>> When you add the space and rebalance with the conversions by adding all
>> those other disks and such it will _completely_ _obliterate_ the current
>> balance.
>
> But if the issue is too large extents, why would they fit on any added
> btrfs space?

Because that added btrfs space will be _empty_. It's not that the extent 
is "too big" by some absolute measure. It's that it's too big to fit in 
the available space at the _extent_ _tree_ level.

You can't put two feet into one shoe.



>> You are cleaning the house before the maid comes.
>
> Indeed, as a health check. And the patient is slightly ill.

Not really...

So lets say I have a bunch of things that are all size 10-inches

And lets say I space them along a rail with 9-inches between each object.

And I glue them down (because Copy On Write only)

And I do that until the rail is "full", say it takes 100 to fill the rail.

So I still have 900 inches of "free space" but I don't have _any_ _more_ 
_room_ available if I need to mount another 10-inch item.

There's plenty of space but there is no room.

This is what youve got going on.

The conversion hoovered up all the block groups from the ext4 donor 
image more-or-less, and then it built the metadata blocks

(see btrfs-convert at about line 1486)
/* for each block group, create device extent and chunk item */
etc...




>> If you are going to add four more volumes, if those volumes are big enough
>> just make a new filesystem on them then copy the files over.
>
> As it looks now, I will, but I also think there's a bug which I'm
> trying to zero in on.

It doesn't exist. There is no bug that I can see from anything you've shown.

You are confusing the word "extent" as used in ext4, which is a per-file 
thing, with the word "extent" as used differently in btrfs which is a 
raw storage region into which other structures or data is placed.

>>> I deleted the subvolume after being satisfied with the conversion,
>>> defragged recursively, and balanced. In that order.
>>
>> Yea, but your file system is full and you are out of space so get on with
>> the adding space.
>
> I don't think it is full. balance -musage=100 -dusage=99 completes
> with ~1.5TB free space. The remaining unbalanced data is using full or
> close to full blocks. Still can't speak for contiguous space though.
>
>
>> (looking back through my mail spool) You haven't sent the output of /bin/df
>> or btrfs fi df yet, I'd like to see what those two commands say.
>
> I have posted these before, but not /bin/df (no access at the moment).

Ah, yes, I remember these, but the /bin/df is what's going to be 
dispositive.


> btrfs fi show
> Label: none  uuid: 770fe01d-6a45-42b9-912e-
> e8f8b413f6a4
>      Total devices 1 FS bytes used 1.35TiB
>      devid    1 size 2.73TiB used 1.36TiB path /dev/sdc1
>
>
> btrfs fi df /mnt
> Data, single: total=1.35TiB, used=1.35TiB
> System, single: total=32.00MiB, used=112.00KiB
> Metadata, single: total=3.00GiB, used=1.55GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> btrfs check /dev/sdc1
> Checking filesystem on /dev/sdc1
> UUID: 770fe01d-6a45-42b9-912e-e8f8b413f6a4
> found 825003219475 bytes used err is 0
> total csum bytes: 1452612464
> total tree bytes: 1669943296
> total fs tree bytes: 39600128
> total extent tree bytes: 52903936
> btree space waste bytes: 79921034
> file data blocks allocated: 1487627730944
>   referenced 1487627730944




>>>> This would
>>>> be quadruply true if you'd tweaked the block group ratios when you made
>>>> the original file system.
>>>
>>> Ext4 created with defaults, but I think it has been completely full at one
>>> time.
>>
>> Did you use e4defrag before you did the conversion or is this the result of
>> converting chaos most profound?
>
> Didn't use e4defrag.

Probably doesn't matter. Now that I've read more of btrfs-convert.c I 
think I can see how this is shaking out. e4defrag might have packed the 
block groups tighter but it doesn't really try to maximize free space 
within the extent.

>>>> Think of the time and worry you'd have saved if you'd copied the thing in
>>>> the first place. 8-)
>>>
>>> But then I wouldn't learn as much. :-)
>>
>> Learning not to cut corners is a lesson... 8-)
>
> This is more of an experiment than cutting corners, but yeah.
>
>
>> TRUTH BE TOLD :: After two very "eventful" conversions not too long ago I
>> just don't do those any more. The total amount of time I "saved" by not
>> copying the files was in the negative numbers before I just copied the files
>> onto an external media and reformatted and restored.
>
> Conversion probably should be discouraged on the wiki then.

I didn't pursue the wiki on the matter, but conversion of anything to 
anything always requires living with the limits of both, at least to 
start. In this case you are suffering under the burden of the block 
group alignment and layout that was selected by mkfs.ext4, which is 
based on assumptions optimal to ext4.

Systems are _rarely_ replaced by other systems based on the same 
assumptions.

As a terrible aside example, EXT4 says it can support file extent sizes 
up to two gig. But that assumes your CPU memory page size is 64k. On a 
typical Intel PC the page size is 4k, so your maximum extent size is 
1/8th that size. I filed a bug on that some time ago because e4defrag 
output didn't take that into account.

e.g. http://sourceforge.net/p/e2fsprogs/bugs/314/

The mythology of that two-gig file extent has people allocating VM drive 
stripes and rdbms files (etc) in two-gig chunks thinking they are 
optimally alinging things with their drive allocations. But when they do 
it on an intel box they are wrong. Those extents should have been 128Meg 
if they wanted one file equals one extent layouts.

So assumptions in systems can become pernicious, and when you try to do 
any sort of in-place conversion you are likely to end up with the least 
of all worlds.

The devils are always in the details.

Heck, we are still dragging around head/track/sector disk geometry 
nonsense despite variable pitch recording performed on modern drives. 
Thats because we just keep converting old ideas to new.

My "eventful" conversions of those two disks may well have (and probably 
were) completely my own doing. It's a poor craftsman that blames his tools.

My house is a mess. My computers tend to be scrupulously organized. And 
the result from btrfs-convert just doesn't seem optimal for all future 
geometries. After all if default extent size of 0x1000 and 0x8000 were 
chosen for optimal cause (instead of beauty) ending up with a buch of 
two-gig-ish extents would oppose that cause.

It just feels ookie to use btrfs-convert in _my_ _humble_ _opinion_.


>> It's like a choose-your-own-adventure book! 8-)
>
> I like that! :-)

