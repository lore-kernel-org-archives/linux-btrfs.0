From: Arne Jansen <sensille@gmx.net>
Subject: [GIT PULL] scrub updates for 3.1
Date: Tue, 05 Jul 2011 15:00:07 +0200
Message-ID: <4E130AD7.2010300@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

since rc-6 seems to be the last rc for 3.0 and in case you're already
preparing your pull request for 3.1, can you please pull the following
updates for scrub, based on your for-linus tree (2f7e33d432)?

git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
for-chris

It just contains the readahead patch, which gives a significant
performance improvement for scrub. Currently scrub is the only
consumer.

Thanks,
Arne

Arne Jansen (7):
      btrfs: add an extra wait mode to read_extent_buffer_pages
      btrfs: add READAHEAD extent buffer flag
      btrfs: state information for readahead
      btrfs: initial readahead code and prototypes
      btrfs: hooks for readahead
      btrfs: test ioctl for readahead
      btrfs: use readahead API for scrub

 fs/btrfs/Makefile    |    3 +-
 fs/btrfs/ctree.h     |   21 ++
 fs/btrfs/disk-io.c   |   85 +++++-
 fs/btrfs/disk-io.h   |    2 +
 fs/btrfs/extent_io.c |    9 +-
 fs/btrfs/extent_io.h |    4 +
 fs/btrfs/ioctl.c     |   93 +++++-
 fs/btrfs/ioctl.h     |   16 +
 fs/btrfs/reada.c     |  949
++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/scrub.c     |  116 +++----
 fs/btrfs/volumes.c   |    8 +
 fs/btrfs/volumes.h   |    8 +
 12 files changed, 1239 insertions(+), 75 deletions(-)
 create mode 100644 fs/btrfs/reada.c
