Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav21.altibox.net ([109.247.116.8]:53236 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3KTKml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 05:42:41 -0500
Message-ID: <528C8F8E.9030908@hesbynett.no>
Date: Wed, 20 Nov 2013 11:31:42 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: Andrea Mazzoleni <amadvance@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<528B3A6F.2010304@hesbynett.no> <CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
In-Reply-To: <CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/11/13 18:36, Andrea Mazzoleni wrote:
> Hi David,
> 
> Just to say that I know your good past work, and it helped me a lot.
> Thanks for that!

If we end up with your Cauchy matrix implementation going into the
kernel and btrfs (and you've persuaded me, anyway), then perhaps I
should make a new version of that document with the Cauchy matrix maths.
 I know I have found Peter's original Raid 6 document very useful and
informative, and I think it would be good to have an equivalent here
too.  A lot of people find the maths of Raid 6 hard to grasp - it
doesn't get easier with triple parity, and such documentation could help
future kernel/btrfs developers.

> 
> Unfortunately the Cauchy matrix is not compatible with a triple parity
> implementation using power coefficients. They are different and
> incompatible roads.

Yes.  I haven't worked through all the details of how Cauchy matrices
work - but I have read enough to see that this is correct.

I am sure that it is /possible/ to make matrices that have the first
three rows matching the power coefficient triple parity with at least 6
rows in total and a useful horizontal size that have the required
property (all square submatrices are invertible) - but I have no idea
how to find such matrices in a sensible time frame.  The key point with
the Cauchy matrix is not the particular form of the coefficients, but
that it gives a way to generate coefficients easily.

> 
> I partially agree on your considerations, and in fact in my sources
> you can also see an alternate triple parity implementation using powers
> of 2^-1 == 1/2 == 0x8e, intended for CPUs not supporting PSHUFB.
> This is faster than using powers of 2^2 == 4, because we can divide
> by 2 as fast as we can multiply by 2.
> The choice of ZFS to use powers of 4 was likely not optimal,
> because to multiply by 4, it has to do two multiplications by 2.

I can agree with that.  I didn't copy ZFS's choice here (I knew that ZFS
/had/ triple parity, but I think my suggestion is not exactly the same)
- I just reached the same conclusion that since we have an operation
that works fast, doing it twice is not going to be an unreasonable cost.
 It hadn't occurred to me that dividing by 2 was equally easy.

> Also this method doesn't work for quad parity, because it fails with
> more than 16 data disks.

Indeed.

> 
> What I tend to do not agree, is to give too importance to low end
> architectures, that don't support PSHUFB or similar instruction.
> Such architectures can just stay with two parity levels.

That's certainly a reasonable way to look at it.  We should not limit
the possibilities for high-end systems because of the limitations of
low-end systems that are unlikely to use 3+ parity anyway.  I've also
looked up a list of the processors that support SSE3 and PSHUFB - a lot
of modern "low-end" x86 cpus support it.  And of course it is possible
to implement general G(2^8) multiplication without PSHUFB, using a
lookup table - it is important that this can all work with any CPU, even
if it is slow.

> Consider that to have a fast recovering (running in degraded mode)
> you need anyway PSHUFB to have acceptable performance.

I don't think we need to be very concerned with fast recovery using the
third (or more) parity.  If one disk (or sector on a disk) has failed,
recovery is done with the RAID5 parity block.  If we have two failures,
we can use the RAID6 procedure (I haven't looked at the implementation
for this at the moment, or for your PSHUFB code - but since RAID6
recovery also involves general multiplication, there may be scope for
speedups here).  It is only with three simultaneous failures that we
need to use additional parities - such situations should be very rare.
Typically this would be only for stripes with unrecoverable read errors
found while rebuilding for another missed disk or two.

Of course, it is always nice to have fast recovery - but fast generation
of parities is far more important.

> In my system I can generate triple parity at 10GB/s using SSE2,
> but recover only at 100MB/s without SSSE3 PSHUFB. It's a slowdown
> of x100! With PSHUFB is a bit better and I can recover at 500MB/s.

The difference here is bigger than I would have guessed, but I haven't
looked at the code yet.

> Note also that the ARM NEON architecture introduced the VTBL
> instruction, and AMD introduced VPPERM, that could be used like
> PSHUFB.

Sounds good - at least it will be fun trying to figure out optimal code.

> 
> For the complexity point of view, I don't any see difference between
> the two methods.
> They are just two matrix with different coefficients sharing the same
> recovering functions. The only difference is in the optimized parity
> generation that uses SSSE3 instead of SSE2.

Recovery is the same, yes.  It is only the parity generation that is
different - multiplying by powers of 2 means each step is a fast
multiply-by-two, with Horner's rule to avoid any other multiplication.
With parity 3 generated as powers of 4 or 2^-1, you have the same system
with only a slightly slower multiply-by-4 step.  With the Cauchy matrix,
you need general multiplication with different coefficients for each
disk block.  This is significantly more complex - but if it can be done
fast enough on at least a reasonable selection of processors, it's okay
to be complex.

> 
> Anyway, I cannot tell what is the best option for Linux RAID and Btrfs.
> There are for sure better qualified people in this list to say that.

I think H. Peter Anvin is the best qualified for such decisions - I
believe he has the most experience and understanding in this area.

For what it is worth, you have convinced /me/ that your Cauchy matrices
are the way to go.  I will want to study your code a bit more, and try
it out for myself, but it looks like you have a way to overcome the
limitations of the power sequence method without too big runtime costs -
and that is exactly what we need.

> I can just say that systems using multiple parity levels do exist, and
> maybe also the Linux Kernel could benefit to have such kind of support.

I certainly think so.  I think 3 parities is definitely useful, and
sometimes four would be nice.  Beyond that, I suspect "coolness" and
bragging rights (btrfs can support more parities than ZFS...) will
outweigh real-life implementations, so it is important that the
implementation does not sacrifice anything on the triple parity in order
to get 5+ parity support.  It's fine for /us/ to look at fun solutions,
but it needs to be practical too if it is going to be accepted in the
kernel.

mvh.,

David

> 
> Here some examples:
> 
> Oracle/Sun, Dell/Compellent ZFS: 3 parity drives
> NEC HydraStor: 3 parity drives
> EMC/Isilon: 4 parity drives
> Amplidata: 4 parity drives
> CleverSafe: 6 parity drives
> StreamScale/BigParity: 7 parity drives
> 
> And Btrfs with six parities would be surely cool :)
> 
> Ciao,
> Andrea
> 
> On Tue, Nov 19, 2013 at 11:16 AM, David Brown <david.brown@hesbynett.no> wrote:
>> On 19/11/13 00:25, H. Peter Anvin wrote:
>>> On 11/18/2013 02:35 PM, Andrea Mazzoleni wrote:
>>>> Hi Peter,
>>>>
>>>> The Cauchy matrix has the mathematical property to always have itself
>>>> and all submatrices not singular. So, we are sure that we can always
>>>> solve the equations to recover the data disks.
>>>>
>>>> Besides the mathematical proof, I've also inverted all the
>>>> 377,342,351,231 possible submatrices for up to 6 parities and 251 data
>>>> disks, and got an experimental confirmation of this.
>>>>
>>>
>>> Nice.
>>>
>>>>
>>>> The only limit is coming from the GF(2^8). You have a maximum number
>>>> of disk = 2^8 + 1 - number_of_parities. For example, with 6 parities,
>>>> you can have no more of 251 data disks. Over this limit it's not
>>>> possible to build a Cauchy matrix.
>>>>
>>>
>>> 251?  Not 255?
>>>
>>>> Note that instead with a Vandermonde matrix you don't have the
>>>> guarantee to always have all the submatrices not singular. This is the
>>>> reason because using power coefficients, before or late, it happens to
>>>> have unsolvable equations.
>>>>
>>>> You can find the code that generate the Cauchy matrix with some
>>>> explanation in the comments at (see the set_cauchy() function) :
>>>>
>>>> http://sourceforge.net/p/snapraid/code/ci/master/tree/mktables.c
>>>
>>> OK, need to read up on the theoretical aspects of this, but it sounds
>>> promising.
>>>
>>>       -hpa
>>>
>>
>> Hi all,
>>
>> A while back I worked through the maths for a method of extending raid
>> to multiple parities, though I never got as far as implementing it in
>> code (other than some simple Python test code to confirm the maths).  It
>> is also missing the maths for simplified ways to recover data.  I've
>> posted a couple of times with this on the linux-raid mailing list (as
>> linked in this thread) - there has certainly been some interest, but
>> it's not easy to turn interest into hard work!
>>
>> I used an obvious expansion on the existing RAID5 and RAID6 algorithms,
>> with parity P_n being generated from powers of 2^n.  This means that the
>> triple-parity version can be implemented by simply applying the RAID6
>> operations twice.  For a triple parity, this works well - the matrices
>> involved are all invertible up to 255 data disks.  Beyond that, however,
>> things drop off rapidly - quad parity implemented in the same way only
>> supports 21 data disks, and for five parity disks you need to use 0x20
>> (skipping 0x10) to get even 8 data disks.
>>
>> This means that my method would be fine for triple parity, and would
>> also be efficient in implementation.
>>
>> Beyond triple parity, the simple method has size limits for four parity
>> and is no use on anything bigger.  The Cauchy matrix method lets us go
>> beyond that (I haven't yet studied your code and your maths - I will do
>> so as soon as I have the chance, but I doubt if that will be before the
>> weekend).
>>
>> Would it be possible to use the simple parity system for the first three
>> parities, and Cauchy beyond that?  That would give the best of both worlds.
>>
>>
>>
>> The important thing to think about here is what would actually be useful
>> in the real world.  It is always nice to have a system that can make an
>> array with 251 data disks and 6 parities (and I certainly think the
>> maths involved is fun), but would anyone use such a beast?
>>
>> Triple parity has clear use cases.  As people have moved up from raid5
>> to raid6, "raid7" or "raid6-3p" would be an obvious next step.  I also
>> see it as being useful for maintenance on raid6 arrays - if you want to
>> replace disks on a raid6 array you could first add a third parity disk
>> with an asymmetric layout, then you could replace the main disks while
>> keeping two disk redundancy at all times.
>>
>> Quad parity is unlikely, I think - you would need a very wide array and
>> unusual requirements to make quad parity a better choice than a layered
>> system of raid10 or raid15.  At most, I think it would find use as a
>> temporary security while maintaining a triple-raid array.  Remember also
>> that such an array would be painfully slow if it ever needed to rebuild
>> data with four missing disks - and if it is then too slow to be usable,
>> then quad parity is not a useful solution.
>>
>>
>> (Obviously anyone with /real/ experience with large arrays can give
>> better ideas here - I like the maths of multi-parity raid, but I will
>> not it for my small arrays.)
>>
>>
>>
>> Of course I will enjoy studying your maths here, and I'll try to give
>> some feedback on it.  But I think for implementation purposes, the
>> simple "powers of 4" generation of triple parity would be better than
>> using the Cauchy matrix - it is a clear step from the existing raid6,
>> and it can work fast on a wide variety of processors (people use ARMs
>> and other "small" cpus on raids, not just x86 with SSE3).  I believe
>> that would mean simpler code and fewer changes, which is always popular
>> with the kernel folk.
>>
>> However, if it is not possible to use Cauchy matrices to get four and
>> more parity while keeping the same first three parities, then the
>> balance changes and a decision needs to be made - do we (the Linux
>> kernel developers, the btrfs developers, and the users) want a simpler
>> system that is limited to triple parity (or quad parity with 21 + 4
>> disks), or do we want a more complex but more flexible system?
>>
>> Personally, I don't mind either way, as long as we get a good technical
>> solution.  And I'll do what I can to help with the maths in either case.
>>
>> David
>>
>>
> 

