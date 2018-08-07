Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726968AbeHGKcz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:32:55 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82B39ADB4
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:19:41 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 00/11] btrfs-progs: mkfs: Quota support through -Q|--quota
Date: Tue,  7 Aug 2018 16:19:27 +0800
Message-Id: <20180807081938.21348-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/mkfs_qgroup

Which is based on v4.17.1 tag.

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

   Currently we insert all qgroup items for all existing file trees.
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

changelog:
v2:
  Use new -R|--runtime quota option.
  Rebased to v4.16.
v3:
  Revert to -Q|--quota single option interface, since data reloc tree
  and uuid tree creation is already supported by mkfs.
  Rebased to v4.17.1.
  Add a new patch to cooperate with enhanced progress indicator.

Qu Wenruo (11):
  btrfs-progs: qgroup-verify: Avoid NULL pointer dereference for later
    silent qgroup repair
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
  btrfs-progs: mkfs: Introduce mkfs time quota support
  btrfs-progs: test/mkfs: Add test case for -Q|--quota option
  btrfs-progs: test/mkfs: Add test case for --rootdir and --quota

 Documentation/mkfs.btrfs.asciidoc             |   5 +
 check/main.c                                  |  20 +--
 ctree.c                                       | 109 ++++++++++++++
 ctree.h                                       |   3 +
 mkfs/main.c                                   | 136 +++++++++++++++++-
 qgroup-verify.c                               |  88 ++++++++----
 qgroup-verify.h                               |   4 +-
 tests/mkfs-tests/001-basic-profiles/test.sh   |  10 ++
 .../mkfs-tests/018-rootdir-with-quota/test.sh |  51 +++++++
 9 files changed, 389 insertions(+), 37 deletions(-)
 create mode 100755 tests/mkfs-tests/018-rootdir-with-quota/test.sh

-- 
2.18.0

