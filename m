Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60150 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaBTBcp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 20:32:45 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K1Wg0X006794
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 09:32:42 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] Btrfs-progs: cleanups: new helper for parsing string to u64
Date: Thu, 20 Feb 2014 09:30:48 +0800
Message-Id: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are many places that need parse string to u64 for btrfs commands,
in fact, we do such things *too casually*, using atoi/atol/atoll..is not
right at all, and even we don't check whether it is a valid string.

Let's do everything more gracefully, we introduce a new helper
arg_strtou64() which will do all the necessary checks.If we fail to
parse string to u64, we will output message and exit directly, this is
something like what usage() is doing. It is ok to not return erro to
it's caller, because this function should be called when parsing arg
(just like usage!)

I convert most places to arg_strtou64, test patches with xfstests.
Feel free to review and comment.

Changelog v1->v2:
	s/btrfs_strtoull64/arg_strtou64 addressed by G.Baroncelli
	fix out of range check,support hex and octal numbers pointed by Stefan.
	add negative check pointed by Eric Sandeen.
	plus more codes cleanups.

Wang Shilong (4):
  Btrfs-progs: new helper to parse string to u64 for btrfs
  Btrfs-progs: switch to arg_strtou64() part1
  Btrfs-progs: switch to arg_strtou64() part2
  Btrfs-progs: switch to arg_strtou64() part3

 btrfs-corrupt-block.c | 45 +++++++++------------------------------------
 btrfs-debug-tree.c    |  2 +-
 btrfs-find-root.c     | 23 +++--------------------
 btrfs-image.c         | 12 ++++++------
 btrfs-list.c          | 14 +++-----------
 btrfs-map-logical.c   | 26 ++++++--------------------
 btrfs-select-super.c  | 12 +++++++++---
 btrfs-show-super.c    | 10 +++++-----
 btrfstune.c           |  4 ++--
 cmds-check.c          | 14 ++++++++++----
 cmds-inspect.c        |  8 ++++----
 cmds-replace.c        |  7 +------
 cmds-restore.c        | 27 +++++----------------------
 cmds-subvolume.c      |  8 ++------
 utils.c               | 35 ++++++++++++++++++++++++++++++++++-
 utils.h               |  1 +
 16 files changed, 101 insertions(+), 147 deletions(-)

-- 
1.8.3.1

