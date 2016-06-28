Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35784 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbcF1SB0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 14:01:26 -0400
Received: by mail-oi0-f54.google.com with SMTP id r2so34144660oih.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 11:01:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au>
References: <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org> <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au> <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
 <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Jun 2016 12:01:22 -0600
Message-ID: <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Austin Hemmelgarn <ahferroin7@gmail.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just wiping the slate clean to summarize:


1. We have a consistent ~1 in 3 maybe 1 in 2, reproducible corruption
of *data extent* parity during a scrub with raid5. Goffredo and I have
both reproduced it. It's a big bug. It might still be useful if
someone else can reproduce it too.

Goffredo, can you file a bug at bugzilla.kernel.org and reference your
bug thread?  I don't know if the key developers know about this, it
might be worth pinging them on IRC once the bug is filed.

Unknown if it affects balance, or raid 6. And if it affects raid 6, is
p or q corrupted, or both? Unknown how this manifests on metadata
raid5 profile (only tested was data raid5). Presumably if there is
metadata corruption that's fixed during a scrub, and its parity is
overwritten with corrupt parity, the next time there's a degraded
state, the file system would face plant somehow. And we've seen quite
a few degraded raid5's (and even 6's) face plant in inexplicable ways
and we just kinda go, shit. Which is what the fs is doing when it
encounters a pile of csum errors. It treats the csum errors as a
signal to disregard the fs rather than maybe only being suspicious of
the fs. Could it turn out that these file systems were recoverable,
just that Btrfs wasn't tolerating any csum error and wouldn't proceed
further?

2. The existing scrub code computes parity on-the-fly, compares it
with what's on-disk, and overwrites if there's a mismatch. If there's
a mismatch, there's no message anywhere. It's a feature request to get
a message on parity mismatches. An additional feature request would be
to get a parity_error counter along the lines of the other error
counters we have for scrub stats and dev stats.

3. I think it's a more significant change to get parity checksums
stored some where. Right now the csum tree holds item type EXTENT_CSUM
but parity is not an extent, it's also not data, it's a variant of
data. So it seems to me we'd need a new item type PARITY_CSUM to get
it into the existing csum tree. And I'm not sure what incompatibility
that brings; presumably older kernels could mount such a volume ro
safely, but shouldn't write to it, including btrfs check --repair
should probably fail.


Chris Murphy
