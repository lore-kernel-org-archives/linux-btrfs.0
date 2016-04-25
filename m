Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54152 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbcDZKjD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 06:39:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5F0AB20123
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 10:39:02 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 4ABD220107
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 10:39:01 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Fixes for races in relocation and avoid start and wait for unrelated IO
Date: Mon, 25 Apr 2016 02:01:09 +0100
Message-Id: <1461546072-11154-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The following patches fix 2 hard to hit races in relocation that make its
first phase (MOVE_DATA_EXTENTS) miss extents, triggers a warning in the
second phase (UPDATE_DATA_PTRS) and leaves metadata in an invalid state
(file extent items pointing to areas corresponding to the deleted block
group), leading to a BUG_ON() when attempting to read those extents after
the relocation finishes.
Patches 1 and 3 fix those races, patch 2 is an optimization that makes
the relocation no longer wait for ordered extents against other groups
and patch 3 besides fixing a race also makes relocation only wait for
tasks that started delalloc flushing and allocated already an extent
from the block group we are relocating, instead of flushing all delalloc
regions.

Filipe Manana (3):
  Btrfs: fix race in relocation that makes us miss extents
  Btrfs: don't wait for unrelated IO to finish before relocation
  Btrfs: don't do unnecessary delalloc flushes when relocating

 fs/btrfs/ctree.h        | 14 ++++++++++
 fs/btrfs/dev-replace.c  |  4 +--
 fs/btrfs/extent-tree.c  | 69 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/inode.c        |  8 ++++++
 fs/btrfs/ioctl.c        |  2 +-
 fs/btrfs/ordered-data.c | 30 ++++++++++++++++-----
 fs/btrfs/ordered-data.h |  6 +++--
 fs/btrfs/relocation.c   | 30 +++++++++++++++++----
 fs/btrfs/super.c        |  2 +-
 fs/btrfs/transaction.c  |  2 +-
 10 files changed, 142 insertions(+), 25 deletions(-)

-- 
2.7.0.rc3

