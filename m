Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42029 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752805AbcLSG5B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 01:57:01 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 4828F41B4BD0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 14:56:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/6] Convert rollback rework for v4.9
Date: Mon, 19 Dec 2016 14:56:36 +0800
Message-Id: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from github:
https://github.com/adam900710/btrfs-progs.git convert_rework_for_4.9

This is mainly to fix problems exposed by Chandan's fix for 64K nodesize.

The problem is, although we're still using old rollback functions, it
has quite a lot of problems to support the new behavior.

1) Can't rollback new convert image with new data chunk
Chunk level check can't handle newly allocated data chunk, which is not
1:1 mapped but completely valid in new behavior.
The last patch will enhance the test case to handle it.

2) Can't rollback real no-hole image
Since it assumes hole file extent as requirement.
And due to the possibility to enable no_holes halfway, btrfsck won't
report such error, since it's acceptable.

3) Too complex logic, and RW btrfs tree operations
In fact, considering how small data we need to rewrite (1M + 128K), we
don't really need to open btrfs read-write.
Just copy needed data and re-fill. Simple and easy.

Thanks Chandan, his report on failure of rollback leads to this rework.

And this is still small fixes, most of the patch are just deleting old codes.
All rollback test cases from btrfs-progs and fstests are passed.

v2:
  Fix a bug that we can still rollback if convert subvolume is just orphaned,
  not deleted. Exposed by btrfs/012.

v3:
  Better patch split. Now only one patch is larger than 200 lines(214 lines)
  Fix regression introduced in last minute update of v2 patch.
  Remove duplicated bs= options.

Qu Wenruo (6):
  btrfs-progs: file-item: Fix wrong file extents inserted
  btrfs-progs: utils: Introduce basic set operations for range
  btrfs-progs: convert: Introduce function to record relocated ranges
  btrfs-progs: convert: Introduce new function to check if we can
    rollback
  btrfs-progs: convert: Switch to new rollback function
  btrfs-progs: convert-test: trigger chunk allocation after convert

 convert/main.c       | 744 ++++++++++++++++++++++-----------------------------
 disk-io.h            |   9 +-
 file-item.c          |  11 +
 tests/common         |   4 +
 tests/common.convert |   3 +
 utils.h              |  19 ++
 6 files changed, 366 insertions(+), 424 deletions(-)

-- 
2.10.2



