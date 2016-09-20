Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34980 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbcITTzC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 15:55:02 -0400
Received: by mail-wm0-f52.google.com with SMTP id l132so228846020wmf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 12:55:01 -0700 (PDT)
Subject: Re: multi-device btrfs with single data mode and disk failure
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
 <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com>
 <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com>
 <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
 <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
 <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com>
 <CAJCQCtQT=j+P=Dy=VtNOBGkpwenK0AngB2k5xk40BE=hZnEfjA@mail.gmail.com>
 <df35fe50-8195-b2b9-e6d9-687b0c883a28@gmail.com>
 <689d4d03-a122-502d-fda0-8b055ee4a182@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Alexandre Poux <pums974@gmail.com>
Message-ID: <8b497ae5-7ed4-e22a-3f8c-fc3cb2d705df@gmail.com>
Date: Tue, 20 Sep 2016 21:54:59 +0200
MIME-Version: 1.0
In-Reply-To: <689d4d03-a122-502d-fda0-8b055ee4a182@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Le 20/09/2016 à 21:43, Austin S. Hemmelgarn a écrit :
> On 2016-09-20 14:53, Alexandre Poux wrote:
>>
>>
>> Le 20/09/2016 à 20:38, Chris Murphy a écrit :
>>> On Tue, Sep 20, 2016 at 12:19 PM, Alexandre Poux <pums974@gmail.com>
>>> wrote:
>>>>
>>>> Le 20/09/2016 à 19:54, Chris Murphy a écrit :
>>>>> On Tue, Sep 20, 2016 at 11:03 AM, Alexandre Poux
>>>>> <pums974@gmail.com> wrote:
>>>>>
>>>>>> If I wanted to try to edit my partitions with an hex editor,
>>>>>> where would
>>>>>> I find infos on how to do that ?
>>>>>> I really don't want to go this way, but if this is relatively
>>>>>> simple, it
>>>>>> may be worth to try.
>>>>> Simple is relative. First you'd need
>>>>> https://btrfs.wiki.kernel.org/index.php/On-disk_Format to get some
>>>>> understanding of where things are to edit, and then btrfs-map-logical
>>>>> to convert btrfs logical addresses to physical device and sector to
>>>>> know what to edit.
>>>>>
>>>>> I'd call it distinctly non-trivial and very tedious.
>>>>>
>>>> OK, another idea:
>>>> would it be possible to trick btrfs with a manufactured file that the
>>>> disk is present while it isn't ?
>>>>
>>>> I mean, looking for a few minutes on the hexdump of my trivial test
>>>> partition, header of members of btrfs array seems very alike.
>>>> So maybe, I can make a file wich would have enough header to make
>>>> btrfs
>>>> believe that this is my device, and then remove it as usual....
>>>> looks like a long shot, but it doesn't hurt to ask....
>>> There may be another test that applies to single profiles, that
>>> disallows dropping a device. I think that's the place to look next.
>>> The superblock is easy to copy, but you'll need the device specific
>>> UUID which should be locatable with btrfs-show-super -f for each
>>> devid. The bigger problem is that Btrfs at mount time doesn't just
>>> look at the superblock and then mount. It actually reads parts of each
>>> tree, the extent of which I don't know. And it's doing a bunch of
>>> sanity tests as it reads those things, including transid (generation).
>>> So I'm not sure how easily spoofable a fake device is going to be.
>>> As a practical matter, migrate it to a new volume is faster and more
>>> reliable. Unfortunately, the inability to mount it read write is going
>>> to prevent you from making read only snapshots to use with btrfs
>>> send/receive. What might work, is find out what on-disk modification
>>> btrfs-tune does to make a device a read-only seed. Again your volume
>>> is missing a device so btrfs-tune won't let you modify it. But if you
>>> could force that to happen, it's probably a very minor change to
>>> metadata on each device, maybe it'll act like a seed device when you
>>> next mount it, in which case you'll be able to add a device and
>>> remount it read write and then delete the seed causing migration of
>>> everything that does remain on the volume over to the new device. I've
>>> never tried anything like this so I have no idea if it'll work. And
>>> even in the best case I haven't tried a multiple device seed going to
>>> a single device sprout (is it even allowed when removing the seed?).
>>> So...more questions than answers.
>>>
>> Sorry if I wasn't clear, but with the patch mentionned earlyer, I can
>> get a read write mount.
>> What I can't do is remove the device.
>> As for moving data to an another volume, since it's only data and
>> nothing fancy (no subvolume or anything), a simple rsync would do the
>> trick.
>> My problem in this case is that I don't have enough available space
>> elsewhere to move my data.
>> That's why I'm trying this hard to recover the partition...
> First off, as Chris said, if you can read the data and don't already
> have a backup, that should be your first priority.  This really is an
> edge case that's not well tested, and the kernel technically doesn't
> officially support it.
>
> Now, beyond that and his suggestions, there's another option, but it's
> risky, so I wouldn't even think about trying it without a backup
> (unless of course you can trivially regenerate the data).  Multiple
> devices support and online resizing allows for a rather neat trick to
> regenerate a filesystem in place.  The process is pretty simple:
> 1. Shrink the existing filesystem down to the minimum size possible.
> 2. Create a new partition in the free space, and format it as a
> temporary BTRFS filesystem.  Ideally, this FS should be mixed mode,
> and ideally single profile.  If you don't have much free space, you
> can use a flash drive to start this temporary filesystem instead.
> 3. Start copying files from the old filesystem to the temporary one.
> 4. Once the new filesystem is about 95% full, stop copying, shrink the
> old filesystem again, create a new partition, and add that partition
> to the temporary filesystem.
> 5. Repeat steps 3-4 until you have everything off of the old filesystem.
> 6. Re-format the remaining portion of the old filesystem using the
> parameters you want for the replacement filesystem.
> 7. Start copying files from the temporary filesystem to the new
> filesystem.
> 8. As you empty out each temporary partition, remove it from the
> temporary filesystem, delete the partition, and expand the new
> filesystem.
>
> This takes a while, and is only safe if you have reliable hardware,
> but I've done it before and it works reliably as long as you don't
> have many big files on the old filesystem (things can get complicated
> if you do). The other negative aspect is that if you aren't careful,
> it's possible to get stuck half-way, but in such a case, adding a
> flash drive to the temporary filesystem can usually give you enough
> extra space to get things unstuck.
>
OK, good idea, but to be able to do that, I have to use the patch that
allow me to mount the partition in rw, otherwise I won't be able to
shrink it I suppose..
And even with the patch I'm not sure that I won't get an IO error the
same way I get it when I try to remove the device.
I will try it on my virtual machine.

