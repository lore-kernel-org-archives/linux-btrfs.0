Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay107.isp.belgacom.be ([195.238.20.134]:39592 "EHLO
	mailrelay107.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbbC3U2r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 16:28:47 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [RFC 1/1 linux-next] Btrfs: avoid using NULL compressed_pages in  insert_inline_extent()
Date: Mon, 30 Mar 2015 22:28:40 +0200
Message-Id: <1427747320-18667-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

insert_inline_extent() checked for compressed_pages to be NULL then
it accessed it under compress_type != BTRFS_COMPRESS_NONE.
This patch adds BUG() when compress_size != 0, compress_type !=
BTRFS_COMPRESS_NONE and compresses_pages == 0.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 686331f..95e0c29 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -149,8 +149,12 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 	size_t cur_size = size;
 	unsigned long offset;
 
-	if (compressed_size && compressed_pages)
-		cur_size = compressed_size;
+	if (compressed_size) {
+		if (compressed_pages)
+			cur_size = compressed_size;
+		else if (compress_type != BTRFS_COMPRESS_NONE)
+			BUG();
+	}
 
 	inode_add_bytes(inode, size);
 
-- 
1.9.1

