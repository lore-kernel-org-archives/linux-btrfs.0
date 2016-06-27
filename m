Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbcF0UOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 16:14:17 -0400
From: jeffm@suse.com
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 0/4] btrfs feature testing + props fix
Date: Mon, 27 Jun 2016 16:14:10 -0400
Message-Id: <1467058454-25907-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Hi all -

Thanks, Eryu, for the review.  The btrfs feature testing changes were a
patchet I wrote three years ago, and it looks like significant cleanup
has happened in the xfstests since then.  I'm sorry for the level of the
review you had to do for them, but do appreciate that you did.

This version should fix the outstanding issues, including some issues
with the tests themselves, where e.g. the 32MB reserved size was file
system-size (and implementation) dependent.  Most notably, since these
tests share some common functionality that ultimately hit ~250 lines, I
chose to create a new common/btrfs library.  Other than that, I tried to
meet the level of consistency you were looking for with just printing
errors instead of failing, not depending on error codes, etc.

Thanks,

-Jeff

---

Jeff Mahoney (4):
  btrfs/048: extend _filter_btrfs_prop_error to handle additional errors
  btrfs/124: test global metadata reservation reporting
  btrfs/125: test sysfs exports of allocation and device membership info
  btrfs/126,127,128: test feature ioctl and sysfs interfaces

 .gitignore               |   1 +
 common/btrfs             | 253 +++++++++++++++++++++++++++++++++++++++++++++++
 common/config            |   7 +-
 common/filter.btrfs      |  10 +-
 src/Makefile             |   3 +-
 src/btrfs_ioctl_helper.c | 220 +++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/048          |   6 +-
 tests/btrfs/048.out      |   4 +-
 tests/btrfs/124          |  84 ++++++++++++++++
 tests/btrfs/124.out      |   1 +
 tests/btrfs/125          | 177 +++++++++++++++++++++++++++++++++
 tests/btrfs/125.out      |   1 +
 tests/btrfs/126          | 244 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/126.out      |   1 +
 tests/btrfs/127          | 166 +++++++++++++++++++++++++++++++
 tests/btrfs/127.out      |   1 +
 tests/btrfs/128          | 128 ++++++++++++++++++++++++
 tests/btrfs/128.out      |   1 +
 tests/btrfs/group        |   5 +
 19 files changed, 1302 insertions(+), 11 deletions(-)
 create mode 100644 common/btrfs
 create mode 100644 src/btrfs_ioctl_helper.c
 create mode 100755 tests/btrfs/124
 create mode 100644 tests/btrfs/124.out
 create mode 100755 tests/btrfs/125
 create mode 100644 tests/btrfs/125.out
 create mode 100755 tests/btrfs/126
 create mode 100644 tests/btrfs/126.out
 create mode 100755 tests/btrfs/127
 create mode 100644 tests/btrfs/127.out
 create mode 100755 tests/btrfs/128
 create mode 100644 tests/btrfs/128.out

-- 
1.8.5.6

