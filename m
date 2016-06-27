Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35804 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbcF0VCu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 17:02:50 -0400
Received: by mail-vk0-f47.google.com with SMTP id j2so248662937vkg.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 14:02:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
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
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 27 Jun 2016 23:02:47 +0200
Message-ID: <CAPmG0jaKTn_oVmsCc4j--VBjYxUmn=Tsr8ucQHrBXfTHF5J5Ww@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 6:17 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Jun 27, 2016 at 5:21 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-06-25 12:44, Chris Murphy wrote:
>>>
>>> On Fri, Jun 24, 2016 at 12:19 PM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>
>>>> Well, the obvious major advantage that comes to mind for me to
>>>> checksumming
>>>> parity is that it would let us scrub the parity data itself and verify
>>>> it.
>>>
>>>
>>> OK but hold on. During scrub, it should read data, compute checksums
>>> *and* parity, and compare those to what's on-disk - > EXTENT_CSUM in
>>> the checksum tree, and the parity strip in the chunk tree. And if
>>> parity is wrong, then it should be replaced.
>>
>> Except that's horribly inefficient.  With limited exceptions involving
>> highly situational co-processors, computing a checksum of a parity block is
>> always going to be faster than computing parity for the stripe.  By using
>> that to check parity, we can safely speed up the common case of near zero
>> errors during a scrub by a pretty significant factor.
>
> OK I'm in favor of that. Although somehow md gets away with this by
> computing and checking parity for its scrubs, and still manages to
> keep drives saturated in the process - at least HDDs, I'm not sure how
> it fares on SSDs.

What I read in this thread clarifies the different flavors of errors I
saw when trying btrfs raid5 while corrupting 1 device or just
unexpectedly removing a device and replacing it with a fresh one.
Especially the lack of parity csums I was not aware of and I think
this is really wrong.

Consider a 4 disk btrfs raid10 and a 3 disk btrfs raid5. Both protect
against the loss of 1 device or badblocks on 1 device. In the current
design (unoptimized for performance), raid10 reads from 2 disk and
raid5 as well (as far as I remember) per task/process.
Which pair of strips for raid10 is pseudo-random AFAIK, so one could
get low throughput if some device in the array is older/slower and
that one is picked. From device to fs logical layer is just a simple
function, namely copy, so having the option to keep data in-place
(zerocopy). The data is at least read by the csum check and in case of
failure, the btrfs code picks the alternative strip and corrects etc.

For raid5, assuming it does avoid the parity in principle, it is also
a strip pair and csum check. In case of csum failure, one needs the
parity strip parity calculation. To me, It looks like that the 'fear'
of this calculation has made raid56 as a sort of add-on, instead of a
more integral part.

Looking at raid6 perf test at boot in dmesg, it is 30GByte/s, even
higher than memory bandwidth. So although a calculation is needed in
case data0strip+paritystrip would be used instead of
data0strip+data1strip, I think looking at total cost, it can be
cheaper than spending time on seeks, at least on HDDs. If the parity
calculation is treated in a transparent way, same as copy, then there
is more flexibility in selecting disks (and strips) and enables easier
design and performance optimizations I think.

>> The ideal situation that I'd like to see for scrub WRT parity is:
>> 1. Store checksums for the parity itself.
>> 2. During scrub, if the checksum is good, the parity is good, and we just
>> saved the time of computing the whole parity block.
>> 3. If the checksum is not good, then compute the parity.  If the parity just
>> computed matches what is there already, the checksum is bad and should be
>> rewritten (and we should probably recompute the whole block of checksums
>> it's in), otherwise, the parity was bad, write out the new parity and update
>> the checksum.

This 3rd point: if parity matches but csum is not good, then there is
a btrfs design error or some hardware/CPU/memory problem. Compare with
btrfs raid10: if the copies match but csum wrong, then there is
something fatally wrong. Just the first step, csum check and if wrong,
it would mean you generate the assumed corrupt strip newly from the 3
others. And for 3 disk raid5 from the 2 others, whether it is copying
or paritycalculation.

>> 4. Have an option to skip the csum check on the parity and always compute
>> it.
