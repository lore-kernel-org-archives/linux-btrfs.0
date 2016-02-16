Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46482 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbcBPMVV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 07:21:21 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fix for direct IO error reporting
Date: Tue, 16 Feb 2016 04:02:41 +0000
Message-Id: <1455595361-29377-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following fix for an upcoming 4.5 release candidate.
It fixes a problem where if the bio for a direct IO request fails, we end
reporting success to userspace. For example, for a direct IO write of 64K,
if the block layer notifies us that an IO error happened with our bio, we
end up returning the value 64K to user space instead of -EIO, making the
application think that its write request succeeded.

This is reproducible with the new generic test cases in xfstests: 271,
272, 276 and 278 (which use dm's error target to simulate IO errors).

Thanks.

The following changes since commit bc4ef7592f657ae81b017207a1098817126ad4cb:

  btrfs: properly set the termination value of ctx->pos in readdir (2016-02-11 07:01:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.5

for you to fetch changes up to 1636d1d77ef4e01e57f706a4cae3371463896136:

  Btrfs: fix direct IO requests not reporting IO error to user space (2016-02-16 03:41:26 +0000)

----------------------------------------------------------------
Filipe Manana (1):
      Btrfs: fix direct IO requests not reporting IO error to user space

 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.7.0.rc3

