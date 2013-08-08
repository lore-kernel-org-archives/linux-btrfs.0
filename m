Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:50441 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933999Ab3HHIRU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 04:17:20 -0400
From: Jan Schmidt <list.xfs@jan-o-sch.net>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de
Subject: [PATCH v3 0/2] xfstest btrfs/316: test send / receive
Date: Thu,  8 Aug 2013 10:17:11 +0200
Message-Id: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two patches add the announced tests for btrfs send / receive. As
requested, the fssum tool is now included.

One drawback is that I'm unable to edit configure.ac or whatever needs
to be modified in an autotools preferred way. Any hints appreciated,
preferrably hints containing all the modifications required to introduce
something like HAVE_SEEK_HOLE.

I do not want to make modifications to fssum.c here, if that's
absolutely required (because one /could/ get along using linux/fs.h,
which is not the way I would like to go), I'd like to have that changed
in the far-progs repository where fssum.c comes from as well.

--
v1->v2:
 - included fssum
 - test number is now 316 (was 314)
v2->v3:
 - added missing -lcrypto to build fssum
 - removed obsolete change in README now that fssum is included
 - fixed comment in test/btrfs/316's header (314 -> 316)

Jan Schmidt (2):
  xfstests: add fssum tool
  xfstests btrfs/316: test send / receive

 .gitignore          |    1 +
 common/config       |    2 +
 src/Makefile        |   11 +-
 src/fssum.c         |  819 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/316     |  113 +++++++
 tests/btrfs/316.out |    4 +
 tests/btrfs/group   |    1 +
 7 files changed, 950 insertions(+), 1 deletions(-)
 create mode 100644 src/fssum.c
 create mode 100755 tests/btrfs/316
 create mode 100644 tests/btrfs/316.out

-- 
1.7.2.5

