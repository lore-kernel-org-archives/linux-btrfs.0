Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63684 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726159AbeHEMoZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2018 08:44:25 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 7BA244B41EE4
        for <linux-btrfs@vger.kernel.org>; Sun,  5 Aug 2018 18:40:08 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 0/4] undelete subvolume online version
Date: Sun, 5 Aug 2018 18:39:57 +0800
Message-ID: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will add the BTRFS_IOC_SUBVOL_UNDELETE ioctl for online
btrfs subvolume undelete.

And btrfs subvolume undelete subcommand was added to btrfs-progs.

So user can use the following command to recover all the subolume that
is left on the device. The recovered subvolume will be link to <dest> dir
named to <name_prefix><subvol_id>.

# btrfs subvolume undelete [-p <name_prefix>] <dest>

btrfs online undelete version:
https://github.com/littleroad/linux.git undelete

btrfs-progs online undelete version:
https://github.com/littleroad/btrfs-progs.git online_undelete

Issue: #82

Lu Fengqi (4):
  btrfs: factor out btrfs_link_subvol from create_subvol
  btrfs: don't BUG_ON() in btrfs_link_subvol()
  btrfs: undelete: introduce btrfs_undelete_subvolume
  btrfs: undelete: Add the btrfs_ioctl_undelete

 fs/btrfs/ioctl.c           | 270 +++++++++++++++++++++++++++++++++----
 include/uapi/linux/btrfs.h |   9 ++
 2 files changed, 255 insertions(+), 24 deletions(-)

-- 
2.18.0



