Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35762 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcF0QRM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 12:17:12 -0400
Received: by mail-oi0-f50.google.com with SMTP id r2so207210188oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 09:17:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org> <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk> <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 10:17:04 -0600
Message-ID: <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
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

On Mon, Jun 27, 2016 at 5:21 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-06-25 12:44, Chris Murphy wrote:
>>
>> On Fri, Jun 24, 2016 at 12:19 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>
>>> Well, the obvious major advantage that comes to mind for me to
>>> checksumming
>>> parity is that it would let us scrub the parity data itself and verify
>>> it.
>>
>>
>> OK but hold on. During scrub, it should read data, compute checksums
>> *and* parity, and compare those to what's on-disk - > EXTENT_CSUM in
>> the checksum tree, and the parity strip in the chunk tree. And if
>> parity is wrong, then it should be replaced.
>
> Except that's horribly inefficient.  With limited exceptions involving
> highly situational co-processors, computing a checksum of a parity block is
> always going to be faster than computing parity for the stripe.  By using
> that to check parity, we can safely speed up the common case of near zero
> errors during a scrub by a pretty significant factor.

OK I'm in favor of that. Although somehow md gets away with this by
computing and checking parity for its scrubs, and still manages to
keep drives saturated in the process - at least HDDs, I'm not sure how
it fares on SSDs.




> The ideal situation that I'd like to see for scrub WRT parity is:
> 1. Store checksums for the parity itself.
> 2. During scrub, if the checksum is good, the parity is good, and we just
> saved the time of computing the whole parity block.
> 3. If the checksum is not good, then compute the parity.  If the parity just
> computed matches what is there already, the checksum is bad and should be
> rewritten (and we should probably recompute the whole block of checksums
> it's in), otherwise, the parity was bad, write out the new parity and update
> the checksum.
> 4. Have an option to skip the csum check on the parity and always compute
> it.
>>
>>
>> Even check > md/sync_action does this. So no pun intended but Btrfs
>> isn't even at parity with mdadm on data integrity if it doesn't check
>> if the parity matches data.
>
> Except that MD and LVM don't have checksums to verify anything outside of
> the very high-level metadata.  They have to compute the parity during a
> scrub because that's the _only_ way they have to check data integrity.  Just
> because that's the only way for them to check it does not mean we have to
> follow their design, especially considering that we have other, faster ways
> to check it.

I'm not opposed to this optimization. But retroactively better
qualifying my previous "major advantage" what I meant was in terms of
solving functional deficiency.



>> The much bigger problem we have right now that affects Btrfs,
>> LVM/mdadm md raid, is this silly bad default with non-enterprise
>> drives having no configurable SCT ERC, with ensuing long recovery
>> times, and the kernel SCSI command timer at 30 seconds - which
>> actually also fucks over regular single disk users also because it
>> means they don't get the "benefit" of long recovery times, which is
>> the whole g'd point of that feature. This itself causes so many
>> problems where bad sectors just get worse and don't get fixed up
>> because of all the link resets. So I still think it's a bullshit
>> default kernel side because it pretty much affects the majority use
>> case, it is only a non-problem with proprietary hardware raid, and
>> software raid using enterprise (or NAS specific) drives that already
>> have short recovery times by default.
>
> On this, we can agree.

It just came up again in a thread over the weekend on linux-raid@. I'm
going to ask while people are paying attention if a patch to change
the 30 second time out to something a lot higher has ever been
floated, what the negatives might be, and where to get this fixed if
it wouldn't be accepted in the kernel code directly.

*Ideally* I think we'd want two timeouts. I'd like to see commands
have a timer that results in merely a warning that could be used by
e.g. btrfs scrub to know "hey this sector range is 'slow' I'm going to
write over those sectors". That's how bad sectors start out, they read
slower and eventually go beyond 30 seconds and now it's all link
resets. If the problem could be fixed before then... that's the best
scenario.

The 2nd timer would be, OK the controller or drive just face planted, reset.

-- 
Chris Murphy
