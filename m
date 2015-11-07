Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59975 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbbKGTcs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Nov 2015 14:32:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zv9EE-0002nd-B5
	for linux-btrfs@vger.kernel.org; Sat, 07 Nov 2015 20:32:46 +0100
Received: from chello213047196183.tirol.surfer.at ([213.47.196.183])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 20:32:46 +0100
Received: from wertstoffe by chello213047196183.tirol.surfer.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 20:32:46 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: Re: boot from snapshot and take snapshot from here.
Date: Sat, 7 Nov 2015 20:30:15 +0100
Message-ID: <8302hc-1m9.ln1@aldebaran.xundeenergie.at>
References: <4iu1hc-23v.ln1@aldebaran.xundeenergie.at>
 <20151107191817.GF27446@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="emC6WRrHtkH8KDvmORJ0Vd5WGmJmbGrJb"
In-Reply-To: <20151107191817.GF27446@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--emC6WRrHtkH8KDvmORJ0Vd5WGmJmbGrJb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 2015-11-07 um 20:18 schrieb Hugo Mills:
> On Sat, Nov 07, 2015 at 08:04:01PM +0100, Jakob Sch=C3=BCrz wrote:
>> Hi there!
>>
>> I can't find any Information for my Problem. And I try to explain, wha=
t
>> I want.
> [snip]
>> BUT
>>
>> When i boot from f.e. @debian-snap2, the mechanics doesn't work any lo=
nger.
>>
>> btrfs subvol snapshot @debian-snap2 @debian-snap3
>>
>> this works.
>>
>> btrfs send -p @debian-snap2 debian-snap3 | btrfs receive /backupmountp=
oint
>>
>> gives me an error, that btrfs can't find a subvol with a proper ID.
>>
>> Ho to do this, if i want to boot from a former snapshot (in case of a
>> mistaken system-upgrade) and i want to transfer the later snapshots to=

>> the external HD - only the differences?
>=20
>    Basically, you can't right now. It's a known limitation, and can, I
> think, be fixed, but it'll need a change to the send stream format,
> which is a tricky migration to do (because there's currently no format
> identifier in it, which makes it hard to handle both formats easily).
>=20
>> There is nothing on the internet on this problem (I've found). But i
>> think this is a usecase, which I'm not alone needing it...
>=20
>    You're not alone. It will come eventually, but only when David's in
> a position to deal with the issues of changing the send stream.

OK!

I'm always happy, when i realize, it's not my tired mind, when i can't
find the solution :)

Thanks for the  info. So we will wait.

jakob


--=20
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/


--emC6WRrHtkH8KDvmORJ0Vd5WGmJmbGrJb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWPlFIAAoJEF2YPOCqoD051YgH/01dEmHewmzKaRMmqPig5M+7
cVhkkGtuBo4M1AGJSAODddrgLk/c0pJtXvTBIGP7K0RvQjFvOjBY4UwoEXGS22bh
uSF/fq1LS2KUDKLJE8TXd+buNSM9xfUONHazas8U8OzsbKG85cTaCNOi48oEIVzd
DCuO6gb63KHnnDm3ta8HLwr4AV/+ZsLvElL7/uv6i3x7P1Mp3KN9FBnMwkNynGVA
LM1hjf2NwjMMn1CYZzOGzfs279SYG1Iwyit5+k8mBOM/zAwTDg26vgh1lnX83LWk
/zLK7ozn3gJeSK/a7f/jSOfcgrdQ8vfGrVquWmyViD1lM8JtzjnB0QjT/I1tqFo=
=3+YQ
-----END PGP SIGNATURE-----

--emC6WRrHtkH8KDvmORJ0Vd5WGmJmbGrJb--

