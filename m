Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47703 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965348AbbLOXQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 18:16:20 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Still not production ready
Date: Wed, 16 Dec 2015 00:16:18 +0100
Message-ID: <3023521.FduxBggIrv@merkaba>
In-Reply-To: <20151215215958.GC6322@ret.masoncoding.com>
References: <8336788.myI8ELqtIK@merkaba> <566E2490.8080905@cn.fujitsu.com> <20151215215958.GC6322@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 15. Dezember 2015, 16:59:58 CET schrieb Chris Mason:
> On Mon, Dec 14, 2015 at 10:08:16AM +0800, Qu Wenruo wrote:
> > Martin Steigerwald wrote on 2015/12/13 23:35 +0100:
> > >Hi!
> > >
> > >For me it is still not production ready.
> > 
> > Yes, this is the *FACT* and not everyone has a good reason to deny it.
> > 
> > >Again I ran into:
> > >
> > >btrfs kworker thread uses up 100% of a Sandybridge core for minutes on
> > >random write into big file
> > >https://bugzilla.kernel.org/show_bug.cgi?id=90401
> > 
> > Not sure about guideline for other fs, but it will attract more dev's
> > attention if it can be posted to maillist.
> > 
> > >No matter whether SLES 12 uses it as default for root, no matter whether
> > >Fujitsu and Facebook use it: I will not let this onto any customer
> > >machine
> > >without lots and lots of underprovisioning and rigorous free space
> > >monitoring. Actually I will renew my recommendations in my trainings to
> > >be careful with BTRFS.
> > >
> > > From my experience the monitoring would check for:
> > >merkaba:~> btrfs fi show /home
> > >Label: 'home'  uuid: […]
> > >
> > >         Total devices 2 FS bytes used 156.31GiB
> > >         devid    1 size 170.00GiB used 164.13GiB path
> > >         /dev/mapper/msata-home
> > >         devid    2 size 170.00GiB used 164.13GiB path
> > >         /dev/mapper/sata-home
> > >
> > >If "used" is same as "size" then make big fat alarm. It is not sufficient
> > >for it to happen. It can run for quite some time just fine without any
> > >issues, but I never have seen a kworker thread using 100% of one core
> > >for extended period of time blocking everything else on the fs without
> > >this condition being met.> 
> > And specially advice on the device size from myself:
> > Don't use devices over 100G but less than 500G.
> > Over 100G will leads btrfs to use big chunks, where data chunks can be at
> > most 10G and metadata to be 1G.
> > 
> > I have seen a lot of users with about 100~200G device, and hit unbalanced
> > chunk allocation (10G data chunk easily takes the last available space and
> > makes later metadata no where to store)
> 
> Maybe we should tune things so the size of the chunk is based on the
> space remaining instead of the total space?

Still on my filesystem where was over 1 GiB free on metadata chunks, so…

… my theory still is: BTRFS has trouble finding free space in chunks at some 
time.

> > And unfortunately, your fs is already in the dangerous zone.
> > (And you are using RAID1, which means it's the same as one 170G btrfs with
> > SINGLE data/meta)
> > 
> > >In addition to that last time I tried it aborts scrub any of my BTRFS
> > >filesstems. Reported in another thread here that got completely ignored
> > >so
> > >far. I think I could go back to 4.2 kernel to make this work.
> 
> We'll pick this thread up again, the ones that get fixed the fastest are
> the ones that we can easily reproduce.  The rest need a lot of think
> time.

I understand. Maybe I just wanted to see at least some sort of an reaction.

I now have 4.4-rc5 running, the boot crash I had appears to be fixed. Oh, and 
I see that scrubbing / at leasted worked now:

merkaba:~> btrfs scrub status -d /
scrub status for […]
scrub device /dev/dm-5 (id 1) history
        scrub started at Wed Dec 16 00:13:20 2015 and finished after 00:01:42
        total bytes scrubbed: 23.94GiB with 0 errors
scrub device /dev/mapper/msata-debian (id 2) history
        scrub started at Wed Dec 16 00:13:20 2015 and finished after 00:01:34
        total bytes scrubbed: 23.94GiB with 0 errors

Okay, I test the other ones tomorrow, so maybe this one is fixed meanwhile.

Yay!

Thanks,
-- 
Martin
