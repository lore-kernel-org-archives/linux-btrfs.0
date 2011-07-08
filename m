From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] btrfs fixes
Date: Fri, 08 Jul 2011 14:55:51 -0400
Message-ID: <1310151138-sup-6548@shiny>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Has three more fixes.  We're fixing oopsen during space balancing (btrfs
filesystem balance /mnt)) and during device removal.

Dave Sterba also sent in a patch to make /proc/mounts properly match a
few new mount options, which he (correctly I think) considers a
regression fix because it makes it hard for testers/users to verify the
options in a running config.

Josef Bacik (1) commits (+2/-1):
    Btrfs: don't panic if we get an error while balancing V2

David Sterba (1) commits (+11/-0):
    btrfs: add missing options displayed in mount output

Miao Xie (1) commits (+7/-5):
    btrfs: fix oops when doing space balance

Total: (3) commits (+20/-6)

 fs/btrfs/ctree.h   |    5 +++++
 fs/btrfs/inode.c   |   12 +++++++-----
 fs/btrfs/super.c   |    6 ++++++
 fs/btrfs/volumes.c |    3 ++-
 4 files changed, 20 insertions(+), 6 deletions(-)
