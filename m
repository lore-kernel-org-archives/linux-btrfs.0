Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35023 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab3DKKcA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 06:32:00 -0400
Message-ID: <51669144.20107@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 18:32:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/2] do not open the extend inode reference at the beginning
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In most cases, we do not insert so many inode references, so it is
better that we don't set incompat flag -- EXTEND_IREF -- when we
make a fs. Otherwise we can not mount the fs on the old kernel
though there is no extend iref in fact.

And some users may not hope to inserting the extend inode reference
because of the incompatible problem. In this case, we introduce a
mount option named noextiref.

Note, if the extend inode reference function is enabled, we will
fail to mount a fs with this option because there might be some
extend irefs in the fs, we should not close this function.

This patchset is against:
[PATCH 1/2] Btrfs: fix unblocked autodefraggers when remount
[PATCH 2/2] Btrfs: use a lock to protect incompat/compat flag of the super block

Miao Xie (2):
  Btrfs: set the INCOMPAT_EXTENDED_IREF when the extended iref is inserted
  Btrfs: introduce noextiref mount option

 fs/btrfs/ctree.h      |  1 +
 fs/btrfs/disk-io.c    |  9 +++++++++
 fs/btrfs/inode-item.c | 20 ++++++++++----------
 fs/btrfs/super.c      | 41 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 60 insertions(+), 11 deletions(-)

-- 
1.8.0.1
