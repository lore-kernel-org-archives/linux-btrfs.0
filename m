Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from baraddur.eliasprobst.eu ([78.47.157.163]:46115 "EHLO
	eliasprobst.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbbHPAF0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 20:05:26 -0400
To: linux-btrfs@vger.kernel.org
Date: Sun, 16 Aug 2015 02:04:27 +0200
Subject: Re: Lockup in BTRFS_IOC_CLONE/Kernel 4.2.0-rc5
References: <55C1C915.4070106@eliasprobst.eu> <20150807040119.GA8887@localhost.localdomain> <55C53F75.6060905@eliasprobst.eu>
Message-ID: <55CFD38B.7000807@eliasprobst.eu>
From: "Elias Probst" <mail@eliasprobst.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="BnPoiOmsIdQXjrsVu0eCMmTtBEtb5T6h7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BnPoiOmsIdQXjrsVu0eCMmTtBEtb5T6h7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/08/2015 01:29 AM, Elias Probst wrote:
> On 08/07/2015 06:01 AM, Liu Bo wrote:
>> Could you do 'echo w > /proc/sysrq-trigger' to gather the whole hang c=
all stack?
>=20
> Thanks a lot for the feedback. Full call stack output is attached
> (pasting inline makes no sense due to the size of 2423 lines/135k).
>=20
> In case VGER will strip attachments of this size, I made it available a=
s
> a pastebin here: https://bpaste.net/show/e5e0fd4bbb9f
>=20
>=20
>> Here's a quick patch that may address your problem, can you give it a =
shot after
>> getting sysrq-w output?
>=20
> Will rebuild now with your patch and keep you updated about the outcome=
=2E

So far I've been unable to reproduce the lockup using your patch on
4.2.0-rc6.

Thanks a lot!

- Elias



--BnPoiOmsIdQXjrsVu0eCMmTtBEtb5T6h7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJVz9OUAAoJEILFEoJlEbrbInwP/08lWloC30cRSe9IHGh8Hcn0
j4jAe2kr7k6kvdSGEGa7hGR9KcE66J2MC1qcXWHMaeaTJMaxb8HPQ3WaCYu3/sLU
Iv9SGtlMIEP+XV0xvgFuxW0w59yAuKDQoKf4T7OrcZUhZ/rMMMnRkjRl/VO8roMh
mcgS/DJD1aAwp6QjSFVJYmxkaoavWj4kVMTOOCcS6ivH37C521JbOfPB1Ma1ZCXs
2HaybHcsM8LtYRlFW/wJnhYzPcx/oMs0/sQk0VcCMfWEPv0w/Zd9EKZO47K28MY3
j7MuS2nBVgEaT3YDRLjVLBqnXDFr21JjJ+z3KGKyHq00BD3UUK7zuj39ODXAH0HW
MU3brEMBE8KeEXDGkxPrAY0tAel76alwdW61UEa94W6mqSZ5QIFwHcySFg/eyRdi
LHmqxx+nb5NWMyqJ/rGVhVbRra1bdtcLP+1MSZ5Sir0UwWqv97JlxqnKA25prABa
0MyBJRAOv5njnIqDpmDvTJn+Y/5b2XlRnW000aYZzFqbOQK/Qld3FxUpWr43pGge
xM7pA0g7AaiQEI62J4SPXXYMN+VrIpgG4B1rzsrB0J4983gcbOIpEZxkjyYmze0I
4u8qvU4JPrS+VfSBx+gtY4Nqm92+sptPRFSZMT93UvdjyPARyru3HH5QSpQS1Dev
5M2iA1QCkCAizXWuyv5Y
=T6U7
-----END PGP SIGNATURE-----

--BnPoiOmsIdQXjrsVu0eCMmTtBEtb5T6h7--
