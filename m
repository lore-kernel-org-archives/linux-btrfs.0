Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:12121 "EHLO
	mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951AbbBNMKa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Feb 2015 07:10:30 -0500
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1 linux-next] btrfs: fix sizeof format specifier in btrfs_check_super_valid()
Date: Sat, 14 Feb 2015 13:10:22 +0100
Message-Id: <1423915822-23442-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes mips compilation warning:

fs/btrfs/disk-io.c: In function 'btrfs_check_super_valid':
fs/btrfs/disk-io.c:3927:21: warning: format '%lu' expects argument
of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f79f385..639f266 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3921,7 +3921,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	}
 	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
 			+ sizeof(struct btrfs_chunk)) {
-		printk(KERN_ERR "BTRFS: system chunk array too small %u < %lu\n",
+		printk(KERN_ERR "BTRFS: system chunk array too small %u < %zu\n",
 				btrfs_super_sys_array_size(sb),
 				sizeof(struct btrfs_disk_key)
 				+ sizeof(struct btrfs_chunk));
-- 
2.1.0

