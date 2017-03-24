Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46998 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932502AbdCXCAm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 22:00:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <bo.li.liu@oracle.com>
Subject: [PATCH v2 0/5] raid56: scrub related fixes
Date: Fri, 24 Mar 2017 10:00:22 +0800
Message-ID: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from my github repo:
https://github.com/adam900710/linux.git raid56_fixes

It's based on v4.11-rc2, the last two patches get modified according to
the advice from Liu Bo.

The patchset fixes the following bugs:

1) False alert or wrong csum error number when scrubbing RAID5/6
   The bug itself won't cause any damage to fs, just pure race.

2) Corrupted data stripe rebuild corrupts P/Q
   So scrub makes one error into another, not really fixing anything

3) Use-after-free caused by cancelling dev-replace 
   This is quite a deadly bug, since cancelling dev-replace can
   cause kernel panic.

   Can be triggered by btrfs/069.

v2:
  Use bio_counter to protect rbio against dev-replace cancel, instead of
  original btrfs_device refcount, which is too restrict and must disable
  rbio cache, suggested by Liu Bo.

Qu Wenruo (5):
  btrfs: scrub: Introduce full stripe lock for RAID56
  btrfs: scrub: Fix RAID56 recovery race condition
  btrfs: scrub: Don't append on-disk pages for raid56 scrub
  btrfs: dev-replace: Wait flighting bio before removing target device
  btrfs: raid56: Use bio_counter to protect scrub

 fs/btrfs/ctree.h       |   4 +
 fs/btrfs/dev-replace.c |   2 +
 fs/btrfs/extent-tree.c |   3 +
 fs/btrfs/raid56.c      |   2 +
 fs/btrfs/scrub.c       | 201 ++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 208 insertions(+), 4 deletions(-)

-- 
2.12.1



