Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50298C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE362086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FE362086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeK1OEJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:09 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47339 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726847AbeK1OEJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:09 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766229"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:07 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 74DC14B7348C
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:07 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:12 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 00/17] btrfs: implementation of priority aware allocator
Date:   Wed, 28 Nov 2018 11:11:31 +0800
Message-ID: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 74DC14B7348C.AADFD
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from repo:
https://github.com/Damenly/btrfs-devel/commits/priority_aware_allocator.
Since patchset 'btrfs: Refactor find_free_extent()' does a nice work
to simplify find_free_extent(). This patchset dependents on the refactor.
The base is the commit in kdave/misc-next:

commit fcaaa1dfa81f2f87ad88cbe0ab86a07f9f76073c (kdave/misc-next)
Author: Nikolay Borisov <nborisov@suse.com>
Date:   Tue Nov 6 16:40:20 2018 +0200

    btrfs: Always try all copies when reading extent buffers


This patchset introduces a new mount option named 'priority_alloc=%s',
%s is supported to be "usage" and "off" now. The mount option changes
the way find_free_extent() how to search block groups.

Previously, block groups are stored in list of btrfs_space_info
by start position. When call find_free_extent() if no hint,
block_groups are searched one by one.

Design of priority aware allocator:
Block group has its own priority. We split priorities to many levels,
block groups are split to different trees according priorities.
And those trees are sorted by their levels and stored in space_info.
Once find_free_extent() is called, try to search block groups in higher
priority level then lower level. Then a block group with higher
priority is more likely to be used.

Pros:
1) Reduce the frequency of balance.
   The block group with a higher usage rate will be used preferentially
   for allocating extents. Free the empty block groups with pinned bytes
   as non-zero.[1]

2) The priority of empty block group with pinned bytes as non-zero
   will be set as the lowest.
   
3) Support zoned block device.[2]
   For metadata allocation, the block group in conventional zones
   will be used as much as possible regardless of usage rate.
   Will do it in future.
   
Cons:
1) Expectable performance regression.
   The degree of the decline is temporarily unknown.
   The user can disable block group priority to get the full performance.

TESTS:

If use usage as priority(the only available option), empty block group
is much harder to be reused.

About block group usage:
  Disk: 4 x 1T HDD gathered in LVM.

  Run script to create files and delete files randomly in loop.
  The num of files to create are double than to delete.

  Default mount option result:
  https://i.loli.net/2018/11/28/5bfdfdf08c760.png

  Priority aware allocator(usage) result:
  https://i.loli.net/2018/11/28/5bfdfdf0c1b11.png

  X coordinate means total disk usage, Y coordinate means avg block
  group usage.

  Due to fragmentation of extents, the different are not obvious,
  only about 1% improvement....
  						   
Performance regression:
   I have ran sysbench on our machine with SSD in multi combinations,
   no obvious regression found.
   However in theory, the new allocator may cost more time in some
   cases.

[1] https://www.spinics.net/lists/linux-btrfs/msg79508.html
[2] https://lkml.org/lkml/2018/8/16/174

---
Due to some reasons includes time and hardware, the use-case is not
outstanding enough. And some codes are dirty but I can't found another
way. So I named it as RFC.
     Any comments and suggestions are welcome.
     
Su Yue (17):
  btrfs: priority alloc: prepare of priority aware allocator
  btrfs: add mount definition BTRFS_MOUNT_PRIORITY_USAGE
  btrfs: priority alloc: introduce compute_block_group_priority/usage
  btrfs: priority alloc: add functions to create/remove priority trees
  btrfs: priority alloc: introduce functions to add block group to
    priority tree
  btrfs: priority alloc: introduce three macros to mark block group
    status
  btrfs: priority alloc: add functions to remove block group from
    priority tree
  btrfs: priority alloc: add btrfs_update_block_group_priority()
  btrfs: priority alloc: call create/remove_priority_trees in space_info
  btrfs: priority alloc: call add_block_group_priority while reading or
    making block group
  btrfs: priority alloc: remove block group from priority tree while
    removing block group
  btrfs: priority alloc: introduce find_free_extent_search()
  btrfs: priority alloc: modify find_free_extent() to fit priority
    allocator
  btrfs: priority alloc: introduce btrfs_set_bg_updating and call
    btrfs_update_block_group_prioriy
  btrfs: priority alloc: write bg->priority_groups_sem while waiting
    reservation
  btrfs: priority alloc: write bg->priority_tree->groups_sem to avoid
    race in btrfs_delete_unused_bgs()
  btrfs: add mount option "priority_alloc=%s"

 fs/btrfs/ctree.h            |  28 ++
 fs/btrfs/extent-tree.c      | 672 +++++++++++++++++++++++++++++++++---
 fs/btrfs/free-space-cache.c |   3 +
 fs/btrfs/super.c            |  18 +
 fs/btrfs/transaction.c      |   1 +
 5 files changed, 681 insertions(+), 41 deletions(-)

-- 
2.19.1



