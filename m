Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34288 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032911AbeE0SW3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 14:22:29 -0400
Received: by mail-wm0-f46.google.com with SMTP id q4-v6so20896041wmq.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 11:22:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHz9+EkB64Y-ZT37Y-Bu=HXcw-FELW4GNGf+G-fC9MPXa3WvBg@mail.gmail.com>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
 <56F21FC5.50209@gmail.com> <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
 <56F22F80.501@gmail.com> <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
 <56F2C991.9080500@gmail.com> <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
 <56F2EA25.4070004@gmail.com> <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
 <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
 <CAPmG0jbUWiDNSVjv9hMF3rpe0cm4EZWkuRKEgM_t6EuU3sPYFA@mail.gmail.com>
 <CAHz9+Emc4DsXoMLKYrp1TfN+2r2cXxaJmPyTnpeCZF=h0FhtMg@mail.gmail.com>
 <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>
 <f773a802-67a3-f148-5d36-fa8a9d168e25@gmx.com> <CAHz9+EkeAAOXN7K+C0Wtmu-3RPOpTC4a6pK-y5gDQCtdAc8nUA@mail.gmail.com>
 <6dc280f8-3822-078e-9b69-c3203e75ec1e@gmx.com> <CAHz9+EkzNkAiP4CSZCiAbTrsKik0SGS9OQ=C4TSfwtB8Rb3zvA@mail.gmail.com>
 <c8077032-58ea-da5b-ea62-6007d837e666@gmx.com> <CAHz9+EkB64Y-ZT37Y-Bu=HXcw-FELW4GNGf+G-fC9MPXa3WvBg@mail.gmail.com>
From: Brad Templeton <bradtem@gmail.com>
Date: Sun, 27 May 2018 11:22:07 -0700
Message-ID: <CAHz9+En7ZwTTY5xi_vkNjsbir6NqKt_zN1_6qPud66QRT9e2iA@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTW, I decided to follow the original double replace strategy
suggested -- replace 6TB with 8TB and replace 4TB with 6TB.  That
should be sure to leave the 2 large drives each with 2TB free once
expanded, and thus able to fully use all space.

However, the first one has been going for 9 hours and is "189.7% done"
and still going.   Some sort of bug in calculating the completion
status, obviously.  With luck 200% will be enough?

