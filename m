Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbaKNKdD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 05:33:03 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, clm@fb.com
Subject: [PULL] [PATCH 0/6] Support for 'pending changes'
Date: Fri, 14 Nov 2014 11:33:01 +0100
Message-Id: <cover.1415894837.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are some actions that modify global filesystem state but cannot be
performed at the time of request, but rather later at the transaction commit
time when the filesystem is in a known state.

The change can be requested from any context and is permanent after sync. This
changes the semantics for the sysfs files that modify label or feature bits,
but I think this does not break existing applications.

You can pull the series from

 git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/pending-changes

David Sterba (6):
  btrfs: add support for processing pending changes
  btrfs: do commit in sync_fs if there are pending changes
  btrfs: switch inode_cache option handling to pending changes
  btrfs: introduce pending action: commit
  btrfs: move commit out of sysfs when changing features
  btrfs: move commit out of sysfs when changing label

 fs/btrfs/ctree.h       | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/disk-io.c     |  8 +++++---
 fs/btrfs/inode-map.c   |  2 +-
 fs/btrfs/super.c       | 18 +++++++++++++-----
 fs/btrfs/sysfs.c       | 34 +++++++++++++---------------------
 fs/btrfs/transaction.c | 38 ++++++++++++++++++++++++++++++++------
 fs/btrfs/transaction.h |  2 ++
 7 files changed, 115 insertions(+), 37 deletions(-)

-- 
1.8.4.5

