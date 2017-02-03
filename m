Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46103 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751866AbdBCIVP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 03:21:15 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 2073147B0CAF
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Feb 2017 16:20:31 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] raid56: variant bug fixes
Date: Fri, 3 Feb 2017 16:20:18 +0800
Message-ID: <20170203082023.3577-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from my github repo:
https://github.com/adam900710/linux.git raid56_fixes

It's based on v4.10-rc6 and none of the patch is modified after its first
appearance in mail list.

The patchset fixes the following bugs:

1) False alert or wrong csum error number when scrubbing RAID5/6
   The bug itself won't cause any damage to fs, just pure race.

2) Corrupted data stripe rebuild corrupts P/Q
   So scrub makes one error into another, not really fixing anything

3) Use-after-free caused by cancelling dev-replace 
   This is quite a deadly bug, since cancelling dev-replace can easily
   cause kernel panic, and thanks to raid bio steal, it makes the race
   windows quite large.

   Can be triggered by btrfs/069.

After all the fixes applied, no scrub/replace related regression can be
detected.

Qu Wenruo (5):
  btrfs: scrub: Introduce full stripe lock for RAID56
  btrfs: scrub: Fix RAID56 recovery race condition
  btrfs: raid56: Use correct stolen pages to calculate P/Q
  btrfs: raid56: Don't keep rbio for later steal
  btrfs: replace: Use ref counts to avoid destroying target device when
    canceled

 fs/btrfs/ctree.h       |   4 ++
 fs/btrfs/dev-replace.c |   7 +-
 fs/btrfs/extent-tree.c |   3 +
 fs/btrfs/raid56.c      |  80 +++++++++++++++------
 fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     |  36 +++++++++-
 fs/btrfs/volumes.h     |  10 +++
 7 files changed, 309 insertions(+), 23 deletions(-)

-- 
2.11.0



