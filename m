Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ngcobalt08.manitu.net ([217.11.48.108]:60510 "EHLO
	ngcobalt08.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaARAw7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 19:52:59 -0500
Received: from [172.22.99.183] (p4FF1D561.dip0.t-ipconnect.de [79.241.213.97])
	(Authenticated sender: jseifert)
	by ngcobalt08.manitu.net (Postfix) with ESMTPSA id AABC63A801E
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jan 2014 01:53:01 +0100 (CET)
Message-ID: <52D9D061.1070100@dergleichrichter.de>
Date: Sat, 18 Jan 2014 01:52:49 +0100
From: Justus Seifert <justus.seifert@dergleichrichter.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: drawbacks of non-ECC RAM
References: <1389983615.90027.YahooMailNeo@web172606.mail.ir2.yahoo.com> <pan$8d0bb$f4bae0c6$a4261ffd$c2bc88eb@cox.net>
In-Reply-To: <pan$8d0bb$f4bae0c6$a4261ffd$c2bc88eb@cox.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="lk4XmtVCdvckLhwdCcsdUVoOlJh0tOI6R"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lk4XmtVCdvckLhwdCcsdUVoOlJh0tOI6R
Content-Type: multipart/mixed;
 boundary="------------000109080709080302000708"

This is a multi-part message in MIME format.
--------------000109080709080302000708
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 18.01.2014 00:18, Duncan wrote:
> valleysmail-lol5@yahoo.de posted on Fri, 17 Jan 2014 18:33:35 +0000 as
> excerpted:
>=20
>> I'd like to know if there are drawbacks in using btrfs with non-ECC RA=
M
>> instead of using ext4 with non-ECC RAM. I know that some features of
>> btrfs may rely on ECC RAM=20
>=20
> Crossed signals somewhere, as that's entirely incorrect.  Btrfs does ha=
ve=20
> date integrity checksumming as one of its features -- one which I'm usi=
ng=20
> here BTW with raid1 mode so there's two copies of everything, on=20
> different devices, in case one goes bad -- but BTRFS IN NO WAY REQUIRES=
=20
> ECC RAM.  ECC RAM is a hardware solution to a conceptually similar data=
=20
> integrity problem in memory to the problem btrfs addresses as filesyste=
m=20
> software for non-volatile storage, but the two shouldn't be confused fo=
r=20
> each other or conflated at all -- they're entirely separate in practice=
,=20
> and one is hardware while the other is software.

To be fair: Both problems are essentially hardware problems where data
gets corrupted, but the solutions are different.  ECC is only used in
systems where the additional cost for the hardware, energy (registered
ECC-RAM uses more electricity than register-less non-ECC-RAM), and space
(ECC-RAM is physically larger) is less than the cost of recovery in case
of soft errors caused by non-ECC-RAM.  ECC-RAM does not offer a memory
performance advantage.  See Wikipedia for more info about registered RAM
and ECC-RAM.
Raid1 uses more power and space as well, but also adds read performance.
 So _there are reasons to use Raid1 besides resilience_.

> [=E2=80=A6]


--------------000109080709080302000708
Content-Type: text/x-vcard; charset=utf-8;
 name="justus_seifert.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="justus_seifert.vcf"

YmVnaW46dmNhcmQNCmZuOkp1c3R1cyBTZWlmZXJ0DQpuOlNlaWZlcnQ7SnVzdHVzDQphZHI6
Ozs7RHJlc2RlbjtTYXhvbnk7O0dlcm1hbnkNCmVtYWlsO2ludGVybmV0Omp1c3R1cy5zZWlm
ZXJ0QGRlcmdsZWljaHJpY2h0ZXIuZGUNCnRlbDtjZWxsOis0OTE1NzMwNjQwNTA5DQp4LW1v
emlsbGEtaHRtbDpGQUxTRQ0KdmVyc2lvbjoyLjENCmVuZDp2Y2FyZA0KDQo=
--------------000109080709080302000708--

--lk4XmtVCdvckLhwdCcsdUVoOlJh0tOI6R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS2dBoAAoJELFJh75Z+IvIX4IP/3iPdgBgrb6w66yMG5imz2QE
KbE8C44ADHLMxFwVEAdI8zlIxu1rErNSitCo1BNT15bTh/EQimz0fmfS7UcT2Pd5
Ab1oTUV0cZQlPmEB2tCskPG8hQshqcqTnIHtFeFhDkjC8hJ83zIreu8PwMPJgjwH
5Yjn5iiw49ScrmSZld1PWkncai50eOmC2wSuSvMpaCmqSe55mmMwW+dhlKKfb2wr
7DpqdNkZEbur1bNC/qOyLeSNwn2iEMaSX8Z+7/EevHaEpx/w3ZGlnHJs10n+nVup
k8iGM7cHIg85IdmDKtwRiNywlFaUZAmmCRviXSXQPptOxh/cV73iFfwhn6Duf3lx
5H+DojVOBRhkZ3nGWjUFXV+LX5/sMhhLT+DWvaxB2jh01v6n91QVLn7WB1ulnQqA
UNh7eiaNwM+vz1KGN6LFqjpNAod/EcjAcrxe8bB1LRGmxA0pxPrnxtSKn2RidZ8A
3MjWnfZwBO8QTeb+VqvDf0IWgvuxVvzhLcGP/sFqYvRjen4n+xs25xcE8c1Ao4PJ
1vYhXKs72PPeKO71ERnt21TmDA00wA+i12KeeR8cdT6hZZwHCX8f88MpOXjl6fQE
d/I4wSQGGXJ9wkHyHh65QnjXOzMn7fHDPHb1iCRjm8OzTsxuDbuFXC5d48lgSc6r
jERUHtD/WGBzHlT1dTck
=4VOk
-----END PGP SIGNATURE-----

--lk4XmtVCdvckLhwdCcsdUVoOlJh0tOI6R--
