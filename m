From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH v2 0/5] Add user-space support for read-only snapshot creation.
Date: Tue, 26 Apr 2011 10:02:39 +0200
Message-ID: <1303804964-2840-1-git-send-email-philipp.andreas@gmail.com>
References: <There is kernel side support for the creation of read-only snapshots>
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	chris.mason@oracle.com, dcrmorgado@gmail.com, kreijack@libero.it,
	lizf@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <There is kernel side support for the creation of read-only snapshots>
List-ID: <linux-btrfs.vger.kernel.org>

Changelog v2:
  - Fixed uninitialized variable (args).
  - Corrected order of patches to make everything compile.
  - Fixed some style errors.

There is kernel side support for the creation of read-only snapshots
for some time now, but I did not find any patches for the userspace
btrfs utilites. Thus I created this patchset which is tested and
working with kernel version 2.6.39-rc2.

Andreas Philipp (5):
  Added support for an additional ioctl.
  Add support for read-only subvolumes.
  Support the new parameters in do_clone(int argc, char** argv).
  Test the additional ioctl.
  Updated manpage for btrfs subvolume snapshot.

 btrfs.c        |    6 +++---
 btrfs_cmds.c   |   48 ++++++++++++++++++++++++++++++++++++++++--------
 ioctl-test.c   |    1 +
 ioctl.h        |   14 ++++++++++++++
 man/btrfs.8.in |   11 ++++++-----
 5 files changed, 64 insertions(+), 16 deletions(-)

-- 
1.7.4.1

