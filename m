Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965546AbaKNNtZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 08:49:25 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAEDn91q005807
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 21:49:09 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/9] Implement device scrub/replace for RAID56
Date: Fri, 14 Nov 2014 21:50:52 +0800
Message-ID: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset implement the device scrub/replace function for RAID56, the
most implementation of the common data is similar to the other RAID type.
The differentia or difficulty is the parity process. In order to avoid
that problem the data that is easy to be change out the stripe lock,
we do most work in the RAID56 stripe lock context.

And in order to avoid making the code more and more complex, we copy some
code of common data process for the parity, the cleanup work is in my
TODO list.

We have done some test, the patchset worked well. Of course, more tests
are welcome. If you are interesting to use it or test it, you can pull
the patchset from

  https://github.com/miaoxie/linux-btrfs.git raid56-scrub-replace

Thanks
Miao

Miao Xie (6):
  Btrfs, raid56: don't change bbio and raid_map
  Btrfs, scrub: repair the common data on RAID5/6 if it is corrupted
  Btrfs,raid56: use a variant to record the operation type
  Btrfs,raid56: support parity scrub on raid56
  Btrfs, replace: write dirty pages into the replace target device
  Btrfs, replace: write raid56 parity into the replace target device

Zhao Lei (3):
  Btrfs: remove noused bbio_ret in __btrfs_map_block in condition
  Btrfs: remove unnecessary code of stripe_index assignment in
    __btrfs_map_block
  Btrfs, replace: enable dev-replace for raid56

 fs/btrfs/dev-replace.c |   5 -
 fs/btrfs/raid56.c      | 711 +++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/raid56.h      |  14 +-
 fs/btrfs/scrub.c       | 793 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.c     |  47 ++-
 fs/btrfs/volumes.h     |  14 +-
 6 files changed, 1471 insertions(+), 113 deletions(-)

-- 
1.9.3

