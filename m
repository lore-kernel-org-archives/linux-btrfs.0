From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Two small btrfs fixes
Date: Tue, 11 Oct 2011 13:27:43 -0400
Message-ID: <1318353941-sup-6080@shiny>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"LKML" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Li Zefan hit some problems with looping in the btrfs autodefrag mode.

These two commits are in the btrfs-3.0 branch:

git://github.com/chrismason/linux.git btrfs-3.0


Chris Mason (1) commits (+3/-1):
    Btrfs: make sure not to defrag extents past i_size

Li Zefan (1) commits (+7/-0):
    Btrfs: fix recursive auto-defrag

Total: (2) commits (+10/-1)

 fs/btrfs/ioctl.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)
