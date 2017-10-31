Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55161 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdJaKgW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 06:36:22 -0400
Subject: Re: [RFC PATCH 0/3] btrfs-progs: Add support for running the tools
 from
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <87a801c8-f50b-d260-cd36-76d75648b52c@gmx.com>
Date: Tue, 31 Oct 2017 18:36:10 +0800
MIME-Version: 1.0
In-Reply-To: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BVIuvlGKgLC2jRSvGtTwOwSI5Bnvt3O8s"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BVIuvlGKgLC2jRSvGtTwOwSI5Bnvt3O8s
Content-Type: multipart/mixed; boundary="J6i4ew1g7XNM8i0XB3brWtHLfCIoVRd4U";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <87a801c8-f50b-d260-cd36-76d75648b52c@gmx.com>
Subject: Re: [RFC PATCH 0/3] btrfs-progs: Add support for running the tools
 from
References: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>

--J6i4ew1g7XNM8i0XB3brWtHLfCIoVRd4U
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 16:43, Gu Jinxiang wrote:
> Add support for running the tools from a given path
> (for example,/usr/bin) by setting $EXEC while running tests.
>=20
> Achieved:
> Specify the location of binary and run test like this:
> $ make EXEC=3D/usr/bin/ test

Any special reason to test system installed btrfs?

Even for system QA case, I think self test should be run at packaging
time other than doing it after packaging.

Thanks,
Qu
>=20
> Not Achieved:
> Can not run make in tests/ directory.
> Because test-misc depends on fssum which relies on header files in
> btrfs-progs.
> And test-misc and test-fsck depend on btrfs-corrupt-block which is
> not installed after installation of btrfs-progs.
>=20
> I am wondering that it is necessary or not to modify those tests to
> run outside of btrfs-progs.
>=20
> Gu Jinxiang (3):
>   btrfs-progs: Add EXEC parameter in Makefile
>   btrfs-progs: Set EXEC to TOP when it not be defined
>   btrfs-progs: Add support for running tools with given path(EXEC)
>=20
>  Makefile                                           | 32 +++++++++++-
>  tests/README.md                                    | 10 ++++
>  tests/cli-tests.sh                                 |  2 +
>  tests/cli-tests/001-btrfs/test.sh                  | 20 ++++----
>  .../cli-tests/002-balance-full-no-filters/test.sh  | 10 ++--
>  tests/cli-tests/003-fi-resize-args/test.sh         | 30 +++++------
>  .../cli-tests/004-send-parent-multi-subvol/test.sh | 12 ++---
>  tests/cli-tests/005-qgroup-show/test.sh            | 14 ++---
>  tests/cli-tests/006-qgroup-show-sync/test.sh       | 14 ++---
>  tests/cli-tests/007-check-force/test.sh            | 14 ++---
>  .../008-subvolume-get-set-default/test.sh          | 20 ++++----
>  tests/common                                       | 18 ++++---
>  tests/common.convert                               |  8 +--
>  tests/convert-tests.sh                             |  2 +
>  .../004-ext2-backup-superblock-ranges/test.sh      | 10 ++--
>  .../convert-tests/005-delete-all-rollback/test.sh  |  2 +-
>  .../007-unsupported-block-sizes/test.sh            |  2 +-
>  .../011-reiserfs-delete-all-rollback/test.sh       |  2 +-
>  tests/fsck-tests.sh                                |  2 +
>  tests/fsck-tests/012-leaf-corruption/test.sh       |  2 +-
>  tests/fsck-tests/013-extent-tree-rebuild/test.sh   | 12 ++---
>  tests/fsck-tests/018-leaf-crossing-stripes/test.sh |  2 +-
>  tests/fsck-tests/020-extent-ref-cases/test.sh      |  2 +-
>  .../021-partially-dropped-snapshot-case/test.sh    |  2 +-
>  tests/fsck-tests/022-qgroup-rescan-halfway/test.sh |  2 +-
>  tests/fsck-tests/023-qgroup-stack-overflow/test.sh |  2 +-
>  tests/fsck-tests/024-clear-space-cache/test.sh     | 10 ++--
>  tests/fsck-tests/025-file-extents/test.sh          | 14 ++---
>  tests/fsck-tests/026-bad-dir-item-name/test.sh     |  2 +-
>  .../028-unaligned-super-dev-sizes/test.sh          |  6 +--
>  tests/fuzz-tests.sh                                |  2 +
>  .../fuzz-tests/001-simple-check-unmounted/test.sh  |  2 +-
>  tests/fuzz-tests/002-simple-image/test.sh          |  2 +-
>  tests/fuzz-tests/003-multi-check-unmounted/test.sh | 12 ++---
>  tests/fuzz-tests/004-simple-dump-tree/test.sh      |  2 +-
>  tests/fuzz-tests/005-simple-dump-super/test.sh     |  4 +-
>  tests/fuzz-tests/006-simple-tree-stats/test.sh     |  2 +-
>  tests/fuzz-tests/007-simple-super-recover/test.sh  |  2 +-
>  tests/fuzz-tests/008-simple-chunk-recover/test.sh  |  2 +-
>  tests/fuzz-tests/009-simple-zero-log/test.sh       |  2 +-
>  tests/misc-tests.sh                                |  2 +
>  tests/misc-tests/001-btrfstune-features/test.sh    | 10 ++--
>  tests/misc-tests/002-uuid-rewrite/test.sh          | 20 ++++----
>  tests/misc-tests/003-zero-log/test.sh              | 16 +++---
>  tests/misc-tests/004-shrink-fs/test.sh             | 14 ++---
>  .../005-convert-progress-thread-crash/test.sh      |  2 +-
>  .../misc-tests/006-image-on-missing-device/test.sh | 10 ++--
>  tests/misc-tests/007-subvolume-sync/test.sh        | 18 +++----
>  tests/misc-tests/008-leaf-crossing-stripes/test.sh |  4 +-
>  .../009-subvolume-sync-must-wait/test.sh           | 22 ++++----
>  .../010-convert-delete-ext2-subvol/test.sh         | 10 ++--
>  tests/misc-tests/011-delete-missing-device/test.sh | 18 +++----
>  tests/misc-tests/012-find-root-no-result/test.sh   |  4 +-
>  tests/misc-tests/013-subvolume-sync-crash/test.sh  | 20 ++++----
>  tests/misc-tests/014-filesystem-label/test.sh      | 22 ++++----
>  tests/misc-tests/015-dump-super-garbage/test.sh    | 18 +++----
>  tests/misc-tests/016-send-clone-src/test.sh        | 12 ++---
>  .../017-recv-stream-malformatted/test.sh           |  8 +--
>  tests/misc-tests/018-recv-end-of-stream/test.sh    | 60 +++++++++++---=
--------
>  .../019-receive-clones-on-munted-subvol/test.sh    | 38 +++++++-------=

