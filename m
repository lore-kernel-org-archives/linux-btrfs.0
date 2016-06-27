Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:52398 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbcF0W3T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 18:29:19 -0400
Received: from [IPv6:2407:e400:b000:201:5447:badc:1e2c:fd1b] (unknown [IPv6:2407:e400:b000:201:5447:badc:1e2c:fd1b])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 60E193A009D
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 08:29:15 +1000 (AEST)
Subject: Re: Strange behavior when replacing device on BTRFS RAID 5 array.
To: linux-btrfs@vger.kernel.org
References: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
 <CAPrP9G8gUfYD92m2e89P4n6_2B4i4CJTe-MnZrR_3gAoQAw=1Q@mail.gmail.com>
 <CAJCQCtTY-vsZi_QmQ7gSpzkQfC9oPfPU1uqvf8madwDRPsCDJw@mail.gmail.com>
 <CAJCQCtTcDc2H3KYHe1oqT9QnZq2pt8Mn=SX6ZpMHT8bTPdE8_w@mail.gmail.com>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <1ef7ca49-35a5-f742-bcb3-70afd97ba384@crc.id.au>
Date: Tue, 28 Jun 2016 08:29:09 +1000
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTcDc2H3KYHe1oqT9QnZq2pt8Mn=SX6ZpMHT8bTPdE8_w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ev6GeAu5FdcFFvx5u3pqeahIRKi1M1IQC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ev6GeAu5FdcFFvx5u3pqeahIRKi1M1IQC
Content-Type: multipart/mixed; boundary="0NtGH5X1gwCXmICa46dD2Is8431ThfBQu"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <1ef7ca49-35a5-f742-bcb3-70afd97ba384@crc.id.au>
Subject: Re: Strange behavior when replacing device on BTRFS RAID 5 array.
References: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
 <CAPrP9G8gUfYD92m2e89P4n6_2B4i4CJTe-MnZrR_3gAoQAw=1Q@mail.gmail.com>
 <CAJCQCtTY-vsZi_QmQ7gSpzkQfC9oPfPU1uqvf8madwDRPsCDJw@mail.gmail.com>
 <CAJCQCtTcDc2H3KYHe1oqT9QnZq2pt8Mn=SX6ZpMHT8bTPdE8_w@mail.gmail.com>
In-Reply-To: <CAJCQCtTcDc2H3KYHe1oqT9QnZq2pt8Mn=SX6ZpMHT8bTPdE8_w@mail.gmail.com>

--0NtGH5X1gwCXmICa46dD2Is8431ThfBQu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 28/06/16 03:46, Chris Murphy wrote:
> On Mon, Jun 27, 2016 at 11:29 AM, Chris Murphy <lists@colorremedies.com=
> wrote:
>=20
>>
>> Next is to decide to what degree you want to salvage this volume and
>> keep using Btrfs raid56 despite the risks
>=20
> Forgot to complete this thought. So if you get a backup, and decide
> you want to fix it, I would see if you can cancel the replace using
> "btrfs replace cancel <mp>" and confirm that it stops. And now is the
> risky part, which is whether to try "btrfs add" and then "btrfs
> remove" or remove the bad drive, reboot, and see if it'll mount with
> -o degraded, and then use add and remove (in which case you'll use
> 'remove missing').
>=20
> The first you risk Btrfs still using the flaky bad drive.
>=20
> The second you risk whether a degraded mount will work, and whether
> any other drive in the array has a problem while degraded (like an
> unrecovery read error from a single sector).

This is the exact set of circumstances that caused my corrupt array. I
was using RAID6 - yet it still corrupted large portions of things. In
theory, due to having double parity, it should still have survived even
if a disk did go bad - but there we are.

I first started a replace - noted how slow it was going - cancelled the
replace, then did an add / delete - the system crashed and it was all ove=
r.

Just as another data point, I've been flogging the guts out of the array
with mdadm RAID6 doing a reshape of that - and no read errors, system
crashes or other problems in over 48 hours.

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--0NtGH5X1gwCXmICa46dD2Is8431ThfBQu--

--ev6GeAu5FdcFFvx5u3pqeahIRKi1M1IQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXcai6AAoJEEGvNdV6fTHcTMEP/Ag5pHaY2NL6h7G2p+a6/pSN
XjOYDPlJrT92BcJ9LJec3nVAFFJJycopxXrXuO8mcG/8arcyNIf+aPsszEUMZelp
byHH00o4/JsNrhv63g/QIzRYQCJO3/1QO8fpYUZhJSI99yLp1F6Y7hkp8vKSJbbI
pTMJDhvsZ9ypkfE4dJTp/tSOyxWNXFRVlbiJDGvxAP5VXA9m76s76eh8FHuLG0UL
nNMPSZ3GnTVvSp8drWugNAWXlmVM/CoxSQ0ZV0dDd/AI/KupVhXh/yMNmE2XbqB5
rzeg9MW8apKPPzbfd9K/K97TEAWfuVGWEx4JGslR8Hd6YHioDf5XHaJaUfcvzTGV
/Sq8uiBagArLpQVsrZvirgqC7n10D/bvjI/LUeLO3nyT8pk+KEFjv2yrS6QEqV8l
D8l/Fj52krGbooHXdrytM7KnkuOub6hD8OGfofjlHIEF2iJTbDX3PA8M533cOKzW
wC2PXrwN3Iyhs7Siu5WSsxODia8/5UmIItuy8H6uIKIHW3Ccf9PRLYCJL4ei7nXw
BaBngTjRPZy3HfcWVlJJiXbLmAChjPYheqXQjknNvYIbCgh5/cIA5bnYO/0zycFP
39Fec6ecuSiDalIJ843Sqof+/BMeYRVpwIEA5w7ZvsPBRtKjq4JuzKp32IkH4J9x
hKeedXg/HzqCNhExCgnc
=byv4
-----END PGP SIGNATURE-----

--ev6GeAu5FdcFFvx5u3pqeahIRKi1M1IQC--
