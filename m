Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:57572 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3KSRgF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 12:36:05 -0500
MIME-Version: 1.0
In-Reply-To: <528B3A6F.2010304@hesbynett.no>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<528B3A6F.2010304@hesbynett.no>
Date: Tue, 19 Nov 2013 18:36:03 +0100
Message-ID: <CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: David Brown <david.brown@hesbynett.no>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Just to say that I know your good past work, and it helped me a lot.
Thanks for that!

Unfortunately the Cauchy matrix is not compatible with a triple parity
implementation using power coefficients. They are different and
incompatible roads.

I partially agree on your considerations, and in fact in my sources
you can also see an alternate triple parity implementation using powers
of 2^-1 == 1/2 == 0x8e, intended for CPUs not supporting PSHUFB.
This is faster than using powers of 2^2 == 4, because we can divide
by 2 as fast as we can multiply by 2.
The choice of ZFS to use powers of 4 was likely not optimal,
because to multiply by 4, it has to do two multiplications by 2.
Also this method doesn't work for quad parity, because it fails with
more than 16 data disks.

What I tend to do not agree, is to give too importance to low end
architectures, that don't support PSHUFB or similar instruction.
Such architectures can just stay with two parity levels.
Consider that to have a fast recovering (running in degraded mode)
you need anyway PSHUFB to have acceptable performance.
In my system I can generate triple parity at 10GB/s using SSE2,
but recover only at 100MB/s without SSSE3 PSHUFB. It's a slowdown
of x100! With PSHUFB is a bit better and I can recover at 500MB/s.
Note also that the ARM NEON architecture introduced the VTBL
instruction, and AMD introduced VPPERM, that could be used like
PSHUFB.

For the complexity point of view, I don't any see difference between
the two methods.
They are just two matrix with different coefficients sharing the same
recovering functions. The only difference is in the optimized parity
generation that uses SSSE3 instead of SSE2.

Anyway, I cannot tell what is the best option for Linux RAID and Btrfs.
There are for sure better qualified people in this list to say that.
I can just say that systems using multiple parity levels do exist, and
maybe also the Linux Kernel could benefit to have such kind of support.

Here some examples:

Oracle/Sun, Dell/Compellent ZFS: 3 parity drives
NEC HydraStor: 3 parity drives
EMC/Isilon: 4 parity drives
Amplidata: 4 parity drives
CleverSafe: 6 parity drives
StreamScale/BigParity: 7 parity drives

And Btrfs with six parities would be surely cool :)

Ciao,
Andrea

On Tue, Nov 19, 2013 at 11:16 AM, David Brown <david.brown@hesbynett.no> wrote:
> On 19/11/13 00:25, H. Peter Anvin wrote:
>> On 11/18/2013 02:35 PM, Andrea Mazzoleni wrote:
>>> Hi Peter,
>>>
>>> The Cauchy matrix has the mathematical property to always have itself
>>> and all submatrices not singular. So, we are sure that we can always
>>> solve the equations to recover the data disks.
>>>
>>> Besides the mathematical proof, I've also inverted all the
>>> 377,342,351,231 possible submatrices for up to 6 parities and 251 data
>>> disks, and got an experimental confirmation of this.
>>>
>>
>> Nice.
>>
>>>
>>> The only limit is coming from the GF(2^8). You have a maximum number
>>> of disk = 2^8 + 1 - number_of_parities. For example, with 6 parities,
>>> you can have no more of 251 data disks. Over this limit it's not
>>> possible to build a Cauchy matrix.
>>>
>>
>> 251?  Not 255?
>>
>>> Note that instead with a Vandermonde matrix you don't have the
>>> guarantee to always have all the submatrices not singular. This is the
>>> reason because using power coefficients, before or late, it happens to
>>> have unsolvable equations.
>>>
>>> You can find the code that generate the Cauchy matrix with some
>>> explanation in the comments at (see the set_cauchy() function) :
>>>
>>> http://sourceforge.net/p/snapraid/code/ci/master/tree/mktables.c
>>
>> OK, need to read up on the theoretical aspects of this, but it sounds
>> promising.
>>
>>       -hpa
>>
>
> Hi all,
>
> A while back I worked through the maths for a method of extending raid
> to multiple parities, though I never got as far as implementing it in
> code (other than some simple Python test code to confirm the maths).  It
> is also missing the maths for simplified ways to recover data.  I've
> posted a couple of times with this on the linux-raid mailing list (as
> linked in this thread) - there has certainly been some interest, but
> it's not easy to turn interest into hard work!
>
> I used an obvious expansion on the existing RAID5 and RAID6 algorithms,
> with parity P_n being generated from powers of 2^n.  This means that the
> triple-parity version can be implemented by simply applying the RAID6
> operations twice.  For a triple parity, this works well - the matrices
> involved are all invertible up to 255 data disks.  Beyond that, however,
> things drop off rapidly - quad parity implemented in the same way only
> supports 21 data disks, and for five parity disks you need to use 0x20
> (skipping 0x10) to get even 8 data disks.
>
> This means that my method would be fine for triple parity, and would
> also be efficient in implementation.
>
> Beyond triple parity, the simple method has size limits for four parity
> and is no use on anything bigger.  The Cauchy matrix method lets us go
> beyond that (I haven't yet studied your code and your maths - I will do
> so as soon as I have the chance, but I doubt if that will be before the
> weekend).
>
> Would it be possible to use the simple parity system for the first three
> parities, and Cauchy beyond that?  That would give the best of both worlds.
>
>
>
> The important thing to think about here is what would actually be useful
> in the real world.  It is always nice to have a system that can make an
> array with 251 data disks and 6 parities (and I certainly think the
> maths involved is fun), but would anyone use such a beast?
>
> Triple parity has clear use cases.  As people have moved up from raid5
> to raid6, "raid7" or "raid6-3p" would be an obvious next step.  I also
> see it as being useful for maintenance on raid6 arrays - if you want to
> replace disks on a raid6 array you could first add a third parity disk
> with an asymmetric layout, then you could replace the main disks while
> keeping two disk redundancy at all times.
>
> Quad parity is unlikely, I think - you would need a very wide array and
> unusual requirements to make quad parity a better choice than a layered
> system of raid10 or raid15.  At most, I think it would find use as a
> temporary security while maintaining a triple-raid array.  Remember also
> that such an array would be painfully slow if it ever needed to rebuild
> data with four missing disks - and if it is then too slow to be usable,
> then quad parity is not a useful solution.
>
>
> (Obviously anyone with /real/ experience with large arrays can give
> better ideas here - I like the maths of multi-parity raid, but I will
> not it for my small arrays.)
>
>
>
> Of course I will enjoy studying your maths here, and I'll try to give
> some feedback on it.  But I think for implementation purposes, the
> simple "powers of 4" generation of triple parity would be better than
> using the Cauchy matrix - it is a clear step from the existing raid6,
> and it can work fast on a wide variety of processors (people use ARMs
> and other "small" cpus on raids, not just x86 with SSE3).  I believe
> that would mean simpler code and fewer changes, which is always popular
> with the kernel folk.
>
> However, if it is not possible to use Cauchy matrices to get four and
> more parity while keeping the same first three parities, then the
> balance changes and a decision needs to be made - do we (the Linux
> kernel developers, the btrfs developers, and the users) want a simpler
> system that is limited to triple parity (or quad parity with 21 + 4
> disks), or do we want a more complex but more flexible system?
>
> Personally, I don't mind either way, as long as we get a good technical
> solution.  And I'll do what I can to help with the maths in either case.
>
> David
>
>
