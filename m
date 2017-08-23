Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47372 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753057AbdHWCd7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:33:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2DCCB472438E
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 10:34:00 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 0/6] btrfs-progs: check: extent tree lowmem repair
Date: Wed, 23 Aug 2017 10:33:44 +0800
Message-ID: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

This is part 2 of lowmem repair patchsets:
1. Change the way of traversal under lowmem check to use walk_up_tree_v2() and
   walk_down_tree_v2() and it scans all trees now.
2. Repair cases: block group missing, tree block backref missing,
   extent item mismatch, extent data mismatch and data extent backref missing.

Methods to repair extent tree is similar as original mode.
1. Delete all wrong extents(REFERENCER_MISSING or REFERENCER_MISMATCH).

2. Traverse all trees and extent data to rebuild  extent tree.

some issues:
1. Because scan of all trees, the speed may be very very slow.
2. Unlike origin mode who gathers all things together and checks, extent tree
   repair in lowmem mode may print some incorrect information after check.
   But, data on disk is fine, next check should be OK.
3. After repair, some extent of extent tree nodes may be reported like
   "Extent buffer leak ....", but next check is fine.
   (I don't know what's wrong)

The reason why lowmem check has to check all trees is list as [patch 2/6] commit
message.

Although I have tested those code by images which tree level is 2 or 3 and has
snapshots with option(--init-extent-tree).
I am still worried some corner cases.

Su Yue (6):
  btrfs-progs: check: enable repair in lowmem mode
  btrfs-progs: check: change traversal way of lowmem mode
  btrfs-progs: check: delete wrong items in lowmem repair
  btrfs-progs: check: Introduce repair_chunk_item()
  [btrfs-progs: check: Introduce repair_tree_block_ref()
  btrfs-progs: check: Introduce repair_extent_data_item()

 cmds-check.c | 1262 +++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 943 insertions(+), 319 deletions(-)

-- 
2.7.4



