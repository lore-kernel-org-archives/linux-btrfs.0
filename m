Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53495 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751702AbeBBK7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 05:59:31 -0500
Subject: Re: [RFC PATCH v2 0/4] Add support for export testsuits
To: Nikolay Borisov <nborisov@suse.com>, Gu Jinxiang <gujx@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
 <4a59c498-300e-7012-6239-8b438c7dea98@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4c29bfca-4887-9ed0-cfaa-5f889302d2af@gmx.com>
Date: Fri, 2 Feb 2018 18:59:12 +0800
MIME-Version: 1.0
In-Reply-To: <4a59c498-300e-7012-6239-8b438c7dea98@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q7AdAub7KsKECsw8Ll5i0sDp2jToVlPLR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q7AdAub7KsKECsw8Ll5i0sDp2jToVlPLR
Content-Type: multipart/mixed; boundary="kWRaWTkRrFXNEcLrG7581qMOTwi5HfpUt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Gu Jinxiang <gujx@cn.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <4c29bfca-4887-9ed0-cfaa-5f889302d2af@gmx.com>
Subject: Re: [RFC PATCH v2 0/4] Add support for export testsuits
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
 <4a59c498-300e-7012-6239-8b438c7dea98@suse.com>
In-Reply-To: <4a59c498-300e-7012-6239-8b438c7dea98@suse.com>

--kWRaWTkRrFXNEcLrG7581qMOTwi5HfpUt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8802=E6=97=A5 18:41, Nikolay Borisov wrote:
>=20
>=20
> On  2.02.2018 10:34, Gu Jinxiang wrote:
>> Achieved:
>> 1. export testsuit by:
>>  $ make EXPORT=3D/where/you/want/to/generate/tests.tar.gz package
>> relative path and absolute path both be ok.
>> Besides tests itself, fssum and btrfs-corrupt-block will also be
>> included in tests.tar.gz, since misc and fsck tests depend on
>> btrfs-corrupt-block, and misc tests depend on fssum.=20
>>
>> 2. after decompress tests.tar.gz, run test by:
>>  $ TEST=3D`MASK` ./mkfs-tests.sh
>> and, without MASK also be ok.
>> replenish:
>> The directory Structure after decompress tests.tar.gz is:
>>  $ tar -xzvf ./tests.tar.gz
>>  $ ls
>>    tests fssum btrfs-corrupt-block
>=20
> So *WHY* do we need this what problem are you solving?

I used to think the same, until Gu pointed out it's in the project idea,
and here is the reason:

https://github.com/kdave/btrfs-progs/issues/77

Thanks,
Qu

