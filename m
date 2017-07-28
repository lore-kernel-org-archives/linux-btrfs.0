Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57455 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751882AbdG1QGA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 12:06:00 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.13-rc3
Date: Fri, 28 Jul 2017 18:04:39 +0200
Message-Id: <cover.1501256500.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following btrfs fixes. They're addressing problems reported by
users, and there's one more regression fix. Thanks.

The next pull request will be sent by Chris, I'm heading off to vacation.


The following changes since commit c3cfb656307583ddfea45375c10183737593c195:

  Btrfs: fix unexpected return value of bio_readpage_error (2017-07-14 20:42:37 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.13-part3

for you to fetch changes up to 0e4324a4c36b3eb5cd1f71cbbc38d888f919ebfc:

  btrfs: round down size diff when shrinking/growing device (2017-07-24 16:05:00 +0200)

----------------------------------------------------------------
Filipe Manana (1):
      Btrfs: fix dir item validation when replaying xattr deletes

Jeff Mahoney (1):
      btrfs: fix lockup in find_free_extent with read-only block groups

Nikolay Borisov (1):
      btrfs: round down size diff when shrinking/growing device

Omar Sandoval (1):
      Btrfs: fix early ENOSPC due to delalloc

 fs/btrfs/extent-tree.c | 11 +++++------
 fs/btrfs/tree-log.c    |  3 +--
 fs/btrfs/volumes.c     |  4 ++--
 3 files changed, 8 insertions(+), 10 deletions(-)
