Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752385AbeAZIav (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:51 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id D1B7949F19AF
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:44 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 00/15] btrfs-progs: fix filetype mismatch in check
Date: Fri, 26 Jan 2018 16:35:04 +0800
Message-ID: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset is based on Qu Wenruo's
"[PATCH v2 0/3] Lowmem fsck repair to fix filetype mismatch".
It can be fetched from my github:
https://github.com/Damenly/btrfs-progs/tree/mismatch_filetype

Above Qu's patchset fixes mismatched filetype already. But both
original and lowmem can't handle more complex cases like image in the
last of this patchset:
Both filetypes of dir_item/index are corrupted and inode item is
missing/mismatched.

This patch contains fixes of lowmem check and original check.
For lowmem:
Patch[1-5] fix the complex cases by this way:
  Check filetypes of couple (dir_item,dir_index) and inode mode.
  If two of three have same filetype, choose it as right filetype.
  Handle it in repair_dir_item().
  
Patch[6-9] fix minor bugs of lowmem repair.

Patch[10-12] fix minor bugs about error bit and return value of
	     original repair.
	     
Patch[13-14] fix the complex cases by another way:
  Since original mode store one filetype from dir_item/dir_index and
  inode mode, if backref has mismatched filetype, we think inode mode
  is trusted. If inode item is missing, get filetype from a normal
  couple (dir_item and dir_index);
  
Patch[15] provides a test image.

Su Yue (15):
  btrfs-progs: lowmem check: introduce repair_inode_item_mismatch()
  btrfs-progs: lowmem check: find and guess inode filetype
  btrfs-progs: lowmem check: find filetype in repair_inode_missing()
  btrfs-progs: lowmem check: repair complex cases in repair_dir_item()
  btrfs-progs: lowmem check: let check_dir_item() continue if find wrong
    inode_item
  btrfs-progs: lowmem check: let check_dir_item() return if repaired
  btrfs-progs: lowmem check: find_dir_item by di_key in check_dir_item()
  btrfs-progs: lowmem check: call get_dir_isize() after repair
  btrfs-progs: lowmem check: change logic of leaf process if repair
  btrfs-progs: check: clear I_ERR_FILE_EXTENT_DISCOUNT after repair
  btrfs-progs: check: modify indoe_rec and backref after repair
  btrfs-progs: check: increase counter error in check_inode_recs()
  btrfs-progs: check: find inode filetype in create_inode_item()
  btrfs-progs: check: handle mismatched filetype in repair_inode_backref
  btrfs-progs: fsck-tests: add image for original and lowmem check

 cmds-check.c                                       | 585 +++++++++++++++++++--
 .../default_case.img                               | Bin 0 -> 3072 bytes
 2 files changed, 528 insertions(+), 57 deletions(-)
 create mode 100644 tests/fsck-tests/029-mismatched-filetype-no-inode/default_case.img

-- 
2.16.1



