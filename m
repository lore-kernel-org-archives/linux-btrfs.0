From: =?us-ascii?Q?Jaromir=20Zdrazil?= <jaromir.zdrazil@email.cz>
Subject: =?us-ascii?Q?Re=3A=20Updated=20btrfs=2Fcrypto=20snappy=20interface=20ready=20for=20merging?=
Date: Fri, 13 Jan 2012 03:40:45 +0100 (CET)
Message-ID: <136712.27328.70563-11092-962093031-1326422445@email.cz>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
Reply-To: jaromir.zdrazil@email.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

   Thank you for the job. Could you please share the output of the test=
ing and give us more info about the crypto?

Thank you!
Jaromir
> ------------ P=F9vodn=ED zpr=E1va ------------
> Od: Andi Kleen <andi@firstfloor.org>
> P=F8edm=ECt: Updated btrfs/crypto snappy interface ready for merging
> Datum: 13.1.2012 01:30:21
> ----------------------------------------
> Here's a slightly updated version of the BTRFS snappy interface.
> snappy is a faster compression algorithm that provides similar
> compression as LZO, but generally better performance.
>=20
> This version has:
>=20
> - Ported to latest tree
> - Extensive testing and benchmarking (in its 3.0 based incarnation)
> - A few cleanups
> - Adds a minor performance improvement
>=20
> Should be ready for pulling into the btrfs tree now.
> The crypto parts have been acked by Herbert.
>=20
> The following changes since commit 2485a4b610171f4e1c4ab0d05356974779=
5c1bbe:
>=20
>   Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2012-01-12 =
12:40:41
> -0800)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc snappy
>=20
> Andi Kleen (3):
>       Add the snappy-c compressor to lib v2
>       BTRFS: Add snappy support v2
>       Add snappy interface to crypto API
>=20
>  crypto/Kconfig         |    9 +
>  crypto/Makefile        |    1 +
>  crypto/snappy.c        |   99 ++++
>  fs/btrfs/Kconfig       |    1 +
>  fs/btrfs/Makefile      |    2 +-
>  fs/btrfs/compression.c |    1 +
>  fs/btrfs/compression.h |    1 +
>  fs/btrfs/ctree.h       |    9 +-
>  fs/btrfs/disk-io.c     |    2 +
>  fs/btrfs/ioctl.c       |    4 +
>  fs/btrfs/snappy.c      |  432 ++++++++++++++++
>  fs/btrfs/super.c       |    9 +-
>  include/linux/snappy.h |   26 +
>  lib/Kconfig            |    6 +
>  lib/Makefile           |    4 +
>  lib/snappy.c           | 1300 ++++++++++++++++++++++++++++++++++++++=
++++++++++
>  16 files changed, 1901 insertions(+), 5 deletions(-)
>  create mode 100644 crypto/snappy.c
>  create mode 100644 fs/btrfs/snappy.c
>  create mode 100644 include/linux/snappy.h
>  create mode 100644 lib/snappy.c
>=20
> -Andi
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20

Jaromir Zdrazil
jaromir.zdrazil@email.cz
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
