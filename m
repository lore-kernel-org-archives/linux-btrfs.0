Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbeEHGcB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 02:32:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 50D9CAF4B
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 06:32:00 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 00/12] mkfs: Quota support through -R|--runtime quota
Date: Tue,  8 May 2018 14:31:44 +0800
Message-Id: <20180508063156.24665-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/mkfs_qgroup

Which is based on v4.16 tag.

This patchset adds quota support, which means the result fs will have
quota enabled by default, and its accounting is already consistent, no
manually rescan or quota enable is needed.

The overall design of such support is:
1) Create needed tree
   Both btrfs_root and real root item and tree root leaf.
   For this, a new infrastructure, btrfs_create_tree(), is added for
   this.

2) Fill quota root with basic skeleton
   Only 3 items are really needed
   a) global quota status item
   b) quota info for specified qgroup
   c) quota limit for specified qgroup

   Currently only 0/5 qgroup is passed.
   If we're going to support extra subvolume at mkfs time, just pass the
   subvolume id into insert_qgroup_items().

   The content doesn't matter at all.

3) Repair qgroups using infrastructure from qgroup-verify
   In fact, qgroup repair is just offline rescan.
   Although the original qgroup-verify infrastructure is mostly noisy,
   modify it a little to make it silent to function as offline quota
   rescan.

And such support is mainly designed for developers and QA guys.

As to enable quota, before we must normally mount the fs, enable quota
(and rescan if needed).
This ioctl based procedure is not common, and fstests doesn't provide
such support.
(Not to mention sometimes rescan itself can be buggy)

There are several attempts to make fstests to support it, but due to
different reasons, all these attempts failed.

To make it easier to test all existing test cases with btrfs quota
enabled, the current best method is to support quota at mkfs time, and
here comes the patchset.


BTW with -R|--runtime-features, we have several possible target to add.
Not limited to such ioctl based operation, but also mount option based
ones.
Like space-cache-tree (space_cache=v2).

Qu Wenruo (12):
  btrfs-progs: qgroup-verify: Also repair qgroup status version
  btrfs-progs: qgroup-verify: Use fs_info->readonly to check if we
    should repair qgroups
  btrfs-progs: qgroup-verify: Move qgroup classification out of
    report_qgroups
  btrfs-progs: qgroup-verify: Allow repair_qgroups function to do silent
    repair
  btrfs-progs: ctree: Introduce function to create an empty tree
  btrfs-progs: mkfs: Introduce function to insert qgroup info and limit
    items
  btrfs-progs: mkfs: Introduce function to setup quota root and rescan
  btrfs-progs: fsfeatures: Introduce a new set of features,
    runtime_features
  btrfs-progs: mkfs: Introduce --runtime-features option
  btrfs-progs: mkfs: Introduce quota runtime feature
  btrfs-progs: test/mkfs: Add test case for -R quota option
  btrfs-progs: test/mkfs: Add test case for --rootdir and -R quota

 Documentation/mkfs.btrfs.asciidoc             |  23 +++
 check/main.c                                  |   2 +-
 convert/main.c                                |   4 +-
 ctree.c                                       | 109 ++++++++++
 ctree.h                                       |   3 +
 fsfeatures.c                                  | 131 +++++++++---
 fsfeatures.h                                  |  10 +-
 mkfs/main.c                                   | 186 ++++++++++++++++--
 qgroup-verify.c                               |  51 +++--
 qgroup-verify.h                               |   2 +-
 tests/mkfs-tests/001-basic-profiles/test.sh   |  10 +
 .../mkfs-tests/017-rootdir-with-quota/test.sh |  51 +++++
 12 files changed, 525 insertions(+), 57 deletions(-)
 create mode 100755 tests/mkfs-tests/017-rootdir-with-quota/test.sh

-- 
2.17.0

