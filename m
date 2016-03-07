Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34501 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbcCGSjM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 13:39:12 -0500
Received: by mail-io0-f175.google.com with SMTP id m184so141549644iof.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 10:39:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160307084235.GB6939@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160305200909.GJ1902@torres.zugschlus.de>
	<pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
	<CAJCQCtSyKgs4ki_dEraofWJtXzN5ecUSFCHjrGF5vyFNJzFY0g@mail.gmail.com>
	<20160307084235.GB6939@torres.zugschlus.de>
Date: Mon, 7 Mar 2016 11:39:11 -0700
Message-ID: <CAJCQCtTbfexN9UKRrHTs6yDkSxP3G7qsX-TMR8qZi=x1ef6vSg@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 7, 2016 at 1:42 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> On Sun, Mar 06, 2016 at 01:27:10PM -0700, Chris Murphy wrote:


>> On the one hand, the practical advice is to just blow it away and use
>> everything current, go back to the same workload including thousands
>> of snapshots, and see if this balance problem is reproducible. That's
>> pretty clearly a bug.
>
> To have the same thing happen in half a year again? That's not why I
> converted to a snapshottable file system.

If you want to help make Btfs better, yes. If you don't, that's fine,
use ZFS on Linux. Or if the ZFS Linux glue thing bugs you, use
FreeBSD. We're very lucky in free software to have so many
alternatives.


>> On the other hand, we're approaching the state with Btrfs where the
>> problems we're seeing are at least as much about aging file systems,
>> because the stability is permitting file systems to get older.
>
> And this is really something to be proud of? I mean, this is a file
> system that is part of the vanilla linux kernel, not marked as
> experimental or something, and you're still concerned about file
> systems that were made a year ago? This is a new experience for me.

I'm not a developer so you should take my opinions with a grain of
salt, but having come from something near to your perspective, it's
changed a lot by following the progress over ~5-6 years. Filesystems
are non-trivial. There's a great set of videos here
http://open-zfs.org/wiki/Main_Page about how non-trivial this was for
ZFS. It was a year to first kernel mount at which point it seemed like
90% of the work was done but far from it as it really took ~10 years
to get to a point where they were certain it could be deployed in an
enterprise environment.

Btrfs first kernel mount was in what 2008? So we're not yet done with
year 8? Not that they're exactly comparable. But I don't know who was
saying Btrfs would be done and stable with no bugs in 5 years.

The reality is, you've lost no data and you've probably found a bug.
So, write it up and contribute if you want. It's been a new experience
for me also.

>
>> So if it were me, I'd gather all possible data, including complete,
>> not trimmed, logs.
>
> So you seriously want all messages like
> Mar  7 09:25:23 fan systemd[1]: Started http per-connection Server, forwarding to 3142 ([2a01:238:4071:328d:5054:ff:fea9:6807]:41060).
> Mar  7 09:25:23 fan named[3000]: client 2a01:238:4071:328d:5054:ff:fea9:6807#59920 (debian.debian.zugschlus.de): query: debian.debian.zugschlus.de IN AAAA + (fec0:0:0:ffff::1)
> Mar  7 09:21:34 fan dhcpd[2468]: DHCPREQUEST for 192.168.182.29 from 54:04:a6:82:21:00 via eth0: unknown lease 192.168.182.29.
> Mar  7 09:17:01 fan CRON[19474]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
> Mar  7 09:18:06 fan systemd[1]: Started Session c101 of user mh.
> Mar  7 08:21:40 fan smartd[1956]: Device: /dev/sdb [SAT], SMART Usage Attribute: 194 Temperature_Celsius changed from 31 to 30
>
> I _can_ swamp the bug report literally with gigabytes of logs, but is
> that really what you want?

Since there's no hardware issue suspect, you could filter for just btrfs.

journalctl -o short-iso | grep -i btrfs

When there's hardware stuff suspect it's better to include all the
SCSI and  libata (and USB if it's a USB drive) messages also.

If you have any logs that include the filesystem mounted with
enospc_debug, that might be useful for a developer?


> [1] Does RHEL 6 have btrfs in the first place?

They do, but you need a decoder ring to figure out what's been
backported to have some vague idea of what equivalent kernel.org
kernel it is.

-- 
Chris Murphy
