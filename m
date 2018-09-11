Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23627 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726713AbeIKQ2G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:28:06 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B00804B6AE13
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 19:29:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH v2 0/4] undelete subvolume online version
Date: Tue, 11 Sep 2018 19:28:59 +0800
Message-ID: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will add the BTRFS_IOC_SUBVOL_UNDELETE ioctl for online
btrfs subvolume undelete.

And using the online_undelete version of btrfs-progs, user can recover
the subvolume given by <subvol_id> to the directory given by <dest>. The
optional parameter [-n <name>] can be used to set the name of the
recovered subvolume.

# btrfs subvolume undelete [-n <name>] <subvol_id> <dest>

btrfs online undelete version:
https://github.com/littleroad/linux.git undelete

btrfs-progs online undelete version:
https://github.com/littleroad/btrfs-progs.git online_undelete

Issue: #82

Lu Fengqi (4):
  btrfs: factor out btrfs_link_subvol from create_subvol
  btrfs: don't BUG_ON() in btrfs_link_subvol()
  btrfs: undelete: introduce btrfs_undelete_subvolume
  btrfs: undelete: Add BTRFS_IOCTL_SUBVOL_UNDELETE ioctl

 fs/btrfs/ioctl.c           | 247 +++++++++++++++++++++++++++++++++----
 include/uapi/linux/btrfs.h |   7 ++
 2 files changed, 231 insertions(+), 23 deletions(-)

-- 
2.18.0
