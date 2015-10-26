Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52859 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbbJZGNX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 02:13:23 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9Q6ClQ2006256
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 14:12:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [4.4][PATCH 0/3] btrfs: Qgroup hotfix
Date: Mon, 26 Oct 2015 14:11:16 +0800
Message-Id: <1445839879-17716-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes 2 bugs:
1. Race condition leading to abort transaction
Reported by Filipe, fixed by 2nd patch.

2. Qgroup low level double free leading to EDQUOT
In fact, I hit such bug several times during internal rebase, but I'm so
stupid to forgot to include it in v3 patchset.
Fixed in 3rd patch.

Qu Wenruo (3):
  btrfs: Cleanup no_quota parameter
  btrfs: qgroup: Fix a race in delayed_ref which leads to abort trans
  btrfs: qgroup: Fix a rebase bug which will cause qgroup double free

 fs/btrfs/ctree.h       |  7 +++---
 fs/btrfs/delayed-ref.c | 48 ++++++++++++++++++++--------------------
 fs/btrfs/delayed-ref.h |  9 +++-----
 fs/btrfs/extent-tree.c | 55 ++++++++++++++++++---------------------------
 fs/btrfs/file.c        | 10 ++++-----
 fs/btrfs/inode.c       | 16 +++++---------
 fs/btrfs/ioctl.c       | 60 +-------------------------------------------------
 fs/btrfs/qgroup.c      |  4 ----
 fs/btrfs/relocation.c  | 16 ++++++--------
 fs/btrfs/tree-log.c    |  2 +-
 10 files changed, 73 insertions(+), 154 deletions(-)

-- 
2.6.2

