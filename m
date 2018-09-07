Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbeIGKzx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 06:55:53 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C7C91AE47
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 06:16:30 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3.1 0/2] btrfs: trim enhancement to allow btrfs really trim block groups
Date: Fri,  7 Sep 2018 14:16:22 +0800
Message-Id: <20180907061624.20604-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/trim_fix
Which is based on v4.19-rc1 tag.

This patchset introduces 2 enhancement, one to output better error
messages during trim, the other one is to ensure we could really trim
block groups if logical bytenr of block groups are beyond physical
device size.

These two patches are in the wild for a long time, and are pretty small
and the 2nd patch in facts fix a regression, and we already have test
case for it (btrfs/156).

Changelog:
v2:
  Only report total number of errors and first errno to make it less
  noisy.
  Change message level from warning to debug
v3:
  Rebase to v4.19-rc1.
  Change back message level from debug to warning since it's less noisy
  and will only report total failed bgs and devices.

v3.1
  Remove the "last error" output from first patch.

Qu Wenruo (2):
  btrfs: Enhance btrfs_trim_fs function to handle error better
  btrfs: Ensure btrfs_trim_fs can trim the whole fs

 fs/btrfs/extent-tree.c | 65 ++++++++++++++++++++++++++----------------
 fs/btrfs/ioctl.c       | 11 ++++---
 2 files changed, 47 insertions(+), 29 deletions(-)

-- 
2.18.0
