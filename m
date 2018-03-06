Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:52368 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752460AbeCFCRF (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 5 Mar 2018 21:17:05 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: dump-super: Don't verify csum if csum type or size is unknown
Date: Tue,  6 Mar 2018 10:16:51 +0800
Message-Id: <20180306021651.9364-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reported-by: Ken Swenson <flat@imo.uto.moe>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-inspect-dump-super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 150c2e5aedf4..85bff262ad85 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -339,7 +339,9 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("csum\t\t\t0x");
 	for (i = 0, p = sb->csum; i < csum_size; i++)
 		printf("%02x", p[i]);
-	if (check_csum_sblock(sb, csum_size))
+	if (csum_type != BTRFS_CSUM_TYPE_CRC32 || csum_size != BTRFS_CRC32_SIZE)
+		printf(" [UNKNOWN CSUM TYPE OR SIZE]");
+	else if (check_csum_sblock(sb, csum_size))
 		printf(" [match]");
 	else
 		printf(" [DON'T MATCH]");
-- 
2.16.2

