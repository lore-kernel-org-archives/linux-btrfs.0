Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:43159 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2H3W0W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 18:26:22 -0400
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>
Subject: [PATCH 0/3] lockdep fixups for sb_interval#2 vs async transaction commit
Date: Thu, 30 Aug 2012 15:26:14 -0700
Message-Id: <1346365577-9405-1-git-send-email-sage@inktank.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These three patches (in combination with btrfs-next) fix things up for me!

Sage Weil (3):
  Btrfs: pass lockdep rwsem metadata to async commit transaction
  Btrfs: set journal_info in async trans commit worker
  Btrfs: do not take cleanup_work_sem in btrfs_run_delayed_iputs()

 fs/btrfs/inode.c       |    2 --
 fs/btrfs/transaction.c |   18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

-- 
1.7.9.5

