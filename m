Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:43087 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754748AbeCVN36 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:29:58 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: Remove deprecated btrfs-zero-log
 standalone tool
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1521724707-19180-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <77235266-888e-14d2-ac50-057b6f4d8390@gmx.com>
Date: Thu, 22 Mar 2018 21:29:46 +0800
MIME-Version: 1.0
In-Reply-To: <1521724707-19180-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2qEVUJMW55tQuvl26NxdPdMynX8CXVqEP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2qEVUJMW55tQuvl26NxdPdMynX8CXVqEP
Content-Type: multipart/mixed; boundary="Mzngah1wwM8pi7XcGPHmnQFRKKT5JjYZj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <77235266-888e-14d2-ac50-057b6f4d8390@gmx.com>
Subject: Re: [PATCH 1/3] btrfs-progs: Remove deprecated btrfs-zero-log
 standalone tool
References: <1521724707-19180-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1521724707-19180-1-git-send-email-nborisov@suse.com>

--Mzngah1wwM8pi7XcGPHmnQFRKKT5JjYZj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 21:18, Nikolay Borisov wrote:
> Its function has been subsumed by "btrfs rescue zero-log". Remove its
> source file and adjust make/tests soruces accordingly.

Despite of the lack of sob tag, it looks good.

> ---
>  Makefile                              |  4 +-
>  btrfs-zero-log.c                      | 78 ---------------------------=
--------
>  tests/misc-tests.sh                   |  1 -
>  tests/misc-tests/003-zero-log/test.sh |  6 +--

What about updating .gitignore to remove btrfs-zero-log?

Thanks,
Qu

