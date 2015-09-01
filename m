Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8909 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755530AbbIAKFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 06:05:06 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t81A4ti0032607
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 18:04:55 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/2] btrfs-progs: tests: Introduce run_check_mount_test_dev wrapper for mount loop device in old system
Date: Tue, 1 Sep 2015 18:03:26 +0800
Message-ID: <cover.1441101420.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mount command in old system can not add -o loop option automatically
for loop device, and make following test failed:
  # ./fsck-tests.sh
  ...
    [TEST]   013-extent-tree-rebuild
  failed: mount /data/btrfsprogs/tests/test.img /data/btrfsprogs/tests/mnt
  test failed for case 013-extent-tree-rebuild

This patchset add run_check_mount_test_dev for mount both block and loop
device.

Changelog v1->v2:
 1: Use string for mount option instead of string array.
 2: Include "run_check $SUDO_HELPER" into wrapper function.
 Both suggested by: David Sterba <dsterba@suse.cz>

Zhao Lei (2):
  btrfs-progs: tests: Fix mount fail of 013-extent-tree-rebuild
  btrfs-progs: tests: Use mount_test_dev for
    misc-tests/007-subvolume-sync

 tests/common                                     | 26 ++++++++++++++++++++++++
 tests/fsck-tests/013-extent-tree-rebuild/test.sh |  4 ++--
 tests/misc-tests/007-subvolume-sync/test.sh      |  4 ++--
 3 files changed, 30 insertions(+), 4 deletions(-)

-- 
1.8.5.1

