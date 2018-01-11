Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753625AbeAKFJ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:09:57 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E9425486A78B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:48 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 00/67] btrfs-progs: add the stack prefix for the set/get
Date: Thu, 11 Jan 2018 13:08:32 +0800
Message-ID: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These set/get functions defined by BTRFS_SETGET_STACK_FUNCS macro is
missing the prefix stack. I can't add an extent buffer version set/get
function as the result of the function name conflict.

To settle a matter once and for all, I have written a script to rename
these functions. And, I will attach this script generated this patchset to
make review easier. At the beginning I forget renaming these functions will
bring on a ton of warning like "WARNING: line over 80 characters".
Consequently, you know I have to split those lines manually. This step is
too boring and stupid.

I'm not sure how to split this patchset appropriately. If this bunch of
patches is annoying, I'm OK with squashing these patches. At last, If this
btrfs-progs version patchset is acceptable, I can send the kernel version
as well.

#!/bin/bash
funcs=$(grep -oP '(?<=^BTRFS_SETGET_STACK_FUNCS\()(?!stack)\w+(?=,)' ctree.h)

for func in ${funcs}; do
	echo $func
	files=$(grep -PIRwl 'btrfs_(set_)?'${func})
	sed -i 's/'"\(btrfs_\(set_\)\?\)\(${func}(\)"'/\1stack_\3/g' ${files}
	sed -i 's/'"^\(BTRFS_SETGET_STACK_FUNCS(\)\(${func},\)"'/\1stack_\2/g' ctree.h
	if ! make; then
		break;
	fi
	git commit -as -F <(cat <<EOF
btrfs-progs: add the stack prefix for ${func} set/get function

The ${func} set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.
EOF
)
done

