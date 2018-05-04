Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44023 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbeEDOrn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 10:47:43 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.17-rc3
Date: Fri,  4 May 2018 16:45:03 +0200
Message-Id: <cover.1525444301.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following branch with 2 regression fixes and one fix for
stable. Thanks.

----------------------------------------------------------------
The following changes since commit c0872323746e11fc79344e3738b283a8cda86654:

  btrfs: print-tree: debugging output enhancement (2018-04-20 19:18:16 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.17-rc3-tag

for you to fetch changes up to a6aa10c70bf72fb28504cb5de5deac75da78b0f5:

  Btrfs: send, fix missing truncate for inode with prealloc extent past eof (2018-05-02 11:55:29 +0200)

----------------------------------------------------------------
Filipe Manana (1):
      Btrfs: send, fix missing truncate for inode with prealloc extent past eof

Qu Wenruo (1):
      btrfs: Fix wrong first_key parameter in replace_path

ethanwu (1):
      btrfs: Take trans lock before access running trans in check_delayed_ref

 fs/btrfs/extent-tree.c | 7 +++++++
 fs/btrfs/relocation.c  | 2 +-
 fs/btrfs/send.c        | 4 ++++
 3 files changed, 12 insertions(+), 1 deletion(-)