>=20
>>
>> Gu Jinxiang (4):
>>   btrfs-progs: Add package command for packaging tests
>>   btrfs-progs: Add EXEC represent path of executable file
>>   btrfs-progs: Modify rootdir files when use mkfs.btrfs
>>   btrfs-progs: Add readme for export testsuits
>>
>>  Makefile                                           |  4 ++
>>  tests/README.md                                    | 20 ++++++++
>>  tests/cli-tests.sh                                 |  5 ++
>>  tests/cli-tests/001-btrfs/test.sh                  | 20 ++++----
>>  .../cli-tests/002-balance-full-no-filters/test.sh  | 10 ++--
>>  tests/cli-tests/003-fi-resize-args/test.sh         | 30 +++++------
>>  .../cli-tests/004-send-parent-multi-subvol/test.sh | 12 ++---
>>  tests/cli-tests/005-qgroup-show/test.sh            | 14 ++---
>>  tests/cli-tests/006-qgroup-show-sync/test.sh       | 14 ++---
>>  tests/cli-tests/007-check-force/test.sh            | 14 ++---
>>  .../008-subvolume-get-set-default/test.sh          | 20 ++++----
>>  tests/common                                       | 16 +++---
>>  tests/common.convert                               |  8 +--
>>  tests/convert-tests.sh                             |  5 ++
>>  .../004-ext2-backup-superblock-ranges/test.sh      | 10 ++--
>>  .../convert-tests/005-delete-all-rollback/test.sh  |  2 +-
>>  .../007-unsupported-block-sizes/test.sh            |  2 +-
>>  .../011-reiserfs-delete-all-rollback/test.sh       |  2 +-
>>  .../015-no-rollback-after-balance/test.sh          |  6 +--
>>  tests/export-tests.sh                              | 28 ++++++++++
>>  tests/fsck-tests.sh                                |  5 ++
>>  tests/fsck-tests/012-leaf-corruption/test.sh       |  2 +-
>>  tests/fsck-tests/013-extent-tree-rebuild/test.sh   | 12 ++---
>>  tests/fsck-tests/018-leaf-crossing-stripes/test.sh |  2 +-
>>  .../fsck-tests/019-non-skinny-false-alert/test.sh  |  2 +-
>>  tests/fsck-tests/020-extent-ref-cases/test.sh      |  2 +-
>>  .../021-partially-dropped-snapshot-case/test.sh    |  2 +-
>>  tests/fsck-tests/022-qgroup-rescan-halfway/test.sh |  2 +-
>>  tests/fsck-tests/023-qgroup-stack-overflow/test.sh |  2 +-
>>  tests/fsck-tests/024-clear-space-cache/test.sh     | 10 ++--
>>  tests/fsck-tests/025-file-extents/test.sh          | 14 ++---
>>  tests/fsck-tests/026-bad-dir-item-name/test.sh     |  2 +-
>>  tests/fsck-tests/027-tree-reloc-tree/test.sh       |  2 +-
>>  .../028-unaligned-super-dev-sizes/test.sh          |  6 +--
>>  tests/fuzz-tests.sh                                |  5 ++
>>  .../fuzz-tests/001-simple-check-unmounted/test.sh  |  2 +-
>>  tests/fuzz-tests/002-simple-image/test.sh          |  2 +-
>>  tests/fuzz-tests/003-multi-check-unmounted/test.sh | 12 ++---
>>  tests/fuzz-tests/004-simple-dump-tree/test.sh      |  2 +-
>>  tests/fuzz-tests/005-simple-dump-super/test.sh     |  4 +-
>>  tests/fuzz-tests/006-simple-tree-stats/test.sh     |  2 +-
>>  tests/fuzz-tests/007-simple-super-recover/test.sh  |  2 +-
>>  tests/fuzz-tests/008-simple-chunk-recover/test.sh  |  2 +-
>>  tests/fuzz-tests/009-simple-zero-log/test.sh       |  2 +-
>>  tests/misc-tests.sh                                |  5 ++
>>  tests/misc-tests/001-btrfstune-features/test.sh    | 10 ++--
>>  tests/misc-tests/002-uuid-rewrite/test.sh          | 24 ++++-----
>>  tests/misc-tests/003-zero-log/test.sh              | 18 +++----
>>  tests/misc-tests/004-shrink-fs/test.sh             | 14 ++---
>>  .../005-convert-progress-thread-crash/test.sh      |  2 +-
>>  .../misc-tests/006-image-on-missing-device/test.sh | 10 ++--
>>  tests/misc-tests/007-subvolume-sync/test.sh        | 18 +++----
>>  tests/misc-tests/008-leaf-crossing-stripes/test.sh |  4 +-
>>  .../009-subvolume-sync-must-wait/test.sh           | 22 ++++----
>>  .../010-convert-delete-ext2-subvol/test.sh         | 10 ++--
>>  tests/misc-tests/011-delete-missing-device/test.sh | 18 +++----
>>  tests/misc-tests/012-find-root-no-result/test.sh   |  4 +-
>>  tests/misc-tests/013-subvolume-sync-crash/test.sh  | 20 ++++----
>>  tests/misc-tests/014-filesystem-label/test.sh      | 22 ++++----
>>  tests/misc-tests/015-dump-super-garbage/test.sh    | 18 +++----
>>  tests/misc-tests/016-send-clone-src/test.sh        | 12 ++---
>>  .../017-recv-stream-malformatted/test.sh           |  8 +--
>>  tests/misc-tests/018-recv-end-of-stream/test.sh    | 60 +++++++++++--=
---------
>>  .../019-receive-clones-on-mounted-subvol/test.sh   | 38 +++++++------=
-
>>  .../020-fix-superblock-corruption/test.sh          |  8 +--
>>  tests/misc-tests/021-image-multi-devices/test.sh   |  6 +--
>>  .../022-filesystem-du-on-empty-subvol/test.sh      | 12 ++---
>>  .../023-device-usage-with-missing-device/test.sh   | 10 ++--
>>  .../misc-tests/024-inspect-internal-rootid/test.sh | 24 ++++-----
>>  tests/misc-tests/025-zstd-compression/test.sh      |  6 +--
>>  .../026-image-non-printable-chars/test.sh          |  8 +--
>>  .../027-subvol-list-deleted-toplevel/test.sh       |  6 +--
>>  tests/mkfs-tests.sh                                |  5 ++
>>  tests/mkfs-tests/001-basic-profiles/test.sh        | 12 ++---
>>  .../002-no-force-mixed-on-small-volume/test.sh     |  2 +-
>>  .../003-mixed-with-wrong-nodesize/test.sh          |  2 +-
>>  tests/mkfs-tests/004-rootdir-keeps-size/test.sh    |  4 +-
>>  .../005-long-device-name-for-ssd/test.sh           |  4 +-
>>  tests/mkfs-tests/006-partitioned-loopdev/test.sh   |  4 +-
>>  .../mkfs-tests/007-mix-nodesize-sectorsize/test.sh |  6 +--
>>  .../008-sectorsize-nodesize-combination/test.sh    |  4 +-
>>  .../009-special-files-for-rootdir/test.sh          |  4 +-
>>  82 files changed, 446 insertions(+), 360 deletions(-)
>>  create mode 100755 tests/export-tests.sh
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--kWRaWTkRrFXNEcLrG7581qMOTwi5HfpUt--

--q7AdAub7KsKECsw8Ll5i0sDp2jToVlPLR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp0RIAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiUPQf6AmDG37jr22f/dqDhC9/hO6ZM
EogjRP6W45kWjvqyD7eftWo5RlJ0/ANBLcFTiceu+0kev5/onNJT6vfLRwBNbDFF
ssc8AUVqc6M28uZVBTDm7rRGRBU+6zAyM71H97HBxONFpkgk0zRHQQ/Zc4MQg1AC
2hMa/Y5C7ePHJ7RzQvvnl0Fz0axIi6TOu4NlYrNCB3jb/tC89yg2141TbgtE4apT
1Ew2svTJp0qvrclnza/UvnrXE08vNQblkGfF8LQdHhRnBvMtK5JMtt8RY03rGNF5
hBMOK7V6bmGxpLzrcdphTMN3xvsLKeVgf+4pclLHrHCgSN6ExJ9Suf5TRO3jZg==
=2Y2D
-----END PGP SIGNATURE-----

--q7AdAub7KsKECsw8Ll5i0sDp2jToVlPLR--
