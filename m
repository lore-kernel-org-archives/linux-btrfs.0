Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52304 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbbDMOHh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:07:37 -0400
Date: Mon, 13 Apr 2015 14:07:36 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael Tharp <gxti@partiallystapled.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Degraded volume silently fails to mount
Message-ID: <20150413140736.GC22084@carfax.org.uk>
References: <552BC9CD.6090406@partiallystapled.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
In-Reply-To: <552BC9CD.6090406@partiallystapled.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 13, 2015 at 09:51:09AM -0400, Michael Tharp wrote:
> Hi list,
>=20
> I've got a 4 disk raid1 volume that has one failed disk. I have so
> far been unable to mount it in degraded mode, but the failure is
> that "mount" silently does nothing.

   Check to see if systemd is unmounting it immediately after
mount. This seems to be the usual reason for silent failures to mount
an FS these days.

   Hugo.

>  # btrfs fi sh
> warning devid 2 not found already
> Label: 'seneca'  uuid: b9da07f5-c0fd-45ad-861b-d1bcad6cbf4c
> 	Total devices 4 FS bytes used 581.71GiB
> 	devid    1 size 931.51GiB used 334.02GiB path /dev/mapper/luks-seneca-1
> 	devid    3 size 931.51GiB used 334.01GiB path /dev/mapper/luks-seneca-3
> 	devid    4 size 931.51GiB used 334.01GiB path /dev/mapper/luks-seneca-4
> 	*** Some devices missing
>=20
> Btrfs v3.18.1
>  # mount -t btrfs -o degraded /dev/mapper/luks-seneca-1 /seneca
>  # echo $?
> 0
>  # ls /seneca/
>  # grep seneca /proc/mounts
>  # dmesg |tail
> [   84.955467] BTRFS: device label seneca devid 1 transid 1753 /dev/dm-4
> [   87.926347] BTRFS: device label seneca devid 4 transid 1753 /dev/dm-5
> [  107.069109] BTRFS: device label seneca devid 3 transid 1753 /dev/dm-6
> [  195.267046] BTRFS info (device dm-6): allowing degraded mounts
> [  195.267094] BTRFS info (device dm-6): disk space caching is enabled
> [  195.267133] BTRFS: has skinny extents
> [  195.277615] BTRFS warning (device dm-6): devid 2 missing
> [  781.160250] BTRFS info (device dm-6): allowing degraded mounts
> [  781.160270] BTRFS info (device dm-6): disk space caching is enabled
> [  781.160286] BTRFS: has skinny extents
>  # uname -a
> Linux ambrosia.homeslice 3.19.3-200.fc21.x86_64 #1 SMP Thu Mar 26
> 21:39:42 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>  # btrfs --version
> Btrfs v3.18.1
>=20
>=20
> Any ideas?

--=20
Hugo Mills             | What's a Nazg=FBl like you doing in a place like t=
his?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Ill=
iad

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVK82nAAoJEFheFHXiqx3kraMP/2fHZykTjX9e7nCIQF8r4V7/
pm08K0YHJunIKoRPCaQLYxbUl5IBVKO3BPQSVaUD5N5zjK6K9RFywGBwX7Rqdcl+
xmRPftB1vcTXkkaEjBW/HMsjkfTKV/wMRbjtZtaeg816RJTDkkGNZWanpQ/0Rmsx
zc8vGzz5cYSrMmUkLy8Q1LQlZUuyYykv3Vc85Eaer5aXECgWTBKec8XhXsnI8RLK
P/t+ICmKya4UKBULorkip6dSfbep+5mfqDSiWFd7BHw0hNnbORIQA1HGgKYoZG/Y
ay1syhLLdKM+6HJqkPmufqEGG0hQYgHUQswve212BFnm2nyWiPMctyyLUdtdVYIo
HAQaQAm+qlvK5jXjKdzSHT0ubxYja3Os2A6Ia7MEnGrUxvbCr02XezwpYjQughis
yHsiTILZXF+c4RarAsBQy/sBEYQ+gc8rVLogiDdqh1m75Bq2p6lGzQhx3pafmCiw
3D9aQr7Nbd4d/lqJ56BuuwNedbtddfG/E0lklW+dqD8nJrsjXNXjDm/PyQRLHRwk
GKbFUULSDtnpUmEhtTi7fXFE0STpw7Bf2JIP7DQ/imvb4wAddTmIVhEBhFRY2xsL
blhUxcxOMOLYWEWCMK0COlIp5UyntLDgD201uhaUvE/2To+/Nvwar+2Qyu0xc9vG
P//SrvDwBWTC7ohdELVw
=hecN
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
