Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:56096 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703Ab3HMRYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 13:24:36 -0400
From: Jan Schmidt <list.xfs@jan-o-sch.net>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de,
        sandeen@sandeen.net
Subject: [PATCH v4 0/2] xfstest btrfs/316: test send / receive
Date: Tue, 13 Aug 2013 19:24:16 +0200
Message-Id: <1376414658-4563-1-git-send-email-list.xfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two patches add the announced tests for btrfs send / receive. As
requested, the fssum tool is now included.

--
v1->v2:
 - included fssum
 - test number is now 316 (was 314)
v2->v3:
 - added missing -lcrypto to build fssum
 - removed obsolete change in README now that fssum is included
 - fixed comment in test/btrfs/316's header (314 -> 316)
v3->v4:
 - build fssum with help of autotools only if libssl is available
 - removed clumsy OPT_TARGETS in src/Makefile
 - added #define directives for SEEK_DATA and SEEK_HOLE to fssum.c

Jan Schmidt (2):
  xfstests: add fssum tool
  xfstests btrfs/316: test send / receive

 .gitignore           |    1 +
 aclocal.m4           |    1 +
 configure.ac         |    1 +
 include/builddefs.in |    1 +
 m4/Makefile          |    1 +
 m4/package_ssldev.m4 |    4 +
 src/Makefile         |    8 +
 src/fssum.c          |  828 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/316      |  116 +++++++
 tests/btrfs/316.out  |    4 +
 tests/btrfs/group    |    1 +
 11 files changed, 966 insertions(+), 0 deletions(-)
 create mode 100644 m4/package_ssldev.m4
 create mode 100644 src/fssum.c
 create mode 100755 tests/btrfs/316
 create mode 100644 tests/btrfs/316.out

-- 
1.7.2.5

