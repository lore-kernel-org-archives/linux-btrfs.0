Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaBSLTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 06:19:39 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1JBJZME025817
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 19:19:35 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] Btrfs-progs: cleanups: new helper for parsing string to u64
Date: Wed, 19 Feb 2014 19:17:50 +0800
Message-Id: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are many places that need parse string to u64 for btrfs commands,
in fact, we do such things *too casually*, using atoi/atol/atoll..is not
right at all, and even we don't check whether it is a valid string.

Let's do everything more gracefully, we introduce a new helper
btrfs_strtoull() which will do all the necessary checks.If we fail to
parse string to u64, we will output message and exit directly, this is
something like what usage() is doing. It is ok to not return erro to
it's caller, because this function should be called when parsing arg
(just like usage!)

I convert most places to btrfs_strtoull, test patches with xfstests.
Feel free to review and comment.

Wang Shilong (4):
  Btrfs-progs: new helper to parse string to u64 for btrfs
  Btrfs-progs: switch to btrfs_strtoull() part1
  Btrfs-progs: switch to btrfs_strtoull() part2
  Btrfs-progs: switch to btrfs_strtoull() part3

 btrfs-corrupt-block.c | 38 +++++++++-----------------------------
 btrfs-debug-tree.c    |  2 +-
 btrfs-find-root.c     | 23 +++--------------------
 btrfs-image.c         |  8 ++++----
 btrfs-list.c          | 14 +++-----------
 btrfs-map-logical.c   | 26 ++++++--------------------
 btrfs-show-super.c    |  7 ++++---
 btrfstune.c           |  4 ++--
 cmds-inspect.c        |  8 ++++----
 cmds-replace.c        |  7 +------
 cmds-restore.c        | 20 ++++----------------
 cmds-subvolume.c      |  8 ++------
 utils.c               | 21 ++++++++++++++++++++-
 utils.h               |  1 +
 14 files changed, 64 insertions(+), 123 deletions(-)

-- 
1.8.3.1

