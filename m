Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45701 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753749AbeCUV4Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 17:56:16 -0400
Date: Wed, 21 Mar 2018 21:56:15 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Shane Walton <shane.walton@indepth.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Out of space and incorrect size reported
Message-ID: <20180321215615.GE17966@carfax.org.uk>
References: <4B67E3B8-BF96-43A5-9F0E-91B32496CE7E@indepth.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
In-Reply-To: <4B67E3B8-BF96-43A5-9F0E-91B32496CE7E@indepth.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 21, 2018 at 09:53:39PM +0000, Shane Walton wrote:
> > uname -a
> Linux rockstor 4.4.5-1.el7.elrepo.x86_64 #1 SMP Thu Mar 10 11:45:51 EST 2=
016 x86_64 x86_64 x86_64 GNU/Linux
>=20
> > btrfs =E2=80=94version=20
> btrfs-progs v4.4.1
>=20
> > btrfs fi df /mnt2/pool_homes
> Data, RAID1: total=3D240.00GiB, used=3D239.78GiB
> System, RAID1: total=3D8.00MiB, used=3D64.00KiB
> Metadata, RAID1: total=3D8.00GiB, used=3D5.90GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D59.31MiB
>=20
> > btrfs filesystem show /mnt2/pool_homes
> Label: 'pool_homes'  uuid: 0987930f-8c9c-49cc-985e-de6383863070
> 	Total devices 2 FS bytes used 245.75GiB
> 	devid    1 size 465.76GiB used 248.01GiB path /dev/sda
> 	devid    2 size 465.76GiB used 248.01GiB path /dev/sdb
>=20
> Why is the line above "Data, RAID1: total=3D240.00GiB, used=3D239.78GiB=
=E2=80=9D almost full and limited to 240 GiB when there is I have 2x 500 GB=
 HDD?  This is all create/implemented with the Rockstor platform and it say=
s the =E2=80=9Cshare=E2=80=9D should be 400 GB.
>=20
> What can I do to make this larger or closer to the full size of 465 GiB (=
minus the System and Metadata overhead)?

   Most likely, you need to ugrade your kernel to get past the known
bug (fixed in about 4.6 or so, if I recall correctly), and then mount
with -o clear_cache to force the free space cache to be rebuilt.

   Hugo.

--=20
Hugo Mills             | Q: What goes, "Pieces of seven! Pieces of seven!"?
hugo@... carfax.org.uk | A: A parroty error.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJastT+AAoJEFheFHXiqx3kzYUP/3TYXp9ldcpExWfLBOgXIipZ
UWaJNsKsH9l7V9ilXQrof2QRbamTnKDkEuTyG4NlSKl1ccDlKejqvEoEfTf0BfSx
CPZF3YHbhhJYgw+5SS06Fh9ouGBoAP+Y12Rcyv4DSusrqh4FGXDahZz8M7WwYWC2
Pci4zOmP2k8bc61nQiErTD+Bs9/dDaW+IXgz+6suBEljGnXWngygr7HR3LwJVeQP
FGYiXZsK+Bifsa9xPs03yjzXsnbId89N/gGrR43MhMUpqHkJUXGkM6uHQEq5Hw8B
UYdrgAr7WEZBOwV72Z26Po0O/gAXoKAbdbTHl9L/oLtAvIMrrsvf+RCHMl1rmQG5
8jBEA3zcvJsENbkyyXTBUKBjS2SeGK12phGnnNhaofULPyv3BXezgHXlFzil3rf8
Sbx0gLSBv4OPoqG5UkQEgZWxyIb14pExcr6OVu4YmqwCnf82TB82LbNheGVXjz6A
/rgZZB1CYqWNjW0sIqEmeeq3NJqNOqq0ci0U/Lx6n3hKVns38tg5mG+dvfC77ApP
PyO+jReQ+pmLZkrO7CbPPAVXzoll8C5hzfWS8jc1FfoyexHKlYBQn/dWK0SSUu9y
nPCoVSZAsFdPpHSysTqUlajKzLEnpHVAoNc61feyDtL8Z1Q87TcNzbvBH37ynmZQ
Vb7BLOnBFbBPXl16hz87
=Z2/4
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
