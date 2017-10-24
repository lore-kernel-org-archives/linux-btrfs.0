Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58002 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751740AbdJXJiJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 05:38:09 -0400
Subject: Re: super_total_bytes 32004083023872 mismatch with fs_devices
 total_rw_bytes 64008166047744
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <13409678.203.1508836811909.JavaMail.gkos@dynomob>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bde403d9-c487-d385-deb1-35c898765f7a@gmx.com>
Date: Tue, 24 Oct 2017 17:37:56 +0800
MIME-Version: 1.0
In-Reply-To: <13409678.203.1508836811909.JavaMail.gkos@dynomob>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3cPxwFXQuxmGLJc5l5O7mc6oXkcQB9rOk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3cPxwFXQuxmGLJc5l5O7mc6oXkcQB9rOk
Content-Type: multipart/mixed; boundary="QSWQ600ni82HUoK8s0DvVb5dMCCOIi7lD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
 Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <bde403d9-c487-d385-deb1-35c898765f7a@gmx.com>
Subject: Re: super_total_bytes 32004083023872 mismatch with fs_devices
 total_rw_bytes 64008166047744
References: <13409678.203.1508836811909.JavaMail.gkos@dynomob>
In-Reply-To: <13409678.203.1508836811909.JavaMail.gkos@dynomob>

--QSWQ600ni82HUoK8s0DvVb5dMCCOIi7lD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8824=E6=97=A5 17:20, Konstantin V. Gavrilenko wr=
ote:
> Hi list,
>=20
> having installed the recent kernel version I am no longer able to mount=
 the btrfs partition with compression on the first attempt. Previously on=
 4.10.0-37-generic everything was working fine, once I switched to 4.13.9=
-041309-generic I started getting the following error while trying to mou=
nt it with the same  options "compress-force=3Dzlib,space_cache=3Dv2"
>=20
> [  204.596381] BTRFS error (device sda): open_ctree failed
> [  204.631895] BTRFS info (device sda): force zlib compression
> [  204.631901] BTRFS info (device sda): using free space tree
> [  204.631903] BTRFS info (device sda): has skinny extents
> [  204.890145] BTRFS error (device sda): super_total_bytes 320040830238=
72 mismatch with fs_devices total_rw_bytes 64008166047744
> [  204.891276] BTRFS error (device sda): failed to read chunk tree: -22=

> [  204.944333] BTRFS error (device sda): open_ctree failed

Such problem can be easily fixed with this branch:
https://github.com/adam900710/btrfs-progs/tree/check_unaligned_dev

Use "btrfs rescue fix-device-size" should handle it well.

But the problem is, normally the super_total_bytes should only be less
than 4K smaller than total device size.

Unless something else went wrong, it should not have such large differenc=
e.

>=20
> For some reason, the super_total_bytes is exactly half of total_rw_byte=
s.
>=20
>=20
> however, if after unsuccessful first mount attempt, I mount it with min=
imum number of options "space_cache=3Dv2" the partition mounts. Then I um=
ount it, and mount normally, with full set of options "compress-force=3Dz=
lib,space_cache=3Dv2" it mounts without an error.
> I also observed the same error on 4.12.14-041214-generic
> Any ideas why this might be happening?

Would you please provide super dump by:

# btrfs inspect-internal dump-super -fa /dev/sda

(Although I don't think it will be very interesting since it can be
mounted later)

And device tree dump by:
# btrfs inspect-internal dump-tree -t dev /dev/sda

Normally it should not be mountable after v4.6 kernel if
super_total_bytes mismatch, but I'm more interested in how it mounted
successfully.


And BTW, are you using x86_64 kernel or x86 kernel?
I don't think it's related in your case, but some reports about 32bit
kernel has strange bugs are in mail list, so just in case.

Thanks,
Qu


>=20
>=20
>=20
> System information
>=20
> distribution: Ubuntu 16.04
> btrfs-progs v4.8.1 later upgraded to v4.13.3
>=20
> # btrfs fi usage /mnt/backup
> Overall:
>     Device size:                  29.11TiB
>     Device allocated:             18.04TiB
>     Device unallocated:           11.07TiB
>     Device missing:                  0.00B
>     Used:                         17.99TiB
>     Free (estimated):             11.12TiB      (min: 5.58TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>=20
> Data,single: Size:17.93TiB, Used:17.88TiB
>    /dev/sda       17.93TiB
>=20
> Metadata,DUP: Size:53.50GiB, Used:51.78GiB
>    /dev/sda      107.00GiB
>=20
> System,DUP: Size:8.00MiB, Used:2.30MiB
>    /dev/sda       16.00MiB
>=20
> Unallocated:
>    /dev/sda       11.07TiB
>=20
>=20
>=20
>=20
> Yours sincerely,
> Konstantin V. Gavrilenko
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--QSWQ600ni82HUoK8s0DvVb5dMCCOIi7lD--

--3cPxwFXQuxmGLJc5l5O7mc6oXkcQB9rOk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnvCfQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgFjwf9HxHfdwQn+OCI/0yNBXXKGbZV
bd8/KKacabIIYxm94Db3RvjNk0v+0qBSbelbHk4WUh2zvgRI+4acIg4QFhvulc/A
iyTNGYakA6ENik5R84MplOI+ZlrM0K5ZkGrMzh9yQawxMQNB9Oiawsa+Rra8ZleE
Rt5ttEYxa+FYxEGL1kEo6kmumDfdVfW88lXdup6KVevgRxpOIxRsXEshLf4RkQL5
wKQVea710f2eSmuBcKtxfQx5engv70BLnOAM0U2S6tf4D4vr6VZyaT0BmasBSb+O
zk2ZjelBPtOZ0VkRBhfA7A8V4hgM4V5PFa4gLu3h3PKRYnd7Rjtfvanof6AX6Q==
=dcsx
-----END PGP SIGNATURE-----

--3cPxwFXQuxmGLJc5l5O7mc6oXkcQB9rOk--
