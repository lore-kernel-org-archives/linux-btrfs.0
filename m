Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54287 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932927AbcKPRPQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 12:15:16 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Martin Steigerwald <martin.steigerwald@teamix.de>,
        Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to find block group for 0
Date: Wed, 16 Nov 2016 18:06:33 +0100
Message-ID: <2758726.eYgiA1VjUp@merkaba>
In-Reply-To: <5a0c51bd-4245-92e2-566b-cc3dbcc26a84@gmail.com>
References: <18970348.FUMEOFOSb3@merkaba> <1672818.LEbdb7TNyD@merkaba> <5a0c51bd-4245-92e2-566b-cc3dbcc26a84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 16. November 2016, 07:57:08 CET schrieb Austin S. Hemmelgarn:
> On 2016-11-16 06:04, Martin Steigerwald wrote:
> > Am Mittwoch, 16. November 2016, 16:00:31 CET schrieb Roman Mamedov:
> >> On Wed, 16 Nov 2016 11:55:32 +0100
> >> 
> >> Martin Steigerwald <martin.steigerwald@teamix.de> wrote:
[…]
> > As there seems to be no force option to override the limitation and I
> > do not feel like compiling my own btrfs-tools right now, I will use rsync
> > instead.
> 
> In a case like this, I'd trust rsync more than send/receive.  The
> following rsync switches might also be of interest:
> -a: This turns on a bunch of things almost everyone wants when using
> rsync, similar to the same switch for cp, just with even more added in.
> -H: This recreates hardlinks on the receiving end.
> -S: This recreates sparse files.
> -A: This copies POSIX ACL's
> -X: This copies extended attributes (most of them at least, there are a
> few that can't be arbitrarily written to).
> Pre-creating the subvolumes by hand combined with using all of those
> will get you almost everything covered by send/receive except for
> sharing of extents and ctime.

I usually use rsync -aAHXSP already :).

I was able to rsync any relevant data of the disk which is now being deleted 
by shred command.

Thank you,
-- 
Martin
