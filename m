Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727480AbeGUGYX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jul 2018 02:24:23 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fix for 4.18-rc5
Date: Sat, 21 Jul 2018 07:32:44 +0200
Message-Id: <cover.1532150370.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following update to btrfs. It's a fix of a corruption
regarding fsync and clone, under some very specific conditions explained
in the patch. The fix is marked for stable 3.16+ so I'd like to get it
merged now given the impact. Thanks.

----------------------------------------------------------------
The following changes since commit 665d4953cde6d9e75c62a07ec8f4f8fd7d396ade:

  btrfs: scrub: Don't use inode page cache in scrub_handle_errored_block() (2018-07-17 13:56:30 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.18-rc5-tag

for you to fetch changes up to bd3599a0e142cd73edd3b6801068ac3f48ac771a:

  Btrfs: fix file data corruption after cloning a range and fsync (2018-07-19 15:36:31 +0200)

----------------------------------------------------------------
Filipe Manana (1):
      Btrfs: fix file data corruption after cloning a range and fsync

 fs/btrfs/extent_io.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
