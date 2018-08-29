Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40472 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726209AbeH2JKm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 05:10:42 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33F20AD7D
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 05:15:36 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] btrfs: trim enhancement to allow btrfs really trim block groups
Date: Wed, 29 Aug 2018 13:15:30 +0800
Message-Id: <20180829051532.32005-1-wqu@suse.com>
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

Qu Wenruo (2):
  btrfs: Enhance btrfs_trim_fs function to handle error better
  btrfs: Ensure btrfs_trim_fs can trim the whole fs

 fs/btrfs/extent-tree.c | 67 ++++++++++++++++++++++++++----------------
 fs/btrfs/ioctl.c       | 11 ++++---
 2 files changed, 49 insertions(+), 29 deletions(-)

-- 
2.18.0
