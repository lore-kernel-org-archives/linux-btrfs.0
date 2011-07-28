From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 0/4] xfstests: Add support for btrfs in a couple of xfstests
Date: Thu, 28 Jul 2011 10:27:57 +0200
Message-ID: <cover.1311776403.git.sbehrens@giantdisaster.de>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Added btrfs to the list of supported filesystems for tests 015, 062,
079, 083, 117, 120 and 192.
For test 079 to run, src/t_immutable.c was also modified (for ext2 and
btrfs filesystems).

Stefan Behrens (4):
  xfstests: Add support for btrfs in 062
  xfstests: Add support for btrfs in 083, 117, 120 and 192
  xfstests: Add support for btrfs in 015
  xfstests: Add support for btrfs in 079

 015               |   11 ++++++++---
 062               |    4 ++--
 062.out           |    6 ------
 079               |    4 ++--
 083               |   12 +++++++++---
 117               |    4 ++--
 120               |    4 ++--
 192               |    2 +-
 src/t_immutable.c |   23 +++++++++++++++--------
 9 files changed, 41 insertions(+), 29 deletions(-)

-- 
1.7.3.4

