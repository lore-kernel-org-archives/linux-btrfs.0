Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759175AbcHEC3i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Aug 2016 22:29:38 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 0C876405641A
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Aug 2016 10:29:27 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] Qgroup fix for dirty hack routines
Date: Fri,  5 Aug 2016 10:29:20 +0800
Message-Id: <20160805022923.6170-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset introduce 2 fixes for data extent owner hacks.

One can be triggered by balance, another one can be trigged by log replay
after power loss.

Root cause are all similar: EXTENT_DATA owner is changed by dirty
hacks, from swapping tree blocks containing EXTENT_DATA to manually
update extent backref without using inc/dec_extent_ref.

The first patch introduces needed functions, then 2 fixes.

The reproducer are all merged into xfstests, btrfs/123 and btrfs/119.

3rd patch stay untouched while 2nd patch get update thanks for the report
from Goldwyn.

Changelog:
v2:
  Update 2nd patch to handle cases where the whole subtree, not only
  level 2 nodes get updated.

Qu Wenruo (3):
  btrfs: qgroup: Refactor btrfs_qgroup_insert_dirty_extent()
  btrfs: relocation: Fix leaking qgroups numbers on data extents
  btrfs: qgroup: Fix qgroup incorrectness caused by log replay

 fs/btrfs/delayed-ref.c |   5 +--
 fs/btrfs/extent-tree.c |  36 +++-------------
 fs/btrfs/qgroup.c      |  39 ++++++++++++++---
 fs/btrfs/qgroup.h      |  44 +++++++++++++++++--
 fs/btrfs/relocation.c  | 114 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/tree-log.c    |  16 +++++++
 6 files changed, 205 insertions(+), 49 deletions(-)

-- 
2.9.2



