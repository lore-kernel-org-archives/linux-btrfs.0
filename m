From: Pat Regan <thehead@patshead.com>
Subject: Re: some issues with lots of snapshots
Date: Sat, 30 Oct 2010 15:12:03 -0400
Message-ID: <20101030151203.44790cdb@zaphod>
References: <20101026102853.GX13205@jeru.org>
	<20101026151528.555ccee9@zaphod>
	<20101027083948.GA13205@jeru.org>
	<20101028180341.7dd5ad12@zaphod>
	<AANLkTi=r+Q4Q8wEC9SB6wG9zFF1nmTwQ=qQ7=6vxbu2Z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Roman Kapusta <roman.kapusta@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=r+Q4Q8wEC9SB6wG9zFF1nmTwQ=qQ7=6vxbu2Z@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 29 Oct 2010 08:31:05 +0200
Roman Kapusta <roman.kapusta@gmail.com> wrote:

> On Fri, Oct 29, 2010 at 00:03, Pat Regan <thehead@patshead.com> wrote=
:
> > On Wed, 27 Oct 2010 10:39:48 +0200
> > Xavier Nicollet <nicollet@jeru.org> wrote:
> >
> >> Le 26 octobre 2010 =E0 15:15, Pat Regan a =E9crit:
> >> > I turned off the 5-minute snapshots and I'm now just keeping 4
> >> > weekly, 7 daily, and 24 hourly snapshots alive.
> >>
> >> I have just rebooted and I am going with /15 minutes interval.
> >>
> >
> > I'm just replying so this is documented somewhere.
> >
> > After I read your message I decided to turn on snaphots at 15 minut=
e
> > intervals yesterday. =A0This morning I had snapshot processing
> > filling up my process list again.
>=20
> I think there is no problem with snapshot creation every 5 or 15
> minutes, but problem is with deleting old snapshots every 5 or 15
> minutes. Can you try to run cleanup of old snapshots only once per da=
y
> to check if it will improve?

Reducing the frequency of snapshot removal sure did work.  I started
with a pretty large amount of time between snapshot removal jobs and I
have been decreasing that number.  I have been running with a 1 hour
delay between snapshot removals for almost 24 hours so far with no
problems.

Pat
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
