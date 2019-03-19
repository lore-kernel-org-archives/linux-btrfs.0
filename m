Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4F8C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 17:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F20420863
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 17:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553015900;
	bh=dpGksxeumKySO2rVWrGSJv/grxJb5rqj2ON/NQL4xLI=;
	h=From:To:Subject:Date:List-ID:From;
	b=dMNbtsWWFk6T8SPJuk8p/04pVd8DGf0A6PHGwb/m1yQT5dE8QBczHpH5V73NpZN9y
	 uZwassh1iGZISDULI2z53a9n3XmAX5EvD1NmfcLIkVCJjIev7Qy+zAj9gI/iLQr83/
	 f5qAumBGuO4JIvf8iBrBaNjH0qpgdIiMu5O6kX0w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfCSRST (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 13:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfCSRST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 13:18:19 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F93420863
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 17:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553015898;
        bh=dpGksxeumKySO2rVWrGSJv/grxJb5rqj2ON/NQL4xLI=;
        h=From:To:Subject:Date:From;
        b=Fo8udTfqUPsAX2C66QtKNXq1rxXQfl+mloZzRkR4KTE9wTa1Zd0zteQ+y5/IrGL/W
         6DiZ6UF4yzQlZGrC/Vw9PeLJosl9gO+OXeBV/9uzl8QIbGGgel5mAcLr9t8933PiKl
         smJ/S2FBzeWYp1xNCRT6KXSApMkxdaZ/j52724v0=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix assertion failure on fsync with NO_HOLES enabled
Date:   Tue, 19 Mar 2019 17:18:13 +0000
Message-Id: <20190319171813.14176-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Back in commit a89ca6f24ffe4 ("Btrfs: fix fsync after truncate when
no_holes feature is enabled") I added an assertion that is triggered when
an inline extent is found to assert that the length of the (uncompressed)
data the extent represents is the same as the i_size of the inode, since
that is true most of the time I couldn't find or didn't remembered about
any exception at that time. Later on the assertion was expanded twice to
deal with a case of a compressed inline extent representing a range that
matches the sector size followed by an expanding truncate, and another
case where fallocate can update the i_size of the inode without adding
or updating existing extents (if the fallocate range falls entirely within
the first block of the file). These two expansion/fixes of the assertion
were done by commit 7ed586d0a8241 ("Btrfs: fix assertion on fsync of
regular file when using no-holes feature") and commit 6399fb5a0b69a
("Btrfs: fix assertion failure during fsync in no-holes mode").
These however missed the case where an falloc expands the i_size of an
inode to exactly the sector size and inline extent exists, for example:

 $ mkfs.btrfs -f -O no-holes /dev/sdc
 $ mount /dev/sdc /mnt

 $ xfs_io -f -c "pwrite -S 0xab 0 1096" /mnt/foobar
 wrote 1096/1096 bytes at offset 0
 1 KiB, 1 ops; 0.0002 sec (4.448 MiB/sec and 4255.3191 ops/sec)

 $ xfs_io -c "falloc 1096 3000" /mnt/foobar
 $ xfs_io -c "fsync" /mnt/foobar
 Segmentation fault

 $ dmesg
 [701253.602385] assertion failed: len == i_size || (len == fs_info->sectorsize && btrfs_file_extent_compression(leaf, extent) != BTRFS_COMPRESS_NONE) || (len < i_size && i_size < fs_info->sectorsize), file: fs/btrfs/tree-log.c, line: 4727
 [701253.602962] ------------[ cut here ]------------
 [701253.603224] kernel BUG at fs/btrfs/ctree.h:3533!
 [701253.603503] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
 [701253.603774] CPU: 2 PID: 7192 Comm: xfs_io Tainted: G        W         5.0.0-rc8-btrfs-next-45 #1
 [701253.604054] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
 [701253.604650] RIP: 0010:assfail.constprop.23+0x18/0x1a [btrfs]
 (...)
 [701253.605591] RSP: 0018:ffffbb48c186bc48 EFLAGS: 00010286
 [701253.605914] RAX: 00000000000000de RBX: ffff921d0a7afc08 RCX: 0000000000000000
 [701253.606244] RDX: 0000000000000000 RSI: ffff921d36b16868 RDI: ffff921d36b16868
 [701253.606580] RBP: ffffbb48c186bcf0 R08: 0000000000000000 R09: 0000000000000000
 [701253.606913] R10: 0000000000000003 R11: 0000000000000000 R12: ffff921d05d2de18
 [701253.607247] R13: ffff921d03b54000 R14: 0000000000000448 R15: ffff921d059ecf80
 [701253.607769] FS:  00007f14da906700(0000) GS:ffff921d36b00000(0000) knlGS:0000000000000000
 [701253.608163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [701253.608516] CR2: 000056087ea9f278 CR3: 00000002268e8001 CR4: 00000000003606e0
 [701253.608880] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [701253.609250] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [701253.609608] Call Trace:
 [701253.609994]  btrfs_log_inode+0xdfb/0xe40 [btrfs]
 [701253.610383]  btrfs_log_inode_parent+0x2be/0xa60 [btrfs]
 [701253.610770]  ? do_raw_spin_unlock+0x49/0xc0
 [701253.611150]  btrfs_log_dentry_safe+0x4a/0x70 [btrfs]
 [701253.611537]  btrfs_sync_file+0x3b2/0x440 [btrfs]
 [701253.612010]  ? do_sysinfo+0xb0/0xf0
 [701253.612552]  do_fsync+0x38/0x60
 [701253.612988]  __x64_sys_fsync+0x10/0x20
 [701253.613360]  do_syscall_64+0x60/0x1b0
 [701253.613733]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 [701253.614103] RIP: 0033:0x7f14da4e66d0
 (...)
 [701253.615250] RSP: 002b:00007fffa670fdb8 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
 [701253.615647] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f14da4e66d0
 [701253.616047] RDX: 000056087ea9c260 RSI: 000056087ea9c260 RDI: 0000000000000003
 [701253.616450] RBP: 0000000000000001 R08: 0000000000000020 R09: 0000000000000010
 [701253.616854] R10: 000000000000009b R11: 0000000000000246 R12: 000056087ea9c260
 [701253.617257] R13: 000056087ea9c240 R14: 0000000000000000 R15: 000056087ea9dd10
 (...)
 [701253.619941] ---[ end trace e088d74f132b6da5 ]---

Updating the assertion again to allow for this particular case would result
in a meaningless assertion, plus there is currently no risk of logging
content that would result in any corruption after a log replay if the size
of the data encoded in an inline extent is greater than the inode's i_size
(which is not currently possibe either with or without compression),
therefore just remove the assertion.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5256cddf3a43..2e617657f3e2 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4718,15 +4718,8 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 					struct btrfs_file_extent_item);
 
 		if (btrfs_file_extent_type(leaf, extent) ==
-		    BTRFS_FILE_EXTENT_INLINE) {
-			len = btrfs_file_extent_ram_bytes(leaf, extent);
-			ASSERT(len == i_size ||
-			       (len == fs_info->sectorsize &&
-				btrfs_file_extent_compression(leaf, extent) !=
-				BTRFS_COMPRESS_NONE) ||
-			       (len < i_size && i_size < fs_info->sectorsize));
+		    BTRFS_FILE_EXTENT_INLINE)
 			return 0;
-		}
 
 		len = btrfs_file_extent_num_bytes(leaf, extent);
 		/* Last extent goes beyond i_size, no need to log a hole. */
-- 
2.11.0