>  4 files changed, 3 insertions(+), 86 deletions(-)
>  delete mode 100644 btrfs-zero-log.c
>=20
> diff --git a/Makefile b/Makefile
> index a7726e98947d..2a2a76855a26 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -210,7 +210,7 @@ MAKEOPTS =3D --no-print-directory Q=3D$(Q)
>  progs =3D $(progs_install) btrfsck btrfs-corrupt-block
> =20
>  # install only selected
> -progs_install =3D btrfs mkfs.btrfs btrfs-map-logical btrfs-image btrfs=
-zero-log \
> +progs_install =3D btrfs mkfs.btrfs btrfs-map-logical btrfs-image \
>  	btrfs-find-root btrfstune \
>  	btrfs-select-super
> =20
> @@ -322,7 +322,7 @@ test-fsck: btrfs btrfs-image btrfs-corrupt-block mk=
fs.btrfs btrfstune
>  	$(Q)bash tests/fsck-tests.sh
> =20
>  test-misc: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune =
fssum \
> -		btrfs-zero-log btrfs-find-root btrfs-select-super btrfs-convert
> +		btrfs-find-root btrfs-select-super btrfs-convert
>  	@echo "    [TEST]   misc-tests.sh"
>  	$(Q)bash tests/misc-tests.sh
> =20
> diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
> deleted file mode 100644
> index 2fce59e98d6e..000000000000
> --- a/btrfs-zero-log.c
> +++ /dev/null
> @@ -1,78 +0,0 @@
> -/*
> - * Copyright (C) 2007 Oracle.  All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public
> - * License v2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public
> - * License along with this program; if not, write to the
> - * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> - * Boston, MA 021110-1307, USA.
> - */
> -
> -#include "kerncompat.h"
> -
> -#include <stdio.h>
> -#include <unistd.h>
> -#include "ctree.h"
> -#include "disk-io.h"
> -#include "transaction.h"
> -#include "utils.h"
> -#include "help.h"
> -
> -__attribute__((noreturn)) static void print_usage(void)
> -{
> -	printf("usage: btrfs-zero-log dev\n");
> -	exit(1);
> -}
> -
> -int main(int argc, char **argv)
> -{
> -	struct btrfs_root *root;
> -	struct btrfs_trans_handle *trans;
> -	struct btrfs_super_block *sb;
> -	int ret;
> -
> -	set_argv0(argv);
> -	if (check_argc_exact(argc - optind, 1))
> -		print_usage();
> -
> -	radix_tree_init();
> -
> -	printf("WARNING: this utility is deprecated, please use 'btrfs rescue=
 zero-log'\n\n");
> -
> -	if ((ret =3D check_mounted(argv[optind])) < 0) {
> -		fprintf(stderr, "ERROR: could not check mount status: %s\n", strerro=
r(-ret));
> -		goto out;
> -	} else if (ret) {
> -		fprintf(stderr, "ERROR: %s is currently mounted\n", argv[optind]);
> -		ret =3D -EBUSY;
> -		goto out;
> -	}
> -
> -	root =3D open_ctree(argv[optind], 0, OPEN_CTREE_WRITES | OPEN_CTREE_P=
ARTIAL);
> -	if (!root) {
> -		fprintf(stderr, "ERROR: cannot open ctree\n");
> -		return 1;
> -	}
> -
> -	sb =3D root->fs_info->super_copy;
> -	printf("Clearing log on %s, previous log_root %llu, level %u\n",
> -			argv[optind],
> -			(unsigned long long)btrfs_super_log_root(sb),
> -			(unsigned)btrfs_super_log_root_level(sb));
> -	trans =3D btrfs_start_transaction(root, 1);
> -	BUG_ON(IS_ERR(trans));
> -	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
> -	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
> -	btrfs_commit_transaction(trans, root);
> -	close_ctree(root);
> -out:
> -	return !!ret;
> -}
> diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
> index 94703a3ec200..dad397ecaeec 100755
> --- a/tests/misc-tests.sh
> +++ b/tests/misc-tests.sh
> @@ -46,7 +46,6 @@ check_prereq btrfs-corrupt-block
>  check_prereq btrfs-image
>  check_prereq btrfstune
>  check_prereq btrfs
> -check_prereq btrfs-zero-log
>  check_prereq btrfs-find-root
>  check_prereq btrfs-select-super
>  check_kernel_support
> diff --git a/tests/misc-tests/003-zero-log/test.sh b/tests/misc-tests/0=
03-zero-log/test.sh
> index 9d2940f56851..8b0d0c57eb0e 100755
> --- a/tests/misc-tests/003-zero-log/test.sh
> +++ b/tests/misc-tests/003-zero-log/test.sh
> @@ -30,11 +30,7 @@ test_zero_log()
>  		--rootdir $INTERNAL_BIN/Documentation \
>  		$TEST_DEV
>  	run_check $TOP/btrfs inspect-internal dump-super $TEST_DEV
> -	if [ "$1" =3D 'standalone' ]; then
> -		run_check $TOP/btrfs rescue zero-log $TEST_DEV
> -	else
> -		run_check $TOP/btrfs-zero-log $TEST_DEV
> -	fi
> +	run_check $TOP/btrfs rescue zero-log $TEST_DEV
>  	log_root=3D$(get_log_root $TEST_DEV)
>  	log_root_level=3D$(get_log_root $TEST_DEV)
>  	if [ "$log_root" !=3D 0 ]; then
>=20


--Mzngah1wwM8pi7XcGPHmnQFRKKT5JjYZj--

--2qEVUJMW55tQuvl26NxdPdMynX8CXVqEP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqzr8oXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhUMwf/Y4WoRHLmCdPkD97h9QFeU/RV
BLGfEij9L/+4TGBE3citsbIJPHuelsedCT+b47P5NLkvwMs/0Q99HHkEuMrKdXfL
oprG7Ea3Ul4f9EFw34SA6M/2XsHMTU5EVDylRDLHPZ24xt/E3WwtfSyGcU7sS0Cw
qH9xqCg8ZjXyCS5UtQnWAfaZOqk0h/I2G0kLPR5kL/KUZZbb+6Upiy4+Fzb+/gRt
uU400Z2uI9A2QtH5Tj3EY+D0zoGe6NkGCbgz45sl17GmiI8L16K4ZWHZTw9nPSC5
E6Eeu6xL6coe2B6/tsw3toxQJjfes3pvSPzlkD+kcPz0ETnUfeidMagKedilbg==
=gp/E
-----END PGP SIGNATURE-----

--2qEVUJMW55tQuvl26NxdPdMynX8CXVqEP--
