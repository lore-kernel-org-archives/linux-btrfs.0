Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27885 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752150AbbIWHUp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 03:20:45 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8N7KPQn027978
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 15:20:25 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/3] btrfs-progs: tests: Move extract_image out of check_all_images for common use
Date: Wed, 23 Sep 2015 15:19:03 +0800
Message-ID: <cover.1442992715.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move code for extract image file to a function from check_all_images()
for common use, so caller can use this function to extrace single
image file.

Changelog v1->v2:
1: Use stdout instead of global variant to store extracted image filename.
   Suggested-by: David Sterba <dsterba@suse.cz>

Zhao Lei (3):
  btrfs-progs: tests: Move extract_image out of check_all_images for
    common use
  btrfs-progs: tests: Introduce fsck-tests/018-leaf-across-stripes
  btrfs-progs: tests: Introduce misc-tests/008-leaf-across-stripes

 tests/common                                       |  76 ++++++++++++---------
 .../018-leaf-across-stripes/default_case.raw.xz    | Bin 0 -> 105064 bytes
 tests/fsck-tests/018-leaf-across-stripes/test.sh   |  12 ++++
 tests/misc-tests/008-leaf-across-stripes/test.sh   |  23 +++++++
 4 files changed, 78 insertions(+), 33 deletions(-)
 create mode 100644 tests/fsck-tests/018-leaf-across-stripes/default_case.raw.xz
 create mode 100755 tests/fsck-tests/018-leaf-across-stripes/test.sh
 create mode 100755 tests/misc-tests/008-leaf-across-stripes/test.sh

-- 
1.8.5.1

