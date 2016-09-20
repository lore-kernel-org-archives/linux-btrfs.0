Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36512 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932124AbcITTGu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 15:06:50 -0400
Received: by mail-wm0-f51.google.com with SMTP id w84so151462681wmg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 12:06:49 -0700 (PDT)
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
 <25b4f61e-8425-a1bf-0bda-44736ceb1841@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Alexandre Poux <pums974@gmail.com>
Message-ID: <6221ff5f-2f20-8d68-4861-72b9e209b950@gmail.com>
Date: Tue, 20 Sep 2016 21:06:47 +0200
MIME-Version: 1.0
In-Reply-To: <25b4f61e-8425-a1bf-0bda-44736ceb1841@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 20/09/2016 à 20:56, Austin S. Hemmelgarn a écrit :
> On 2016-09-20 13:54, Chris Murphy wrote:
>> On Tue, Sep 20, 2016 at 11:03 AM, Alexandre Poux <pums974@gmail.com>
>> wrote:
>>
>>> If I wanted to try to edit my partitions with an hex editor, where
>>> would
>>> I find infos on how to do that ?
>>> I really don't want to go this way, but if this is relatively
>>> simple, it
>>> may be worth to try.
>>
>> Simple is relative. First you'd need
>> https://btrfs.wiki.kernel.org/index.php/On-disk_Format to get some
>> understanding of where things are to edit, and then btrfs-map-logical
>> to convert btrfs logical addresses to physical device and sector to
>> know what to edit.
>>
>> I'd call it distinctly non-trivial and very tedious.
>>
> It really is.  I've done this before, but I had a copy of the on-disk
> format documentation, a couple of working filesystems, a full copy of
> the current kernel sources for reference, and about 8 cups of green
> tea (my beverage of choice for staying awake and focused).  I got
> _really_ lucky and it was something that really was simple to fix once
> I found it (it amounted to about 64 bytes of changes, it took me maybe
> 5 minutes to actually correct the issue once I found where it was),
> but it took me a good couple of hours to figure out what to even look
> for, plus another hour just to find it, and I'm not sure I would be
> able to do it any faster if I had to again (unlike doing so for ext4,
> which is a walk in the park by comparison).
>
> TBH the only thing I'd worry about using a hex editor to fix in BTRFS
> is the super-blocks or system chunks, because they're pretty easy to
> find, and usually not all that hard to fix.  In fact, if it hadn't
> been for the fact that I had no backup of the data I would lose by
> recreating that filesystem, and I was _really_ bored that day, I
> probably wouldn't have even tried.
OK I will forget this.
Thank you

