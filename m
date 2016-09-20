Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32930 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753386AbcITSiI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 14:38:08 -0400
Received: by mail-oi0-f67.google.com with SMTP id w11so2089651oia.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 11:38:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com> <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com> <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com> <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
 <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com> <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Sep 2016 12:38:06 -0600
Message-ID: <CAJCQCtQT=j+P=Dy=VtNOBGkpwenK0AngB2k5xk40BE=hZnEfjA@mail.gmail.com>
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Alexandre Poux <pums974@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 12:19 PM, Alexandre Poux <pums974@gmail.com> wrote:
>
>
> Le 20/09/2016 à 19:54, Chris Murphy a écrit :
>> On Tue, Sep 20, 2016 at 11:03 AM, Alexandre Poux <pums974@gmail.com> wrote:
>>
>>> If I wanted to try to edit my partitions with an hex editor, where would
>>> I find infos on how to do that ?
>>> I really don't want to go this way, but if this is relatively simple, it
>>> may be worth to try.
>> Simple is relative. First you'd need
>> https://btrfs.wiki.kernel.org/index.php/On-disk_Format to get some
>> understanding of where things are to edit, and then btrfs-map-logical
>> to convert btrfs logical addresses to physical device and sector to
>> know what to edit.
>>
>> I'd call it distinctly non-trivial and very tedious.
>>
> OK, another idea:
> would it be possible to trick btrfs with a manufactured file that the
> disk is present while it isn't ?
>
> I mean, looking for a few minutes on the hexdump of my trivial test
> partition, header of members of btrfs array seems very alike.
> So maybe, I can make a file wich would have enough header to make btrfs
> believe that this is my device, and then remove it as usual....
> looks like a long shot, but it doesn't hurt to ask....

There may be another test that applies to single profiles, that
disallows dropping a device. I think that's the place to look next.
The superblock is easy to copy, but you'll need the device specific
UUID which should be locatable with btrfs-show-super -f for each
devid. The bigger problem is that Btrfs at mount time doesn't just
look at the superblock and then mount. It actually reads parts of each
tree, the extent of which I don't know. And it's doing a bunch of
sanity tests as it reads those things, including transid (generation).
So I'm not sure how easily spoofable a fake device is going to be.

As a practical matter, migrate it to a new volume is faster and more
reliable. Unfortunately, the inability to mount it read write is going
to prevent you from making read only snapshots to use with btrfs
send/receive. What might work, is find out what on-disk modification
btrfs-tune does to make a device a read-only seed. Again your volume
is missing a device so btrfs-tune won't let you modify it. But if you
could force that to happen, it's probably a very minor change to
metadata on each device, maybe it'll act like a seed device when you
next mount it, in which case you'll be able to add a device and
remount it read write and then delete the seed causing migration of
everything that does remain on the volume over to the new device. I've
never tried anything like this so I have no idea if it'll work. And
even in the best case I haven't tried a multiple device seed going to
a single device sprout (is it even allowed when removing the seed?).
So...more questions than answers.


-- 
Chris Murphy
