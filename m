Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33779 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbbKJIf3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 03:35:29 -0500
Received: by wmec201 with SMTP id c201so121106390wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 00:35:28 -0800 (PST)
Subject: Re: [PATCH] btrfs-progs: Fix partitioned loop devices resolve.
To: Karel Zak <kzak@redhat.com>
References: <56409A52.2000708@commerceguys.com>
 <20151109141256.GW19508@ws.net.home>
Cc: linux-btrfs@vger.kernel.org
From: Florian Margaine <florian.margaine@commerceguys.com>
Message-ID: <5641AC4A.2090703@commerceguys.com>
Date: Tue, 10 Nov 2015 09:35:22 +0100
MIME-Version: 1.0
In-Reply-To: <20151109141256.GW19508@ws.net.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GDE7wClk55IA2IlXKnXRf2GjV6j3uMajb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GDE7wClk55IA2IlXKnXRf2GjV6j3uMajb
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

I was thinking that this kind of code could be used, can you confirm
that this would be fine? Untested code:

static int resolve_loop_device()
{
    int ret;
    ret =3D fopen('/sys/...', 'r');
    if (ret =3D=3D NULL)
        if (errno =3D=3D ENOENT)
            return resolve_loop_device_ioctl();
}

static int __attribute__((noinline)) resolve_loop_device_ioctl()
{
    /* use ioctl */
}

This would use the normal path most of the time, and use the fallback
only if necessary. The 64-bytes buffer issue would be mitigated.

>=20
>     Karel
>=20
>=20

--=20
Florian Margaine

Product Engineer @ Platform.sh
https://platform.sh

https://keybase.io/fmargaine


--GDE7wClk55IA2IlXKnXRf2GjV6j3uMajb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWQaxKAAoJEIQ/bXU9lJcqalIH/1HjhJTcqgpRrQgKaylSou2d
5ZEiVnRgDlRDo8RTRdeYeE0MXVcaQOm4adiqC1+5KSyu/nFx8M26K2PmP0mZQ68f
j67VhXcuPLn5g1iQ7dmoW9LQYLtNldMXC/tuAbEYwxuvx6ZnYe3+nV4eIhWlZUuY
cC8dSMFO11KHysc2yD1DRzRJ5dpM8w/h+rgAqmiev7S0ncuSlDBfgOwb7Ye83zKM
JX/udpjPfkZFNwOKYZmbfsLOPOldf1VnTQcz0xgNa8NKK9ItdcBDp0Cu+xgFCS7p
bh179vtODq43hsyABV7+H9EPK6ozC6Yd8TT7E6MLycIFvI/QMYLpP5cPhYClQ20=
=i25o
-----END PGP SIGNATURE-----

--GDE7wClk55IA2IlXKnXRf2GjV6j3uMajb--
