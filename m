Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37247 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751645AbdDKQ7e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 12:59:34 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs fixes for 4.11-rc7
Date: Tue, 11 Apr 2017 18:59:31 +0200
Message-Id: <cover.1491929895.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

there are some fixes for crashes or use-after-free and one fix to the mount
options handling (user-visible behaviour). Please pull to 4.11, thanks.

----------------------------------------------------------------

The following changes since commit 41a75a6eb2bf4e75e0d93862171bebb3ca4efec7:

  Merge branch 'for-chris-4.11-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.11 (2017-03-29 13:10:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.11-rc7

for you to fetch changes up to a967efb30b3afa3d858edd6a17f544f9e9e46eea:

  Btrfs: fix potential use-after-free for cloned bio (2017-04-11 18:49:56 +0200)

----------------------------------------------------------------
Adam Borowski (1):
      btrfs: drop the nossd flag when remounting with -o ssd

Liu Bo (3):
      Btrfs: fix invalid dereference in btrfs_retry_endio
      Btrfs: fix segmentation fault when doing dio read
      Btrfs: fix potential use-after-free for cloned bio

 fs/btrfs/inode.c   | 22 ++++++++++------------
 fs/btrfs/super.c   |  3 +++
 fs/btrfs/volumes.c |  2 +-
 3 files changed, 14 insertions(+), 13 deletions(-)
