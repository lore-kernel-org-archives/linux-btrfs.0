Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaANNQP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 08:16:15 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0ECUOq5015720
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 20:30:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 0/4] Btrfs: improve the performance fluctuating of the fsync
Date: Tue, 14 Jan 2014 20:31:48 +0800
Message-Id: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We met the performance fluctuating problem when we synchronized the file data.
The main reason of this problem was that we might only flush part dirty pages
in a ordered extent, then got that ordered extent, wait for the csum
calcucation. But if no task flushed the left part, we would wait until the
flusher flushed them, sometimes we need wait for several seconds, it made
the performance drop down suddenly.

This patchset improved the above problem. The 1st patch helps us filter
the logged ordered extents, the 2nd one removes the unnecessary lock operation,
the 3rd one prevents the ordered extents from being inserted into a global
list, it can reduce the lock contention and the traverse time of list.
The 4th is the key patch to the above problem, it fixes the problem by flush
the left dirty pages aggressively.

Miao Xie (4):
  Btrfs: filter the ordered extents that has been logged
  Btrfs: don't get the lock when adding a csum into a ordered extent
  Btrfs: don't mix the ordered extents of all files together during logging the inodes
  Btrfs: flush the dirty pages of the ordered extent aggressively during logging csum

 fs/btrfs/ordered-data.c |   46 +++++++++++++++++++++++++++++-----------
 fs/btrfs/ordered-data.h |    6 ++++-
 fs/btrfs/tree-log.c     |   53 +++++++++++++++++-----------------------------
 3 files changed, 58 insertions(+), 47 deletions(-)

