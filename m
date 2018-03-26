Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:33625 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbeCZOT7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 10:19:59 -0400
Subject: Re: [PATCH v2] btrfs-progs: Add test for collision DIR_ITEM handling
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <1522072774-2113-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ff0743b5-f096-6b75-28a1-43b50bd28647@gmx.com>
Date: Mon, 26 Mar 2018 22:19:49 +0800
MIME-Version: 1.0
In-Reply-To: <1522072774-2113-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OryEfJjiC2myJbaZlKrVW2kZQhaKtGL8v"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OryEfJjiC2myJbaZlKrVW2kZQhaKtGL8v
Content-Type: multipart/mixed; boundary="OCLyFRjAgusgUpcwVvxLfMhcz7sivOM1Q";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ff0743b5-f096-6b75-28a1-43b50bd28647@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: Add test for collision DIR_ITEM handling
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <1522072774-2113-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1522072774-2113-1-git-send-email-nborisov@suse.com>

--OCLyFRjAgusgUpcwVvxLfMhcz7sivOM1Q
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8826=E6=97=A5 21:59, Nikolay Borisov wrote:
> Verify that if we have an otherwise clean filesystem, containging colli=
ded
> DIR_ITEM, btrfs check lowmem's mode can correctly handle those and not =
produce
> any false positives.
>=20
> This if fixed by commit titled:
>=20
>  "btrfs-progs: Fix DIR_ITEM checking in lowmem"
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  .../031-lowmem-collission-dir-items/test.sh        | 23 ++++++++++++++=
++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100755 tests/fsck-tests/031-lowmem-collission-dir-items/te=
st.sh
>=20
> diff --git a/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh b=
/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
> new file mode 100755
> index 000000000000..fa0b88af0557
> --- /dev/null
> +++ b/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
> @@ -0,0 +1,23 @@
> +#!/bin/bash
> +# Ensure that running btrfs check on a fs which has name collisions of=
 files
> +# doesn't result in false positives. This test is specifically targete=
d at
> +# lowmem mode.
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
> +run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e206~~~~~~~~XVT1U3ZF647YS2=
PD4AKAG826"
> +run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e26a~~~~~~~~AP1C3VQBE79IJO=
TVOEZIR9YU"
> +
> +run_check_umount_test_dev
> +
> +# The fs is clean so lowmem shouldn't produce any warnings
> +run_check "$TOP/btrfs" check --readonly "$TEST_DEV"
>=20


--OCLyFRjAgusgUpcwVvxLfMhcz7sivOM1Q--

--OryEfJjiC2myJbaZlKrVW2kZQhaKtGL8v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq5AYYACgkQwj2R86El
/qitvgf7BXw6Lv233moHZxXdG+qyvFVzru/rJu/SM2CzDpV1JdSyOT4szNSGlqKi
BNtbvoyw1xASgrTWUIP5UCFVZ/9+daEY187NVChgCPPFwWm/glLh22N6S5QVuAmk
TJLRpR/QlO+kAkWz6qlGPgQtI2rAaqZtggTC+QImetRSCYHEi0nCrFQDguYQzvHb
0XmJGtJXSOjXZp+FSIDLs/UGjXoSkA8HvBpOLR+2CyiKumA+6Pi367shJdTH0v+O
+gLJsrwk0K+isXM+o+G3WBoirL2ZqrWYyS7CFTxXvbgyoAzluex8ueeghT/4wvBy
JIDdZAK44HtwCs55ZSyyzGzNhEw16A==
=+bgK
-----END PGP SIGNATURE-----

--OryEfJjiC2myJbaZlKrVW2kZQhaKtGL8v--
