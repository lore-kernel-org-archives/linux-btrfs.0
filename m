From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v2 0/2] Balance management, kernel side
Date: Fri, 12 Nov 2010 00:36:28 +0000
Message-ID: <cover.1289522188.git.hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   These two patches give a degree of control over balance operations.
The first makes it possible to get an idea of how much work remains to
do, by tracking the number of block groups (chunks) that need to be
moved/rewritten. The second patch allows a running balance operation
to be cancelled when the current block group has been moved.

   Since the last version, I've added some more locking (assigning to
a u64 isn't atomic on non-64-bit architectures). I've not added the
sysfs bits, as I haven't had a chance to try out Goffredo's sysfs code
yet. I've also not implemented liubo's suggestion of tracking the
current block group ID (I'll take that discussion up with him
separately -- basically it's not a good fit with the "polling" method
required by this ioctl).

Hugo Mills (2):
  Balance progress monitoring.
  Cancel filesystem balance.

 fs/btrfs/ctree.h   |   10 ++++++++
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/ioctl.c   |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h   |    8 ++++++
 fs/btrfs/volumes.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 146 insertions(+), 2 deletions(-)

