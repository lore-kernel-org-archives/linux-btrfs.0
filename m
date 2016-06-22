Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1.mail.ruhr-uni-bochum.de ([134.147.53.149]:51272 "EHLO
	out1.mail.ruhr-uni-bochum.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbcFVQTn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 12:19:43 -0400
Received: from mx1.mail.ruhr-uni-bochum.de (localhost [127.0.0.1])
	by out1.mail.ruhr-uni-bochum.de (Postfix mo-ext) with ESMTP id 3rZV2D5SrBz4wGf
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 18:11:00 +0200 (CEST)
Received: from mx1.mail.ruhr-uni-bochum.de (localhost [127.0.0.1])
	by mx1.mail.ruhr-uni-bochum.de (Postfix idis) with ESMTP id 3rZV2D4m3sz4xDv
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 18:11:00 +0200 (CEST)
Received: from mail1.mail.ruhr-uni-bochum.de (mail1.mail.ruhr-uni-bochum.de [134.147.42.227])
	by mx1.mail.ruhr-uni-bochum.de (Postfix mi-int) with ESMTP id 3rZV2D3fCcz4wGf
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 18:11:00 +0200 (CEST)
Received: from [10.4.13.35] (unknown [213.152.161.74])
	by mail1.mail.ruhr-uni-bochum.de (Postfix) with ESMTPSA id 3rZV2B53GDzyVc
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 18:10:58 +0200 (CEST)
Subject: Re: btrfs send/receive error
To: linux-btrfs@vger.kernel.org
References: <20160622120108.GA15708@localhost>
From: Michael Duell <michael.duell@rub.de>
Message-ID: <b3bf0ff9-175b-29fa-485d-4818811619eb@rub.de>
Date: Wed, 22 Jun 2016 18:10:50 +0200
MIME-Version: 1.0
In-Reply-To: <20160622120108.GA15708@localhost>
Content-Type: multipart/signed; micalg=pgp-sha384;
 protocol="application/pgp-signature";
 boundary="IDAQUMqxErjF0glIgCBDhBwsILWjRoCOD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IDAQUMqxErjF0glIgCBDhBwsILWjRoCOD
Content-Type: multipart/mixed; boundary="Kg5NDKhmchJ5j05Fh2b3E6dJlDCQFrsI9"
From: Michael Duell <michael.duell@rub.de>
To: linux-btrfs@vger.kernel.org
Message-ID: <b3bf0ff9-175b-29fa-485d-4818811619eb@rub.de>
Subject: Re: btrfs send/receive error
References: <20160622120108.GA15708@localhost>
In-Reply-To: <20160622120108.GA15708@localhost>

--Kg5NDKhmchJ5j05Fh2b3E6dJlDCQFrsI9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hallo Lubos!

I have got the same problems with send/receive. Had those problems
for several weeks or months now. Not sure when those started.

These send/receive problems are known and there are several bug=20
reports all over the internet and also on this list.

Not sure if or when this gets fixed. It's broken atm.

Michael


On 2016-06-22 14:01, Lubos Kolouch wrote:
> Hello,
>=20
> I am having strange issue with btrfs send/receive:
>=20
> #btrfs send -p /mnt/a/_btrbk_snap/debian.20160621_1 /mnt/a/_btrbk_snap/=
debian.20160622 | btrfs receive /mnt/ext/backups/vaclfw/
>=20
> At subvol /mnt/a/_btrbk_snap/debian.20160622
> At snapshot debian.20160622
> ERROR: unlink var/lib/samba/private/msg.sock/7992 failed. No such file =
or directory
>=20
>=20
> But :
>=20
> ls -la /mnt/a/_btrbk_snap/debian.20160621_1/var/lib/samba/private/msg.s=
ock/
> 2330   2388   2394   29375  7992
>=20
> ls -la /mnt/ext/backups/vaclfw/debian.20160621_1/var/lib/samba/private/=
msg.sock/
> 2330   2388   2394   29375  7992
>=20
> uname -a
> Linux vaclfw 4.6.0-1-amd64 #1 SMP Debian 4.6.2-1 (2016-06-15) x86_64 GN=
U/Linux
>=20
> # btrfs version
> # btrfs-progs v4.5.2
>=20
> What could be wrong?
>=20
> Thanks
>=20
> Lubos
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Kg5NDKhmchJ5j05Fh2b3E6dJlDCQFrsI9--

--IDAQUMqxErjF0glIgCBDhBwsILWjRoCOD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCQAGBQJXariKAAoJEPMsk5xVZv93oq4QALvempC215SQqL7OnqBbD5ox
zkyJj9jvMBu5tC+yir4kSImrvLX/Tweh7T3TZjRuckmbmGC/IEBNaDHP9FBagIOU
dIHMhZ7NAEZER12XYOQl67ZaagNHz0lYQftYRuqmjfOgL9Vwb2u6AZC3zHKI/6y0
rhFl/Iy57qO2MBiRi0BRr1OcEASzEsOC5Q1zlqa3CVAZGP692eTT1xDPg4+hqzrl
CnzX8jaJJKxULJiwohYxxHqqRccY0+yc4w4DRfOaBPpyUyYReBwwjZ/NhwyLS14H
NPW1sKbknKlWyt7kKinZmZbhhGo1A5AK2Wo8MM69ki/o0S3NXJ08YjTCYJf2n8I8
E2Eyese2Nl0kL9WjT+BOHHEv8Rby16KwcJlv9efFM5I0yrKq1K/SlIlQcySfZlut
+2Wj439opUSYZTDa5qvvgBrhYYhXGTAi6+TemUFecjgw8RBmIOY8n7itBWqyFEEX
a0O/Sj73kZIcJCaZC9GHpD/gmgjrQNl87rO8hn7xL31DovMZUptHZLXPpgh2Zo4E
X1E4L781yk2ooFjrEuyEvpourznBW3AjTKzRUoh1uwkB+To4PD6C+BL4mwwTkE1w
e8Uamjibjmi+qXTy86BZjJ5YoA8OnkFu/WpvHlWc6z7rj/4NrMJE7cv09hHhtlYL
ijInlAXAcR0Nb34KPJ8x
=X/PM
-----END PGP SIGNATURE-----

--IDAQUMqxErjF0glIgCBDhBwsILWjRoCOD--
