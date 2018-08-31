Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeHaGew (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 02:34:52 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E1C3B05B
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 02:29:43 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: qgroup: Deprecate unused features for btrfs_qgroup_inherit()
Date: Fri, 31 Aug 2018 10:29:27 +0800
Message-Id: <20180831022930.3465-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/qgroup_inherit_check
Which is based on v4.19-rc1 tag.

This patchset will first set btrfs_qgroup_inherit structure size limit
from PAGE_SIZE to fixed SZ_4K.
I understand this normally will cause compatibility problem, but
considering how minor this feature is and no sane guy should use it for
over 100 qgroups, it should be fine in real world.

The 2nd patch introduce check function for btrfs_qgroup_inherit
structure and deprecates the following features:
1) limit set
   Never utilized by btrfs-progs from the beginning.

2) copy rfer/excl
   Although btrfs-progs provides support for it as a hidden,
   undocumented feature, it's the easiest way to screw up qgroup
   numbers.
   And we already have patches wondering around the ML to remove such
   support.

The last one will just cleanup the code for unsupported features.

Qu Wenruo (3):
  btrfs: Set qgroup inherit size limit to SZ_4K instead of page size
  btrfs: qgroup: Validate btrfs_qgroup_inherit structure before passing
    it to qgroup
  btrfs: qgroup: Remove deprecated feature support in
    btrfs_qgorup_inhert()

 fs/btrfs/ioctl.c           |  5 +-
 fs/btrfs/qgroup.c          | 96 ++++++++++++++++----------------------
 fs/btrfs/qgroup.h          |  2 +
 include/uapi/linux/btrfs.h | 18 +++----
 4 files changed, 55 insertions(+), 66 deletions(-)

-- 
2.18.0
