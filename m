Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35120 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbcISWF3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 18:05:29 -0400
Received: by mail-wm0-f47.google.com with SMTP id l132so175627128wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 15:05:28 -0700 (PDT)
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Chris Murphy <lists@colorremedies.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
 <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com>
 <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Alexandre Poux <pums974@gmail.com>
Message-ID: <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com>
Date: Tue, 20 Sep 2016 00:05:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Le 15/09/2016 à 23:54, Chris Murphy a écrit :
> On Thu, Sep 15, 2016 at 3:48 PM, Alexandre Poux <pums974@gmail.com> wrote:
>> Le 15/09/2016 à 18:54, Chris Murphy a écrit :
>>> On Thu, Sep 15, 2016 at 10:30 AM, Alexandre Poux <pums974@gmail.com> wrote:
>>>> Thank you very much for your answers
>>>>
>>>> Le 15/09/2016 à 17:38, Chris Murphy a écrit :
>>>>> On Thu, Sep 15, 2016 at 1:44 AM, Alexandre Poux <pums974@gmail.com> wrote:
>>>>>>     Is it possible to do some king of a "btrfs delete missing" on this
>>>>>>     kind of setup, in order to recover access in rw to my other data, or
>>>>>>     I must copy all my data on a new partition
>>>>> That *should* work :) Except that your file system with 6 drives is
>>>>> too full to be shrunk to 5 drives. Btrfs will either refuse, or get
>>>>> confused, about how to shrink a nearly full 6 drive volume into 5.
>>>>>
>>>>> So you'll have to do one of three things:
>>>>>
>>>>> 1. Add a 2+TB drive, then remove the missing one; OR
>>>>> 2. btrfs replace is faster and is raid10 reliable; OR
>>>>> 3. Read only scrub to get a file listing of bad files, then remount
>>>>> read-write degraded and delete them all. Now you maybe can do a device
>>>>> delete missing. But it's still a tight fit, it basically has to
>>>>> balance things out to get it to fit on an odd number of drives, it may
>>>>> actually not work even though there seems to be enough total space,
>>>>> there has to be enough space on FOUR drives.
>>>>>
>>>> Are you sure you are talking about data in single mode ?
>>>> I don't understand why you are talking about raid10,
>>>> or the fact that it will have to rebalance everything.
>>> Yeah sorry I got confused in that very last sentence. Single, it will
>>> find space in 1GiB increments. Of course this fails because that data
>>> doesn't exist anymore, but to start the operation it needs to be
>>> possible.
>> No problem
>>>> Moreover, even in degraded mode I cannot mount it in rw
>>>> It tells me
>>>> "too many missing devices, writeable remount is not allowed"
>>>> due to the fact I'm in single mode.
>>> Oh you're in that trap. Well now you're stuck. I've had the case where
>>> I could mount read write degraded with metadata raid1 and data single,
>>> but it was good for only one mount and then I get the same message you
>>> get and it was only possible to mount read only. At that point it's
>>> totally suck unless you're adept at manipulating the file system with
>>> a hex editor...
>>>
>>> Someone might have a patch somewhere that drops this check and lets
>>> too many missing devices to mount anyway... I seem to recall this.
>>> It'd be in the archives if it exists.
>>>
>>>
>>>
>>>> And as far as as know, btrfs replace and btrfs delete, are not supposed
>>>> to work in read only...
>>> It doesn't. Must be read write mounted.
>>>
>>>
>>>> I would like to tell him forgot about the missing data, and give me back
>>>> my partition.
>>> This feature doesn't exist yet. I really want to see this, it'd be
>>> great for ceph and gluster if the volume could lose a drive, report
>>> all the missing files to the cluster file system, delete the device
>>> and the file references, and then the cluster knows that brick doesn't
>>> have those files and can replicate them somewhere else or even back to
>>> the brick that had them.
>>>
>> So I found this patch : https://patchwork.kernel.org/patch/7014141/
>>
>> Does this seems ok ?
> No idea I haven't tried it.
>
>> So after patching my kernel with it,
>> I should be able to mount in rw my partition, and thus,
>> I will be able to do a btrfs delete missing
>> Which will just forgot about the old disk and everything should be fine
>> afterward ?
> It will forget about the old disk but it will try to migrate all
> metadata and data that was on that disk to the remaining drives; so
> until you delete all files that are corrupt, you'll continue to get
> corruption messages about them.
>
>> Is this risky ? or not so much ?
> Probably. If you care about the data, mount read only, back up what
> you can, then see if you can fix it after that.
>
>> The scrubing is almost finished, and as I was expecting, I lost no data
>> at all.
> Well I'd guess the device delete should work then, but I still have no
> idea if that patch will let you mount it degraded read-write. Worth a
> shot though, it'll save time.
>
OK, so I found some time to work on it.

I decided to do some tests in a vm (virtualbox) with 3 disks
after making an array with 3 disks, metadata in raid1 and data in single,
I remove one disk to reproduce my situation.

I tried the patch, and, after updated it (nothing fancy),
I can indeed mount a degraded partition with data in single.

But I can't remove the device :
#btrfs device remove missing /mnt
ERROR: error removing device 'missing': Input/output error
or
#btrfs device remove 2 /mnt
ERROR: error removing devid 2: Input/output error

replace doesn't work either
btrfs replace start -B 2 /dev/sdb /mnt
BTRFS error (device sda2): btrfs_scrub_dev(<missing disk>, 2, /dev/sdb)
failed -12
ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt": Cannot allocate
memory, <illegal result value>

but scrub works, and I can add and remove an another device if I want.
It's just the missing device that I cant get rid of.

Any other idea ?

