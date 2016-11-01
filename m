Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57611 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423333AbcKANCb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Nov 2016 09:02:31 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs fixes for 4.9-rc4
Date: Tue,  1 Nov 2016 14:02:25 +0100
Message-Id: <cover.1477327098.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following assorted small fixes to 4.9, thanks. The branch is
"rc3" as it was meant for rc3 but I did not get to sending the pull request,
and I don't want to recreate the branch just because of a slightly wrong
name.

----------------------------------------------------------------
The following changes since commit d9ed71e5457c8c5bf1dc706e06468eab9e2aa87e:

  Merge branch 'fst-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.9 (2016-10-12 13:16:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.9-rc3

for you to fetch changes up to 9d1032cc49a8a1065e79ee323de66bcb4fdbd535:

  btrfs: fix WARNING in btrfs_select_ref_head() (2016-10-24 18:20:29 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      Btrfs: remove some no-op casts

Goldwyn Rodrigues (1):
      btrfs: qgroup: Prevent qgroup->reserved from going subzero

Liu Bo (1):
      Btrfs: kill BUG_ON in do_relocation

Wang Xiaoguang (3):
      btrfs: make file clone aware of fatal signals
      btrfs: pass correct args to btrfs_async_run_delayed_refs()
      btrfs: fix WARNING in btrfs_select_ref_head()

 fs/btrfs/extent-tree.c |  3 +++
 fs/btrfs/extent_io.c   |  8 ++++----
 fs/btrfs/inode.c       | 13 +++++++++----
 fs/btrfs/ioctl.c       |  5 +++++
 fs/btrfs/relocation.c  |  9 ++++++++-
 5 files changed, 29 insertions(+), 9 deletions(-)
