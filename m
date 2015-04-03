Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49036 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750767AbbDCHDV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:03:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3372Dbc001955
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 15:02:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/6] New test case for btrfs-convert and serval minor updates on framework/test cases
Date: Fri, 3 Apr 2015 15:01:11 +0800
Message-ID: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset do the following things:
1) Test framework variant naming update
   Change some lower case variant name to upper case.
   Provides a unified naming scheme.

2) Remove duplicated TEST_MNT check
   Fsck test case 012 has duplicated TEST_MNT, just remove it.

3) Update test cases to use more test framework infrastructure.
   Update fsck test case 013 and convert test case.

4) Add regular file extent in convert test
   Now btrfs-progs test case can detect odd csum error in btrfs-convert.

Qu Wenruo (6):
  btrfs-progs: test-frame: Update variant names
  btrfs-progs: fsck-tests: Remove duplicatesd TEST_MNT setup.
  btrfs-progs: fsck-tests: Update 013-extent-tree-rebuild to use more
    test     framework infrastructure.
  btrfs-progs: fsck-tests: Add fallback TEST_DEV for test case 013
  btrfs-progs: convert-tests: Update to use test framework
    infrastructure.
  btrfs-progs: convert-tests: Add check for converted btrfs with regular
        file extent.

 tests/common                                     | 20 +++----
 tests/convert-tests.sh                           | 76 +++++++++++++-----------
 tests/fsck-tests.sh                              | 24 ++++----
 tests/fsck-tests/006-bad-root-items/test.sh      |  6 +-
 tests/fsck-tests/012-leaf-corruption/test.sh     |  8 +--
 tests/fsck-tests/013-extent-tree-rebuild/test.sh | 36 ++++++-----
 6 files changed, 90 insertions(+), 80 deletions(-)

-- 
2.3.5

