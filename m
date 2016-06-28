Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:57032 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbcF1QkW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 12:40:22 -0400
Received: from [IPv6:2407:e400:b000:201:89f6:8482:989e:de43] (unknown [IPv6:2407:e400:b000:201:89f6:8482:989e:de43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 1B5443A009D
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 02:40:14 +1000 (AEST)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: linux-btrfs@vger.kernel.org
References: <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
 <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org>
 <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au>
 <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au>
Date: Wed, 29 Jun 2016 02:40:05 +1000
MIME-Version: 1.0
In-Reply-To: <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BX8Mw7bjEuRg3H6MCiCNsVQUs67kb4JMH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BX8Mw7bjEuRg3H6MCiCNsVQUs67kb4JMH
Content-Type: multipart/mixed; boundary="UuD396iVeIxsB2DgdmTfDi6gt8QIUSGGR"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au>
Subject: Re: Adventures in btrfs raid5 disk recovery
References: <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
 <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org>
 <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au>
 <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
In-Reply-To: <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>

--UuD396iVeIxsB2DgdmTfDi6gt8QIUSGGR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 28/06/16 22:25, Austin S. Hemmelgarn wrote:
> On 2016-06-28 08:14, Steven Haigh wrote:
>> On 28/06/16 22:05, Austin S. Hemmelgarn wrote:
>>> On 2016-06-27 17:57, Zygo Blaxell wrote:
>>>> On Mon, Jun 27, 2016 at 10:17:04AM -0600, Chris Murphy wrote:
>>>>> On Mon, Jun 27, 2016 at 5:21 AM, Austin S. Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>> On 2016-06-25 12:44, Chris Murphy wrote:
>>>>>>> On Fri, Jun 24, 2016 at 12:19 PM, Austin S. Hemmelgarn
>>>>>>> <ahferroin7@gmail.com> wrote:
>>>>>>>
>>>>>>> OK but hold on. During scrub, it should read data, compute checks=
ums
>>>>>>> *and* parity, and compare those to what's on-disk - > EXTENT_CSUM=
 in
>>>>>>> the checksum tree, and the parity strip in the chunk tree. And if=

>>>>>>> parity is wrong, then it should be replaced.
>>>>>>
>>>>>> Except that's horribly inefficient.  With limited exceptions
>>>>>> involving
>>>>>> highly situational co-processors, computing a checksum of a parity=

>>>>>> block is
>>>>>> always going to be faster than computing parity for the stripe.  B=
y
>>>>>> using
>>>>>> that to check parity, we can safely speed up the common case of ne=
ar
>>>>>> zero
>>>>>> errors during a scrub by a pretty significant factor.
>>>>>
>>>>> OK I'm in favor of that. Although somehow md gets away with this by=

>>>>> computing and checking parity for its scrubs, and still manages to
>>>>> keep drives saturated in the process - at least HDDs, I'm not sure =
how
>>>>> it fares on SSDs.
>>>>
>>>> A modest desktop CPU can compute raid6 parity at 6GB/sec, a less-mod=
est
>>>> one at more than 10GB/sec.  Maybe a bottleneck is within reach of an=

>>>> array of SSDs vs. a slow CPU.
>>> OK, great for people who are using modern desktop or server CPU's.  N=
ot
>>> everyone has that luxury, and even on many such CPU's, it's _still_
>>> faster to computer CRC32c checksums.  On top of that, we don't appear=
 to
>>> be using the in-kernel parity-raid libraries (or if we are, I haven't=

>>> been able to find where we are calling the functions for it), so we
>>> don't necessarily get assembly optimized or co-processor accelerated
>>> computation of the parity itself.  The other thing that I didn't ment=
ion
>>> above though, is that computing parity checksums will always take les=
s
>>> time than computing parity, because you have to process significantly=

>>> less data.  On a 4 disk RAID5 array, you're processing roughly 2/3 as=

>>> much data to do the parity checksums instead of parity itself, which
>>> means that the parity computation would need to be 200% faster than t=
he
>>> CRC32c computation to break even, and this margin gets bigger and big=
ger
>>> as you add more disks.
>>>
>>> On small arrays, this obviously won't have much impact.  Once you sta=
rt
>>> to scale past a few TB though, even a few hundred MB/s faster process=
ing
>>> means a significant decrease in processing time.  Say you have a CPU
>>> which gets about 12.0GB/s for RAID5 parity, and and about 12.25GB/s f=
or
>>> CRC32c (~2% is a conservative ratio assuming you use the CRC32c
>>> instruction and assembly optimized RAID5 parity computations on a mod=
ern
>>> x86_64 processor (the ratio on both the mobile Core i5 in my laptop a=
nd
>>> the Xeon E3 in my home server is closer to 5%)).  Assuming those
>>> numbers, and that we're already checking checksums on non-parity bloc=
ks,
>>> processing 120TB of data in a 4 disk array (which gives 40TB of parit=
y
>>> data, so 160TB total) gives:
>>> For computing the parity to scrub:
>>> 120TB / 12.25GB =3D  9795.9 seconds for processing CRC32c csums of al=
l the
>>> regular data
>>> 120TB / 12GB    =3D 10000 seconds for processing parity of all stripe=
s
>>>                 =3D 19795.9 seconds total
>>>                 ~ 5.4 hours total
>>>
>>> For computing csums of the parity:
>>> 120TB / 12.25GB =3D  9795.9 seconds for processing CRC32c csums of al=
l the
>>> regular data
>>> 40TB / 12.25GB  =3D  3265.3 seconds for processing CRC32c csums of al=
l the
>>> parity data
>>>                 =3D 13061.2 seconds total
>>>                 ~ 3.6 hours total
>>>
>>> The checksum based computation is approximately 34% faster than the
>>> parity computation.  Much of this of course is that you have to proce=
ss
>>> the regular data twice for the parity computation method (once for
>>> csums, once for parity).  You could probably do one pass computing bo=
th
>>> values, but that would need to be done carefully; and, without
>>> significant optimization, would likely not get you much benefit other=

>>> than cutting the number of loads in half.
>>
>> And it all means jack shit because you don't get the data to disk that=

>> quick. Who cares if its 500% faster - if it still saturates the
>> throughput of the actual drives, what difference does it make?
> It has less impact on everything else running on the system at the time=

> because it uses less CPU time and potentially less memory.  This is the=

> exact same reason that you want your RAID parity computation performanc=
e
> as good as possible, the less time the CPU spends on that, the more it
> can spend on other things.  On top of that, there are high-end systems
> that do have SSD's that can get multiple GB/s of data transfer per
> second, and NVDIMM's are starting to become popular in the server
> market, and those give you data transfer speeds equivalent to regular
> memory bandwidth (which can be well over 20GB/s on decent hardware (I'v=
e
> got a relatively inexpensive system using DDR3-1866 RAM that has roughl=
y
> 22-24GB/s of memory bandwidth)).  Looking at this another way, the fact=

> that the storage device is the bottleneck right now is not a good excus=
e
> to not worry about making everything else as efficient as possible.

If its purely about performance - then start with multi-thread as a base
- not chopping features to make better performance. I'm not aware of any
modern CPU that comes with a single core these days - so parallel
workloads are much more efficient than a single thread.

Yes, its a law of diminishing returns - but if you're not doing a full
check of data when one would assume you are, then is that broken by desig=
n?

Personally, during a scrub, I would want to know if either the checksum
OR the parity is wrong - as that indicates problems at a much deeper
level. As someone who just lost ~4Tb of data due to BTRFS bugs,
protection of data trumps performance in most cases.

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--UuD396iVeIxsB2DgdmTfDi6gt8QIUSGGR--

--BX8Mw7bjEuRg3H6MCiCNsVQUs67kb4JMH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXcqhtAAoJEEGvNdV6fTHcXoQP/jPVVjydkLRbh8l3AODfZNEm
Adwbf8WksQvB0N7RpusQsHMZ169o1Y5yf6ObiGdPFvEEC0w3hglmC3HSRg4nL1Yf
P9BBWAOJaD6C2rro8FXGDpU1Gn8Tejk95EwV2slHP+eUq/vPr0yg4NTeNj3MjfqE
qB9GC1rjQqTKu8iIXHBHAWCBQRUrLog3OUTrRt6Nf4TH0vlavcTbYC+mPol4k+ZU
jg8T+WFUCNDN7OmKVULWgNNjxG2dYq0Bz8iIvKFnCv29aWUQXsTqKTEdqj2w6wvF
86vHeONWOblYnjb2/0W/rfWUvKWZPxsESBif+hWvRHFs3n7AjfQVKMY+OEZH67K9
7Hu7OxOLXiH98017XUB5hHwcr85L+JR81j3srZ48zsoHYHuzbm8h24+J6s/Ftbk3
bcDc9tXvqVhX/d2rOfka7bVivtUVEcICfTec7oBQxLsq0eQhBcRH00iKeSFYnenY
Jl9OuLY8ynHqD7gTbTddBPVWwh8c64RIG0ywLtSU4Pj+PuB6NBobBfCQmUh4nBjb
VAEHZnFVAWBhXJkvB35f7ipdPpWIJcW40Se8ugsES2DrLInXNQr0Lws7ucnQkDSD
YaGhfaGq7mVS/N/DdXbzVLjSuXLDDCxUOctP+V2EbN+T6e4AJ/dUJ/xyxbXP7S4h
2v6Dy+i0rg+ZbrD0cyj5
=CAqC
-----END PGP SIGNATURE-----

--BX8Mw7bjEuRg3H6MCiCNsVQUs67kb4JMH--
