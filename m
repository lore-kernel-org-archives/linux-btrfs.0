Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:48231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753924AbeEHGKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 02:10:32 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: tests: check btrfs qgroup parent-child
 relation output
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
 <20180508054803.20851-2-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ef00c885-c912-8027-6790-317fd8341e78@gmx.com>
Date: Tue, 8 May 2018 14:10:25 +0800
MIME-Version: 1.0
In-Reply-To: <20180508054803.20851-2-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0KMWtnxuLqNqiA3p6JdnRlcAazel7LWvp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0KMWtnxuLqNqiA3p6JdnRlcAazel7LWvp
Content-Type: multipart/mixed; boundary="0rjBhXOrcbVQwUpjgTXOizLyh4Zy1Wxtq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <ef00c885-c912-8027-6790-317fd8341e78@gmx.com>
Subject: Re: [PATCH 2/2] btrfs-progs: tests: check btrfs qgroup parent-child
 relation output
References: <20180508054803.20851-1-lufq.fnst@cn.fujitsu.com>
 <20180508054803.20851-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180508054803.20851-2-lufq.fnst@cn.fujitsu.com>

--0rjBhXOrcbVQwUpjgTXOizLyh4Zy1Wxtq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8808=E6=97=A5 13:48, Lu Fengqi wrote:
> Since commit aaf2dac5ef37 ("btrfs-progs: qgroup: split update_qgroup to=

> reduce arguments") cause qgroup show to output the wrong qgroup
> parent-child relationship, in addition to fixing the problem, a test ca=
se
> is needed to prevent the similar problem in the future.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  .../031-qgroup-parent-child-relation/test.sh  | 27 +++++++++++++++++++=

>  1 file changed, 27 insertions(+)
>  create mode 100755 tests/misc-tests/031-qgroup-parent-child-relation/t=
est.sh
>=20
> diff --git a/tests/misc-tests/031-qgroup-parent-child-relation/test.sh =
b/tests/misc-tests/031-qgroup-parent-child-relation/test.sh
> new file mode 100755
> index 000000000000..5be32aef58d9
> --- /dev/null
> +++ b/tests/misc-tests/031-qgroup-parent-child-relation/test.sh
> @@ -0,0 +1,27 @@
> +#!/bin/bash
> +# Test that btrfs qgroup show output the correct parent-child qgroup r=
elation
> +
> +source "$TEST_TOP/common"
> +
> +check_prereq mkfs.btrfs
> +check_prereq btrfs
> +
> +setup_root_helper
> +prepare_test_dev
> +
> +run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
> +run_check_mount_test_dev
> +
> +run_check $SUDO_HELPER "$TOP/btrfs" quota enable "$TEST_MNT"
> +run_check $SUDO_HELPER "$TOP/btrfs" qgroup create 1/0 "$TEST_MNT"
> +run_check $SUDO_HELPER "$TOP/btrfs" qgroup assign 0/5 1/0 "$TEST_MNT"
> +run_check $SUDO_HELPER "$TOP/btrfs" quota rescan -w "$TEST_MNT"
> +
> +run_check_stdout $SUDO_HELPER "$TOP/btrfs" qgroup show --sort=3D-qgrou=
pid \
> +	-p "$TEST_MNT" | tail -n 1 | grep -q "1/0" \
> +	|| _fail "parent qgroup check failed, please check the log"
> +run_check_stdout $SUDO_HELPER "$TOP/btrfs" qgroup show --sort=3Dqgroup=
id \
> +	-c "$TEST_MNT" | tail -n 1 | grep -q "0/5" \
> +	|| _fail "child qgroup check failed, please check the log"
> +
> +run_check_umount_test_dev "$TEST_MNT"
>=20


--0rjBhXOrcbVQwUpjgTXOizLyh4Zy1Wxtq--

--0KMWtnxuLqNqiA3p6JdnRlcAazel7LWvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrxP1EACgkQwj2R86El
/qgI4gf+Jry8Q8ieRRRaEhygk66q44RmrOFtpFachmXpUvUwJ+AUQaSudFG7ErR9
3BdGXxPqS5WHJvq3fSrRI/BkCYpgXoHOcgPFIK3lng19FyXF4bCatwoAzQlLHHT+
r3zadT/mI6XOGBTdHL7v8nfZChkie0qkhGyjJYETS0HqLS6TH4jAByGsGr4WgLej
gMBhbqu29ruSUgCS3leM0GHzjyHYFAnufu8tAMzG5grt5I1HA/Vb/XBuYGW6KYj4
k42p35ZjaI16WSwv60ddC+nm6+VlyUisqfFyU8E4/KM02mL+lwClSk/mDG70UNGX
Xy2hgYdmXVOZwbHwYeDwiUgj8pkCgA==
=qdmg
-----END PGP SIGNATURE-----

--0KMWtnxuLqNqiA3p6JdnRlcAazel7LWvp--
