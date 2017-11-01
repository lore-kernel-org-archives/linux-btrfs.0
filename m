Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754054AbdKABms (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 21:42:48 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "dsterba@suse.cz" <dsterba@suse.cz>
Subject: RE: [RFC PATCH 0/3] btrfs-progs: Add support for running the tools
 from
Date: Wed, 1 Nov 2017 01:42:42 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01479E87A3@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
 <87a801c8-f50b-d260-cd36-76d75648b52c@gmx.com>
In-Reply-To: <87a801c8-f50b-d260-cd36-76d75648b52c@gmx.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]
> Sent: Tuesday, October 31, 2017 6:36 PM
> To: Gu, Jinxiang/é¡¾ é‡‘é¦™ <gujx@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
> Cc: dsterba@suse.cz
> Subject: Re: [RFC PATCH 0/3] btrfs-progs: Add support for running the tools from
> 
> 
> 
> On 2017å¹´10æœˆ31æ—¥ 16:43, Gu Jinxiang wrote:
> > Add support for running the tools from a given path (for
> > example,/usr/bin) by setting $EXEC while running tests.
> >
> > Achieved:
> > Specify the location of binary and run test like this:
> > $ make EXEC=/usr/bin/ test
> 
> Any special reason to test system installed btrfs?
> 
> Even for system QA case, I think self test should be run at packaging time other than doing it after packaging.

Just implement the project list below in github.
.................
Add support for running the tools from a given path (git, /usr/bin, /usr/local/bin), so the testsuite can be run independently.
.................

