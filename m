Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37317 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbeIUDWI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 23:22:08 -0400
Received: by mail-lf1-f68.google.com with SMTP id b12-v6so2366074lfa.4
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 14:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com> <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
 <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com> <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
 <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com> <CAMrg+aQV97Cv4WgH-DQvwDikFydrxD-zeJajUk3iLk1oKf12_A@mail.gmail.com>
 <CAJCQCtQ6GQ=oihewodXDOfSRE1X_gE=esxY7kZnPZmCXYHGqiA@mail.gmail.com>
In-Reply-To: <CAJCQCtQ6GQ=oihewodXDOfSRE1X_gE=esxY7kZnPZmCXYHGqiA@mail.gmail.com>
From: Adrian Bastholm <adrian@javaguru.org>
Date: Thu, 20 Sep 2018 23:35:57 +0200
Message-ID: <CAMrg+aQX+NM+Rt7nhQqBa50Ar2bPh9MEN5iOk-48P_27dgAD-Q@mail.gmail.com>
Subject: Re: btrfs problems
To: lists@colorremedies.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot for the detailed explanation.
Aabout "stable hardware/no lying hardware". I'm not running any raid
hardware, was planning on just software raid. three drives glued
together with "mkfs.btrfs -d raid5 /dev/sdb /dev/sdc /dev/sdd". Would
this be a safer bet, or would You recommend running the sausage method
instead, with "-d single" for safety ? I'm guessing that if one of the
drives dies the data is completely lost
Another variant I was considering is running a raid1 mirror on two of
the drives and maybe a subvolume on the third, for less important
stuff

BR Adrian
On Thu, Sep 20, 2018 at 9:39 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Thu, Sep 20, 2018 at 11:23 AM, Adrian Bastholm <adrian@javaguru.org> wrote:
> > On Mon, Sep 17, 2018 at 2:44 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >
> >>
> >> Then I strongly recommend to use the latest upstream kernel and progs
> >> for btrfs. (thus using Debian Testing)
> >>
> >> And if anything went wrong, please report asap to the mail list.
> >>
> >> Especially for fs corruption, that's the ghost I'm always chasing for.
> >> So if any corruption happens again (although I hope it won't happen), I
> >> may have a chance to catch it.
> >
> > You got it
> >> >
> >> >> Anyway, enjoy your stable fs even it's not btrfs
> >
> >> > My new stable fs is too rigid. Can't grow it, can't shrink it, can't
> >> > remove vdevs from it , so I'm planning a comeback to BTRFS. I guess
> >> > after the dust settled I realize I like the flexibility of BTRFS.
> >> >
> > I'm back to btrfs.
> >
> >> From the code aspect, the biggest difference is the chunk layout.
> >> Due to the ext* block group usage, each block group header (except some
> >> sparse bg) is always used, thus btrfs can't use them.
> >>
> >> This leads to highly fragmented chunk layout.
> >
> > The only thing I really understood is "highly fragmented" == not good
> > . I might need to google these "chunk" thingies
>
> Chunks are synonyms with block groups. They're like a super extent, or
> extent of extents.
>
> The block group is how Btrfs abstracts the logical address used most
> everywhere in Btrfs land, and device + physical location of extents.
> It's how a file is referenced only by on logical address, and doesn't
> need to know either where the extent is located, or how many copies
> there are. The block group allocation profile is what determines if
> there's one copy, duplicate copies, raid1, 10, 5, 6 copies of a chunk
> and where the copies are located. It's also fundamental to how device
> add, remove, replace, file system resize, and balance all interrelate.
>
>
> >> If your primary concern is to make the fs as stable as possible, then
> >> keep snapshots to a minimal amount, avoid any functionality you won't
> >> use, like qgroup, routinely balance, RAID5/6.
> >
> > So, is RAID5 stable enough ? reading the wiki there's a big fat
> > warning about some parity issues, I read an article about silent
> > corruption (written a while back), and chris says he can't recommend
> > raid56 to mere mortals.
>
> Depends on how you define stable. In recent kernels it's stable on
> stable hardware, i.e. no lying hardware (actually flushes when it
> claims it has), no power failures, and no failed devices. Of course
> it's designed to help protect against a clear loss of a device, but
> there's tons of stuff here that's just not finished including ejecting
> bad devices from the array like md and lvm raids will do. Btrfs will
> just keep trying, through all the failures. There are some patches to
> moderate this but I don't think they're merged yet.
>
> You'd also want to be really familiar with how to handle degraded
> operation, if you're going to depend on it, and how to replace a bad
> device. Last I refreshed my memory on it, it's advised to use "btrfs
> device add" followed by "btrfs device remove" for raid56; whereas
> "btrfs replace" is preferred for all other profiles. I'm not sure if
> the "btrfs replace" issues with parity raid were fixed.
>
> Metadata as raid56 shows a lot more problem reports than metadata
> raid1, so there's something goofy going on in those cases. I'm not
> sure how well understood they are. But other people don't have
> problems with it.
>
> It's worth looking through the archives about some things. Btrfs
> raid56 isn't exactly perfectly COW, there is read-modify-write code
> that means there can be overwrites. I vaguely recall that it's COW in
> the logical layer, but the physical writes can end up being RMW or not
> for sure COW.
>
>
>
> --
> Chris Murphy



-- 
Vänliga hälsningar / Kind regards,
Adrian Bastholm

``I would change the world, but they won't give me the sourcecode``
