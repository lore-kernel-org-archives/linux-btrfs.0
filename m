Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52099 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932108AbdGJN5M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:57:12 -0400
From: David Sterba <dsterba@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Urgent nowait aio fixup for btrfs
Date: Mon, 10 Jul 2017 15:55:49 +0200
Message-Id: <cover.1499693798.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following patch that fixes a user-visible bug introduced by the
nowait-aio patches merged in this cycle.

The branch is based on the closest merge in Jens' block changes that contained
the nowait-aio patches, the patch does not apply to current btrfs branch. As
the fix is urgent I send the pull request myself (it's all within btrfs code),
I was not available to sync with Jens over the weekend.

The following changes since commit f95a0d6a95b12a79b7492da7ab687ae4cd741124:

  Merge commit '8e8320c9315c' into for-4.13/block (2017-06-22 21:55:24 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git nowait-aio-btrfs-fixup

for you to fetch changes up to ff0fa73247e442518936baa43c3f037b17f10fa7:

  btrfs: nowait aio: Correct assignment of pos (2017-07-10 15:29:44 +0200)

----------------------------------------------------------------
Goldwyn Rodrigues (1):
      btrfs: nowait aio: Correct assignment of pos

 fs/btrfs/file.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)
