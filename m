Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:44969 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdJ0H3n (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 27 Oct 2017 03:29:43 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/8] mkfs: Quota support
Date: Fri, 27 Oct 2017 15:29:28 +0800
Message-Id: <20171027072936.4697-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
   b) quota info for 0/5 qgroup
   c) quota limit for 0/5 qgroup

   The content doesn't matter at all.

3) Repair qgroups using infrastructure from qgroup-verify
   In fact, qgroup repair is just offline rescan.
   Although the original qgroup-verify infrastructure is mostly noisy,
   modify it a little to make it silent to function as offline quota
   rescan.

And such support is mainly designed for developers and QA guys.

As to enable quota, we must normally mount the fs, enable quota (and
rescan if needed).
This ioctl based procedure is not common, and fstests doesn't provide
such support.

There are several attempts to make fstests to support it, but due to
different reasons, all these attempts failed.

To make it easier to test all existing test cases with btrfs quota
enabled, the current best method is to support quota at mkfs time, and
here comes the patchset.

Qu Wenruo (8):
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
  btrfs-progs: mkfs: Introduce option to enable quota at mkfs time
  btrfs-progs: test/mkfs: Add test case for --enable-quota option

 Documentation/mkfs.btrfs.asciidoc           |   3 +
 cmds-check.c                                |   2 +-
 ctree.c                                     | 109 ++++++++++++++++++++++
 ctree.h                                     |   3 +
 mkfs/main.c                                 | 136 +++++++++++++++++++++++++++-
 qgroup-verify.c                             |  51 ++++++++---
 qgroup-verify.h                             |   2 +-
 tests/mkfs-tests/001-basic-profiles/test.sh |  10 ++
 8 files changed, 302 insertions(+), 14 deletions(-)

-- 
2.14.3

