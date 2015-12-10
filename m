Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41565 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbbLJLpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 06:45:06 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org, clm@fb.com
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes for 4.4
Date: Thu, 10 Dec 2015 11:44:50 +0000
Message-Id: <1449747890-26516-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following fixes for kernel 4.4. Two of them are fixes
to new issues introduced in the 4.4 merge window and 4.4 release candidates.
The other one just fixes a warning message that is confusing and has made
several users wonder if they are supposed to do anything or not when we
fail to read a space cache.
All these fixes have been previously sent to the mailing list.

Thanks.

The following changes since commit dba72cb30b6a4811038128c8a98b268d18ca60fe:

  btrfs: fix balance range usage filters in 4.4-rc (2015-11-25 05:27:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.4

for you to fetch changes up to 94356889c404faf050895099fd0d23f8bef118c4:

  btrfs: fix misleading warning when space cache failed to load (2015-12-10 11:38:08 +0000)

----------------------------------------------------------------
Filipe Manana (2):
      Btrfs: fix unprotected list move from unused_bgs to deleted_bgs list
      Btrfs: fix transaction handle leak in balance

Holger Hoffstätte (1):
      btrfs: fix misleading warning when space cache failed to load

 fs/btrfs/extent-tree.c      | 10 +++++++---
 fs/btrfs/free-space-cache.c |  2 +-
 fs/btrfs/transaction.c      |  1 -
 fs/btrfs/transaction.h      |  2 +-
 fs/btrfs/volumes.c          |  3 +--
 5 files changed, 10 insertions(+), 8 deletions(-)

-- 
2.1.3