> 
> Thanks,
> Qu
> >
> > Not Achieved:
> > Can not run make in tests/ directory.
> > Because test-misc depends on fssum which relies on header files in
> > btrfs-progs.
> > And test-misc and test-fsck depend on btrfs-corrupt-block which is not
> > installed after installation of btrfs-progs.
> >
> > I am wondering that it is necessary or not to modify those tests to
> > run outside of btrfs-progs.
> >
> > Gu Jinxiang (3):
> >   btrfs-progs: Add EXEC parameter in Makefile
> >   btrfs-progs: Set EXEC to TOP when it not be defined
> >   btrfs-progs: Add support for running tools with given path(EXEC)
> >
> >  Makefile                                           | 32 +++++++++++-
> >  tests/README.md                                    | 10 ++++
> >  tests/cli-tests.sh                                 |  2 +
> >  tests/cli-tests/001-btrfs/test.sh                  | 20 ++++----
> >  .../cli-tests/002-balance-full-no-filters/test.sh  | 10 ++--
> >  tests/cli-tests/003-fi-resize-args/test.sh         | 30 +++++------
> >  .../cli-tests/004-send-parent-multi-subvol/test.sh | 12 ++---
> >  tests/cli-tests/005-qgroup-show/test.sh            | 14 ++---
> >  tests/cli-tests/006-qgroup-show-sync/test.sh       | 14 ++---
> >  tests/cli-tests/007-check-force/test.sh            | 14 ++---
> >  .../008-subvolume-get-set-default/test.sh          | 20 ++++----
> >  tests/common                                       | 18 ++++---
> >  tests/common.convert                               |  8 +--
> >  tests/convert-tests.sh                             |  2 +
> >  .../004-ext2-backup-superblock-ranges/test.sh      | 10 ++--
> >  .../convert-tests/005-delete-all-rollback/test.sh  |  2 +-
> >  .../007-unsupported-block-sizes/test.sh            |  2 +-
> >  .../011-reiserfs-delete-all-rollback/test.sh       |  2 +-
> >  tests/fsck-tests.sh                                |  2 +
> >  tests/fsck-tests/012-leaf-corruption/test.sh       |  2 +-
> >  tests/fsck-tests/013-extent-tree-rebuild/test.sh   | 12 ++---
> >  tests/fsck-tests/018-leaf-crossing-stripes/test.sh |  2 +-
> >  tests/fsck-tests/020-extent-ref-cases/test.sh      |  2 +-
> >  .../021-partially-dropped-snapshot-case/test.sh    |  2 +-
> >  tests/fsck-tests/022-qgroup-rescan-halfway/test.sh |  2 +-
> > tests/fsck-tests/023-qgroup-stack-overflow/test.sh |  2 +-
> >  tests/fsck-tests/024-clear-space-cache/test.sh     | 10 ++--
> >  tests/fsck-tests/025-file-extents/test.sh          | 14 ++---
> >  tests/fsck-tests/026-bad-dir-item-name/test.sh     |  2 +-
> >  .../028-unaligned-super-dev-sizes/test.sh          |  6 +--
> >  tests/fuzz-tests.sh                                |  2 +
> >  .../fuzz-tests/001-simple-check-unmounted/test.sh  |  2 +-
> >  tests/fuzz-tests/002-simple-image/test.sh          |  2 +-
> >  tests/fuzz-tests/003-multi-check-unmounted/test.sh | 12 ++---
> >  tests/fuzz-tests/004-simple-dump-tree/test.sh      |  2 +-
> >  tests/fuzz-tests/005-simple-dump-super/test.sh     |  4 +-
> >  tests/fuzz-tests/006-simple-tree-stats/test.sh     |  2 +-
> >  tests/fuzz-tests/007-simple-super-recover/test.sh  |  2 +-
> > tests/fuzz-tests/008-simple-chunk-recover/test.sh  |  2 +-
> >  tests/fuzz-tests/009-simple-zero-log/test.sh       |  2 +-
> >  tests/misc-tests.sh                                |  2 +
> >  tests/misc-tests/001-btrfstune-features/test.sh    | 10 ++--
> >  tests/misc-tests/002-uuid-rewrite/test.sh          | 20 ++++----
> >  tests/misc-tests/003-zero-log/test.sh              | 16 +++---
> >  tests/misc-tests/004-shrink-fs/test.sh             | 14 ++---
> >  .../005-convert-progress-thread-crash/test.sh      |  2 +-
> >  .../misc-tests/006-image-on-missing-device/test.sh | 10 ++--
> >  tests/misc-tests/007-subvolume-sync/test.sh        | 18 +++----
> >  tests/misc-tests/008-leaf-crossing-stripes/test.sh |  4 +-
> >  .../009-subvolume-sync-must-wait/test.sh           | 22 ++++----
> >  .../010-convert-delete-ext2-subvol/test.sh         | 10 ++--
> >  tests/misc-tests/011-delete-missing-device/test.sh | 18 +++----
> >  tests/misc-tests/012-find-root-no-result/test.sh   |  4 +-
> >  tests/misc-tests/013-subvolume-sync-crash/test.sh  | 20 ++++----
> >  tests/misc-tests/014-filesystem-label/test.sh      | 22 ++++----
> >  tests/misc-tests/015-dump-super-garbage/test.sh    | 18 +++----
> >  tests/misc-tests/016-send-clone-src/test.sh        | 12 ++---
> >  .../017-recv-stream-malformatted/test.sh           |  8 +--
> >  tests/misc-tests/018-recv-end-of-stream/test.sh    | 60 +++++++++++-----------
> >  .../019-receive-clones-on-munted-subvol/test.sh    | 38 +++++++-------
> >  .../020-fix-superblock-corruption/test.sh          |  8 +--
> >  tests/misc-tests/021-image-multi-devices/test.sh   |  6 +--
> >  .../022-filesystem-du-on-empty-subvol/test.sh      | 12 ++---
> >  .../023-device-usage-with-missing-device/test.sh   | 10 ++--
> >  .../misc-tests/024-inspect-internal-rootid/test.sh | 24 ++++-----
> >  tests/misc-tests/025-zstd-compression/test.sh      |  6 +--
> >  .../026-image-non-printable-chars/test.sh          |  8 +--
> >  .../027-subvol-list-deleted-toplevel/test.sh       |  6 +--
> >  tests/mkfs-tests.sh                                |  2 +
> >  tests/mkfs-tests/001-basic-profiles/test.sh        | 12 ++---
> >  .../002-no-force-mixed-on-small-volume/test.sh     |  2 +-
> >  .../003-mixed-with-wrong-nodesize/test.sh          |  2 +-
> >  tests/mkfs-tests/004-rootdir-keeps-size/test.sh    |  2 +-
> >  .../005-long-device-name-for-ssd/test.sh           |  4 +-
> >  tests/mkfs-tests/006-partitioned-loopdev/test.sh   |  4 +-
> >  .../mkfs-tests/007-mix-nodesize-sectorsize/test.sh |  6 +--
> >  .../008-secorsize-nodesize-combination/test.sh     |  4 +-
> >  .../009-special-files-for-rootdir/test.sh          |  4 +-
> >  78 files changed, 410 insertions(+), 352 deletions(-)
> >



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
