Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8681 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2JYJUK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 05:20:10 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9P9K5MI029865
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 17:20:06 +0800
Message-ID: <5089045D.8050801@cn.fujitsu.com>
Date: Thu, 25 Oct 2012 17:20:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] flush delalloc by multi-task
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset introduce multi-task delalloc flush, it can make the delalloc
flush more faster. And besides that, it also can fix the problem that we join
the same transaction handler more than 2 times.

Implementation:
- Create a new worker pool.
- Queue the inode with pending delalloc into the work queue of the worker pool
  when we want to force them into the disk, and then we will wait till all the
  works we submit are done. 
- The ordered extents also can be queued into this work queue. The process is
  similar to the second one.

Miao Xie (3):
      Btrfs: make delalloc inodes be flushed by multi-task
      Btrfs: make ordered operations be handled by multi-task
      Btrfs: make ordered extent be flushed by multi-task

 fs/btrfs/ctree.h        |   14 +++++++
 fs/btrfs/disk-io.c      |    7 ++++
 fs/btrfs/inode.c        |   78 ++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/ordered-data.c |   87 ++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/ordered-data.h |    7 +++-
 fs/btrfs/relocation.c   |    6 +++-
 fs/btrfs/transaction.c  |   24 ++++++++++---
 7 files changed, 185 insertions(+), 38 deletions(-)
