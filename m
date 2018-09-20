Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f170.google.com ([209.85.208.170]:36427 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387475AbeITXIo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 19:08:44 -0400
Received: by mail-lj1-f170.google.com with SMTP id v26-v6so9129249ljj.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 10:24:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com> <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
 <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com> <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
 <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com>
In-Reply-To: <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com>
From: Adrian Bastholm <adrian@javaguru.org>
Date: Thu, 20 Sep 2018 19:23:35 +0200
Message-ID: <CAMrg+aQV97Cv4WgH-DQvwDikFydrxD-zeJajUk3iLk1oKf12_A@mail.gmail.com>
Subject: Re: btrfs problems
To: quwenruo.btrfs@gmx.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2018 at 2:44 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

>
> Then I strongly recommend to use the latest upstream kernel and progs
> for btrfs. (thus using Debian Testing)
>
> And if anything went wrong, please report asap to the mail list.
>
> Especially for fs corruption, that's the ghost I'm always chasing for.
> So if any corruption happens again (although I hope it won't happen), I
> may have a chance to catch it.

You got it
> >
> >> Anyway, enjoy your stable fs even it's not btrfs

> > My new stable fs is too rigid. Can't grow it, can't shrink it, can't
> > remove vdevs from it , so I'm planning a comeback to BTRFS. I guess
> > after the dust settled I realize I like the flexibility of BTRFS.
> >
I'm back to btrfs.

> From the code aspect, the biggest difference is the chunk layout.
> Due to the ext* block group usage, each block group header (except some
> sparse bg) is always used, thus btrfs can't use them.
>
> This leads to highly fragmented chunk layout.

The only thing I really understood is "highly fragmented" == not good
. I might need to google these "chunk" thingies

> We doesn't have error report about such layout yet, but if you want
> everything to be as stable as possible, I still recommend to use a newly
> created fs.

I guess I'll stick with ext4 on the rootfs

> > Another thing is I'd like to see a "first steps after getting started
> > " section in the wiki. Something like take your first snapshot, back
> > up, how to think when running it - can i just set some cron jobs and
> > forget about it, or does it need constant attention, and stuff like
> > that.
>
> There are projects do such things automatically, like snapper.
>
> If your primary concern is to make the fs as stable as possible, then
> keep snapshots to a minimal amount, avoid any functionality you won't
> use, like qgroup, routinely balance, RAID5/6.

So, is RAID5 stable enough ? reading the wiki there's a big fat
warning about some parity issues, I read an article about silent
corruption (written a while back), and chris says he can't recommend
raid56 to mere mortals.

> And keep the necessary btrfs specific operations to minimal, like
> subvolume/snapshot (and don't keep too many snapshots, say over 20),
> shrink, send/receive.
>
> Thanks,
> Qu
>
> >
> > BR Adrian
> >
> >
>


-- 
Vänliga hälsningar / Kind regards,
Adrian Bastholm

``I would change the world, but they won't give me the sourcecode``
