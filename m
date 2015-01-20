Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbbATSF3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 13:05:29 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: guihc.fnst@cn.fujitsu.com, quwenruo@cn.fujitsu.com, miaoxie@huawei.com,
        David Sterba <dsterba@suse.cz>, clm@fb.com
Subject: [PULL] [PATCH 0/3] Btrfs, fixes for freezing vs pending changes
Date: Tue, 20 Jan 2015 19:05:27 +0100
Message-Id: <cover.1421776294.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was some churn regarding the patches to $SUBJ, here's what I think is
enough to fix it for 3.19.

It's based on top of my other patch "btrfs: sync ioctl, handle errors after
transaction start" that might land in Chris' for-linus already so it's not
included here.

The patches are for review by the involved people, also available in this
branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git

David Sterba (1):
  btrfs: remove a no-op unfreeze superbock callback

Qu Wenruo (2):
  btrfs: Fix the bug that fs_info->pending_changes is never cleared.
  btrfs: Don't call btrfs_start_transaction() on frozen fs to avoid
    deadlock.

 fs/btrfs/super.c       | 16 ++++++++++------
 fs/btrfs/transaction.c |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.1.3

