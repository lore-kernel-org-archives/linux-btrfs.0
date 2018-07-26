Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbeGZHy3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 03:54:29 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8914AD82
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:39:08 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: Fix qgroup false alerts on uninitialized rescan
Date: Thu, 26 Jul 2018 14:38:59 +0800
Message-Id: <20180726063901.1252-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patches can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/qgroup_report

It's possible that certain timed power loss could lead to initialized quota
tree without rescan kicked in.
Can be reproduced in btrfs/166 with low possibility.

In that case, since default flags for QUOTA_STATUS is ON|INCONSISTENT,
btrfs check will still check qgroups and report difference as error.

However rescan progress of QUOTA_STATUS is still 0, means qgroup rescan
hasn't been kicked in, and all quota numbers are 0, difference is
expected.

In this case, make btrfs check don't report such uninitialized rescan as
error.

Qu Wenruo (2):
  btrfs-progs: qgroup-verify: Don't treat qgroup difference as error if
    the fs hasn't initialized a rescan
  btrfs-progs: fsck-tests: Add test image to check if btrfs check
    reports uninitialized rescan as error

 qgroup-verify.c                                 |  14 +++++++++++++-
 .../no_rescan_kicked_in.img                     | Bin 0 -> 3072 bytes
 .../fsck-tests/035-rescan-not-kicked-in/test.sh |  16 ++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)
 create mode 100644 tests/fsck-tests/035-rescan-not-kicked-in/no_rescan_kicked_in.img
 create mode 100755 tests/fsck-tests/035-rescan-not-kicked-in/test.sh

-- 
2.18.0

