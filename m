Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:32998 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdHMXkZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 19:40:25 -0400
Received: by mail-lf0-f45.google.com with SMTP id d17so33608248lfe.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Aug 2017 16:40:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtToFj4BowawgYPT-GiUnZPAXsjtuZO2=imcoyOZmaQzug@mail.gmail.com>
References: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it> <CAJCQCtToFj4BowawgYPT-GiUnZPAXsjtuZO2=imcoyOZmaQzug@mail.gmail.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Mon, 14 Aug 2017 01:40:08 +0200
Message-ID: <CANznX5EfXJ4eUh-bGXK0stPqiDfAnafFFw=_hxgxm2UiFpPeOQ@mail.gmail.com>
Subject: Re: [RFC] Checksum of the parity
To: Chris Murphy <lists@colorremedies.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 13, 2017 at 8:45 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Further, the error detection of corrupt reconstruction is why I say
> Btrfs is not subject *in practice* to the write hole problem. [2]
>
> [1]
> I haven't tested the raid6 normal read case where a stripe contains
> corrupt data strip and corrupt P strip, and Q strip is good. I expect
> instead of EIO, we get a reconstruction from Q, and then both data and
> P get fixed up, but I can't find it in comments or code.

Yes, that's what I would expect (which theoretically makes the odds of
successful recovery better on RAID6, possible "good enough") but I
have no clue how that actually gets handled right now (I guess the
current code isn't that thorough).

> [2]
> Is Btrfs subject to the write hole problem manifesting on disk? I'm
> not sure, sadly I don't read the code well enough. But if all Btrfs
> raid56 writes are full stripe CoW writes, and if the prescribed order
> guarantees still happen: data CoW to disk > metadata CoW to disk >
> superblock update, then I don't see how the write hole happens. Write
> hole requires: RMW of a stripe, which is a partial stripe overwrite,
> and a crash during the modification of the stripe making that stripe
> inconsistent as well as still pointed to by metadata.

I guess the problem is that stripe size or stripe element size is
(sort of) fixed (not sure which one, I guess it's the latter, in which
case the actual stripe size depends on the number of devices) and
relatively big (much bigger than the usual 4k sector size or even the
leaf size which now defaults to 16k, if I recall [but I set this to 4k
myself]), so a partial stripe update (RMW) is certainly possible
during generic use.

This is why I threw the idea around a few months ago to resurrect that
old (but dead looking / stuck) project about making the stripe
(element) size configurable by the user. That would allow for making
the stripe size equal to the filesystem sector size on a limited
amount of setups (for example, 5 or 6 HDD with 512-byte physical
sectors in RAID-5 or RAID-6 respectively) which would (as I
understand) practically eliminate the problem (at least on the
filesystem side, I am not sure if the HDD's volatile write-cache or at
least it's internal re-ordering feature should still be disabled for
this to really avoid inconsistencies between stripe elements --- I
can't recall ever seeing partially written sectors [we would know
since these are checksummed in place and thus appear unreadable if
partially written], I guess there might be usually enough electricity
in some small capacitor to finish the current sector after the power
gets cut ???).
