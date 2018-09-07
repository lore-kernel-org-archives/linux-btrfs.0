Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbeIGPIJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 11:08:09 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B516AE06
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 10:27:50 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: qgroup: Prepare to deprecate unused features for btrfs_qgroup_inherit()
Date: Fri,  7 Sep 2018 18:27:42 +0800
Message-Id: <20180907102745.10387-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/qgroup_inherit_check
Which is based on v4.19-rc1 tag.

This patchset will firstly set btrfs_qgroup_inherit structure size limit
from PAGE_SIZE to fixed SZ_4K.
I understand this normally will cause compatibility problem, but
considering how minor this feature is and no sane guy should use it for
over 100 qgroups, it should be fine in real world.

The theoretical difference can be found in the commit message of the 1st
patch.

The 2nd patch introduce check function for btrfs_qgroup_inherit
structure and deprecates the following features:
1) flags
   No unsupported flags should sneak in.

2) num_qgroups limit
   It should not exceed the maximum size of btrfs_qgroup_inherit nor the
   size passed from btrfs_ioctl_vol_args_v2.

3) qgroupid
   No valid qgroupid should be 0/0.

The 3rd patch prepare to deprecate the following features:

1) flags
2) num_excl|ref_copies
3) btrfs_qgroup_inherit::lim

Details can be found in the 3rd patch.

changelog:
v2:
  Show more details in the 1st patch about the incompatibility for 64K
  page size arch.
  Don't deprecate unused features right now, only mark then deprecated
  and output warning message for now.
  Better split validation check and deprecation patches.

Qu Wenruo (3):
  btrfs: Set qgroup inherit size limit to SZ_4K instead of page size
  btrfs: qgroup: Validate btrfs_qgroup_inherit structure before passing
    it to qgroup
  btrfs: qgroup: Prepare to deprecate some btrfs_qgroup_inherit features

 fs/btrfs/ioctl.c           |  7 +++++-
 fs/btrfs/qgroup.c          | 44 ++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h          |  3 +++
 include/uapi/linux/btrfs.h | 17 +++++++--------
 4 files changed, 61 insertions(+), 10 deletions(-)

-- 
2.18.0
