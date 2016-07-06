Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:32946 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbcGFLv2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 07:51:28 -0400
Received: by mail-io0-f175.google.com with SMTP id t74so197728766ioi.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 04:51:28 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id m133sm1514965ioa.23.2016.07.06.04.51.25
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 04:51:26 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
 <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org>
 <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au>
 <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
 <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au>
 <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
 <70f12c1b-8d30-c5f7-faa8-10a86a49c332@crc.id.au>
 <CAJCQCtR+S7mVSKiDSLOnJ+CjCwtmpj9w=pFDK_chHCqpcV-+Ww@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a3ce663f-6df5-e662-f3c2-a11f44f46715@gmail.com>
Date: Wed, 6 Jul 2016 07:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR+S7mVSKiDSLOnJ+CjCwtmpj9w=pFDK_chHCqpcV-+Ww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-05 19:05, Chris Murphy wrote:
> Related:
> http://www.spinics.net/lists/raid/msg52880.html
>
> Looks like there is some traction to figuring out what to do about
> this, whether it's a udev rule or something that happens in the kernel
> itself. Pretty much the only hardware setup unaffected by this are
> those with enterprise or NAS drives. Every configuration of a consumer
> drive, single, linear/concat, and all software (mdadm, lvm, Btrfs)
> RAID Levels are adversely affected by this.
The thing I don't get about this is that while the per-device settings 
on a given system are policy, the default value is not, and should be 
expected to work correctly (but not necessarily optimally) on as many 
systems as possible, so any claim that this should be fixed in udev are 
bogus by the regular kernel rules.
>
> I suspect, but haven't tested, that ZFS On Linux would be equally
> affected, unless they're completely reimplementing their own block
> layer (?) So there are quite a few parties now negatively impacted by
> the current default behavior.
OTOH, I would not be surprised if the stance there is 'you get no 
support if your not using enterprise drives', not because of the project 
itself, but because it's ZFS.  Part of their minimum recommended 
hardware requirements is ECC RAM, so it wouldn't surprise me if 
enterprise storage devices are there too.

