Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934776AbcJQPdw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:33:52 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Send fix for 4.9
Date: Fri, 14 Oct 2016 22:54:08 +0100
Message-Id: <1476482048-3659-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris, please pull the following send fix for the 4.9 kernel.

Doing snapshots while balance is ongoing can result in file extent items whose
only difference between snapshots is their bytenr, which got replaced by the
relocation process, and the inode item does not get changed between the parent
and send snapshots (since nothing changed except the location of extent).
Prior to the 4.8 kernel, send would consider this a bug and we would hit a
BUG_ON(), but on 4.8 due to another change this made only send fail with -EIO
and log an error message, since the same can happen due to rare errors that can
occur when attempting to update an inode item after successfully updating its
extents.
This has been observed with some frequency on openSUSE and SLE boxes where
balance is triggered periodically by a cron job, snapshotting is triggered
before package installations/updates and snapper calls for incremental send
operations in no data mode.

Thanks.

The following changes since commit 19c4d2f994788a954af1aa7e53b0fdb46fd7925a:

  Revert "btrfs: let btrfs_delete_unused_bgs() to clean relocated bgs" (2016-10-10 13:43:31 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.9

for you to fetch changes up to d5e84fd8d0634d056248b67463b42f6c85896a19:

  Btrfs: fix incremental send failure caused by balance (2016-10-12 10:41:01 +0100)

----------------------------------------------------------------
Filipe Manana (1):
      Btrfs: fix incremental send failure caused by balance

 fs/btrfs/send.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

-- 
2.7.0.rc3

