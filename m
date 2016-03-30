Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41253 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbcCaKqB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 06:46:01 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs file/data loss bug fix
Date: Wed, 30 Mar 2016 23:40:21 +0100
Message-Id: <1459377621-3826-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following fix for the linux kernel 4.6 release. It is
not a regression in the code for 4.6 nor introduced in any recent release,
it's a problem that's been around for a long time (years). But since it's
a quite serious one, it's important in my opinion to get the fix into 4.6
(and to the stable releases) instead of waiting for the 4.7 merge window.
Three test cases were sent upstream for xfstests.

Thanks.

The following changes since commit 232cad8413a0bfbd25f11cc19fd13dfd85e1d8ad:

  Merge branch 'misc-4.6' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.6 (2016-03-24 17:36:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.6

for you to fetch changes up to 3943609915b333dd6c69ea2993e4c717da07ad46:

  Btrfs: fix file/data loss caused by fsync after rename and new inode (2016-03-30 23:39:06 +0100)

----------------------------------------------------------------
Filipe Manana (1):
      Btrfs: fix file/data loss caused by fsync after rename and new inode

 fs/btrfs/tree-log.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

-- 
2.7.0.rc3

