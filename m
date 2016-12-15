Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33431 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755731AbcLOJFz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 04:05:55 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: t-itoh@jp.fujitsu.com
Subject: [PATCH v2 0/3] Convert rollback rework for v4.9
Date: Thu, 15 Dec 2016 17:03:28 +0800
Message-Id: <20161215090331.27486-1-quwenruo@cn.fujitsu.com>
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

3) Too complex logical, and RW btrfs tree operations
In fact, considering how small data we need to rewrite (1M + 128K), we
don't really need to open btrfs read-write.
Just copy needed data and re-fill. Simple and easy.

Thanks Chandan, his report on failure of rollback leads to this rework.

And this is still small fixes, most of the patch are just deleting old codes.
All rollback test cases from btrfs-progs and fstests are passed.

v2:
  Fix a bug that we can still rollback if convert subvolume is just orphaned,
  not deleted. Exposed by btrfs/012.

Qu Wenruo (3):
  btrfs-progs: file-item: Fix wrong file extents inserted
  btrfs-progs: convert: Rework rollback to handle new convert image
  btrfs-progs: convert-test: trigger chunk allocation after convert

 convert/main.c       | 699 ++++++++++++++++++++-------------------------------
 file-item.c          |  11 +
 tests/common         |   4 +
 tests/common.convert |   3 +
 4 files changed, 297 insertions(+), 420 deletions(-)

-- 
2.10.2



