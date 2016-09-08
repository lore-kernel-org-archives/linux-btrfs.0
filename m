Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935162AbcIHQ6p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 12:58:45 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs fixes for 4.8-rc
Date: Thu,  8 Sep 2016 18:57:04 +0200
Message-Id: <cover.1473353605.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here are two fixups for the new space handling code introduced in 4.8.
Please pull.

----------------------------------------------------------------
The following changes since commit cb887083d084d74421ae7bb18acca40568da791f:

  Merge tag 'for-chris' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.8 (2016-09-01 17:29:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris

for you to fetch changes up to ce129655c9d9aaa7b3bcc46529db1b36693575ed:

  btrfs: introduce tickets_id to determine whether asynchronous metadata reclaim work makes progress (2016-09-06 16:31:43 +0200)

----------------------------------------------------------------
Wang Xiaoguang (2):
      btrfs: do not decrease bytes_may_use when replaying extents
      btrfs: introduce tickets_id to determine whether asynchronous metadata reclaim work makes progress

 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/extent-tree.c | 23 +++++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)
