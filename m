Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:35629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933115AbeD1AU2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 20:20:28 -0400
Subject: Re: Problems with btrfs
To: "David C. Partridge" <david.partridge@perdrix.co.uk>,
        linux-btrfs@vger.kernel.org
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com>
Date: Sat, 28 Apr 2018 08:20:21 +0800
MIME-Version: 1.0
In-Reply-To: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BY8OYUFCK2FU8iSGlvCwpfoRMijCDN5Eo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BY8OYUFCK2FU8iSGlvCwpfoRMijCDN5Eo
Content-Type: multipart/mixed; boundary="TDqKxYGZqWjziNZt8NfAouc9ME1yLixgi";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "David C. Partridge" <david.partridge@perdrix.co.uk>,
 linux-btrfs@vger.kernel.org
Message-ID: <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com>
Subject: Re: Problems with btrfs
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk>
In-Reply-To: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk>

--TDqKxYGZqWjziNZt8NfAouc9ME1yLixgi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 02:38, David C. Partridge wrote:
> I'm running Ubuntu 16.04.  I rebooted my server today as it wasn't
> responding.
>=20
> When I rebooted the root FS was read only.
>=20
> I booted a live Ubuntu CD and checked the drive with the results shown =
in
> attachment btrfs-check.log.
>=20
> The error was still there after completing the btrfs check --repair :( =
And
> when I deleted some old subvolumes from there after that the filesystem=
 went
> read-only with a bunch errors in dmesg which are in the attached file
> btrfs-dmesg-errs.log.
>=20
> Of course my last backup was longer ago than I like to think about. Tho=
ugh I
> could restore back to about 8 months ago, I'd very much prefer not to .=
=2E.
>=20
> On my bootable CD the Kernel is 4.18.3 and btrfs-progs is 4.7.3-1

Hello time traveler. :)
Or it's just 4.16.3.

Btrfs-progs is a little old, and it is not recommended to execute btrfs
check --repair until you know that the problem is.

Fortunately it doesn't cause further damage, although it doesn't fix it
neither.

The offending tree block is 224304857088, please dump the following info
(using latest btrfs-progs if possible)

# btrfs inspect dump-tree -b 224304857088 /dev/mapper/Charon--vg-root
# btrfs inpsect dump-tree /dev/mapper/Charon--vg-root | grep -C 20

Thanks,
Qu

>=20
> HELP!!!
>=20
> If do have enough space to copy stuff off the root volume but I think I=
'll
> need hand holding through the recovery process.
>=20
> The volume has sub-volumes called @ and @home which are mounted as / an=
d
> /home respectively.=20
>=20
> Thanks
> David
>=20
>=20


--TDqKxYGZqWjziNZt8NfAouc9ME1yLixgi--

--BY8OYUFCK2FU8iSGlvCwpfoRMijCDN5Eo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrjvkUACgkQwj2R86El
/qhiMgf/eEPzES/ghevQZdc0EdeVd8ykiSVE0GlPfHZBwJno9GoJXYQQ/WAIwpOp
yRZSJkVf38zY8jyVZ+u2YGz0SX9i49HGiROBk2dqd3ICD/pWfKy6oRDnQ+jIw71j
fsTiRceoKwiKdQ5syvthjoYcbwaUGwzOGW9u/Dkps5e/udGg/npVIkSK83EHxFiD
U8oZ0k/L4rwTccK5RBN+08XJTS0eaeWGXhkFv7gVtVJgKE37MHb4Mrt8qJIipjoa
rv6dT/mHAZGs0Fdm5VTYcyIJ2Y0hn8sZ1Vs0dxegmc0xbnVhFC/SSkbcGUCOWi1U
FXrsEwTHnhvZWVkGuef/tvJvksLYvQ==
=bLp3
-----END PGP SIGNATURE-----

--BY8OYUFCK2FU8iSGlvCwpfoRMijCDN5Eo--
