Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34771 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbcIOQyL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 12:54:11 -0400
Received: by mail-oi0-f54.google.com with SMTP id m11so78481861oif.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 09:54:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com> <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Sep 2016 10:54:09 -0600
Message-ID: <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Alexandre Poux <pums974@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 10:30 AM, Alexandre Poux <pums974@gmail.com> wrote:
> Thank you very much for your answers
>
> Le 15/09/2016 à 17:38, Chris Murphy a écrit :
>> On Thu, Sep 15, 2016 at 1:44 AM, Alexandre Poux <pums974@gmail.com> wrote:
>>>     Is it possible to do some king of a "btrfs delete missing" on this
>>>     kind of setup, in order to recover access in rw to my other data, or
>>>     I must copy all my data on a new partition
>> That *should* work :) Except that your file system with 6 drives is
>> too full to be shrunk to 5 drives. Btrfs will either refuse, or get
>> confused, about how to shrink a nearly full 6 drive volume into 5.
>>
>> So you'll have to do one of three things:
>>
>> 1. Add a 2+TB drive, then remove the missing one; OR
>> 2. btrfs replace is faster and is raid10 reliable; OR
>> 3. Read only scrub to get a file listing of bad files, then remount
>> read-write degraded and delete them all. Now you maybe can do a device
>> delete missing. But it's still a tight fit, it basically has to
>> balance things out to get it to fit on an odd number of drives, it may
>> actually not work even though there seems to be enough total space,
>> there has to be enough space on FOUR drives.
>>
> Are you sure you are talking about data in single mode ?
> I don't understand why you are talking about raid10,
> or the fact that it will have to rebalance everything.

Yeah sorry I got confused in that very last sentence. Single, it will
find space in 1GiB increments. Of course this fails because that data
doesn't exist anymore, but to start the operation it needs to be
possible.


>
> Moreover, even in degraded mode I cannot mount it in rw
> It tells me
> "too many missing devices, writeable remount is not allowed"
> due to the fact I'm in single mode.

Oh you're in that trap. Well now you're stuck. I've had the case where
I could mount read write degraded with metadata raid1 and data single,
but it was good for only one mount and then I get the same message you
get and it was only possible to mount read only. At that point it's
totally suck unless you're adept at manipulating the file system with
a hex editor...

Someone might have a patch somewhere that drops this check and lets
too many missing devices to mount anyway... I seem to recall this.
It'd be in the archives if it exists.



> And as far as as know, btrfs replace and btrfs delete, are not supposed
> to work in read only...

It doesn't. Must be read write mounted.


>
> I would like to tell him forgot about the missing data, and give me back
> my partition.

This feature doesn't exist yet. I really want to see this, it'd be
great for ceph and gluster if the volume could lose a drive, report
all the missing files to the cluster file system, delete the device
and the file references, and then the cluster knows that brick doesn't
have those files and can replicate them somewhere else or even back to
the brick that had them.


-- 
Chris Murphy
