Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14682 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932571AbcAMJ30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 04:29:26 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Chris Mason'" <clm@fb.com>
CC: "'btrfs'" <linux-btrfs@vger.kernel.org>, <zhaolei@cn.fujitsu.com>
Subject: [GIT PULL] Fujitsu for 4.5
Date: Wed, 13 Jan 2016 17:28:12 +0800
Message-ID: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This is collection of some bug fix, enhance and cleanup from fujitsu
against btrfs for v4.5, mainly for reada, plus some small fix and cleanup
for scrub and raid56.

All patchs are in btrfs-maillist, rebased on top of integration-4.5.

TEST STATUS:
Tested by xfstests, btrfs and generic group with default mount option,
diffed result with 4.4-rc8 and confirmed no regression:
Diff From:
  dir=/var/ltf/testqueue/v4.4-rc8/xfstests/
  head=v4.4-rc8
Diff To:
  dir=/var/ltf/testqueue/8e16378041f7f3531c256fd3e17a36a4fca92d29
  head=v4.4-rc6_00037_8e1637
Test:
  node=ALL
Decrease items:
  none

Xfstests for other 9 mount options is in running, I'll check results after finished.

Would you please consider merging the following fixes to integration-4.5 branch?

REPO is:
https://github.com/zhaoleidd/btrfs.git integration-4.5

--
Zhao Lei (26):
  btrfs: Small cleanup for get index_srcdev loop
  btrfs: Use direct way to determine raid56 write/recover mode
  btrfs: Fix in-segment calculation for reada
  btrfs: reduce additional fs_info->reada_lock in reada_find_zone
  btrfs: Add missed segment checking in reada_find_zone
  btrfs: reada: Avoid many times of empty loop
  btrfs: reada: Move is_need_to_readahead contition earlier
  btrfs: reada: add all reachable mirrors into reada device list
  btrfs: reada: bypass adding extent when all zone failed
  btrfs: reada: Remove level argument in severial functions
  btrfs: reada: move reada_extent_put to place after __readahead_hook()
  btrfs: reada: Pass reada_extent into __readahead_hook directly
  btrfs: reada: Use fs_info instead of root in __readahead_hook's
    argument
  btrfs: reada: Jump into cleanup in direct way for __readahead_hook()
  btrfs: reada: Fix a debug code typo
  btrfs: Continue write in case of can_not_nocow
  btrfs: delete no_used argument in btrfs_copy_from_user
  btrfs: merge functions for wait snapshot creation
  btrfs: reada: limit max works count
  btrfs: reada: simplify dev->reada_in_flight processing
  btrfs: Fix no_space in write and rm loop
  btrfs: Fix calculation of rbio->dbitmap's size calculation
  btrfs: Use unified stripe_page's index calculation
  btrfs: use rbio->nr_pages to reduce calculation
  btrfs: Remove unnecessary ClearPageUptodate for raid56
  btrfs: raid56: Use raid_write_end_io for scrub

 fs/btrfs/ctree.h       |   5 +-
 fs/btrfs/disk-io.c     |  22 ++---
 fs/btrfs/extent-tree.c |  24 +++++-
 fs/btrfs/file.c        |  43 +++++-----
 fs/btrfs/inode.c       |  22 +----
 fs/btrfs/raid56.c      | 100 ++++++++--------------
 fs/btrfs/reada.c       | 224 ++++++++++++++++++++++++-------------------------
 fs/btrfs/scrub.c       |   2 +-
 fs/btrfs/volumes.c     |  45 +++++-----
 9 files changed, 225 insertions(+), 262 deletions(-)

Thanks
Zhaolei




