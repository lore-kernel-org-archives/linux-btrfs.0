Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11585 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750742AbbHEIDS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 04:03:18 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <robert.munteanu@gmail.com>
Subject: [PATCH 0/3] Fix for infinite loop on non-empty inode but with no file extent
Date: Wed, 5 Aug 2015 16:03:11 +0800
Message-ID: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A bug reported by Robert Munteanu, which btrfsck infinite loops on an
inode with discount file extent.

This patchset includes a fix in printing file extent hole, fix the
infinite loop, and corresponding test case.

BTW, thanks Robert Munteanu a lot for its detailed debug report, makes
it super fast to reproduce the error.

Qu Wenruo (3):
  btrfs-progs: fsck: Print correct file hole
  btrfs-progs: fsck: Fix a infinite loop on discount file extent repair
  btrfs-progs: fsck-tests: Add test case for inode lost all its file    
    extent

 cmds-check.c                                            |  16 +++++++++++++++-
 .../017-missing-all-file-extent/default_case.img.xz     | Bin 0 -> 1104 bytes
 2 files changed, 15 insertions(+), 1 deletion(-)
 create mode 100644 tests/fsck-tests/017-missing-all-file-extent/default_case.img.xz

-- 
2.5.0

