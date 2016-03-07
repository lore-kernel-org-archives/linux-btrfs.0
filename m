Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:43748 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbcCGImh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 03:42:37 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acqkN-0004nZ-RU
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 09:42:35 +0100
Date: Mon, 7 Mar 2016 09:42:35 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160307084235.GB6939@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160305200909.GJ1902@torres.zugschlus.de>
 <pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
 <CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 06, 2016 at 01:27:10PM -0700, Chris Murphy wrote:
> Marc said it was created maybe 2 years ago and doesn't remember what
> version of the tools were used. Between it being two years ago and
> also being Debian, for all we know it could've been 0.19. *shrug*

You are mixing up Debian unstable and Debian stable *snort*. You're
lucky that I'm not on RHEL 6[1].

> On the one hand, the practical advice is to just blow it away and use
> everything current, go back to the same workload including thousands
> of snapshots, and see if this balance problem is reproducible. That's
> pretty clearly a bug.

To have the same thing happen in half a year again? That's not why I
converted to a snapshottable file system.

> On the other hand, we're approaching the state with Btrfs where the
> problems we're seeing are at least as much about aging file systems,
> because the stability is permitting file systems to get older.

And this is really something to be proud of? I mean, this is a file
system that is part of the vanilla linux kernel, not marked as
experimental or something, and you're still concerned about file
systems that were made a year ago? This is a new experience for me.

>  As they get older though, the issues get more non-deterministic. So
>  it's an interesting bug from that perspective, the current kernel
>  code ought to be able to contend with this (as in, the user is right
>  to expect the code to deal with this scenario, and if it doesn't it's
>  a bug; not that I expect today's code to actually do this).

Kernel 4.4.4 as of the day before yesterday, thanks for considering.

> So if it were me, I'd gather all possible data, including complete,
> not trimmed, logs.

So you seriously want all messages like
Mar  7 09:25:23 fan systemd[1]: Started http per-connection Server, forwarding to 3142 ([2a01:238:4071:328d:5054:ff:fea9:6807]:41060).
Mar  7 09:25:23 fan named[3000]: client 2a01:238:4071:328d:5054:ff:fea9:6807#59920 (debian.debian.zugschlus.de): query: debian.debian.zugschlus.de IN AAAA + (fec0:0:0:ffff::1)
Mar  7 09:21:34 fan dhcpd[2468]: DHCPREQUEST for 192.168.182.29 from 54:04:a6:82:21:00 via eth0: unknown lease 192.168.182.29.
Mar  7 09:17:01 fan CRON[19474]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Mar  7 09:18:06 fan systemd[1]: Started Session c101 of user mh.
Mar  7 08:21:40 fan smartd[1956]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 31 to 30

I _can_ swamp the bug report literally with gigabytes of logs, but is
that really what you want? If it is not, please state what you mean by
"not trimmed" as I only removed those clutter messages from the logs I
sent.

Greetings
Marc

[1] Does RHEL 6 have btrfs in the first place?

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
