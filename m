Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49931 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbcGEJc0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jul 2016 05:32:26 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 1D6844056401
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2016 17:32:09 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Qgroup fixes for dirty hack routines
Date: Tue,  5 Jul 2016 17:32:04 +0800
Message-Id: <20160705093207.14983-1-quwenruo@cn.fujitsu.com>
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

The 2nd patch is sent to mail list weeks ago, only commit message and
comment is updated.

Qu Wenruo (3):
  btrfs: qgroup: Refactor btrfs_qgroup_insert_dirty_extent()
  btrfs: relocation: Fix leaking qgroups numbers on data extents
  btrfs: qgroup: Fix qgroup incorrectness caused by log replay

 fs/btrfs/delayed-ref.c |  5 +---
 fs/btrfs/extent-tree.c | 36 ++++------------------
 fs/btrfs/qgroup.c      | 39 ++++++++++++++++++++----
 fs/btrfs/qgroup.h      | 44 +++++++++++++++++++++++++--
 fs/btrfs/relocation.c  | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/tree-log.c    | 16 ++++++++++
 6 files changed, 178 insertions(+), 43 deletions(-)

-- 
2.9.0



