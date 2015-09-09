Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60900 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751925AbbIIIt3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 04:49:29 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t898nD7Y006458
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2015 16:49:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
Date: Wed, 9 Sep 2015 16:49:19 +0800
Message-ID: <1441788564-27382-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Again the buggy btrfs-convert, even David tried to ban mixed-bg features
for btrfs-convert, it will still put data and metadata extents into the
same chunk, without marking the chunk mixed.

So in the patchset, first add fsck support for such problem, and then
force btrfs-convert to use mixed block group.

Lastly change the test case as they won't convert with non pagesize
nodesize.

Qu Wenruo (5):
  btrfs-progs: fsck: Add check for extent and parent chunk type
  btrfs: utils: Check nodesize against features
  btrfs: convert: force convert to used mixed block group
  btrfs: util: add parameter for btrfs_list_all_fs_features
  btrfs-progs: convert-test: Disable different nodesize test

 btrfs-convert.c        | 59 ++++++++++++++++++++++++++-----------------
 cmds-check.c           | 68 +++++++++++++++++++++++++++++++++++++++++++++++++-
 ctree.h                |  2 +-
 extent-tree.c          | 15 ++++++++++-
 mkfs.c                 | 19 ++++++--------
 tests/convert-tests.sh | 36 +++++++++++++++-----------
 utils.c                | 12 ++++++---
 utils.h                | 20 ++++++++++++---
 8 files changed, 171 insertions(+), 60 deletions(-)

-- 
2.5.1

