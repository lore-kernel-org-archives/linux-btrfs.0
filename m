Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46431 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752511AbcHSIQm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 04:16:42 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 3B2B542BC534
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 16:13:16 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/4] Convert regression fix with print-tree enhancement
Date: Fri, 19 Aug 2016 16:13:04 +0800
Message-ID: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes one convert regression, adds regression test.
Then with 2 print-tree enhancement, which is quite handy to find how inode
and subvolume READONLY flag is set.

Qu Wenruo (4):
  btrfs-progs: convert: Fix a regression that ext2_save/image is not
    readonly
  btrfs-progs: convert-test: Check if the ext2_save/image is read only
  btrfs-progs: print-tree: Print human readable inode flags
  btrfs-progs: print-tree: Print hex and human readable root flags

 btrfs-convert.c                                |  9 ++++-
 ctree.h                                        |  2 ++
 inode.c                                        | 36 +++++++++++++++++++
 print-tree.c                                   | 49 ++++++++++++++++++++++++--
 tests/convert-tests/008-readonly-image/test.sh | 26 ++++++++++++++
 5 files changed, 119 insertions(+), 3 deletions(-)
 create mode 100755 tests/convert-tests/008-readonly-image/test.sh

-- 
2.9.3