On Sat, May 26, 2018 at 7:21 PM, Brad Templeton <bradtem@gmail.com> wrote:
> Certainly.  My apologies for not including them before.   As
> described, the disks are reasonably balanced -- not as full as the
> last time.  As such, it might be enough that balance would (slowly)
> free up enough chunks to get things going.  And if I have to, I will
> partially convert to single again.   Certainly btrfs replace seems
> like the most planned and simple path but it will result in a strange
> distribution of the chunks.
>
> Label: 'butter'  uuid: a91755d4-87d8-4acd-ae08-c11e7f1f5438
>        Total devices 3 FS bytes used 6.11TiB
>        devid    1 size 3.62TiB used 3.47TiB path /dev/sdj2Overall:
>    Device size:                  12.70TiB
>    Device allocated:             12.25TiB
>    Device unallocated:          459.95GiB
>    Device missing:                  0.00B
>    Used:                         12.21TiB
>    Free (estimated):            246.35GiB      (min: 246.35GiB)
>    Data ratio:                       2.00
>    Metadata ratio:                   2.00
>    Global reserve:              512.00MiB      (used: 1.32MiB)
>
> Data,RAID1: Size:6.11TiB, Used:6.09TiB
>   /dev/sda        3.48TiB
>   /dev/sdi2       5.28TiB
>   /dev/sdj2       3.46TiB
>
> Metadata,RAID1: Size:14.00GiB, Used:12.38GiB
>   /dev/sda        8.00GiB
>   /dev/sdi2       7.00GiB
>   /dev/sdj2      13.00GiB
>
> System,RAID1: Size:32.00MiB, Used:888.00KiB
>   /dev/sdi2      32.00MiB
>   /dev/sdj2      32.00MiB
>
> Unallocated:
>   /dev/sda      153.02GiB
>   /dev/sdi2     154.56GiB
>   /dev/sdj2     152.36GiB
>
>       devid    2 size 3.64TiB used 3.49TiB path /dev/sda
>        devid    3 size 5.43TiB used 5.28TiB path /dev/sdi2
>
>
> On Sat, May 26, 2018 at 7:16 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2018年05月27日 10:06, Brad Templeton wrote:
>>> Thanks.  These are all things which take substantial fractions of a
>>> day to try, unfortunately.
>>
>> Normally I would suggest just using VM and several small disks (~10G),
>> along with fallocate (the fastest way to use space) to get a basic view
>> of the procedure.
>>
>>> Last time I ended up fixing it in a
>>> fairly kluged way, which was to convert from raid-1 to single long
>>> enough to get enough single blocks that when I converted back to
>>> raid-1 they got distributed to the right drives.
>>
>> Yep, that's the ultimate one-fit-all solution.
>> Also, this reminds me about the fact we could do the
>> RAID1->Single/DUP->Single downgrade in a much much faster way.
>> I think it's worthy considering for later enhancement.
>>
>>>  But this is, aside
>>> from being a kludge, a procedure with some minor risk.  Of course I am
>>> taking a backup first, but still...
>>>
>>> This strikes me as something that should be a fairly common event --
>>> your raid is filling up, and so you expand it by replacing the oldest
>>> and smallest drive with a new much bigger one.   In the old days of
>>> RAID, you could not do that, you had to grow all drives at the same
>>> time, and this is one of the ways that BTRFS is quite superior.
>>> When I had MD raid, I went through a strange process of always having
>>> a raid 5 that consisted of different sized drives.  The raid-5 was
>>> based on the smallest of the 3 drives, and then the larger ones had
>>> extra space which could either be in raid-1, or more imply was in solo
>>> disk mode and used for less critical data (such as backups and old
>>> archives.)   Slowly, and in a messy way, each time I replaced the
>>> smallest drive, I could then grow the raid 5.  Yuck.     BTRFS is so
>>> much better, except for this issue.
>>>
>>> So if somebody has a thought of a procedure that is fairly sure to
>>> work and doesn't involve too many copying passes -- copying 4tb is not
>>> a quick operation -- it is much appreciated and might be a good thing
>>> to add to a wiki page, which I would be happy to do.
>>
>> Anyway, "btrfs fi show" and "btrfs fi usage" would help before any
>> further advice from community.
>>
>> Thanks,
>> Qu
>>
>>>
>>> On Sat, May 26, 2018 at 6:56 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>>
>>>> On 2018年05月27日 09:49, Brad Templeton wrote:
>>>>> That is what did not work last time.
>>>>>
>>>>> I say I think there can be a "fix" because I hope the goal of BTRFS
>>>>> raid is to be superior to traditional RAID.   That if one replaces a
>>>>> drive, and asks to balance, it figures out what needs to be done to
>>>>> make that work.  I understand that the current balance algorithm may
>>>>> have trouble with that.   In this situation, the ideal result would be
>>>>> the system would take the 3 drives (4TB and 6TB full, 8TB with 4TB
>>>>> free) and move extents strictly from the 4TB and 6TB to the 8TB -- ie
>>>>> extents which are currently on both the 4TB and 6TB -- by moving only
>>>>> one copy.
>>>>
>>>> Btrfs can only do balance in a chunk unit.
>>>> Thus btrfs can only do:
>>>> 1) Create new chunk
>>>> 2) Copy data
>>>> 3) Remove old chunk.
>>>>
>>>> So it can't do the way you mentioned.
>>>> But your purpose sounds pretty valid and maybe we could enhanace btrfs
>>>> to do such thing.
>>>> (Currently only replace can behave like that)
>>>>
>>>>> It is not strictly a "bug" in that the code is operating
>>>>> as designed, but it is an undesired function.
>>>>>
>>>>> The problem is the approach you describe did not work in the prior upgrade.
>>>>
>>>> Would you please try 4/4/6 + 4 or 4/4/6 + 2 and then balance?
>>>> And before/after balance, "btrfs fi usage" and "btrfs fi show" output
>>>> could also help.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> On Sat, May 26, 2018 at 6:41 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>
>>>>>>
>>>>>> On 2018年05月27日 09:27, Brad Templeton wrote:
>>>>>>> A few years ago, I encountered an issue (halfway between a bug and a
>>>>>>> problem) with attempting to grow a BTRFS 3 disk Raid 1 which was
>>>>>>> fairly full.   The problem was that after replacing (by add/delete) a
>>>>>>> small drive with a larger one, there were now 2 full drives and one
>>>>>>> new half-full one, and balance was not able to correct this situation
>>>>>>> to produce the desired result, which is 3 drives, each with a roughly
>>>>>>> even amount of free space.  It can't do it because the 2 smaller
>>>>>>> drives are full, and it doesn't realize it could just move one of the
>>>>>>> copies of a block off the smaller drive onto the larger drive to free
>>>>>>> space on the smaller drive, it wants to move them both, and there is
>>>>>>> nowhere to put them both.
>>>>>>
>>>>>> It's not that easy.
>>>>>> For balance, btrfs must first find a large enough space to locate both
>>>>>> copy, then copy data.
>>>>>> Or if powerloss happens, it will cause data corruption.
>>>>>>
>>>>>> So in your case, btrfs can only find enough space for one copy, thus
>>>>>> unable to relocate any chunk.
>>>>>>
>>>>>>>
>>>>>>> I'm about to do it again, taking my nearly full array which is 4TB,
>>>>>>> 4TB, 6TB and replacing one of the 4TB with an 8TB.  I don't want to
>>>>>>> repeat the very time consuming situation, so I wanted to find out if
>>>>>>> things were fixed now.   I am running Xenial (kernel 4.4.0) and could
>>>>>>> consider the upgrade to  bionic (4.15) though that adds a lot more to
>>>>>>> my plate before a long trip and I would prefer to avoid if I can.
>>>>>>
>>>>>> Since there is nothing to fix, the behavior will not change at all.
>>>>>>
>>>>>>>
>>>>>>> So what is the best strategy:
>>>>>>>
>>>>>>> a) Replace 4TB with 8TB, resize up and balance?  (This is the "basic" strategy)
>>>>>>> b) Add 8TB, balance, remove 4TB (automatic distribution of some blocks
>>>>>>> from 4TB but possibly not enough)
>>>>>>> c) Replace 6TB with 8TB, resize/balance, then replace 4TB with
>>>>>>> recently vacated 6TB -- much longer procedure but possibly better
>>>>>>>
>>>>>>> Or has this all been fixed and method A will work fine and get to the
>>>>>>> ideal goal -- 3 drives, with available space suitably distributed to
>>>>>>> allow full utilization over time?
>>>>>>
>>>>>> Btrfs chunk allocator is already trying to utilize all drivers for a
>>>>>> long long time.
>>>>>> When allocate chunks, btrfs will choose the device with the most free
>>>>>> space. However the nature of RAID1 needs btrfs to allocate extents from
>>>>>> 2 different devices, which makes your replaced 4/4/6 a little complex.
>>>>>> (If your 4/4/6 array is set up and then filled to current stage, btrfs
>>>>>> should be able to utilize all the space)
>>>>>>
>>>>>>
>>>>>> Personally speaking, if you're confident enough, just add a new device,
>>>>>> and then do balance.
>>>>>> If enough chunks get balanced, there should be enough space freed on
>>>>>> existing disks.
>>>>>> Then remove the newly added device, then btrfs should handle the
>>>>>> remaining space well.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> On Sat, May 26, 2018 at 6:24 PM, Brad Templeton <bradtem@gmail.com> wrote:
>>>>>>>> A few years ago, I encountered an issue (halfway between a bug and a
>>>>>>>> problem) with attempting to grow a BTRFS 3 disk Raid 1 which was fairly
>>>>>>>> full.   The problem was that after replacing (by add/delete) a small drive
>>>>>>>> with a larger one, there were now 2 full drives and one new half-full one,
>>>>>>>> and balance was not able to correct this situation to produce the desired
>>>>>>>> result, which is 3 drives, each with a roughly even amount of free space.
>>>>>>>> It can't do it because the 2 smaller drives are full, and it doesn't realize
>>>>>>>> it could just move one of the copies of a block off the smaller drive onto
>>>>>>>> the larger drive to free space on the smaller drive, it wants to move them
>>>>>>>> both, and there is nowhere to put them both.
>>>>>>>>
>>>>>>>> I'm about to do it again, taking my nearly full array which is 4TB, 4TB, 6TB
>>>>>>>> and replacing one of the 4TB with an 8TB.  I don't want to repeat the very
>>>>>>>> time consuming situation, so I wanted to find out if things were fixed now.
>>>>>>>> I am running Xenial (kernel 4.4.0) and could consider the upgrade to  bionic
>>>>>>>> (4.15) though that adds a lot more to my plate before a long trip and I
>>>>>>>> would prefer to avoid if I can.
>>>>>>>>
>>>>>>>> So what is the best strategy:
>>>>>>>>
>>>>>>>> a) Replace 4TB with 8TB, resize up and balance?  (This is the "basic"
>>>>>>>> strategy)
>>>>>>>> b) Add 8TB, balance, remove 4TB (automatic distribution of some blocks from
>>>>>>>> 4TB but possibly not enough)
>>>>>>>> c) Replace 6TB with 8TB, resize/balance, then replace 4TB with recently
>>>>>>>> vacated 6TB -- much longer procedure but possibly better
>>>>>>>>
>>>>>>>> Or has this all been fixed and method A will work fine and get to the ideal
>>>>>>>> goal -- 3 drives, with available space suitably distributed to allow full
>>>>>>>> utilization over time?
>>>>>>>>
>>>>>>>> On Fri, Mar 25, 2016 at 7:35 AM, Henk Slager <eye1tm@gmail.com> wrote:
>>>>>>>>>
>>>>>>>>> On Fri, Mar 25, 2016 at 2:16 PM, Patrik Lundquist
>>>>>>>>> <patrik.lundquist@gmail.com> wrote:
>>>>>>>>>> On 23 March 2016 at 20:33, Chris Murphy <lists@colorremedies.com> wrote:
>>>>>>>>>>>
>>>>>>>>>>> On Wed, Mar 23, 2016 at 1:10 PM, Brad Templeton <bradtem@gmail.com>
>>>>>>>>>>> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> I am surprised to hear it said that having the mixed sizes is an odd
>>>>>>>>>>>> case.
>>>>>>>>>>>
>>>>>>>>>>> Not odd as in wrong, just uncommon compared to other arrangements being
>>>>>>>>>>> tested.
>>>>>>>>>>
>>>>>>>>>> I think mixed drive sizes in raid1 is a killer feature for a home NAS,
>>>>>>>>>> where you replace an old smaller drive with the latest and largest
>>>>>>>>>> when you need more storage.
>>>>>>>>>>
>>>>>>>>>> My raid1 currently consists of 6TB+3TB+3*2TB.
>>>>>>>>>
>>>>>>>>> For the original OP situation, with chunks all filled op with extents
>>>>>>>>> and devices all filled up with chunks, 'integrating' a new 6TB drive
>>>>>>>>> in an 4TB+3TG+2TB raid1 array could probably be done in a bit unusual
>>>>>>>>> way in order to avoid immediate balancing needs:
>>>>>>>>> - 'plug-in' the 6TB
>>>>>>>>> - btrfs-replace  4TB by 6TB
>>>>>>>>> - btrfs fi resize max 6TB_devID
>>>>>>>>> - btrfs-replace  2TB by 4TB
>>>>>>>>> - btrfs fi resize max 4TB_devID
>>>>>>>>> - 'unplug' the 2TB
>>>>>>>>>
>>>>>>>>> So then there would be 2 devices with roughly 2TB space available, so
>>>>>>>>> good for continued btrfs raid1 writes.
>>>>>>>>>
>>>>>>>>> An offline variant with dd instead of btrfs-replace could also be done
>>>>>>>>> (I used to do that sometimes when btrfs-replace was not implemented).
>>>>>>>>> My experience is that btrfs-replace speed is roughly at max speed (so
>>>>>>>>> harddisk magnetic media transferspeed) during the whole replace
>>>>>>>>> process and it does in a more direct way what you actually want. So in
>>>>>>>>> total mostly way faster device replace/upgrade than with the
>>>>>>>>> add+delete method. And raid1 redundancy is active all the time. Of
>>>>>>>>> course it means first make sure the system runs up-to-date/latest
>>>>>>>>> kernel+tools.
>>>>>>>>
>>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
