From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 0/5] btrfs: Add lzo compression support
Date: Mon, 25 Oct 2010 15:11:22 +0800
Message-ID: <4CC52D9A.3030709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Lzo is a much faster compression algorithm than gzib, so would allow
more users to enable transparent compression, and some users can
choose from compression ratio and compression speed.

Usage:

# mount -t btrfs -o compress[=<zlib,lzo>] dev /mnt
or
# mount -t btrfs -o compress-force[=<zlib,lzo>] dev /mnt

"-o compress" without argument is still allowed for compatability.

Performance:

The test copied a linux source tarball (~400M) from an ext4 partition
to the btrfs partition, and then extracted the tarball.

(time in second)
           lzo        zlib        nocompress
copy:      10.6       21.7        14.9
extract:   70.1       94.4        66.6

(data size in MB)
           lzo        zlib        nocompress
copy:      185.87     108.69      394.49
extract:   193.80     132.36      381.21

Other:

The defrag ioctl is also updated, so one can choose lzo or zlib when
turning on compression in defrag operation.

TODO:

- Update btrfs-progs accordingly.

---
 fs/btrfs/Makefile       |    2 +-
 fs/btrfs/btrfs_inode.h  |    2 +-
 fs/btrfs/compression.c  |  329 +++++++++++++++++++++++++++++++++++++-
 fs/btrfs/compression.h  |   72 ++++++--
 fs/btrfs/ctree.h        |   11 +-
 fs/btrfs/extent_io.c    |    5 +-
 fs/btrfs/extent_io.h    |   17 ++-
 fs/btrfs/extent_map.c   |    2 +
 fs/btrfs/extent_map.h   |    3 +-
 fs/btrfs/file.c         |    2 +
 fs/btrfs/inode.c        |   82 ++++++----
 fs/btrfs/ioctl.c        |   10 +-
 fs/btrfs/ioctl.h        |    9 +-
 fs/btrfs/lzo.c          |  409 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ordered-data.c |   18 ++-
 fs/btrfs/ordered-data.h |    8 +-
 fs/btrfs/super.c        |   47 +++++-
 fs/btrfs/zlib.c         |  361 +++++++----------------------------------
 18 files changed, 1013 insertions(+), 376 deletions(-)

