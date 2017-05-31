Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58416 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750778AbdEaF40 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 01:56:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 0/6] Lowmem mode check check fix for mulit-device
Date: Wed, 31 May 2017 13:56:04 +0800
Message-ID: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will fix a false alert in lowmem mode, which doesn't handle
RAID0/5/6/10 chunk well. (the 5th patch)

Along the lowmem fix, also enhance and cleanup some chunk verification code,
as lowmem mode and original mode are using different chunk verification.
(the 1st~4th patch)

Finally, cleanup the loop device setup and move it to test/common other
than handling in each test case. (the 6th patch)

changelog:
v2:
  Fix a bug that single chunk is always treated as invalid, since its
  profile is not power of 2.
  Add the 6th patch to move the loop device setup to test/common.

Qu Wenruo (6):
  btrfs-progs: Cleanup open-coded btrfs_chunk_item_size
  btrfs-progs: Enhance chunk item validation check
  btrfs-progs: check: Reuse btrfs_check_chunk_valid in lowmem mode
  btrfs-progs: Introduce function to get correct stripe length
  btrfs-progs: lowmem check: Fix false alert on missing chunk or dev
    extent
  btrfs-progs: test: Introduce functions to prepare and cleanup loop
    device

 cmds-check.c                                       | 35 +++++------
 tests/common                                       | 38 ++++++++++++
 .../misc-tests/006-image-on-missing-device/test.sh | 12 +---
 tests/misc-tests/011-delete-missing-device/test.sh | 12 +---
 tests/mkfs-tests/001-basic-profiles/test.sh        | 12 +---
 .../005-long-device-name-for-ssd/test.sh           | 10 +---
 tests/mkfs-tests/006-partitioned-loopdev/test.sh   | 10 +---
 volumes.c                                          | 70 ++++++++++++++++++++--
 volumes.h                                          |  3 +
 9 files changed, 136 insertions(+), 66 deletions(-)

-- 
2.13.0



