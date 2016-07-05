Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34717 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbcGEXFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2016 19:05:48 -0400
Received: by mail-oi0-f41.google.com with SMTP id s66so249774753oif.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 16:05:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <70f12c1b-8d30-c5f7-faa8-10a86a49c332@crc.id.au>
References: <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org> <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au> <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
 <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au> <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
 <70f12c1b-8d30-c5f7-faa8-10a86a49c332@crc.id.au>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 5 Jul 2016 17:05:44 -0600
Message-ID: <CAJCQCtR+S7mVSKiDSLOnJ+CjCwtmpj9w=pFDK_chHCqpcV-+Ww@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Related:
http://www.spinics.net/lists/raid/msg52880.html

Looks like there is some traction to figuring out what to do about
this, whether it's a udev rule or something that happens in the kernel
itself. Pretty much the only hardware setup unaffected by this are
those with enterprise or NAS drives. Every configuration of a consumer
drive, single, linear/concat, and all software (mdadm, lvm, Btrfs)
RAID Levels are adversely affected by this.

I suspect, but haven't tested, that ZFS On Linux would be equally
affected, unless they're completely reimplementing their own block
layer (?) So there are quite a few parties now negatively impacted by
the current default behavior.


Chris Murphy
