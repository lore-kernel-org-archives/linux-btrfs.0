Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28622 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751780AbaLYBeO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:34:14 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP1Xipk020155
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 09:33:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] New btrfsck test framework
Date: Thu, 25 Dec 2014 09:32:10 +0800
Message-ID: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset introduce the new btrfsck test framework.
The main changes are:
1) File layout change
The new file layout is based on dir.
Every corruption type has its own dir, and it can contain several
different images for different cases, like bad root items type, it has
the default case and the skinny metadata case.

2) Image format
The framework support 2 image format.
One is the original btrfs-image dump.
The other one is custom script.

Any other type will need a small script to extract the image and use the
framework routine or other codes to check it.

3) New test case for leaf-corruption recovery
Added a new type dir for leaf-corruption, and add verification codes to
check the recovered data.

Minor changes include:
1) fsck-test.sh can be called from anywhere
Now fsck-test.sh can determine the btrfs-progs top dir according to its
path, no need to be called from btrfs-progs dir.

2) default value and auto-detect for environment variant
Now fsck-test.sh can accept environment variants, no need to edit the
script anymore.
And if TEST_MNT is not set, it will use <btrfs-progs>/tests/mnt as
default mount point.

3) better prompt for needed environment variant/privilege
When some case is not run due to missing environment variant or
privilege, fsck-test.sh will prompt it.

Qu Wenruo (5):
  btrfs-progs: New btrfsck test infrastructure
  btrfs-progs: Move btrfs-image dump to corresponding dir
  btrfs-progs: Move bad root items test cases to its corresponding dir
  btrfs-progs: Move leaf-corruption no extent data case and add    
    verification script
  btrfs-progs: Move extent tree rebuild test to its dir

 tests/common                                       |  49 +++++++++
 tests/fsck-tests.sh                                | 122 +++++++--------------
 .../default_case.img}                              | Bin
 .../default_case.img}                              | Bin
 .../default_case.img}                              | Bin
 .../default_case.img}                              | Bin
 .../default_case.img}                              | Bin
 .../default_case.tar.xz}                           | Bin
 .../skinny_case.tar.xz}                            | Bin
 tests/fsck-tests/006-bad-root-items/test.sh        |  15 +++
 .../default_case.img}                              | Bin
 .../default_case.img}                              | Bin
 .../default_case.img}                              | Bin
 .../default_case.img}                              | Bin
 .../default_case.img}                              | Bin
 .../no_data_extent.tar.xz}                         | Bin
 tests/fsck-tests/012-leaf-corruption/test.sh       | 119 ++++++++++++++++++++
 tests/fsck-tests/013-extent-tree-rebuild/test.sh   |  47 ++++++++
 18 files changed, 272 insertions(+), 80 deletions(-)
 create mode 100644 tests/common
 mode change 100644 => 100755 tests/fsck-tests.sh
 rename tests/fsck-tests/{001-bad-file-extent-bytenr.img => 001-bad-file-extent-bytenr/default_case.img} (100%)
 rename tests/fsck-tests/{002-bad-transid.img => 002-bad-transid/default_case.img} (100%)
 rename tests/fsck-tests/{003-shift-offsets.img => 003-shift-offsets/default_case.img} (100%)
 rename tests/fsck-tests/{004-no-dir-index.img => 004-no-dir-index/default_case.img} (100%)
 rename tests/fsck-tests/{005-bad-item-offset.img => 005-bad-item-offset/default_case.img} (100%)
 rename tests/fsck-tests/{006-bad_root_items_fs.tar.xz => 006-bad-root-items/default_case.tar.xz} (100%)
 rename tests/fsck-tests/{007-bad_root_items_fs_skinny.tar.xz => 006-bad-root-items/skinny_case.tar.xz} (100%)
 create mode 100755 tests/fsck-tests/006-bad-root-items/test.sh
 rename tests/fsck-tests/{008-bad-offset-snapshots.img => 007-bad-offset-snapshots/default_case.img} (100%)
 rename tests/fsck-tests/{009-bad-dir-index-name.img => 008-bad-dir-index-name/default_case.img} (100%)
 rename tests/fsck-tests/{010-no-dir-item-or-index.img => 009-no-dir-item-or-index/default_case.img} (100%)
 rename tests/fsck-tests/{011-no-rootdir-inode-item.img => 010-no-rootdir-inode-item/default_case.img} (100%)
 rename tests/fsck-tests/{012-no-inode-item.img => 011-no-inode-item/default_case.img} (100%)
 rename tests/fsck-tests/{013-leaf-corruption-no-extent-data.tar.xz => 012-leaf-corruption/no_data_extent.tar.xz} (100%)
 create mode 100755 tests/fsck-tests/012-leaf-corruption/test.sh
 create mode 100755 tests/fsck-tests/013-extent-tree-rebuild/test.sh

-- 
2.2.1

