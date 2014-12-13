Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:47704 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933210AbaLMDKj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 22:10:39 -0500
Message-ID: <548BAE2C.6000508@pobox.com>
Date: Fri, 12 Dec 2014 19:10:36 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: A note on spotting "bugs" [Was: ENOSPC after conversion]
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>	<548A13F7.30904@pobox.com>	<CAA7pwKNKeuysdoS83m=z-Cn5ecWtGrQAfjNKwXjryRceHUV=3Q@mail.gmail.com>	<548AEDD6.1090904@pobox.com> <pan$93dc7$f46dda26$f7d33e3f$b328e05d@cox.net>
In-Reply-To: <pan$93dc7$f46dda26$f7d33e3f$b328e05d@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 05:12 PM, Duncan wrote:
> Robert White posted on Fri, 12 Dec 2014 05:29:58 -0800 as excerpted:
>
>> This still doesnt say _anything_ is wrong with your filesystem except
>> that it doesn't have enough _raw_ space to create a 2-ish gig extent.
>
> What's wrong with the filesystem is that there shouldn't /be/ a need to
> create a 2-ish gig extent.  All btrfs native structures are 1 GiB each or
> smaller, and the completed-without-error btrfs fi defrag should have
> eliminated any > 1 GiB structures remaining from the conversion from
> ext*, such that btrfs balance only has to deal with <= 1 GiB structures.
>
> So that balance is having to deal with a 2-ish gig extent at all is
> indicative of a bug.  Balance isn't prepared to have to allocate 2-ish
> GiB extents in the first place as that's beyond it's design specs.
>

Looking at the error message and the code, I would strongly disagree.

Balance has no hard-coded limit of 1-Gig.

The superblock has entries for the various sizes the filesystem uses.

Balance is _clearly_ asking for the chunk of that size and the system 
configuraion is _clearly_ considering that size legal.

The structures are only limited by their 64bit unsigned integer 
representation which is _way_ bigger than 2-ish gigs.

The actual code that controls the 1GiB extent allocation does a 
(paraphrased) :: min(requested,system_minimum_for_this_purpose)

Indeed, if it were a hard limit of 1GiB, then the message wouldn't even 
bother to say how much was requested, it would just say "Could not 
allocate data extent" because that extent would have both a minimum and 
maxium of the same known value.

Nowhere in or near the allocator does it do a test that I can find that 
would force the number to be smaller. And if it did, that wouldn't be a 
"ENOSPC" etc, it'd come back as a "too big" result such as ENOSUP.

So your statement that this is "beyond its design specs" isn't supported 
by the code. (That's why I looked it up the before I said "this is not a 
bug").

I went through the code until I accounted for _ever_ _word_ in the error 
message.

I don't see any kind of bug.

And now that we know that btrfs-convert has to make larger-than-one-GiB 
extents to encompass the block groups that are preexistent in EXT4, we 
also know that the sliding-block puzzle its trying to solve doesn't have 
nice round numbers of 1GiB and 256MiB, so the holes it leaves behind 
when it does move something are not nice and square and evenly sized etc.

So yea, he's jammed up and needs more space. As his filesystem churns 
all its new extents will be the 1GiB or 256MiB sized things and he'd 
slowly, but perhaps asymptotically, approach a clean layout of customary 
extent sizes.

It's not broken, it's just not pretty.

And _IF_ I had been saying it's "not a bug" and any of the actual code 
contributors had disagreed, they'd have jumped in here and shut me down 
(as they should in that case). e.g. If I was wrong about its non-bug 
status we'd have heard by now.


