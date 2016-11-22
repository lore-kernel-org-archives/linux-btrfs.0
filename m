Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1241 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755002AbcKVIib (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 03:38:31 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [RFC PATCH 0/3] Add testcase for fundamental scrub recovery
Date: Tue, 22 Nov 2016 16:38:08 +0800
Message-Id: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Despite the scrub test cases in fstests, there is not even one test case
which really checked if scrub can recover data.

In fact, btrfs scrub for RAID56 will even corrupt correct data stripes.

So let's start from the needed facilities and check scrub starting from RAID1.

The main reason the patchset is RFC, is the method I take to corrupt/verify
btrfs data.

unlike other stable fs, like ext* or xfs, which has good tool to
manipulate the fs.

There used to be btrfs-corrupt-block, but it gets fewer and fewer
update, no man page nor installed by default.

Here I take the method I normally do in my scripts: use btrfs-dump-tree
(btrfs inspect-internal dump-tree) and use bash to corrupt btrfs
pinpointly.
It works quite fine for several different mount options which affects
how data lies on-disk.

But the problem is also obvious, bash script is super hard to maintain,
and there is no promise that btrfs-dump-tree output won't change.
Such change will be destructive.

But IMHO it's still worthy, or btrfs scrub may break at any time.

Qu Wenruo (3):
  fstests: common: rename _require_btrfs to _require_btrfs_subcommand
  fstests: common/ondisk.btrfs: Introduce function to get btrfs ondisk  
      info
  fstests: btrfs: Add new test case to check scrub recovery and report

 common/ondisk.btrfs | 113 ++++++++++++++++++++++++++
 common/rc           |   2 +-
 tests/btrfs/004     |   2 +-
 tests/btrfs/048     |   2 +-
 tests/btrfs/059     |   2 +-
 tests/btrfs/131     |   2 +-
 tests/btrfs/132     | 229 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/132.out | 111 +++++++++++++++++++++++++
 tests/btrfs/group   |   2 +
 9 files changed, 460 insertions(+), 5 deletions(-)
 create mode 100644 common/ondisk.btrfs
 create mode 100755 tests/btrfs/132
 create mode 100644 tests/btrfs/132.out

-- 
2.7.4



