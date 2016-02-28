Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:33604 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbcB1KXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 05:23:22 -0500
Received: by mail-wm0-f48.google.com with SMTP id l68so2409524wml.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 02:23:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO8qraHMxmqtO1-BQWMOm2943HHxaQ3-jPorT3Auu011ow@mail.gmail.com>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
	<pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
	<CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
	<565E0356.9030006@gmail.com>
	<CA+WRLO-VSOH1QUHTXFGzCSUKW=mRoufmUpYG8xRB4N80+rHmjg@mail.gmail.com>
	<CA+WRLO_1bLpve50YkuGD4wDxyO_e=4u9xev8y4XxZT9L01KxDQ@mail.gmail.com>
	<pan$c5c73$162474d7$f06e12fa$496fb5f@cox.net>
	<565EE329.3050902@gmail.com>
	<pan$85c2b$46f55be$d534ced$bd1aab07@cox.net>
	<565F00E0.6040204@gmail.com>
	<CA+WRLO8qraHMxmqtO1-BQWMOm2943HHxaQ3-jPorT3Auu011ow@mail.gmail.com>
Date: Sun, 28 Feb 2016 21:23:20 +1100
Message-ID: <CA+WRLO9Ls=E96ZQYt2PdAE1veBtayhv0uvP9tFjWnuwY-9XNOA@mail.gmail.com>
Subject: Re: utils version and convert crash
From: Gareth Pye <gareth@cerberos.id.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just noting that I left things till I put a 4.4 kernel on (4.4.3 as it
turns out) and now convert is going much nicer.

Well it's still got some silly thing where the newly allocated blocks
are mostly empty. It appears that the convert likes to take the 1Gig
RAID1 block and write it to a new RAID5 block (6x1Gig=5Gig capacity).
Meaning that the disks are likely to hit full during the convert. To
avoid that I'm looping a convert with a block limit with a balance to
target those blocks. The balance is pretty quick, but it does slow the
process down.

On Thu, Dec 3, 2015 at 9:14 AM, Gareth Pye <gareth@cerberos.id.au> wrote:
> Yeah having a scrub take 9 hours instead of 24 (+ latency of human
> involvement) would be really nice.
>
> On Thu, Dec 3, 2015 at 1:32 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-12-02 08:45, Duncan wrote:
>>>
>>> Austin S Hemmelgarn posted on Wed, 02 Dec 2015 07:25:13 -0500 as
>>> excerpted:
>>>
>>>> On 2015-12-02 05:01, Duncan wrote:
>>>
>>>
>>> [on unverified errors returned by scrub]
>>>>>
>>>>>
>>>>> Unverified errors are, I believe[1], errors where a metadata block
>>>>> holding checksums itself has an error, so the blocks its checksums in
>>>>> turn covered are not checksum-verified.
>>>>>
>>>>> What that means in practice is that once the first metadata block error
>>>>> has been corrected in a first scrub run, a second scrub run can now
>>>>> check the blocks that were recorded as unverified errors in the first
>>>>> run, potentially finding and hopefully fixing additional errors[.]
>>>
>>>
>>>>> ---
>>>>> [1] I'm not a dev and am not absolutely sure of the technical accuracy
>>>>> of this description, but from an admin's viewpoint it seems to be
>>>>> correct at least in practice, based on the fact that further scrubs as
>>>>> long as there were unverified errors often did find additional errors,
>>>>> while once the unverified count dropped to zero and the last read
>>>>> errors were corrected, further scrubs turned up no further errors.
>>>>>
>>>> AFAICT from reading the code, that is a correct assessment.  It would be
>>>> kind of nice though if there was some way to tell scrub to recheck up to
>>>> X many times if there are unverified errors...
>>>
>>>
>>> Yes.  For me as explained it wasn't that big a deal as another scrub was
>>> another minute or less, but definitely on terabyte-scale filesystems on
>>> spinning rust, where scrubs take hours, having scrub be able to
>>> automatically track just the corrected errors along with their
>>> unverifieds, and rescan just those, should only take a matter of a few
>>> minutes more, while a full rescan of /everything/ would take the same
>>> number of hours yet again... and again if there's a third scan required,
>>> etc.
>>>
>>> I'd say just make it automatic on corrected metadata errors as I can't
>>> think of a reason people wouldn't want it, given the time it would save
>>> over rerunning a full scrub over and over again, but making it an option
>>> would be fine with me too.
>>>
>> I was thinking an option to do a full re-scrub, but having an automatic
>> reparse of the metadata in a fixed metadata block would be a lot more
>> efficient that what I was thinking :)
>>
>
>
>
> --
> Gareth Pye - blog.cerberos.id.au
> Level 2 MTG Judge, Melbourne, Australia
> "Dear God, I would like to file a bug report"



-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
