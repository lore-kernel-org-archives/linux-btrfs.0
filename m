Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9722 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932645AbcLMJog (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 04:44:36 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: chandan@linux.vnet.ibm.com
Subject: [PATCH 0/3] Convert rollback rework and test enhancement
Date: Tue, 13 Dec 2016 17:44:12 +0800
Message-Id: <20161213094415.30912-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current convert rollback condition is too restrict for new convert
behavior, and has several problems.

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

Qu Wenruo (3):
  btrfs-progs: file-item: Fix wrong file extents inserted
  btrfs-progs: convert: Rework rollback to handle new convert image
  btrfs-progs: convert-test: trigger chunk allocation after convert

 convert/main.c       | 693 ++++++++++++++++++++-------------------------------
 file-item.c          |  11 +
 tests/common         |   4 +
 tests/common.convert |   3 +
 4 files changed, 285 insertions(+), 426 deletions(-)

-- 
2.10.2



