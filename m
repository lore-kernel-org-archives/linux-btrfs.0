Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav21.altibox.net ([109.247.116.8]:48766 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3KUUbw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 15:31:52 -0500
Message-ID: <528E6DB2.6050005@hesbynett.no>
Date: Thu, 21 Nov 2013 21:31:46 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
CC: Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <20131119181237.GA3666@lazy.lzy> <528C9297.9030801@hesbynett.no> <20131120215939.GA2622@lazy.lzy> <528DDCC9.7050701@hesbynett.no> <20131121200545.GB1916@lazy.lzy>
In-Reply-To: <20131121200545.GB1916@lazy.lzy>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/11/13 21:05, Piergiorgio Sartor wrote:
> On Thu, Nov 21, 2013 at 11:13:29AM +0100, David Brown wrote:
> [...]
>> Ah, you are trying to find which disk has incorrect data so that you can
>> change just that one disk?  There are dangers with that...
> 
> Hi David,
> 
>> <http://neil.brown.name/blog/20100211050355>
> 
> I think we already did the exercise, here :-)
> 
>> If you disagree with this blog post (and I urge you to read it in full
> 
> We discussed the topic (with Neil) and, if I
> recall correctly, he is agaist having an
> _automatic_ error detectio and correction _in_
> kernel.
> I fully agree with that: user space is better
> and it should not be automatic, but it should
> do things under user control.
> 

OK.

> The current "check" operetion is pretty poor.
> It just reports how many mismatches, it does
> not even report where in the array.
> The first step, independent from how many
> parities one has, would be to tell the user
> where the mismatches occurred, so it would
> be possible to check the FS at that position.

Certainly it would be good to give the user more information.  If you
can tell the user where the errors are, and what the likely failed block
is, then that would be very useful.  If you can tell where it is in the
filesystem (such as which file, if any, owns the blocks in question)
then that would be even better.

> Having a multi parity RAID allows to check
> even which disk.
> This would provide the user with a more
> comprehensive (I forgot the spelling)
> information.
> 
> Of course, since we are there, we can
> also give the option to fix it.
> This would be much likely a "fsck".

If this can all be done to give the user an informed choice, then it
sounds good.

One issue here is whether the check should be done with the filesystem
mounted and in use, or only off-line.  If it is off-line then it will
mean a long down-time while the array is checked - but if it is online,
then there is the risk of confusing the filesystem and caches by
changing the data.

> 
>> first), then this is how I would do a "smart" stripe recovery:
>>
>> First calculate the parities from the data blocks, and compare these
>> with the existing parity blocks.
>>
>> If they all match, the stripe is consistent.
>>
>> Normal (detectable) disk errors and unrecoverable read errors get
>> flagged by the disk and the IO system, and you /know/ there is a problem
>> with that block.  Whether it is a data block or a parity block, you
>> re-generate the correct data and store it - that's what your raid is for.
> 
> That's not always the case, otherwise
> having the mismatch count would be useless.
> The issue is that errors appear, whatever
> the reason, without being reported by the
> underlying hardware.
>  

(I know you know how this works, so I am not trying to be patronising
with this explanation - I just think we have slightly misunderstood what
the other is saying, so spelling it out will hopefully make it clearer.)

Most disk errors /are/ detectable, and are reported by the underlying
hardware - small surface errors are corrected by the disk's own error
checking and correcting mechanisms, and larger errors are usually
detected.  It is (or should be!) very rare that a read error goes
undetected without there being a major problem with the disk controller.
 And if the error is detected, then the normal raid processing kicks in
as there is no doubt about which block has problems.

>> If you have no detected read errors, and there is one parity
>> inconsistency, then /probably/ that block has had an undetected read
>> error, or it simply has not been written completely before a crash.
>> Either way, just re-write the correct parity.
> 
> Why re-write the parity if I can get
> the correct data there?
> If can be sure that one data block is
> incorrect and I can re-create properly,
> that's the thing to do.

If you can be /sure/ about which data block is incorrect, then I agree -
but you can't be /entirely/ sure.  But I agree that you can make a good
enough guess to recommend a fix to the user - as long as it is not
automatic.

>  
>> Remember, this is not a general error detection and correction scheme -
> 
> It is not, but it could be. For free.
> 

For most ECC schemes, you know that all your blocks are set
synchronously - so any block that does not fit in, is an error.  With
raid, it could also be that a stripe is only partly written - you can
have two different valid sets of data mixed to give an inconsistent
stripe, without any good way of telling what consistent data is the best
choice.

Perhaps a checking tool can take advantage of a write-intent bitmap (if
there is one) so that it knows if an inconsistent stripe is partly
updated or the result of a disk error.

mvh.,

David


