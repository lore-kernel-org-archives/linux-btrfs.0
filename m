From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs update for 2.6.35-rc
Date: Mon, 19 Jul 2010 20:48:06 -0400
Message-ID: <20100720004806.GE3133@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

This batch has changes I've been testing in the master branch of the
btrfs-unstable repo

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

The first deals with the balancing bug that Edward Shishkin found.  The
others are bugs that have turned up during the rc.

Chris Mason (1) commits (+111/-18):
    Btrfs: fix split_leaf double split corner case

Dan Rosenberg (1) commits (+2/-2):
    Btrfs: fix checks in BTRFS_IOC_CLONE_RANGE

Sage Weil (1) commits (+13/-3):
    Btrfs: fix CLONE ioctl destination file size expansion to block boundary

Total: (3) commits (+126/-23)

 fs/btrfs/ctree.c |  129 ++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c |   20 ++++++--
 2 files changed, 126 insertions(+), 23 deletions(-)
