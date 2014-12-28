Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:39696 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbaL1AZr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 19:25:47 -0500
Message-ID: <549F4E0A.9090700@pobox.com>
Date: Sat, 27 Dec 2014 16:25:46 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <34633403.WlleJmkifE@merkaba> <549ECCD8.6090307@pobox.com> <1694920.QVWA5EcL6C@merkaba>
In-Reply-To: <1694920.QVWA5EcL6C@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2014 08:01 AM, Martin Steigerwald wrote:
>>From how you write I get the impression that you think everyone else
> beside you is just silly and dumb. Please stop this assumption. I may not
> always get terms right, and I may make a mistake as with the wrong df
> figure. But I also highly dislike to feel treated like someone who doesn´t
> know a thing.

Nope. I'm a systems theorist and I demand/require variable isolation.

Not a question of "silly" or "dumb" but a question of "speaking with 
sufficient precision and clarity".

For instance you speak of "having an impression" and then decide I've 
made an assumption.

I define my position. Explain my terms. Give my examples.

I also risk being utterly wrong because sometimes being completely wrong 
gets others to cut away misconceptions and assumptions.

It annoys some people, but it gets results. You've been going around on 
this topic for how long? and just today Hugo "got" that your problem is 
becoming CPU bound (long process) instead of a hard lockup. We've 
stopped talking about "trees" and started talking about free space 
management. We've stopped talking about 17G of free space and gotten 
down to the 5 or so, plus you've gotten angry at me, tried to prove me 
an idiot, and so produced test cases and data that is absolutely clear 
including steps to reproduce.

In real life I work on mission critical systems that can get people 
killed when they fail. So I have developed the reflex of tenacity in 
getting everyone using the same words, talking about the same concepts, 
giving concrete examples, and generally bringing the discussion to a 
very precise head.

Example: I had two parties in conflict about a system. One party said 
that every time they did "an orderly shutdown" the device would hang in 
a way that took days to recover from. The other party would examine the 
device and say "could not reproduce". Turns out that the two parties 
were doing entirely different (but both correct) sequences for "orderly 
shutdown". They'd been having that conflict for more than a year. But 
since they both _knew_ what an "orderly shutdown" was, they _never_ 
analyzed what they were saying. (turns out one procedure left a chip in 
a state that it wouldn't restart until a capacitor discharged, and the 
other procedure did not.)

So yea, when people make statements that "everybody understands" and 
those statements don't agree. I start slicing concepts off one at a time...

It's not about "dumb" or "silly" it's about exact and accurate 
descriptions that have been stripped of assumptions and tribal knowledge.

And I don't care if I come off looking like "the bad guy" because I 
don't believe in "the bad guy" at all when it comes to making things 
more clear and getting out of a communications deadlock. My only goal is 
"less broken".

So occasionally annoying... but look... progress!
