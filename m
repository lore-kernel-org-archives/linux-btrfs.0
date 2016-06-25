Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36244 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbcFYQoy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 12:44:54 -0400
Received: by mail-oi0-f44.google.com with SMTP id f189so153178861oig.3
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 09:44:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org> <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk> <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 25 Jun 2016 10:44:51 -0600
Message-ID: <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 12:19 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> Well, the obvious major advantage that comes to mind for me to checksumming
> parity is that it would let us scrub the parity data itself and verify it.

OK but hold on. During scrub, it should read data, compute checksums
*and* parity, and compare those to what's on-disk - > EXTENT_CSUM in
the checksum tree, and the parity strip in the chunk tree. And if
parity is wrong, then it should be replaced.

Even check > md/sync_action does this. So no pun intended but Btrfs
isn't even at parity with mdadm on data integrity if it doesn't check
if the parity matches data.


> I'd personally much rather know my parity is bad before I need to use it
> than after using it to reconstruct data and getting an error there, and I'd
> be willing to be that most seasoned sysadmins working for companies using
> big storage arrays likely feel the same about it.

That doesn't require parity csums though. It just requires computing
parity during a scrub and comparing it to the parity on disk to make
sure they're the same. If they aren't, assuming no other error for
that full stripe read, then the parity block is replaced.

So that's also something to check in the code or poke a system with a
stick and see what happens.

> I could see it being
> practical to have an option to turn this off for performance reasons or
> similar, but again, I have a feeling that most people would rather be able
> to check if a rebuild will eat data before trying to rebuild (depending on
> the situation in such a case, it will sometimes just make more sense to nuke
> the array and restore from a backup instead of spending time waiting for it
> to rebuild).

The much bigger problem we have right now that affects Btrfs,
LVM/mdadm md raid, is this silly bad default with non-enterprise
drives having no configurable SCT ERC, with ensuing long recovery
times, and the kernel SCSI command timer at 30 seconds - which
actually also fucks over regular single disk users also because it
means they don't get the "benefit" of long recovery times, which is
the whole g'd point of that feature. This itself causes so many
problems where bad sectors just get worse and don't get fixed up
because of all the link resets. So I still think it's a bullshit
default kernel side because it pretty much affects the majority use
case, it is only a non-problem with proprietary hardware raid, and
software raid using enterprise (or NAS specific) drives that already
have short recovery times by default.

This has been true for a very long time, maybe a decade. And it's such
complete utter crap that this hasn't been dealt with properly by any
party. No distribution has fixed this for their users. Upstream udev
hasn't dealt with it. And kernel folks haven't dealt with it. It's a
perverse joke on the user to do this out of the box.



-- 
Chris Murphy
