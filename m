Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8912 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751262AbbLaPGE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 10:06:04 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id E772C409255C
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 23:05:24 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 00/10] btrfs: reada: Avoid many times of empty loop
Date: Thu, 31 Dec 2015 23:03:34 +0800
Message-ID: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is some cleanup, bugfix and enhance for reada, tested by a
script running scrub and relatice trace log.

Zhao Lei (10):
  btrfs: reada: Avoid many times of empty loop
  btrfs: reada: Move is_need_to_readahead contition earlier
  btrfs: reada: add all reachable mirrors into reada device list
  btrfs: reada: bypass adding extent when all zone failed
  btrfs: reada: Remove level argument in severial functions
  btrfs: reada: move reada_extent_put() to place after
    __readahead_hook()
  btrfs: reada: Pass reada_extent into __readahead_hook() directly
  btrfs: reada: Use fs_info instead of root in __readahead_hook's
    argument
  btrfs: reada: Jump into cleanup in direct way for __readahead_hook()
  btrfs: reada: Fix a debug code typo

 fs/btrfs/ctree.h   |   4 +-
 fs/btrfs/disk-io.c |  22 +++----
 fs/btrfs/reada.c   | 173 ++++++++++++++++++++++++++---------------------------
 3 files changed, 98 insertions(+), 101 deletions(-)

-- 
1.8.5.1



