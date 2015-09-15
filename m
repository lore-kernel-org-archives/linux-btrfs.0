Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22360 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbbIONJs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 09:09:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8FD9Usm016731
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 21:09:30 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/3] btrfs: Move btrfs_raid_array to public
Date: Tue, 15 Sep 2015 21:08:05 +0800
Message-ID: <cover.1442322310.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This array is used to record attributes of each raid type,
make it public, and many functions will benifit with this array.

For example, num_tolerated_disk_barrier_failures(), we can
avoid complex conditions in this function, and get raid attribute
simply by accessing above array.

It can also make code logic simple, reduce duplication code, and
increase maintainability.

We can also add more raid attributes in this array, to make it
widely used.

Zhao Lei (3):
  btrfs: Move btrfs_raid_array to public
  btrfs: use btrfs_raid_array for
    btrfs_get_num_tolerated_disk_barrier_failures()
  btrfs: use btrfs_raid_array in btrfs_reduce_alloc_profile

 fs/btrfs/disk-io.c     |  35 ++++++++-----
 fs/btrfs/extent-tree.c |  48 ++++++++----------
 fs/btrfs/volumes.c     | 135 ++++++++++++++++++++++++++++---------------------
 fs/btrfs/volumes.h     |   5 ++
 4 files changed, 125 insertions(+), 98 deletions(-)

-- 
1.8.5.1

