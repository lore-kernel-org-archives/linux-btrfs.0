Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36148 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbbJZKTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 06:19:31 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes for delayed refs regression and a deadlock
Date: Mon, 26 Oct 2015 10:19:06 +0000
Message-Id: <1445854746-18256-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

please consider the following fixes for the 4.4 merge window (they were
previously sent to the mailing list already). They fix an issue with
delayed references that makes us hit some BUG_ONs as of the 4.2 kernel
release.

A lot of people have been hitting this and reported it in the mailing
list and bugzilla. For at least some of them this has been making it
impossible to run a balance on a 4.2+ kernel, such as Stéphane's case
on his multi terabyte filesystem.

I've tagged both for stable and included review tags that people gave
through the mailing list.

A very special thanks to Stéphane Lesimple for volunteering not only
to test these fixes (balance took over 1 day to complete on his fs!)
but also debug patches to help me figure out what was leading to the
crashes. Not only balance finishes successfully for him now, but fsck
also does not report any inconsistencies and his filesystem seems
healthy (his files, snapshots, etc, seem all ok).

As a bonus, the second patch also ends up fixing a deadlock in the clone
ioctl when qgroups are enabled (reported by Elias Probst in the mailing
list).

Thanks.

The following changes since commit a9e6d153563d2ed69c6cd7fb4fa5ce4ca7c712eb:

  Merge branch 'allocator-fixes' into for-linus-4.4 (2015-10-21 19:00:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git delayed-refs-balance-fix-4.4

for you to fetch changes up to b06c4bf5c874a57254b197f53ddf588e7a24a2bf:

  Btrfs: fix regression running delayed references when using qgroups (2015-10-25 19:53:26 +0000)

----------------------------------------------------------------
Filipe Manana (2):
      Btrfs: fix regression when running delayed references
      Btrfs: fix regression running delayed references when using qgroups

 fs/btrfs/ctree.h       |   4 ++--
 fs/btrfs/delayed-ref.c | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
 fs/btrfs/delayed-ref.h |   7 ++-----
 fs/btrfs/extent-tree.c |  59 ++++++++++++++++++++++++++++++-----------------------------
 fs/btrfs/file.c        |  10 +++++-----
 fs/btrfs/inode.c       |   4 ++--
 fs/btrfs/ioctl.c       |  62 +-------------------------------------------------------------
 fs/btrfs/relocation.c  |  16 +++++++---------
 fs/btrfs/tree-log.c    |   2 +-
 9 files changed, 170 insertions(+), 133 deletions(-)

-- 
2.1.3

