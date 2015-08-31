Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59954 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771AbbHaFGV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 01:06:21 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7V567HT019999
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 13:06:07 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/4] btrfs-progs: tests: umount TEST_MNT in clean-tests.sh
Date: Mon, 31 Aug 2015 13:04:35 +0800
Message-ID: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a testcase failed, we can't run it(or other tests needs mount) again,
  # ./misc-tests.sh 007
   [TEST]   007-subvolume-sync
   failed: fail
   test failed for case 007-subvolume-sync
  # ./misc-tests.sh 007
   [TEST]   007-subvolume-sync
   failed: mount /root/btrfs-progs/tests/test.img /root/btrfs-progs/tests/mnt
   test failed for case 007-subvolume-sync
  #

To solve this problem, I put umount command into test sctipt in v1,
but it will change stat of failed-test in next test, and make it
hard to debug, noticed by David Sterba <dsterba@suse.cz>:
 My expectation is that the testsuite will not fail and if it does,
 I wan't to keep the last stat so I can have a look.
 Would it be acceptable for you to enhance the clean-tests.sh
 script to unmount the TEST_DEV?

Putting umount command into clean-tests.sh need a global $TEST_MNT,
which already done in my previous patch.

This patchset rebase my previous patch of "setting global $TEST_MNT"
to git head in [PATCH 1..2/4], and add v2 of "umount TEST_MNT"
in [PATCH 3/4].

Thanks
Zhaolei

Zhao Lei (4):
  btrfs-progs: tests: Introduce init_env() to initialize common env
    variant
  btrfs-progs: tests: Fix mount fail of 013-extent-tree-rebuild
  btrfs-progs: tests: umount TEST_MNT in clean-tests.sh
  btrfs-progs: Use mount_test_dev for misc-tests/007-subvolume-sync

 tests/clean-tests.sh                             |  7 ++++--
 tests/common                                     | 30 ++++++++++++++++++++++++
 tests/convert-tests.sh                           |  1 -
 tests/fsck-tests.sh                              |  3 ---
 tests/fsck-tests/012-leaf-corruption/test.sh     |  1 -
 tests/fsck-tests/013-extent-tree-rebuild/test.sh |  9 ++-----
 tests/misc-tests.sh                              |  3 ---
 tests/misc-tests/001-btrfstune-features/test.sh  |  5 ----
 tests/misc-tests/002-uuid-rewrite/test.sh        |  5 ----
 tests/misc-tests/003-zero-log/test.sh            |  5 ----
 tests/misc-tests/007-subvolume-sync/test.sh      |  4 ++--
 11 files changed, 39 insertions(+), 34 deletions(-)

-- 
1.8.5.1

