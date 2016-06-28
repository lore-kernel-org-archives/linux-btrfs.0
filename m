Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:57726 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbcF1SRL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 14:17:11 -0400
Received: from [IPv6:2407:e400:b000:201:89f6:8482:989e:de43] (unknown [IPv6:2407:e400:b000:201:89f6:8482:989e:de43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 145463A009D
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 04:17:06 +1000 (AEST)
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
 <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au>
 <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <70f12c1b-8d30-c5f7-faa8-10a86a49c332@crc.id.au>
Date: Wed, 29 Jun 2016 04:17:05 +1000
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xRQbrfEOspAofT38vixImEcdNhb0ne84K"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xRQbrfEOspAofT38vixImEcdNhb0ne84K
Content-Type: multipart/mixed; boundary="TGVtR3OHtib3Q0WPGnqBe2VOm7MjrxLLc"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <70f12c1b-8d30-c5f7-faa8-10a86a49c332@crc.id.au>
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
 <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au>
 <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
In-Reply-To: <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>

--TGVtR3OHtib3Q0WPGnqBe2VOm7MjrxLLc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 29/06/16 04:01, Chris Murphy wrote:
> Just wiping the slate clean to summarize:
>=20
>=20
> 1. We have a consistent ~1 in 3 maybe 1 in 2, reproducible corruption
> of *data extent* parity during a scrub with raid5. Goffredo and I have
> both reproduced it. It's a big bug. It might still be useful if
> someone else can reproduce it too.
>=20
> Goffredo, can you file a bug at bugzilla.kernel.org and reference your
> bug thread?  I don't know if the key developers know about this, it
> might be worth pinging them on IRC once the bug is filed.
>=20
> Unknown if it affects balance, or raid 6. And if it affects raid 6, is
> p or q corrupted, or both? Unknown how this manifests on metadata
> raid5 profile (only tested was data raid5). Presumably if there is
> metadata corruption that's fixed during a scrub, and its parity is
> overwritten with corrupt parity, the next time there's a degraded
> state, the file system would face plant somehow. And we've seen quite
> a few degraded raid5's (and even 6's) face plant in inexplicable ways
> and we just kinda go, shit. Which is what the fs is doing when it
> encounters a pile of csum errors. It treats the csum errors as a
> signal to disregard the fs rather than maybe only being suspicious of
> the fs. Could it turn out that these file systems were recoverable,
> just that Btrfs wasn't tolerating any csum error and wouldn't proceed
> further?

I believe this is the same case for RAID6 based on my experiences. I
actually wondered if the system halts were the result of a TON of csum
errors - not the actual result of those errors. Just about every system
hang when to 100% CPU usage on all cores and the system just stopped was
after a flood of csum errors. If it was only one or two (or I copied
data off via a network connection where the read rate was slower), I
found I had a MUCH lower chance of the system locking up.

In fact, now that I think about it, when I was copying data to an
external USB drive (maxed out at ~30MB/sec), I still got csum errors -
but the system never hung.

Every crash ended with the last line along the lines of "Stopped
recurring error. Your system needs rebooting". I wonder if this error
reporting was altered, that the system wouldn't go down.

Of course I have no way of testing this.....


--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--TGVtR3OHtib3Q0WPGnqBe2VOm7MjrxLLc--

--xRQbrfEOspAofT38vixImEcdNhb0ne84K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXcr8hAAoJEEGvNdV6fTHcYNMP/3VMTqS9tANwbWb1+Eng0Acj
QXRqznWOsPtHwrQEohJ2CGiMJTLDp36IDKdaYFYOeQ2pjlmDUn4t6s5nw3Oa1jab
RHht83IhJ2Z9HstSrpp+wMgYDHOLie9c+CLFP2/hKWE81HHmVQY1dn6ebtbxUAVX
30nKxuVNP6HCsgVHM8hDmcjA22sWDmkfVNaxIHiUUSj70p5YKg0Aw1tjcP7jcLe+
jJLoxKSVuuBKfpqqD6iXrN30Yr+/fr2VSZiYD2KNW5oJn3PL8oG8AUSCetfHf45h
+pGg34UZghRv1UrzV+LVM+hmQJXs8xYM8TiKmClnxj9KKxq6dqtZFXM8iNYj2IDK
U9IJEe9aOrqJq4SdAzaMArSvlbSvPZzaLDyPty5c2sffCbfPDWm17aoA+BLWK/3z
mbAF5Su1y0fCHTlZAFFPs8sdE9Npt6vb3lP8rIsStuO2LkTOquTBDgXmZ4Zsl0sv
2si2GwhlFHUIytdxuBnrg7JBnw43NlJf5U7+dVpQdg36y7Kq5nEbXwt7fDmq3nr0
hOf9jJ5357ioMpRL/GJsb1y/UtZRDiXWRL5mVOhbysOfRrK/RZYHqd/uQXOEJiuy
aoGY3E4dzWK2bqPnIA8dAkEAwMX8UJGUv0ZHn2+NnM6/WwMITSsT978E2FCrTXao
hMQqVqksWLNI4IYl9Kaw
=52Je
-----END PGP SIGNATURE-----

--xRQbrfEOspAofT38vixImEcdNhb0ne84K--
