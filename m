Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35970 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752620AbeFGGtj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 02:49:39 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id E7C5E4B41E79
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 14:49:34 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 0/3] btrfs-progs: check: verify symlinks with append/immutable flags
Date: Thu, 7 Jun 2018 14:55:39 +0800
Message-ID: <20180607065542.17273-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetch from my github:
https://github.com/Damenly/btrfs-progs/commits/odd_inode_flags
It's based on kdave/devel whose HEAD is:
commit 1c846faaf87fbb01e080c94098c02b1695ed86dd
Author: Nikolay Borisov <nborisov@suse.com>
Date:   Mon May 28 09:36:50 2018 +0300

	btrfs-progs: Remove fs_info argument from write_ctree_super
	
symlinks should never have append/immutable attributes.
This patchset enables btrfs check to verify such corruption.

PATCH[1] is for original mode.
PATCH[2] is for original mode.

PATCH[3] adds a test image.
For further use, the directory is called bad-inode-flags.

#issue 133

---
Changelog:
v3:
  Use S_ISLNK instead of BTRFS_FT_SYMLINK. Thanks Misono.
  Change the test image created by hand.
v2:
  Use "rec->errors |=" instead of "rec->errors =" in patch[1].
  Define new error bit of invalid inode flags in lowmem mode.
  Adjust print message in patch[2]. Thanks, Qu and Nikolay.
  Rename test directory from odd-inode-flags to bad-inode-flags.

Su Yue (3):
  btrfs-progs: check: check symlinks with append/immutable flags
  btrfs-progs: check: lowmem: check symlinks with append/immutable flags
  btrfs-progs: fsck-tests: add test case to check symlinks with bad
    flags

 check/main.c                                     |   7 +++++++
 check/mode-lowmem.c                              |  10 ++++++++++
 check/mode-lowmem.h                              |   1 +
 check/mode-original.h                            |   1 +
 .../034-bad-inode-flags/default_case.img         | Bin 0 -> 4096 bytes
 tests/fsck-tests/034-bad-inode-flags/test.sh     |  15 +++++++++++++++
 6 files changed, 34 insertions(+)
 create mode 100644 tests/fsck-tests/034-bad-inode-flags/default_case.img
 create mode 100755 tests/fsck-tests/034-bad-inode-flags/test.sh

-- 
2.17.1



