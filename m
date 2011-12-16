From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes (part two, against 3.2-rc)
Date: Fri, 16 Dec 2011 13:27:28 -0500
Message-ID: <20111216182728.GB25457@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I try to keep most of the btrfs commits against the last release.  This
way, people can update their old and crusty kernels from 3 months ago,
and still have the latest btrfs code.

We do have one commit that is 3.2 specific though, so I put it into a
for-linus-3.2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-3.2

Wu Fengguang noticed that btrfs' file write needs to consider the balance
dirty thresholds when it allows big multi-page writes.

Wu Fengguang (1) commits (+2/-0):
    btrfs: lower the dirty balance poll interval

Total: (1) commits (+2/-0)

 fs/btrfs/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

