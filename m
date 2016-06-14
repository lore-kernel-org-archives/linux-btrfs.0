Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38588 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbcFNVcR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 17:32:17 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH] Btrfs: let super_stripesize match with sectorsize
Date: Tue, 14 Jun 2016 14:33:43 -0700
Message-Id: <1465940023-27773-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Right now stripesize is set to 4096 while sectorsize is set to
max(4096, pagesize).  However, kernel requires super_stripesize
to match with sectorsize.

Reported-by: Eryu Guan <guaneryu@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 mkfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mkfs.c b/mkfs.c
index a3a3c14..8d00766 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1482,6 +1482,8 @@ int main(int argc, char **argv)
 	}
 
 	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
+	stripesize = sectorsize;
+
 	saved_optind = optind;
 	dev_cnt = argc - optind;
 	if (dev_cnt == 0)
-- 
2.5.0

