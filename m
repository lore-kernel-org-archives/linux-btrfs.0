Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59460 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab2FNIQB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:01 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL][PATCH 00/10] bug-fixes and cleanups
Date: Thu, 14 Jun 2012 16:23:16 +0800
Message-Id: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Here are some bug-fixes and cleanups, you can pull it from

         git://github.com/liubogithub/btrfs-work.git for-chris


There are two patches for setflags/getflags, in which we did not set compress
flags properly.

And four patches focus on error handling side.

Besides, three trival cleanups and an update for MAINTAINERS are also included.

I've run through xfstests and everything looks good.


Liu Bo (9):
  Btrfs: remove unused FS_NOCOMP_FL check in setflags and getflags
  Btrfs: fix missing inherited flag in rename
  Btrfs: do not resize a seeding device
  Btrfs: avoid memory leak of extent state in error handling routine
  Btrfs: make sure that we've made everything in pinned tree clean
  Btrfs: fix typo in btrfs_finish_ordered_io
  Btrfs: fix typo in cow_file_range_async
  Btrfs: update MAINTAINERS info for BTRFS FILE SYSTEM
  Btrfs: use wrapper page_offset

Miao Xie (1):
  Btrfs: destroy the items of the delayed inodes in error handling
    routine

 MAINTAINERS              |    4 ++--
 fs/btrfs/delayed-inode.c |   18 ++++++++++++++++++
 fs/btrfs/delayed-inode.h |    3 +++
 fs/btrfs/disk-io.c       |   21 ++++++++++++++++++++-
 fs/btrfs/extent_io.c     |   20 ++++++++++----------
 fs/btrfs/inode.c         |   17 ++++++++++-------
 fs/btrfs/ioctl.c         |   24 +++++++++++-------------
 fs/btrfs/relocation.c    |    2 +-
 8 files changed, 75 insertions(+), 34 deletions(-)

