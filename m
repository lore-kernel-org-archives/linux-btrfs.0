Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15899 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938AbbAMCEw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 21:04:52 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0D24FGP025904
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 10:04:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/4] Better btrfsck tree corruption report and automatic csum tree rebuild.
Date: Tue, 13 Jan 2015 10:04:43 +0800
Message-ID: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although btrfsck can rebuild the csum tree, but has the following
problems for end users or sysadmins who is not familiar with btrfs.
1) No brief info on which tree is corrupted.
   In fact, after extent and chunk tree check, we iterate all the
   extents and should have a brief view about which tree is corrupted.
   We can info user the fact to give them a clear view about what to do
   next

2) No automatically csum tree rebuild.
   If btrfsck can rebuild csum tree when needed and possible, why not
   rebuild it?

This patchset handles this 2 problems:
Patch 1 will handle problem 1) and patch 2~3) to handle problem 2).
Now csum tree will be automatically rebuilt if and only if csum tree is
broken but all other tree is OK.

Qu Wenruo (4):
  btrfs-progs: Report corrupted trees after check_chunks_and_extents()
  btrfs-progs: Continue repair even some extent reference can't be    
    repaired and report result to user.
  btrfs-progs: Automatically rebuild csum/extent tree if no other tree
    has     corrupted/missing extent.
  btrfs-progs: Remove all csum extents for init_csum

 cmds-check.c  | 172 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 ctree.h       |   4 ++
 extent-tree.c | 108 ++++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+), 21 deletions(-)

-- 
2.2.1

