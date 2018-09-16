Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f49.google.com ([209.85.167.49]:37435 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbeIQBgf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 21:36:35 -0400
Received: by mail-lf1-f49.google.com with SMTP id t140-v6so5981703lff.4
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2018 13:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com> <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
In-Reply-To: <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
From: Adrian Bastholm <adrian@javaguru.org>
Date: Sun, 16 Sep 2018 22:11:50 +0200
Message-ID: <CAMrg+aS4anZaXHmVZchESbmNAZ0QYzE98LGD0nWc1JV1h8jfng@mail.gmail.com>
Subject: Fwd: btrfs problems
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for answering Qu.

> At this timing, your fs is already corrupted.
> I'm not sure about the reason, it can be a failed CoW combined with
> powerloss, or corrupted free space cache, or some old kernel bugs.
>
> Anyway, the metadata itself is already corrupted, and I believe it
> happens even before you noticed.
 I suspected it had to be like that
>
> > BTRFS check --repair is not recommended, it
> > crashes , doesn't fix all problems, and I later found out that my
> > lost+found dir had about 39G of lost files and dirs.
>
> lost+found is completely created by btrfs check --repair.
>
> > I spent about two days trying to fix everything, removing a disk,
> > adding it again, checking , you name it. I ended up removing one disk,
> > reformatting it, and moving the data there.
>
> Well, I would recommend to submit such problem to the mail list *BEFORE*
> doing any write operation to the fs (including btrfs check --repair).
> As it would help us to analyse the failure pattern to further enhance btrfs.

IMHO that's a, how should I put it, a design flaw, the wrong way of
looking at how people think, with all respect to all the very smart
people that put in countless hours of hard work. Users expect and fs
check and repair to repair, not to break stuff.
Reading that --repair is "destructive" is contradictory even to me.

This problem emerged in a direcory where motion (the camera software)
was saving pictures. Either killing the process or a powerloss could
have left these jpg files (or fs metadata) in a bad state. Maybe
that's something to go on. I was thinking that there's not much anyone
can do without root access to my box anyway, and I'm not sure I was
prepared to give that to anyone.

>
> > Now I removed BTRFS
> > entirely and replaced it with a OpenZFS mirror array, to which I'll
> > add the third disk later when I transferred everything over.
>
> Understandable, it's really annoying a fs just get itself corrupted, and
> without much btrfs specified knowledge it would just be a hell to try
> any method to fix it (even a lot of them would just make the case worse).
>

I now know for a fact that ZFS has its own set of problems, like
adding a vdev to an existing zpool is irreversible, or that you can't
grow an array by just adding a bigger drive, stuff that seems som
natural, and that BTRFS is very good at.

> >
> > Please have a look at the console logs. I've been running linux on the
> > desktop for the past 15 years, so I'm not a noob, but for running
> > BTRFS you better be involved in the development of it.
>
> I'd say, yes.
> For any btrfs unexpected behavior, don't use btrfs check --repair unless
> you're a developer or some developer asked to do.

Again, this is counterintuitive. the repair option has been there in
all other systems and has worked (more or less the same way). Fixing
mbr's in windows, checkdisk, etc. Most linux fs variants create the
lost+found folder, but I've never before with another filesystem read
anywhere "don't use it unless you're one of the developers, it
destroys your filesystem". In that case it should be called btrfs
check --destructive so you don't get the impression that it'll somehow
give you an easy fix

> Any btrfs unexpected behavior, from strange ls output to aborted
> transaction, please consult with the mail list first.
> (Of course, with kernel version and btrfs-progs version, which is
> missing in your console log though)

Linux jenna 4.9.0-8-amd64 #1 SMP Debian 4.9.110-3+deb9u4 (2018-08-21)
x86_64 GNU/Linux
btrfs-progs is already the newest version (4.7.3-1).

> In fact, in recent (IIRC starting from v4.15) kernel releases, btrfs is
> already doing much better error detection thus it would detect such
> problem early on and protect the fs from being further modified.
>
> (This further shows that the importance of using the latest mainline
> kernel other than some old kernel provided by stable distribution).

> Thanks,
> Qu

Thank You very much Qu for the comments, even though I ranted a bit,
the purpose was to give a bit of feedback.

--
Vänliga hälsningar / Kind regards,
Adrian Bastholm

``I would change the world, but they won't give me the sourcecode``


-- 
Vänliga hälsningar / Kind regards,
Adrian Bastholm

``I would change the world, but they won't give me the sourcecode``
