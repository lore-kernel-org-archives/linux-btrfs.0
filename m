Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934458AbcKWJ6x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 04:58:53 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs corruption fix and a couple cleanups
Date: Sat, 19 Nov 2016 13:44:10 +0000
Message-Id: <1479563050-18185-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Here follows two cleanups and a fix for an issue that leads to a logical
corruption in the extent tree, where we end up with file extent items in
subvolume trees that don't have a matching extent item and back reference
in the extent tree after a balance when qgroups are enabled. This is a
regression introduced in 4.7 by a fix for yet another regression caused
by the last qgroups rework. This has been hitting SLE and openSUSE users
and QA very badly, where transactions keep getting aborted when running
delayed references leaving the root filesystem in RO mode and nearly
unusable. If you think it's appropriate, please consider it for
the 4.9 kernel (I've also tagged it for stable).
And of course, the two cleanups can wait for the 4.10 merge window.

Thanks.

The following changes since commit e3597e6090ddf40904dce6d0a5a404e2c490cac6:

  Merge branch 'for-4.9-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.9 (2016-11-01 12:54:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.10

for you to fetch changes up to 2a2a83de548f7afe2c27e51cbc9ff761cba2b61b:

  Btrfs: remove rb_node field from the delayed ref node structure (2016-11-19 13:39:18 +0000)

----------------------------------------------------------------
Filipe Manana (3):
      Btrfs: fix relocation incorrectly dropping data references
      Btrfs: remove unused code when creating and merging reloc trees
      Btrfs: remove rb_node field from the delayed ref node structure

 fs/btrfs/delayed-ref.h |  6 ------
 fs/btrfs/relocation.c  | 34 ++++++++++++----------------------
 2 files changed, 12 insertions(+), 28 deletions(-)

-- 
2.7.0.rc3

