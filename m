Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:41464 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbeIDUs0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 16:48:26 -0400
Received: by mail-oi0-f66.google.com with SMTP id k12-v6so7827554oiw.8
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 09:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
 <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com> <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>
 <43e5b6dc-a963-6d67-732f-c13c2f5abc78@gmx.com>
In-Reply-To: <43e5b6dc-a963-6d67-732f-c13c2f5abc78@gmx.com>
From: Etienne Champetier <champetier.etienne@gmail.com>
Date: Tue, 4 Sep 2018 12:22:23 -0400
Message-ID: <CAOdf3gqtbGJD29sYCOgL4+RC3a5ypvUbXP=F4r+pVDa_D+bCjg@mail.gmail.com>
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
To: quwenruo.btrfs@gmx.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Qu, one last question I think

Le mar. 4 sept. 2018 à 08:33, Qu Wenruo <quwenruo.btrfs@gmx.com> a écrit :
>
> On 2018/9/4 下午7:53, Etienne Champetier wrote:
> > Hi Qu,
> >
> > Le lun. 3 sept. 2018 à 20:27, Qu Wenruo <quwenruo.btrfs@gmx.com> a écrit :
> >>
> >> On 2018/9/3 下午10:18, Etienne Champetier wrote:
> >>> Hello btfrs hackers,
> >>>
> >>> I have a computer acting as backup server with BTRFS RAID1, and I
> >>> would like to know the different options to rebuild this RAID
> >>> (I saw this thread
> >>> https://www.spinics.net/lists/linux-btrfs/msg68679.html but there was
> >>> no raid 1)
> >>>
> >>> # uname -a
> >>> Linux servmaison 4.4.0-134-generic #160-Ubuntu SMP Wed Aug 15 14:58:00
> >>> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
> >>>
> >>> # btrfs --version
> >>> btrfs-progs v4.4
> >>>
> >>> # dmesg
> >>> ...
> >>> [ 1955.581972] BTRFS critical (device sda2): corrupt leaf, bad key
> >>> order: block=6020235362304,root=1, slot=63
> >>> [ 1955.582299] BTRFS critical (device sda2): corrupt leaf, bad key
> >>> order: block=6020235362304,root=1, slot=63
> >
> > Now running a Fedora 28 install kernel
> >
> > # uname -a
> > Linux servmaison 4.16.3-301.fc28.x86_64 #1 SMP Mon Apr 23 21:59:58 UTC
> > 2018 x86_64 x86_64 x86_64 GNU/Linux
> > # btrfs --version
> > btrfs-progs v4.15.1
>
> Unfortunately, even for latest btrfs-progs release (v4.17.1, and even
> devel branch), btrfs check will abort checking if free space cache is
> corrupted.
>
> So we didn't get any useful info from btrfs check.
>
> Such diff would help you continue checking (if you really want, other
> than starting salvaging your data)
> ------
> diff --git a/check/main.c b/check/main.c
> index b361cd7e26a0..4f720163221e 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -9885,7 +9885,6 @@ int cmd_check(int argc, char **argv)
>                         error("errors found in free space tree");
>                 else
>                         error("errors found in free space cache");
> -               goto out;
>         }
>
>         /*
> ------
>
>
> For dump tree block, the corrupted tree block belongs to extent tree.
> Which could be a good news (depends on how you define GOOD news).
>
> The corruption is not an easy fix, it's not just a swapped slot.
> The corrupted slot (item 64, whole key objectid is 5946810351616) is way
> beyond the extent data range, thus btrfs-progs can't fix it easily.
>
> Considering how much bytenr difference there is and the generation gap
> (53167 vs current generation 1555950), the bug happens a long long time
> ago (days or weeks before 2016-06-04). So it's a little too late to be
> fixed (unless someone could send me a time machine).
>
> On the other hand, this means any WRITE would easily fail due to
> corrupted extent tree, but your fs should be OK if mounted RO, thus you
> could copy your data out.
>

Do you have a procedure to copy all subvolumes & skip error ? (I have
~200 snapshots)

> >
> >>
> >> Please provide the following dump:
> >>
> >> # btrfs inspect dump-tree -t root /dev/sda2
> >> # btrfs inspect dump-tree -b 6020235362304 /dev/sda2
> >
> > All requested dump are in this repo:
> > https://github.com/champtar/debugraidbtrfs
> >
> [snip]
> >>
> >> If it's the only problem, "btrfs check --repair" indeed could fix it.
> >
> > Also available in https://github.com/champtar/debugraidbtrfs, here
> > "btrfs check --readonly /dev/sda2" output
> > ~~~~~~~~~~~~~~~~~~~~
> > checking extents
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad key ordering 63 64
> > bad block 6020235362304
> > ERROR: errors found in extent allocation tree or chunk allocation
> > checking free space cache
> > there is no free space entry for 6011561750528-5942842273792
> > there is no free space entry for 6011561750528-6012044050432
> > cache appears valid but isn't 6010970308608
> > there is no free space entry for 6015529828352-5946810351616
> > there is no free space entry for 6015529828352-6016339017728
> > cache appears valid but isn't 6015265275904
> > there is no free space entry for 6139476623360-6070757146624
> > there is no free space entry for 6139476623360-6139852881920
> > cache appears valid but isn't 6138779140096
> > ERROR: errors found in free space cache
> > Checking filesystem on /dev/sda2
> > UUID: 4917db5e-fc20-4369-9556-83082a32d4cd
> > found 1321120776195 bytes used, error(s) found
> > total csum bytes: 0
> > total tree bytes: 1163182080
> > total fs tree bytes: 0
> > total extent tree bytes: 1161740288
> > btree space waste bytes: 290512355
> > file data blocks allocated: 618135552
> >  referenced 618135552
> > ~~~~~~~~~~~~~~~~~~~~
>
> As expected, btrfs-progs is unable to fix it.
>
> >
> > Thanks
> > Etienne
> >
> > P.S: sorry for the initial duplicate email, it took a very long time
> > to show up in https://www.spinics.net/lists/linux-btrfs/maillist.html,
> > thought it was discarded as I was not subscribed to the list
>
> It's pretty common, I even sometimes sent patches twice for the same reason.
>
> And just another kindly note, for "btrfs check" or "btrfs inspect
> dump-tree", there is no difference using difference device.
> So one output is enough.

I was not sure that in case of error it would produce the same results
for both disk, so I prefered to send both to remove 1 round trip ;)

>
> Thanks,
> Qu
>
> >
> >>
> >> Thanks,
> >> Qu
> >>
> >>> (I can boot on a more up to date Linux live if it helps)
> >>>
> >>> Thanks
> >>> Etienne
> >>>
> >>
>
