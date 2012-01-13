From: Andi Kleen <andi@firstfloor.org>
Subject: Updated btrfs/crypto snappy interface ready for merging
Date: Thu, 12 Jan 2012 16:28:47 -0800
Message-ID: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here's a slightly updated version of the BTRFS snappy interface.
snappy is a faster compression algorithm that provides similar
compression as LZO, but generally better performance.

This version has:

- Ported to latest tree
- Extensive testing and benchmarking (in its 3.0 based incarnation)
- A few cleanups
- Adds a minor performance improvement

Should be ready for pulling into the btrfs tree now.
The crypto parts have been acked by Herbert.

The following changes since commit 2485a4b610171f4e1c4ab0d053569747795c1bbe:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2012-01-12 12:40:41 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc snappy

Andi Kleen (3):
      Add the snappy-c compressor to lib v2
      BTRFS: Add snappy support v2
      Add snappy interface to crypto API

 crypto/Kconfig         |    9 +
 crypto/Makefile        |    1 +
 crypto/snappy.c        |   99 ++++
 fs/btrfs/Kconfig       |    1 +
 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/compression.c |    1 +
 fs/btrfs/compression.h |    1 +
 fs/btrfs/ctree.h       |    9 +-
 fs/btrfs/disk-io.c     |    2 +
 fs/btrfs/ioctl.c       |    4 +
 fs/btrfs/snappy.c      |  432 ++++++++++++++++
 fs/btrfs/super.c       |    9 +-
 include/linux/snappy.h |   26 +
 lib/Kconfig            |    6 +
 lib/Makefile           |    4 +
 lib/snappy.c           | 1300 ++++++++++++++++++++++++++++++++++++++++++++++++
 16 files changed, 1901 insertions(+), 5 deletions(-)
 create mode 100644 crypto/snappy.c
 create mode 100644 fs/btrfs/snappy.c
 create mode 100644 include/linux/snappy.h
 create mode 100644 lib/snappy.c

-Andi

