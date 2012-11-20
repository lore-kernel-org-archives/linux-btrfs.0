Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40222 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2KTJRO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Nov 2012 04:17:14 -0500
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>
Subject: [PATCH 0/4][RFC] remove duplicated check from ext4, xfs, btrfs, and ocfs2
Date: Tue, 20 Nov 2012 17:29:41 +0800
Message-Id: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This patch series tries to remove a sanity check in fallocate from specific
filesystems because vfs has already checked it.

I am not very familiar with why we need to do this duplicated check.  Please let
me know if I miss something.

Regards,
						- Zheng

---
Zheng Liu(4):
      ext4: remove dupoicated check from ext4_fallocate
      xfs: remove duplicated check from xfs_file_fallocate
      btrfs: remove duplicated check from btrfs_fallocate
      ocfs2: remove duplicated check from ocfs2_fallocate

 fs/btrfs/file.c   | 4 ----
 fs/ext4/extents.c | 4 ----
 fs/ocfs2/file.c   | 2 --
 fs/xfs/xfs_file.c | 3 ---
 4 files changed, 13 deletions(-)
