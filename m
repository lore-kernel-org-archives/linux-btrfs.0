Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35224 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934801AbeBMMGq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 07:06:46 -0500
Received: by mail-lf0-f42.google.com with SMTP id a204so24743378lfa.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 04:06:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <CAJ3TwYSTnQfj=qmBLtnmtXQKexMMD4x=9Gk3p3anf4uF+G26kw@mail.gmail.com>
 <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
 <5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com> <CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
 <799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com> <CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
 <e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com> <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
 <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com> <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
 <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com> <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>
 <87975474-0cb9-13d7-f623-c0622b31f437@gmx.com> <CAJ3TwYQ-GgZCCoD07AgQ0EDtpOknt3Ta1=WNAH7sSvXO3R-u8w@mail.gmail.com>
 <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com>
From: John Ettedgui <john.ettedgui@gmail.com>
Date: Tue, 13 Feb 2018 04:06:43 -0800
Message-ID: <CAJ3TwYTAhOc1eRUC_FoUFjpC=Ys_DRbHBp9NW6EdVSXArqiMww@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 3:40 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年02月13日 19:25, John Ettedgui wrote:
>> On Tue, Feb 13, 2018 at 3:04 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>>
>>> The problem is not about how much space it takes, but how many extents
>>> are here in the filesystem.
>>>
>>> For new fs filled with normal data, I'm pretty sure data extents will be
>>> as large as its maximum size (256M), causing very little or even no
>>> pressure to block group search.
>>>
>> What do you mean by "new fs",
>
> I mean the 4TB partition on that 5400rpm HDD.
>
>> was there any change that would improve
>> the behavior if I were to recreate the FS?
>
> If you backed up your fs, and recreate a new, empty btrfs on your
> original SSD, then copying all data back, I believe it would be much
> faster to mount.
>
Alright, I'll have to wait on getting some more drives for that but I
look forward to trying that.

>> Last time we talked I believe max extent was 128M for non-compressed
>> files, so maybe there's been some good change.
>
> My fault, 128M is correct.
>
>>> And since I went to SUSE, some mail/info is lost during the procedure.
>> I still have all mails, if you want it. No dump left though.
>>>
>>> Despite that, I have several more assumption to this problem:
>>>
>>> 1) Metadata usage bumped by inline files
>> What are inline files? Should I view this as inline in C, in that the
>> small files are stored in the tree directly?
>
> Exactly.
>
>>>    If there are a lot of small files (<2K as default),
>> Of the slow to mount partitions:
>> 2 partitions have less than a dozen files smaller than 2K.
>> 1 has about 5 thousand and the last one 15 thousand.
>> Are the latter considered a lot?
>
> If using default 16K nodesize, 8 small files takes one leaf.
> And 15K small failes means about 2K tree extents.
>
> Not that much in my opinion, can't even fill half of a metadata chunk.
>
>>> and your metadata
>>>    usage is quite high (generally speaking, it meta:data ratio should be
>>>    way below 1:8), that may be the cause.
>>>
>> The ratio is about 1:900 on average so that should be ok I guess.
>
> Yep, that should be fine.
> So not metadata to blame.
>
> Then purely fragmented data extents.
>
>>>    If so, try mount the fs with "max_inline=0" mount option and then
>>>    try to rewrite such small files.
>>>
>> Should I try that?
>
> No need, it won't cause much difference.

Alright!

>>> 2) SSD write amplification along with dynamic remapping
>>>    To be honest, I'm not really buying this idea, since mount doesn't
>>>    have anything related to write.
>>>    But running fstrim won't harm anyway.
>>>
>> Oh I am not complaining about slow SSDs mounting. I was just amazed
>> that a partition on a slow HDD mounted faster.
>> Without any specific work, my SSDs partitions tend to mount around 1 sec or so.
>> Of course I'd be happy to worry about them once all the partitions on
>> HDDs mount in a handful of ms :)
>>
>>> 3) Rewrite the existing files (extreme defrag)
>>>    In fact, defrag doesn't work well if there are subvolumes/snapshots
>> I have no subvolume or snapshot so that's not a problem.
>>>    /reflink involved.
>>>    The most stupid and mindless way, is to write a small script and find
>>>    all regular files, read them out and rewrite it back.
>>>
>> That's fairly straightforward to do, though it should be quite slow so
>> I'd hope not to have to do that too often.
>
> Then it could be tried on the most frequently updated files then.

That's an interesting idea.
More than 3/4 of the data is just storage, so that should be very ok.

>
> And since you don't use snapshot, locate such files and then "chattr +C"
> would make them nodatacow, reducing later fragments.

I don't understand, why would that reduce later fragments?

>
>>>    This should acts much better than traditional defrag, although it's
>>>    time-consuming and makes snapshot completely meaningless.
>>>    (and since you're already hitting ENOSPC, I don't think the idea is
>>>     really working for you)
>>>
>>> And since you're already hitting ENOSPC, either it's caused by
>>> unbalanced meta/data usage, or it's really going hit the limit, I would
>>> recommend to enlarge the fs or delete some files to see if it helps.
>>>
>> Yup, I usually either slowly ramp up the {d,m}usage to pass it, or
>> when that does not work I free some space, then balance will finish.
>> Or did you mean to free some space to see about mount speed?
>
> Kind of, just do such freeing in advance, and try to make btrfs always
> have unallocated space in case.
>

I actually have very little free space on those partitions, usually
under 90Gb, maybe that's part of my problem.

> And finally, use latest kernel if possible.
> IIRC old kernel doesn't have empty block group auto remove, which makes
> user need to manually balance to free some space.
>
> Thanks,
> Qu
>

I am on 4.15 so no problem there.

So manual defrag and new FS to try.

Thank you!
