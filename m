Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60579 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751985AbeCYLpA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Mar 2018 07:45:00 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: Add test for collision DIR_ITEM handling
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <1521816494-22947-2-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <617236e1-acc0-33b7-8697-a29036296829@gmx.com>
Date: Sun, 25 Mar 2018 19:44:49 +0800
MIME-Version: 1.0
In-Reply-To: <1521816494-22947-2-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="behjDweYiWt5jSXTDyuPd0vlmzFqh6iSr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--behjDweYiWt5jSXTDyuPd0vlmzFqh6iSr
Content-Type: multipart/mixed; boundary="DObggXAI6qZgz7qGDhcJmnWH3ubBfT8eh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <617236e1-acc0-33b7-8697-a29036296829@gmx.com>
Subject: Re: [PATCH 2/2] btrfs-progs: Add test for collision DIR_ITEM handling
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <1521816494-22947-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1521816494-22947-2-git-send-email-nborisov@suse.com>

--DObggXAI6qZgz7qGDhcJmnWH3ubBfT8eh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8823=E6=97=A5 22:48, Nikolay Borisov wrote:
> Verify that if we have an otherwise clean filesystem, containging colli=
ded=20
> DIR_ITEM, btrfs check lowmem's mode can correctly handle those and not =
produce
> any false positives.=20
>=20
> This if fixed by commit titled:
>=20
>  "btrfs-progs: Fix DIR_ITEM checking in lowmem"=20
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks pretty good.

However a nitpick inlined below.

> ---
>  .../031-lowmem-collission-dir-items/test.sh        | 27 ++++++++++++++=
++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100755 tests/fsck-tests/031-lowmem-collission-dir-items/te=
st.sh
>=20
> diff --git a/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh b=
/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
> new file mode 100755
> index 0000000..8a01889
> --- /dev/null
> +++ b/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
> @@ -0,0 +1,27 @@
> +#!/bin/bash
> +# Ensure that running btrfs check in lowmem mode on a fs
> +# which contains DIR_ITEM with collissions handles it
> +# properly
> +source "$TEST_TOP/common"
> +
> +check_prereq btrfs
> +check_prereq mkfs.btrfs
> +
> +setup_root_helper
> +prepare_test_dev
> +
> +run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
> +run_check_mount_test_dev
> +
> +# Create 2 files whose names collide
> +
> +run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e206~~~~~~~~XVT1U3ZF647YS2=
PD4AKAG826"
> +run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e26a~~~~~~~~AP1C3VQBE79IJO=
TVOEZIR9YU"
> +
> +run_check_umount_test_dev
> +
> +# The fs is clean so lowmem shouldn't produce any warnings
> +run_check "$TOP/btrfs" check --mode=3Dlowmem --readonly "$TEST_DEV"

I understand this is a pinpoint test case for lowmem mode, but for
lowmem mode test, we set TEST_ENABLE_OVERRIDE and the whole test case
will use lowmem mode.

So it doesn't seem necessary to explicitly call lowmem check here.
Just normal run_check "$TOP/btrfs" check would be enough.
(And this will also test original mode)

> +if [ $? -ne 0 ]; then
> +	_fail "check --lowmem doesn't handle collissioned DIR_ITEMs correctly=
"
> +fi
>=20
IIRC run_check() will check the return value and exit if failure.
So this seems not necessary.

Thanks,
Qu


--DObggXAI6qZgz7qGDhcJmnWH3ubBfT8eh--

--behjDweYiWt5jSXTDyuPd0vlmzFqh6iSr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq3i7EXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjmhQf/TbhZ5k9ueYa1N8rUAM9a0l0X
lQM20NHYh/pAqz+BJLD60DSnXI8D/J0X2GfiHHVnSmtYJb7Xlg1ZVpKDoQ2bQUII
MXOHlWGoxXMI+lG0eunSml12vy6E9MzkH166JGV/blPOZBt1aKwinw6/+zMiPWiL
CwMCDOofdwM4FPEs49s1kMNAPbESHQRMwYRxcloGWmej59bAgAwZ3rzq2UsY4kva
Oiqj+X4LzLB1ru3ZB1XgVP2oRjDzkgc2WncG7qW/8TnUggPw2f5SmcCjPEkvY64Z
4//AbsBmIrlBi6t0RrtZ4tVW0CDz5R3EvWA5GUTkgGlSI9Epy96cvXsVH06gGg==
=2rFR
-----END PGP SIGNATURE-----

--behjDweYiWt5jSXTDyuPd0vlmzFqh6iSr--
