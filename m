Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50732 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbbHSSsA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 14:48:00 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes for integration-4.3
Date: Wed, 19 Aug 2015 19:37:42 +0100
Message-Id: <1440009462-7303-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following fixes for your integration-4.3 branch.
Nothing unusual. I included any Reviewed-by tags people added and a
test case for xfstests for the file corruption after fsync fix.

Thanks.

The following changes since commit 46cd28555ffaa40162290dba203daad0ff6f7abd:

  Merge branch 'jeffm-discard-4.3' into for-linus-4.3 (2015-08-09 07:35:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.3

for you to fetch changes up to 477594f93c43b1ee685f085f437293758cf3f581:

  Btrfs: fix file read corruption after extent cloning and fsync (2015-08-19 19:26:37 +0100)

----------------------------------------------------------------
Filipe Manana (2):
      Btrfs: check if previous transaction aborted to avoid fs corruption
      Btrfs: fix file read corruption after extent cloning and fsync

 fs/btrfs/transaction.c |  3 +++
 fs/btrfs/tree-log.c    | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

-- 
2.1.3

