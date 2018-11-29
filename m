Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869F7C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 09:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 113CF2081B
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 09:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 113CF2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbeK2Ug0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 15:36:26 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57797 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726008AbeK2UgZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 15:36:25 -0500
X-IronPort-AV: E=Sophos;i="5.56,293,1539619200"; 
   d="scan'208";a="48825111"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 29 Nov 2018 17:31:40 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 00ED44B734A5
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 17:31:39 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 29 Nov
 2018 17:31:45 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: skip file_extent generation check for free_space_inode in run_delalloc_nocow
Date:   Thu, 29 Nov 2018 17:31:32 +0800
Message-ID: <20181129093132.25147-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 00ED44B734A5.A19F0
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The btrfs/001 with inode_cache mount option will encounter the following
warning:

WARNING: CPU: 1 PID: 23700 at fs/btrfs/inode.c:956 cow_file_range.isra.19+0x32b/0x430 [btrfs]
CPU: 1 PID: 23700 Comm: btrfs Kdump: loaded Tainted: G        W  O      4.20.0-rc4-custom+ #30
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
RIP: 0010:cow_file_range.isra.19+0x32b/0x430 [btrfs]
Call Trace:
 ? free_extent_buffer+0x46/0x90 [btrfs]
 run_delalloc_nocow+0x455/0x900 [btrfs]
 btrfs_run_delalloc_range+0x1a7/0x360 [btrfs]
 writepage_delalloc+0xf9/0x150 [btrfs]
 __extent_writepage+0x125/0x3e0 [btrfs]
 extent_write_cache_pages+0x1b6/0x3e0 [btrfs]
 ? __wake_up_common_lock+0x63/0xc0
 extent_writepages+0x50/0x80 [btrfs]
 do_writepages+0x41/0xd0
 ? __filemap_fdatawrite_range+0x9e/0xf0
 __filemap_fdatawrite_range+0xbe/0xf0
 btrfs_fdatawrite_range+0x1b/0x50 [btrfs]
 __btrfs_write_out_cache+0x42c/0x480 [btrfs]
 btrfs_write_out_ino_cache+0x84/0xd0 [btrfs]
 btrfs_save_ino_cache+0x551/0x660 [btrfs]
 commit_fs_roots+0xc5/0x190 [btrfs]
 btrfs_commit_transaction+0x2bf/0x8d0 [btrfs]
 btrfs_mksubvol+0x48d/0x4d0 [btrfs]
 btrfs_ioctl_snap_create_transid+0x170/0x180 [btrfs]
 btrfs_ioctl_snap_create_v2+0x124/0x180 [btrfs]
 btrfs_ioctl+0x123f/0x3030 [btrfs]

The file extent generation of the free space inode is equal to the last
snapshot of the file root, so the inode will be passed to cow_file_rage.
But the inode was created and its extents were preallocated in
btrfs_save_ino_cache, there are no cow copies on disk.

The preallocated extents don't present on disk, and the
btrfs_cross_ref_exist will ignore the -ENOENT returned by
check_committed_ref, so we can directly write the inode to the disk.

Fixes: 78d4295b1eee ("btrfs: lift some btrfs_cross_ref_exist checks in nocow path")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d54bdef16d8d..9c5e9629eb6c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1369,7 +1369,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			 * Do the same check as in btrfs_cross_ref_exist but
 			 * without the unnecessary search.
 			 */
-			if (btrfs_file_extent_generation(leaf, fi) <=
+			if (!nolock &&
+			    btrfs_file_extent_generation(leaf, fi) <=
 			    btrfs_root_last_snapshot(&root->root_item))
 				goto out_check;
 			if (extent_type == BTRFS_FILE_EXTENT_REG && !force)
-- 
2.19.2



