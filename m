Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45126 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754335AbbIJCgX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 22:36:23 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
Date: Thu, 10 Sep 2015 10:34:13 +0800
Message-ID: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
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

v2:
  Reword the title, as some patch uses wrong title 'btrfs' not
  'btrfs-progs'.
  No real code change, so no changelog for each patch.

Qu Wenruo (5):
  btrfs-progs: fsck: Add check for extent and parent chunk type
  btrfs-progs: utils: Check nodesize against features
  btrfs-progs: convert: force convert to used mixed block group
  btrfs-progs: util: add parameter for btrfs_list_all_fs_features
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