>  .../020-fix-superblock-corruption/test.sh          |  8 +--
>  tests/misc-tests/021-image-multi-devices/test.sh   |  6 +--
>  .../022-filesystem-du-on-empty-subvol/test.sh      | 12 ++---
>  .../023-device-usage-with-missing-device/test.sh   | 10 ++--
>  .../misc-tests/024-inspect-internal-rootid/test.sh | 24 ++++-----
>  tests/misc-tests/025-zstd-compression/test.sh      |  6 +--
>  .../026-image-non-printable-chars/test.sh          |  8 +--
>  .../027-subvol-list-deleted-toplevel/test.sh       |  6 +--
>  tests/mkfs-tests.sh                                |  2 +
>  tests/mkfs-tests/001-basic-profiles/test.sh        | 12 ++---
>  .../002-no-force-mixed-on-small-volume/test.sh     |  2 +-
>  .../003-mixed-with-wrong-nodesize/test.sh          |  2 +-
>  tests/mkfs-tests/004-rootdir-keeps-size/test.sh    |  2 +-
>  .../005-long-device-name-for-ssd/test.sh           |  4 +-
>  tests/mkfs-tests/006-partitioned-loopdev/test.sh   |  4 +-
>  .../mkfs-tests/007-mix-nodesize-sectorsize/test.sh |  6 +--
>  .../008-secorsize-nodesize-combination/test.sh     |  4 +-
>  .../009-special-files-for-rootdir/test.sh          |  4 +-
>  78 files changed, 410 insertions(+), 352 deletions(-)
>=20


--J6i4ew1g7XNM8i0XB3brWtHLfCIoVRd4U--

--BVIuvlGKgLC2jRSvGtTwOwSI5Bnvt3O8s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln4UhoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiJmAf9GpV9LQx3y3zPOeakxomamkhn
GrwfdL8CATVvL6G4571jiJGn0PykkheeDufOtLTs4FAmvdmcIfdCnG/muaz88cH6
wKMCcT89F37Li/7mZYd8P9Jo8/+mWf+7T7F/N5v4BzED79rw7J/XWtmajmACmHOa
xztHEZ1CpYU2CPzukKVRrMP6jieGfPKmMbIOwr2n256YD6psgbC9DpE4x3MV0j1d
5P4s+UjNOqccL7U2uPO4RBEdo6Ub12fgtm20JyZSR8x0cIOXWCqHRGT/Lscj8yLK
RU7zsxIEzClLvIlp7GKnAaFtFHxM0zcqEtsf+5WXtcmhRYZmIhS31aeVSSR5iQ==
=L7sh
-----END PGP SIGNATURE-----

--BVIuvlGKgLC2jRSvGtTwOwSI5Bnvt3O8s--
