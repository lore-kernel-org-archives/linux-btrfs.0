Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24133 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbbG0G3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 02:29:34 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6R6RehG003795
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 14:27:40 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/7] btrfs-progs: Fix wrong address accessing by subthread in btrfs-convert
Date: Mon, 27 Jul 2015 14:27:47 +0800
Message-ID: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

It is v2 patchset of:
 Fix wrong address accessing by subthread in btrfs-convert.

Changelog:
 1: Move bug test script from patch description into a single script in
    test/misc-tests, suggested-by: David Sterba <dsterba@suse.com>
 2: Move code for creating loop device to common [PATCH 6/7]

Zhao Lei (7):
  btrfs-progs: Fix wrong address accessing by subthread in btrfs-convert
  btrfs-progs: Move close timer handle code to line after sub process
    exit
  btrfs-progs: Remove cleanup-timer code for btrfs-convert
  btrfs-progs: resst info->periodic.timer_fd's value after free
  btrfs-progs: Set info->periodic.timer_fd to 0 in init-fail
  btrfs-progs: Move code to create loop device to common
  btrfs-progs: Introduce a misc test for thread conflict in
    btrfs-convert

 btrfs-convert.c                                    |  4 +---
 task-utils.c                                       | 22 ++++++++++++++--------
 tests/common                                       | 16 ++++++++++++++++
 tests/fsck-tests/013-extent-tree-rebuild/test.sh   | 11 +----------
 tests/misc-tests/001-btrfstune-features/test.sh    | 11 +----------
 tests/misc-tests/002-uuid-rewrite/test.sh          | 11 +----------
 tests/misc-tests/003-zero-log/test.sh              | 11 +----------
 .../misc-tests/004-convert-thread-conflict/test.sh | 14 ++++++++++++++
 8 files changed, 49 insertions(+), 51 deletions(-)
 create mode 100755 tests/misc-tests/004-convert-thread-conflict/test.sh

-- 
1.8.5.1

