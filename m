Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34287 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbcFZHyU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 03:54:20 -0400
Received: by mail-lf0-f44.google.com with SMTP id h129so139092412lfh.1
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 00:54:19 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <CAJCQCtQhRbL_AWpspudPZzkkGkHT3O9T0QL94Of5LD8agmonwg@mail.gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <576F8A28.7060808@gmail.com>
Date: Sun, 26 Jun 2016 10:54:16 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQhRbL_AWpspudPZzkkGkHT3O9T0QL94Of5LD8agmonwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

26.06.2016 00:52, Chris Murphy пишет:
> Interestingly enough, so far I'm finding with full stripe writes, i.e.
> 3x raid5, exactly 128KiB data writes, devid 3 is always parity. This
> is raid4.

That's not what code suggests and what I see in practice - parity seems
to be distributed across all disks; each new 128KiB file (extent) has
parity on new disk. At least as long as we can trust btrfs-map-logical
to always show parity as "mirror 2".

Do you see consecutive full stripes in your tests? Or how do you
determine which devid has parity for a given full stripe? This
information is not actually stored anywhere, it is computed based on
block group geometry and logical stripe offset.

P.S. usage of "stripe" to mean "stripe element" actually adds to
confusion when reading code :)
