Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:32944 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbKIOOb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 09:14:31 -0500
Received: by wmec201 with SMTP id c201so81572705wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 06:14:29 -0800 (PST)
Subject: Re: [PATCH] btrfs-progs: Fix partitioned loop devices resolve.
To: Karel Zak <kzak@redhat.com>
References: <56409A52.2000708@commerceguys.com>
 <20151109141256.GW19508@ws.net.home>
Cc: linux-btrfs@vger.kernel.org
From: Florian Margaine <florian.margaine@commerceguys.com>
Message-ID: <5640AA3F.2030008@commerceguys.com>
Date: Mon, 9 Nov 2015 15:14:23 +0100
MIME-Version: 1.0
In-Reply-To: <20151109141256.GW19508@ws.net.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6gUrfeAUlaXFG7cgi2AOBDcqgFABd6Qxf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6gUrfeAUlaXFG7cgi2AOBDcqgFABd6Qxf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable



On 11/09/2015 03:12 PM, Karel Zak wrote:
> On Mon, Nov 09, 2015 at 02:06:26PM +0100, Florian Margaine wrote:
>> Instead of using string functions to extract the device name and readi=
ng
>> this file, this patch uses the loop device API through ioctl to get th=
e
>> correct backing file.
>=20
>     #define LO_NAME_SIZE    64
>=20
>     struct loop_info64 {
>         ...
>         uint8_t         lo_file_name[LO_NAME_SIZE];
>     };
>=20
>=20
> The loopdev is based on file descriptor, the lo_file_name[] is hint
> only and it does not have to match with the real path and the most
> important problem is that it uses 64-bytes buffer.
>=20
> For losetup we use LOOP_GET_STATUS64 ioctl as fallback solution only.

So btrfs-progs should do the same? Use the /sys filesystem by default,
and use ioctl if it doesn't find the file?

>=20
>     Karel
>=20
>=20

--=20
Florian Margaine

Product Engineer @ Platform.sh
https://platform.sh

https://keybase.io/fmargaine


--6gUrfeAUlaXFG7cgi2AOBDcqgFABd6Qxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWQKo/AAoJEIQ/bXU9lJcq2d4IAI7SEErHoLBCOequFc3s3i4/
5eZ51o6o4dnHzGLZvgpu40ClS9OeQlb9U6A5awCQz5NifGy7/tT9lQVo2zwmich9
CY/wi/Od9xW6h5sRlVzK/DDMd23H5ACh+zcc0pIvYKDDQT+ECrIBrFMtXUpeoUvV
eRfU56HK/y398OAbfrhw0hfeYQvO8HdStLSuXmrODNUtUuXki6DfBWiLHOyjeCdi
N11oWX/T619S7B4Uua1yjbwRwI3GQvyYWpYRvZW9ciWFLrPACuUNPV2pavTODcje
K7Fiv0ac5ZQDeJ4yOcuh/d4viXdfq9F2BoysoH20r4lGhw5ghK7D3FdWvh63eQ8=
=SRzI
-----END PGP SIGNATURE-----

--6gUrfeAUlaXFG7cgi2AOBDcqgFABd6Qxf--
