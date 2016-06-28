Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:55628 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbcF1MOs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 08:14:48 -0400
Received: from [IPv6:2407:e400:b000:201:dd1d:b89b:e3fe:28c2] (unknown [IPv6:2407:e400:b000:201:dd1d:b89b:e3fe:28c2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 30A583A009D
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 22:14:44 +1000 (AEST)
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
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au>
Date: Tue, 28 Jun 2016 22:14:25 +1000
MIME-Version: 1.0
In-Reply-To: <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="toJHEpaeR6497f7H4vdws9aTG4eVBdbEb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--toJHEpaeR6497f7H4vdws9aTG4eVBdbEb
Content-Type: multipart/mixed; boundary="gT7iN5TwBEFX9aNRLlVPN9eKJp4cBHLxL"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au>
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
In-Reply-To: <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>

--gT7iN5TwBEFX9aNRLlVPN9eKJp4cBHLxL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 28/06/16 22:05, Austin S. Hemmelgarn wrote:
> On 2016-06-27 17:57, Zygo Blaxell wrote:
>> On Mon, Jun 27, 2016 at 10:17:04AM -0600, Chris Murphy wrote:
>>> On Mon, Jun 27, 2016 at 5:21 AM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>> On 2016-06-25 12:44, Chris Murphy wrote:
>>>>> On Fri, Jun 24, 2016 at 12:19 PM, Austin S. Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>
>>>>> OK but hold on. During scrub, it should read data, compute checksum=
s
>>>>> *and* parity, and compare those to what's on-disk - > EXTENT_CSUM i=
n
>>>>> the checksum tree, and the parity strip in the chunk tree. And if
>>>>> parity is wrong, then it should be replaced.
>>>>
>>>> Except that's horribly inefficient.  With limited exceptions involvi=
ng
>>>> highly situational co-processors, computing a checksum of a parity
>>>> block is
>>>> always going to be faster than computing parity for the stripe.  By
>>>> using
>>>> that to check parity, we can safely speed up the common case of near=

>>>> zero
>>>> errors during a scrub by a pretty significant factor.
>>>
>>> OK I'm in favor of that. Although somehow md gets away with this by
>>> computing and checking parity for its scrubs, and still manages to
>>> keep drives saturated in the process - at least HDDs, I'm not sure ho=
w
>>> it fares on SSDs.
>>
>> A modest desktop CPU can compute raid6 parity at 6GB/sec, a less-modes=
t
>> one at more than 10GB/sec.  Maybe a bottleneck is within reach of an
>> array of SSDs vs. a slow CPU.
> OK, great for people who are using modern desktop or server CPU's.  Not=

> everyone has that luxury, and even on many such CPU's, it's _still_
> faster to computer CRC32c checksums.  On top of that, we don't appear t=
o
> be using the in-kernel parity-raid libraries (or if we are, I haven't
> been able to find where we are calling the functions for it), so we
> don't necessarily get assembly optimized or co-processor accelerated
> computation of the parity itself.  The other thing that I didn't mentio=
n
> above though, is that computing parity checksums will always take less
> time than computing parity, because you have to process significantly
> less data.  On a 4 disk RAID5 array, you're processing roughly 2/3 as
> much data to do the parity checksums instead of parity itself, which
> means that the parity computation would need to be 200% faster than the=

> CRC32c computation to break even, and this margin gets bigger and bigge=
r
> as you add more disks.
>=20
> On small arrays, this obviously won't have much impact.  Once you start=

> to scale past a few TB though, even a few hundred MB/s faster processin=
g
> means a significant decrease in processing time.  Say you have a CPU
> which gets about 12.0GB/s for RAID5 parity, and and about 12.25GB/s for=

> CRC32c (~2% is a conservative ratio assuming you use the CRC32c
> instruction and assembly optimized RAID5 parity computations on a moder=
n
> x86_64 processor (the ratio on both the mobile Core i5 in my laptop and=

> the Xeon E3 in my home server is closer to 5%)).  Assuming those
> numbers, and that we're already checking checksums on non-parity blocks=
,
> processing 120TB of data in a 4 disk array (which gives 40TB of parity
> data, so 160TB total) gives:
> For computing the parity to scrub:
> 120TB / 12.25GB =3D  9795.9 seconds for processing CRC32c csums of all =
the
> regular data
> 120TB / 12GB    =3D 10000 seconds for processing parity of all stripes
>                 =3D 19795.9 seconds total
>                 ~ 5.4 hours total
>=20
> For computing csums of the parity:
> 120TB / 12.25GB =3D  9795.9 seconds for processing CRC32c csums of all =
the
> regular data
> 40TB / 12.25GB  =3D  3265.3 seconds for processing CRC32c csums of all =
the
> parity data
>                 =3D 13061.2 seconds total
>                 ~ 3.6 hours total
>=20
> The checksum based computation is approximately 34% faster than the
> parity computation.  Much of this of course is that you have to process=

> the regular data twice for the parity computation method (once for
> csums, once for parity).  You could probably do one pass computing both=

> values, but that would need to be done carefully; and, without
> significant optimization, would likely not get you much benefit other
> than cutting the number of loads in half.

And it all means jack shit because you don't get the data to disk that
quick. Who cares if its 500% faster - if it still saturates the
throughput of the actual drives, what difference does it make?

I'm all for actual solutions, but the nirvana fallacy seems to apply here=
=2E..

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--gT7iN5TwBEFX9aNRLlVPN9eKJp4cBHLxL--

--toJHEpaeR6497f7H4vdws9aTG4eVBdbEb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXcmoxAAoJEEGvNdV6fTHcPDwQAL4asN3yaHZbkOHqWHM1D395
8oFurSH1E9vmuETfadTDy33OP5oL6tYsO3f8nfxdH3jyBfLb2apIDRzK9EYbuFPI
CWqNl7AISxt1vLbTLePW6kCU6djTQXQa2gQBJPWmjoIdTWFfTK6L3pMSn394CUkl
e9Y96prcGfNUey7MylhZAEQianylIXA5G/M2tXPS0a4diBO23hllkAR9a6Y8+90x
YEeAGPueqlGnNks2KUHUfcLdfpe/9YI2v1QMfBpeaiK9NEDJxMm9EPYmpjw0SPvC
4leaBo2ik6v3T1EHMQhk5XYvB+EimqAz+pMkwtPJHFYZatXN9NQXUq63o0kYYIlv
+/k8AJqZD2lTtxaYaA2chNPqWz8he3yZ4o6fF0+UAxSvEsatisxbwdB0loJQXRKm
SGKwqtH5qmpor0Gs/zF/8phfslHXNESXM1Erk/xFH8eu/O7nbci9PUwQDmnUDIkw
j0wgJfWU2j5Gtjj2DWn0mOgiQPz57R0HezSx+zPFWqHK+/4goWlI15WFTy6IoPA5
Lk/MaWDu5ac1tK8jfl5n5QTVUfQyE7fb+PeqiJRr7EOQp1KuvQBwvtu8CykMmslO
FKelB2/OoSikWKX0Yrt/hbQeNnGyTq9n2ROu54Il6v15ZtfKNXNb3Kh/DLZ+AI+5
QNyaAzLExu/Tywwh80hX
=w2HO
-----END PGP SIGNATURE-----

--toJHEpaeR6497f7H4vdws9aTG4eVBdbEb--
