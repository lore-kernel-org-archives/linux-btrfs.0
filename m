Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:43010 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab2JWIIE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 04:08:04 -0400
Received: from yeono.kjorling.se (c-6d16e655.6036809--62697410.cust.bredbandsbolaget.se [85.230.22.109])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "yeono", Issuer "yeono" (not verified))
	by loup.kjorling.se (Postfix) with ESMTPS id 1712410A5C0F0
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 07:57:22 +0000 (UTC)
Received: from yeono.kjorling.se (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by yeono (Postfix) with ESMTPS id 886E847E1C9
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 09:57:22 +0200 (CEST)
Date: Tue, 23 Oct 2012 07:57:21 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: linux-btrfs@vger.kernel.org
Subject: Re: device delete, error removing device
Message-ID: <20121023075721.GB391@yeono.kjorling.se>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com>
 <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com>
 <20121022091904.GY25498@carfax.org.uk>
 <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com>
 <20121022171809.GA25498@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
In-Reply-To: <20121022171809.GA25498@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22 Oct 2012 18:18 +0100, from hugo@carfax.org.uk (Hugo Mills):
>> [root@f18v ~]# btrfs device delete /dev/sdb /mnt
>> [root@f18v ~]# btrfs fi show
>> failed to read /dev/sr0
>> Label: none  uuid: 6e96a96e-3357-4f23-b064-0f0713366d45
>> 	Total devices 5 FS bytes used 7.52GB
>> 	devid    5 size 12.00GB used 4.17GB path /dev/sdf
>> 	devid    4 size 12.00GB used 4.62GB path /dev/sde
>> 	devid    3 size 3.00GB used 2.68GB path /dev/sdd
>> 	devid    2 size 3.00GB used 2.68GB path /dev/sdc
>> 	*** Some devices missing
>>=20
>> However, I think that last line is a bug. When I
>>=20
>> [root@f18v ~]# btrfs device delete missing /mnt
>>=20
>> I get
>>=20
>> [ 2152.257163] btrfs: no missing devices found to remove
>>=20
>> So they're missing but not missing?
>=20
>    If you run sync, or wait for 30 seconds, you'll find that fi show
> shows the correct information again -- btrfs fi show reads the
> superblocks directly, and if you run it immediately after the dev del,
> they've not been flushed back to disk yet.

That sounds like it has the potential to bite a lot of people in the
rear. Yes, 30 seconds or a sync is trivial, but only if you know about
it.

Considering that a device delete is a pretty rare but potentially
important operation, would it not be better for a sync to be done
automatically after a "device delete" command? And potentially others
in a similar vein. With an option --no-sync or similar to disable the
behavior (in the relatively unlikely situation that multiple devices
are unavailable and need to be deleted, for example).

I can definitely see the described behavior qualifying as a "WTF?"
moment.

--=20
Michael Kj=C3=B6rling =E2=80=A2 http://michael.kjorling.se =E2=80=A2 michae=
l@kjorling.se
                =E2=80=9CPeople who think they know everything really annoy
                those of us who know we don=E2=80=99t.=E2=80=9D (Bjarne Str=
oustrup)

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFQhk3hdY+HSb3praYRAl8NAKCubXsgWzCxYZ4E2ZK1fs28JGWWagCgk/Lk
xcyi9J5D38+eVxWOjQgK7/g=
=GxIv
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
