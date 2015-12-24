Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60785 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbbLXK3F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 05:29:05 -0500
Date: Thu, 24 Dec 2015 10:29:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: could not find root 8
Message-ID: <20151224102902.GH1586@carfax.org.uk>
References: <4764679.qpAWc4Esch@zafu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKijDXBCEH69PxaN"
In-Reply-To: <4764679.qpAWc4Esch@zafu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 24, 2015 at 10:04:48AM +0100, Sw=C3=A2mi Petaramesh wrote:
> Hi there,
>=20
> I=E2=80=99m running Arch Linux with kernel 4.2.5-1-ARCH
>=20
> Since a few days, I have noticed a series of messages :
>=20
> =C2=AB BTRFS: could not find root 8 =C2=BB
>=20
> During boot.

   systemd is now probing for qgroups on startup. The message is
simply indicating that qgroups are not enabled on the FS. It's harmless.

   Hugo.

> Besides that, the system behaves normally, and I have no clue=E2=80=A6
>=20
> Here is an extract of the relevant parts of my dmesg :
>=20
> [    1.515764] Btrfs loaded
> [    1.516239] BTRFS: device label BOOT devid 1 transid 8557 /dev/sda8
> [    1.523135] device-mapper: uevent: version 1.0.3
> =E2=80=A6
> [   20.639556] BTRFS: device label LINUX devid 1 transid 474967 /dev/dm-1
> [   20.952280] PM: Starting manual resume from disk
> [   20.952291] PM: Hibernation image partition 254:2 present
> [   20.952295] PM: Looking for hibernation image.
> [   20.952730] PM: Image not found (code -22)
> [   20.952738] PM: Hibernation image not present or could not be loaded.
> [   20.979997] BTRFS info (device dm-1): use ssd allocation scheme
> [   20.980008] BTRFS info (device dm-1): turning on discard
> [   20.980014] BTRFS info (device dm-1): disk space caching is enabled
> [   20.980017] BTRFS: has skinny extents
> [   21.319036] ip_tables: (C) 2000-2006 Netfilter Core Team
> =E2=80=A6
> [   23.047601] FS-Cache: Loaded
> [   23.053089] systemd[1]: Mounted POSIX Message Queue File System.
> [   23.070842] systemd[1]: Mounted Huge Pages File System.
> [   23.072100] systemd[1]: Mounted Temporary Directory.
> [   23.080089] BTRFS info (device dm-1): disk space caching is enabled
> [   23.087653] systemd[1]: Started Remount Root and Kernel File Systems.
> =E2=80=A6
> [   25.429686] BTRFS info (device sda8): use ssd allocation scheme
> [   25.429694] BTRFS info (device sda8): turning on discard
> [   25.429698] BTRFS info (device sda8): disk space caching is enabled
> [   25.429700] BTRFS: has skinny extents
> =E2=80=A6
> [   25.593769] Adding 4530172k swap on /dev/mapper/VGZ-SWAP.  Priority:-1=
=20
> extents:1 across:4530172k SSDscFS
> =E2=80=A6
> [   25.777378] FAT-fs (sda2): utf8 is not a recommended IO charset for FA=
T=20
> filesystems, filesystem will be case sensitive!
> [   25.800485] FAT-fs (sda2): Volume was not properly unmounted. Some dat=
a may=20
> be corrupt. Please run fsck.
> [   25.817125] BTRFS: could not find root 8
> [   25.844334] BTRFS: could not find root 8
> [   25.845650] BTRFS: could not find root 8
> [   25.847190] BTRFS: could not find root 8
> [   25.855431] BTRFS: could not find root 8
> [   25.856834] BTRFS: could not find root 8
> [   25.860539] BTRFS: could not find root 8
> [   25.862021] BTRFS: could not find root 8
> [   29.778795] IPv6: ADDRCONF(NETDEV_UP): enp3s0: link is not ready
> =E2=80=A6
>=20
> TIA, kind regards.
>=20

--=20
Hugo Mills             | I am an opera lover from planet Zog. Take me to yo=
ur
hugo@... carfax.org.uk | lieder.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--gKijDXBCEH69PxaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWe8juAAoJEFheFHXiqx3kABgP/j9c6/AcrO1WMmjaryPxAIHi
nM+mNGsktWFfeVQlJtHPl2GHfwMUkQvlDvgd7Aaa52Ly+ceS8ijhFOr0OaHcLZ9W
+kzwhPTvo7VcDKGvciXSEZYeBuBDvPipILShTC9UalB/xzGSq9iw4IFzg3bHPSBP
1OSLxr67ovKFBh6vOZ8LqJZ2vcsgF+btAHvGASNCbjsrMqBfdyDjoRPdb2Zvahta
U3GM5qCDbS+v7gpqJXikzikfBDwxX25ra4X+J/6o4SCImZFGcWmAYZ/IjLIdnPSI
kQ8L3HlqK+IzFvM+Ut6QG6eVFFbjNBLqGFVMjzxQMhqXMVO+wNhCdz8a2f3k5Cc9
yf9WfI1FQWEc/NP/liVMEO2/dMVbnHlW93ZUCl+gy72IqyhkUDTBVT1k95gGXsFi
85ImpxbO8ciPDNWuQUXgVJD5kDFPg5GiznKY1HUXdQZDhBbLdlZlipd/oPhIMw5j
SDVoNHh5v3vNt5C504PGC27i9J8SbTiZjJ9yKsDpWb000xNcG1qJaOvT1Rq0mBkW
d7BRSB9T074h/Nx26ZlMjjTVRIOVfGT1RiQzw9LHvoTa0Sf0vWQkZi/E9RI7kx8N
yrJG8vR8H63Uyw8GeSMY1LawUFYpwbvxav2+FP/Saj17CuyUEe5uawhYbyGPjtLE
appwMhLbpVI9FEFZq5e1
=tGNx
-----END PGP SIGNATURE-----

--gKijDXBCEH69PxaN--
