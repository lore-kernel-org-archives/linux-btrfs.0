From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: btrfs encryption problems
Date: Thu, 15 Dec 2011 17:49:17 -0600
Message-ID: <CAKcLGm_scJ57cC1hHY4rmqTrqwOdndQDbBtj09UYMYYABLb2Tw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Fajar A. Nugraha" <list@fajar.net>,
	Chris Mason <chris.mason@oracle.com>,
	=?ISO-8859-1?Q?J=E9r=F4me_Carretero?= <cJ-ko@zougloub.eu>,
	sander@humilis.net, linux-btrfs@vger.kernel.org
To: 810d4rk <810d4rk@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAVfQjm03u6ZZTyvLGrz8VC7MebEkBzQ8Mo_Sqw2kmuEx427vg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 15, 2011 at 1:44 PM, 810d4rk <810d4rk@gmail.com> wrote:
> Is anyone there trying to reproduce the bug??
>

I've been using btrfs and luks encryption on my Acer netbook for about
a year now.  I haven't had an unmountable corruption on that computer
yet.

What are your goals now?

Are you trying to recover data from this disk, or are you trying to
accomplish some debugging?

Reviewing the thread, I don't see where you've run btrfsck on the
/dev/mapper/<entry>.

Although btrfsck won't fix anything, it might give some insight as the
the extent of the corruption.
