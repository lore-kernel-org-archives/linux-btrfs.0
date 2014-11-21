Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:39366 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKUSGT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 13:06:19 -0500
Received: by mail-yh0-f54.google.com with SMTP id 29so2801059yhl.41
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 10:06:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141121174229.GT17395@hungrycats.org>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za>
	<20141121045801.GS17395@hungrycats.org>
	<546EE43C.7020900@swiftspirit.co.za>
	<20141121174229.GT17395@hungrycats.org>
Date: Fri, 21 Nov 2014 11:06:19 -0700
Message-ID: <CAJCQCtQF9Lqeo_7OZQYAknTU_a7+k7b1-xt5DXe49_hwg-1QtQ@mail.gmail.com>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Chris Murphy <lists@colorremedies.com>
To: Zygo Blaxell <zblaxell@furryterror.org>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 21, 2014 at 10:42 AM, Zygo Blaxell <zblaxell@furryterror.org> wrote:

> I run 'smartctl -t long' from cron overnight (or whenever the drives
> are most idle).  You can also set up smartd.conf to launch the self
> tests; however, the syntax for test scheduling is byzantine compared to
> cron (and that's saying something!).  On multi-drive systems I schedule
> a different drive for each night.
>
> If you are also doing btrfs scrub, then stagger the scheduling so
> e.g. smart runs in even weeks and btrfs scrub runs in odd weeks.
>
> smartd is OK for monitoring test logs and email alerts.  I've had no
> problems there.

Most attributes are always updated without issuing a smart test of any
kind. A drive I have here only has four offline updateable attributes.

When it comes to bad sectors, the drive won't use a sector that
persistently fails writes. So you don't really have to worry about
latent bad sectors that don't have data on them already. The sectors
you care about are the ones with data. A scrub reads all of those
sectors.

First the drive could report a read error in which case Btrfs
raid1/10, and any (md, lvm, hardware) raid can use mirrored data, or
rebuild it from parity, and write to the affected sector; and also
this same mechanism happens in normal reads so it's a kind of passive
scrub. But it happens to miss checking inactively read data, which a
scrub will check.

Second, the drive could report no problem, and Btrfs raid1/10 could
still fix the problem in case of a csum mismatch. And it looks like
soonish we'll see this apply to raid5/6.

So I think a nightly long smart test is a bit overkill. I think you
could do nightly -t short tests which will report problems scrub won't
notice, such as higher seek times or lower throughput performance. And
then scrub once a week.


> The drive itself could be failing in some way that prevents recording
> SMART errors (e.g. because of host timeouts triggering a bus reset,
> which also prevents the SMART counter update for what was going wrong at
> the time).  This is unfortunately quite common, especially with drives
> configured for non-RAID workloads.

Libata resetting the link should be recorded in kernel messages.



-- 
Chris Murphy
