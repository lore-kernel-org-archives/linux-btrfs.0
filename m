Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753824AbdEQPbV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 11:31:21 -0400
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60F6D23986
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 15:31:14 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: Fix restoring image from multi devices fs into single device
Date: Wed, 17 May 2017 02:41:21 +0100
Message-Id: <20170517014121.8499-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We correctly build an image from a multiple devices filesystem but when
restoring the image into a single device we were missing updating the
number of devices in the superblock to the value 1 (we already took care
of setting the number of stripes to 1 for each chunk item and setting
the device id for each chunk item to match the device id from the super
block).

This missing update of the number of devices makes it impossible to mount
the restored filesystem on recent kernels, more specifically since the
linux kernel commit 99e3ecfcb9f4ca35192d20a5bea158b81f600062
("Btrfs: add more validation checks for superblock"), that produce the
following message in the dmesg/syslog:

[21097.542047] BTRFS error (device sdi): super_num_devices 2 mismatch with num_devices 1 found here
[21097.543972] BTRFS error (device sdi): failed to read chunk tree: -22
[21097.720360] BTRFS error (device sdi): open_ctree failed

So fix this by updating the number of devices to 1 in the superblock.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 image/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/image/main.c b/image/main.c
index f1c28de1..1eca414b 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1500,6 +1500,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 	flags |= BTRFS_SUPER_FLAG_METADUMP_V2;
 	btrfs_set_super_flags(super, flags);
 	btrfs_set_super_sys_array_size(super, new_array_size);
+	btrfs_set_super_num_devices(super, 1);
 	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
 
 	return 0;
-- 
2.11.0

