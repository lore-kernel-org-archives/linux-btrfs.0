Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29728 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176AbbGWJSV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 05:18:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH 0/4] Metadata crossing stripe boundary fixes
Date: Thu, 23 Jul 2015 17:18:06 +0800
Message-ID: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The problem is originally reported by Chris Murphy<lists@colorremedies.com>,
and Zhao Lei digs out the root cause:
Metadata extent in mixed block group may cross stripe boundary, causing
scrub can't handle them.

For normal data/metadata separated case, as BTRFS_STRIPE_LEN(64K) can
always be divided by nodesize (4~64K, power of 2), so metadata will
never cross the stripe boundary.
But for mixed block group, data is page size(4K) aligned, breaking the
original metadata alignment, make metadata extent possible to cross
stripe boundary.

In the patchset, btrfsck will report such error and normal extent
allocate routine along with btrfs-convert will be patched to fix such
problem.

I'd like to add a test case, but it is already covered by the existing
convert test, and further more, btrfsck can only report the error with
only the 2nd patch applied.
So no good test case yet.

Kernel also needs such check, I'll check kernel codes later.

Qu Wenruo (4):
  btrfs: print-tree: print stripe len of a chunk
  btrfs: fsck: Check if a metadata tree block crossing stripe boundary
  btrfs: extent-tree: Avoid allocating tree block that cross stripe    
    boundary
  btrfs: convert: Avoid allocating metadata extent crossing stripe    
    boundary

 btrfs-convert.c | 15 ++++++++++++---
 cmds-check.c    | 28 +++++++++++++++++++++++++++-
 ctree.h         |  2 +-
 extent-tree.c   |  7 ++++++-
 print-tree.c    |  4 +++-
 volumes.h       | 10 ++++++++++
 6 files changed, 59 insertions(+), 7 deletions(-)

-- 
2.4.6

