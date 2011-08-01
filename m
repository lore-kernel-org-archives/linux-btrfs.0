From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v3 0/2] xfstests: Changed a couple of tests to be generic
Date: Mon,  1 Aug 2011 12:31:18 +0200
Message-ID: <cover.1312193821.git.sbehrens@giantdisaster.de>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Changes v2->v3:
- Merged 3 patches into one.
- Less verbose subject lines.

Changes v1->v2:
- Instead of just adding btrfs to the list of supported filesystems,
  the 7 tests that are touched by this patch series are now executed
  for all filesystems (since the tests are generic ones).
- The changes in src/t_immutable.c are revised to make the setting
  of append-only and immutable flags generic instead of just adding
  code for btrfs.

This patch series changes the tests 015, 062, 079, 083, 117, 120 and
192 to be generic for all filesystems and to be executed for all
filesystems.
For test 079 to run, src/t_immutable.c was also modified to use the
new generic FS_IOC_SETFLAGS/FS_IOC_GETFLAGS ioctl() if they are
available.

Stefan Behrens (2):
  xfstests: make more tests generic
  xfstests: make t_immutable and 079 filesystem-agnostic

 015               |    5 ++-
 062               |    4 +-
 062.out           |    6 -----
 079               |   12 +++++++--
 083               |   12 +++++++--
 117               |    4 +-
 120               |    4 +-
 192               |    2 +-
 src/t_immutable.c |   66 +++++++++++++++++-----------------------------------
 9 files changed, 50 insertions(+), 65 deletions(-)

-- 
1.7.3.4

