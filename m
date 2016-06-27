Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36407 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbcF0LWL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 07:22:11 -0400
Received: by mail-io0-f175.google.com with SMTP id s63so145435517ioi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 04:22:05 -0700 (PDT)
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
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
Date: Mon, 27 Jun 2016 07:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-25 12:44, Chris Murphy wrote:
> On Fri, Jun 24, 2016 at 12:19 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> Well, the obvious major advantage that comes to mind for me to checksumming
>> parity is that it would let us scrub the parity data itself and verify it.
>
> OK but hold on. During scrub, it should read data, compute checksums
> *and* parity, and compare those to what's on-disk - > EXTENT_CSUM in
> the checksum tree, and the parity strip in the chunk tree. And if
> parity is wrong, then it should be replaced.
Except that's horribly inefficient.  With limited exceptions involving 
highly situational co-processors, computing a checksum of a parity block 
is always going to be faster than computing parity for the stripe.  By 
using that to check parity, we can safely speed up the common case of 
near zero errors during a scrub by a pretty significant factor.

The ideal situation that I'd like to see for scrub WRT parity is:
1. Store checksums for the parity itself.
2. During scrub, if the checksum is good, the parity is good, and we 
just saved the time of computing the whole parity block.
3. If the checksum is not good, then compute the parity.  If the parity 
just computed matches what is there already, the checksum is bad and 
should be rewritten (and we should probably recompute the whole block of 
checksums it's in), otherwise, the parity was bad, write out the new 
parity and update the checksum.
4. Have an option to skip the csum check on the parity and always 
compute it.
>
> Even check > md/sync_action does this. So no pun intended but Btrfs
> isn't even at parity with mdadm on data integrity if it doesn't check
> if the parity matches data.
Except that MD and LVM don't have checksums to verify anything outside 
of the very high-level metadata.  They have to compute the parity during 
a scrub because that's the _only_ way they have to check data integrity. 
  Just because that's the only way for them to check it does not mean we 
have to follow their design, especially considering that we have other, 
faster ways to check it.
>
>
>> I'd personally much rather know my parity is bad before I need to use it
>> than after using it to reconstruct data and getting an error there, and I'd
>> be willing to be that most seasoned sysadmins working for companies using
>> big storage arrays likely feel the same about it.
>
> That doesn't require parity csums though. It just requires computing
> parity during a scrub and comparing it to the parity on disk to make
> sure they're the same. If they aren't, assuming no other error for
> that full stripe read, then the parity block is replaced.
It does not require it, but it can make it significantly more efficient, 
and even a 1% increase in efficiency is a huge difference on a big array.
>
> So that's also something to check in the code or poke a system with a
> stick and see what happens.
>
>> I could see it being
>> practical to have an option to turn this off for performance reasons or
>> similar, but again, I have a feeling that most people would rather be able
>> to check if a rebuild will eat data before trying to rebuild (depending on
>> the situation in such a case, it will sometimes just make more sense to nuke
>> the array and restore from a backup instead of spending time waiting for it
>> to rebuild).
>
> The much bigger problem we have right now that affects Btrfs,
> LVM/mdadm md raid, is this silly bad default with non-enterprise
> drives having no configurable SCT ERC, with ensuing long recovery
> times, and the kernel SCSI command timer at 30 seconds - which
> actually also fucks over regular single disk users also because it
> means they don't get the "benefit" of long recovery times, which is
> the whole g'd point of that feature. This itself causes so many
> problems where bad sectors just get worse and don't get fixed up
> because of all the link resets. So I still think it's a bullshit
> default kernel side because it pretty much affects the majority use
> case, it is only a non-problem with proprietary hardware raid, and
> software raid using enterprise (or NAS specific) drives that already
> have short recovery times by default.
On this, we can agree.
