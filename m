Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52457 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752900AbdLEJdv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 04:33:51 -0500
Subject: Re: [PATCH 6/7] btrfs-progs: Add test for super block recovery
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-7-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ea75633b-10e7-28e0-ae47-5502901599de@gmx.com>
Date: Tue, 5 Dec 2017 17:33:45 +0800
MIME-Version: 1.0
In-Reply-To: <1512463189-24724-7-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rHJifKDP51iP5CuAJrkqQTds3x4unHh1s"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rHJifKDP51iP5CuAJrkqQTds3x4unHh1s
Content-Type: multipart/mixed; boundary="26Eg2r6CJXfOb7a1uPi7OKJ5gAtm4BlK5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ea75633b-10e7-28e0-ae47-5502901599de@gmx.com>
Subject: Re: [PATCH 6/7] btrfs-progs: Add test for super block recovery
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-7-git-send-email-nborisov@suse.com>

--26Eg2r6CJXfOb7a1uPi7OKJ5gAtm4BlK5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:
> This functionality regressed some time ago and it was never caught. See=
ms no
> one complained of that, but to be sure add a regression test to prevent=
 future=20
> regressions.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

One nitpick for the patch sequence, normally we put fix before test
case, to avoid breaking bisect.

> ---
>  tests/fsck-tests/029-superblock-recovery/test.sh | 64 ++++++++++++++++=
++++++++
>  1 file changed, 64 insertions(+)
>  create mode 100755 tests/fsck-tests/029-superblock-recovery/test.sh
>=20
> diff --git a/tests/fsck-tests/029-superblock-recovery/test.sh b/tests/f=
sck-tests/029-superblock-recovery/test.sh
> new file mode 100755
> index 000000000000..beb78d6ccc22
> --- /dev/null
> +++ b/tests/fsck-tests/029-superblock-recovery/test.sh
> @@ -0,0 +1,64 @@
> +#!/bin/bash
> +# Test that any superblock is correctly detected
> +# and fixed by btrfs rescue
> +
> +source "$TOP/tests/common"
> +
> +check_prereq btrfs
> +check_prereq mkfs.btrfs
> +check_prereq btrfs-select-super
> +
> +setup_root_helper
> +
> +rm -f dev1
> +run_check truncate -s 260G dev1
> +loop=3D$(run_check_stdout $SUDO_HELPER losetup --find --show dev1)

We have function to do it already.
prepare_test_dev will use loopback device as fallback if $TEST_DEV is
not specified.
Tt can handle size well, and it also uses sparse file so no need to
worry about disk usage.

> +
> +# Create the test file system.
> +run_check $SUDO_HELPER "$TOP"/mkfs.btrfs -f "$loop"
> +
> +function check_corruption {
> +	local sb_offset=3D$1
> +	local source_sb=3D$2
> +
> +
> +	# First we ensure we can mount it successfully
> +	run_check $SUDO_HELPER mount $loop "$TEST_MNT"
> +	run_check $SUDO_HELPER umount "$TEST_MNT"
> +
> +	# Now corrupt 1k of the superblock at sb_offset
> +	run_check $SUDO_HELPER dd bs=3D1K count=3D1 seek=3D$(($sb_offset + 1)=
) if=3D/dev/zero of=3D"$loop"
> +
> +	#if corrupting one of the sb copies, copy it over the initial superbl=
ock
> +	if [ ! -z $source_sb ]; then
> +		local shift_val=3D$((16 << $source_sb * 12 ))
> +		run_check $SUDO_HELPER dd bs=3D1K count=3D4 seek=3D64 skip=3D$shift_=
val if=3D"$loop" of=3D"$loop"
> +	fi

Personally speaking, corrupt 64K (1st super) then corrupt the desired
copy could make the function easier.
Although we need to split the check part from this function, resulting
something like:

corrupt_super 64k
corrupt_super 64m
check_super_recover

> +
> +	run_mustfail "Mounted fs with corrupted superblock" \
> +		$SUDO_HELPER mount $loop "$TEST_MNT"
> +
> +	# Now run btrfs rescue which should fix the superblock. It uses 2
> +	# to signal success of recovery use mayfail to ignore that retval
> +	# but still log the output of the command
> +	run_mayfail $SUDO_HELPER "$TOP"/btrfs rescue super-recover -yv "$loop=
"
> +	if [ $? !=3D 2 ]; then
> +		_fail "couldn't rescue super"
> +	fi

It's understandable to have return value other than 0 to distinguish
health fs from repairable fs.
But at least let's also put this into man page.

Thanks,
Qu

> +
> +	run_check $SUDO_HELPER mount $loop "$TEST_MNT"
> +	run_check $SUDO_HELPER umount "$TEST_MNT"
> +}
> +
> +_log "Corrupting first superblock"
> +check_corruption 64
> +
> +_log "Corrupting second superblock"
> +check_corruption 65536 1
> +
> +_log "Corrupting third superblock"
> +check_corruption 268435456 2
> +
> +# Cleanup
> +run_check $SUDO_HELPER losetup -d "$loop"
> +rm -f dev1
>=20


--26Eg2r6CJXfOb7a1uPi7OKJ5gAtm4BlK5--

--rHJifKDP51iP5CuAJrkqQTds3x4unHh1s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomZ/oXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg6DAf/aOPFtuv05p1G8RzCbwrYgujV
IZbRkiMFWXWzlSU99KaU8sNJfJzu1DWsfJSj2xdrLhazp5Ge0bkB39eA3GPEBVoN
iIQfoJQZFFAC0pYZj4APVFn8I0rs4ly68M41wxGkUIZQ29DHS/lzj6AV9/HKAEjG
o13DuPy1aFwI1t/5njEqy1c9/+0c50NFTRqy+OA+vjK4U00O4OHynadwmSz4NTMW
SDAytiJAOcwo/ZSSA8/xw9derCh4N6uz17U3zbLmvWCYuiwXvOecD1VPojOfT19A
QKejvXXvoB7PTHU0TNjVB+avhYHjXSmAk4dl37EImKBswLRDFHec5x2wbcUABg==
=bsUM
-----END PGP SIGNATURE-----

--rHJifKDP51iP5CuAJrkqQTds3x4unHh1s--
