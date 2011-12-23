From: 810d4rk <810d4rk@gmail.com>
Subject: Re: btrfs encryption problems
Date: Fri, 23 Dec 2011 14:25:27 +0000
Message-ID: <CAAVfQjkeH_umb41EoH4LRD_c15a7jxbR2N=6-3v9NcoHsiOR0Q@mail.gmail.com>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
	<20111123110956.GB31800@attic.humilis.net>
	<CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
	<20111124160617.680b676f@zougloub.eu>
	<CAAVfQj=gM7ikTzdFmi=yNpo9guukQwFyKfdu7jD=z-J2PwrZEg@mail.gmail.com>
	<20111124165429.10496040@Bidule>
	<CAAVfQjmmXnyCmXerCyymEQm-DhDxi0YSSo9sVSvkHE1WvJ4wYA@mail.gmail.com>
	<20111130134814.GW24338@shiny>
	<CAAVfQjk+O_3uLb=DShFwV2gVnLeDzQ45ebpMidDGFXZtqXJBbQ@mail.gmail.com>
	<CAG1y0scRTcpHxEnRHgeKgFtYgVYJdgMFydZfXmKEOnRQvUpcQA@mail.gmail.com>
	<CAAVfQjnHkovhOQcWcRGAXON6ywfBAFHuT9vwp8QBf8hVd+wkjw@mail.gmail.com>
	<CAAVfQjm03u6ZZTyvLGrz8VC7MebEkBzQ8Mo_Sqw2kmuEx427vg@mail.gmail.com>
	<CAKcLGm_scJ57cC1hHY4rmqTrqwOdndQDbBtj09UYMYYABLb2Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Fajar A. Nugraha" <list@fajar.net>,
	Chris Mason <chris.mason@oracle.com>,
	=?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>,
	sander@humilis.net, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm_scJ57cC1hHY4rmqTrqwOdndQDbBtj09UYMYYABLb2Tw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I've been using btrfs and luks encryption on my Acer netbook for about
> a year now.  I haven't had an unmountable corruption on that computer
> yet.
>
> What are your goals now?

I would like to recover the data that is not in the backup.

> Are you trying to recover data from this disk, or are you trying to
> accomplish some debugging?

I am trying to recover the data, also I think this bug needs to be fixed.

> Reviewing the thread, I don't see where you've run btrfsck on the
> /dev/mapper/<entry>.
>
> Although btrfsck won't fix anything, it might give some insight as the
> the extent of the corruption.

I have run it now and it says "No valid Btrfs found"


-- 
Thanks
