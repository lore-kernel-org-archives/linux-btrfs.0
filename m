Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:51929 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755025AbdKAU2A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 16:28:00 -0400
Received: by mail-wm0-f48.google.com with SMTP id b9so7186778wmh.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 13:28:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ca0bc340-25eb-bf80-82a1-fbb0e7ca1a44@rqc.ru>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru> <CAH=dxU7APYANHn3PjqepY9dr9F3RRhzE1OSgtar9tN-74haS9g@mail.gmail.com>
 <ca0bc340-25eb-bf80-82a1-fbb0e7ca1a44@rqc.ru>
From: Dave <davestechshop@gmail.com>
Date: Wed, 1 Nov 2017 16:27:38 -0400
Message-ID: <CAH=dxU6fJ1uJgY9ECFH8YpQkXQxc-qqDsuQZ=jd75HOE0nd2gA@mail.gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Marat Khalili <mkh@rqc.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 1, 2017 at 4:34 AM, Marat Khalili <mkh@rqc.ru> wrote:

>> We do experience severe performance problems now, especially with
>> Firefox. Part of my experiment is to reduce the number of snapshots on
>> the live volumes, hence this question.
>
> Just for statistics, how many snapshots do you have and how often do you
> take them? It's on SSD, right?

I don't think the severe performance problems stem solely from the
number of snapshots. I think it is also related to Firefox stuff
(cache fragmentation, lack of multi-processor mode maybe, etc.) I
still have to investigate the Firefox issues, but I'm starting at the
foundation by trying to get a basic BTRFS setup that will support
better desktop application performance first.

The poor performance has existed from the beginning of using BTRFS +
KDE + Firefox (almost 2 years ago), at a point when very few snapshots
had yet been created. A comparison system running similar hardware as
well as KDE + Firefox (and LVM + EXT4) did not have the performance
problems. The difference has been consistent and significant. For a
while I thought the difference was due to the hardware, as one system
used the z170 chipset and the other used the X99 chipset (but were
otherwise equivalent). So I repeated the testing on identical hardware
and the stark performance difference remained. When I realized that, I
began focusing on BTRFS, as it is the only consistent difference I can
recognize.

Sometimes I have used Snapper settings like this:

TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="36"
TIMELINE_LIMIT_DAILY="30"
TIMELINE_LIMIT_MONTHLY="12"
TIMELINE_LIMIT_YEARLY="10"

However, I also have some computers set like this:

TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="10"
TIMELINE_LIMIT_DAILY="10"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"

> BTW beware of deleting too many snapshots at once with any tool. Delete few
> and let filesystem stabilize before proceeding.

OK, thanks for the tip.

> For deduplication tool to be useful you ought to have some duplicate data on
> your live volume. Do you have any (e.g. many LXC containers with the same
> distribution)?

No, no containers and no duplication to that large extent.

> P.S. I still think you need some off-system backup solution too, either
> rsync+snapshot-based over ssh or e.g. Burp (shameless advertising:
> http://burp.grke.org/ ).

I agree, but that's beyond the scope of the current problem I'm trying
to solve.  However, I'll check out Burp once I have a base
configuration that is working satisfactorily.