Lu Fengqi (67):
  btrfs-progs: add the stack prefix for block_group_used set/get
    function
  btrfs-progs: add the stack prefix for block_group_chunk_objectid
    set/get function
  btrfs-progs: add the stack prefix for block_group_flags set/get
    function
  btrfs-progs: add the stack prefix for disk_key_objectid set/get
    function
  btrfs-progs: add the stack prefix for disk_key_offset set/get function
  btrfs-progs: add the stack prefix for disk_key_type set/get function
  btrfs-progs: add the stack prefix for root_generation set/get function
  btrfs-progs: add the stack prefix for root_bytenr set/get function
  btrfs-progs: add the stack prefix for root_level set/get function
  btrfs-progs: add the stack prefix for root_dirid set/get function
  btrfs-progs: add the stack prefix for root_refs set/get function
  btrfs-progs: add the stack prefix for root_flags set/get function
  btrfs-progs: add the stack prefix for root_used set/get function
  btrfs-progs: add the stack prefix for root_limit set/get function
  btrfs-progs: add the stack prefix for root_last_snapshot set/get
    function
  btrfs-progs: add the stack prefix for root_generation_v2 set/get
    function
  btrfs-progs: add the stack prefix for root_ctransid set/get function
  btrfs-progs: add the stack prefix for root_otransid set/get function
  btrfs-progs: add the stack prefix for root_stransid set/get function
  btrfs-progs: add the stack prefix for root_rtransid set/get function
  btrfs-progs: add the stack prefix for backup_tree_root set/get
    function
  btrfs-progs: add the stack prefix for backup_tree_root_gen set/get
    function
  btrfs-progs: add the stack prefix for backup_tree_root_level set/get
    function
  btrfs-progs: add the stack prefix for backup_chunk_root set/get
    function
  btrfs-progs: add the stack prefix for backup_chunk_root_gen set/get
    function
  btrfs-progs: add the stack prefix for backup_chunk_root_level set/get
    function
  btrfs-progs: add the stack prefix for backup_extent_root set/get
    function
  btrfs-progs: add the stack prefix for backup_extent_root_gen set/get
    function
  btrfs-progs: add the stack prefix for backup_extent_root_level set/get
    function
  btrfs-progs: add the stack prefix for backup_fs_root set/get function
  btrfs-progs: add the stack prefix for backup_fs_root_gen set/get
    function
  btrfs-progs: add the stack prefix for backup_fs_root_level set/get
    function
  btrfs-progs: add the stack prefix for backup_dev_root set/get function
  btrfs-progs: add the stack prefix for backup_dev_root_gen set/get
    function
  btrfs-progs: add the stack prefix for backup_dev_root_level set/get
    function
  btrfs-progs: add the stack prefix for backup_csum_root set/get
    function
  btrfs-progs: add the stack prefix for backup_csum_root_gen set/get
    function
  btrfs-progs: add the stack prefix for backup_csum_root_level set/get
    function
  btrfs-progs: add the stack prefix for backup_total_bytes set/get
    function
  btrfs-progs: add the stack prefix for backup_bytes_used set/get
    function
  btrfs-progs: add the stack prefix for backup_num_devices set/get
    function
  btrfs-progs: add the stack prefix for super_bytenr set/get function
  btrfs-progs: add the stack prefix for super_flags set/get function
  btrfs-progs: add the stack prefix for super_generation set/get
    function
  btrfs-progs: add the stack prefix for super_root set/get function
  btrfs-progs: add the stack prefix for super_sys_array_size set/get
    function
  btrfs-progs: add the stack prefix for super_chunk_root_generation
    set/get function
  btrfs-progs: add the stack prefix for super_root_level set/get
    function
  btrfs-progs: add the stack prefix for super_chunk_root set/get
    function
  btrfs-progs: add the stack prefix for super_chunk_root_level set/get
    function
  btrfs-progs: add the stack prefix for super_log_root set/get function
  btrfs-progs: add the stack prefix for super_log_root_transid set/get
    function
  btrfs-progs: add the stack prefix for super_log_root_level set/get
    function
  btrfs-progs: add the stack prefix for super_total_bytes set/get
    function
  btrfs-progs: add the stack prefix for super_bytes_used set/get
    function
  btrfs-progs: add the stack prefix for super_sectorsize set/get
    function
  btrfs-progs: add the stack prefix for super_nodesize set/get function
  btrfs-progs: add the stack prefix for super_stripesize set/get
    function
  btrfs-progs: add the stack prefix for super_root_dir set/get function
  btrfs-progs: add the stack prefix for super_num_devices set/get
    function
  btrfs-progs: add the stack prefix for super_compat_flags set/get
    function
  btrfs-progs: add the stack prefix for super_compat_ro_flags set/get
    function
  btrfs-progs: add the stack prefix for super_incompat_flags set/get
    function
  btrfs-progs: add the stack prefix for super_csum_type set/get function
  btrfs-progs: add the stack prefix for super_cache_generation set/get
    function
  btrfs-progs: add the stack prefix for super_uuid_tree_generation
    set/get function
  btrfs-progs: add the stack prefix for super_magic set/get function

 backref.c                 |   2 +-
 btrfs-find-root.c         |  14 ++--
 btrfs-fragments.c         |   4 +-
 btrfs-list.c              |  10 +--
 btrfs-zero-log.c          |   8 +--
 btrfstune.c               |  18 ++---
 chunk-recover.c           |  37 ++++++-----
 cmds-check.c              | 111 ++++++++++++++++---------------
 cmds-inspect-dump-super.c | 105 ++++++++++++++---------------
 cmds-inspect-dump-tree.c  |  37 ++++++-----
 cmds-rescue.c             |   8 +--
 cmds-restore.c            |   9 +--
 convert/common.c          |  98 +++++++++++++--------------
 convert/main.c            |  20 +++---
 ctree.c                   |  12 ++--
 ctree.h                   | 150 ++++++++++++++++++++++-------------------
 dir-test.c                |   6 +-
 disk-io.c                 | 166 ++++++++++++++++++++++++----------------------
 extent-tree.c             |  49 +++++++-------
 find-root.c               |   2 +-
 free-space-cache.c        |   4 +-
 free-space-tree.c         |   4 +-
 image/main.c              |  39 +++++------
 inode.c                   |   2 +-
 mkfs/common.c             |  83 ++++++++++++-----------
 mkfs/main.c               |  17 ++---
 print-tree.c              |  46 ++++++-------
 qgroup-verify.c           |   2 +-
 random-test.c             |   4 +-
 root-tree.c               |   6 +-
 send-utils.c              |  23 ++++---
 super-recover.c           |   4 +-
 transaction.c             |  10 +--
 utils.c                   |  20 +++---
 volumes.c                 |  39 ++++++-----
 35 files changed, 610 insertions(+), 559 deletions(-)

-- 
2.15.1



