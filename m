Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57647 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752167AbdATOnM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 09:43:12 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs fixes for 4.10
Date: Fri, 20 Jan 2017 15:42:50 +0100
Message-Id: <cover.1484923236.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few more fixes, please pull. Thanks.

----------------------------------------------------------------
The following changes since commit 0bf70aebf12d8fa0d06967b72ca4b257eb6adf06:

  Merge branch 'tracepoint-updates-4.10' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.10 (2017-01-11 06:26:12 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris

for you to fetch changes up to 91298eec05cd8d4e828cf7ee5d4a6334f70cf69a:

  Btrfs: fix truncate down when no_holes feature is enabled (2017-01-19 18:02:22 +0100)

----------------------------------------------------------------
Chandan Rajendra (1):
      Btrfs: Fix deadlock between direct IO and fast fsync

Liu Bo (1):
      Btrfs: fix truncate down when no_holes feature is enabled

Wang Xiaoguang (1):
      btrfs: fix false enospc error when truncating heavily reflinked file

 fs/btrfs/inode.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)
