From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v2 0/3] Balance management, userspace side
Date: Fri, 12 Nov 2010 00:23:53 +0000
Message-ID: <cover.1289521433.git.hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   These three patches complement the previous two kernel-side
patches. The first implements a way of displaying the current progress
of any running balance process. The second adds a "monitor" mode,
which watches the progress and makes an estimate of the completion
time. The third and final patch allows a running balance to be
cancelled.

Hugo Mills (3):
  Balance progress monitoring.
  Add --monitor option to btrfs balance progress.
  User-space tool for cancelling balance operations.

 btrfs.c        |   12 ++++
 btrfs_cmds.c   |  187 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h   |    2 +
 ioctl.h        |    8 +++
 man/btrfs.8.in |    7 ++
 5 files changed, 216 insertions(+), 0 deletions(-)

