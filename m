Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay119.isp.belgacom.be ([195.238.20.146]:27017 "EHLO
	mailrelay119.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbbDYIDP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Apr 2015 04:03:15 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] Btrfs: avoid using NULL compressed_pages in  insert_inline_extent()
Date: Sat, 25 Apr 2015 10:02:54 +0200
Message-Id: <1429948974-24767-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

insert_inline_extent() checked for compressed_pages to be NULL then
it accessed it under compress_type != BTRFS_COMPRESS_NONE.
This patch adds a BUG() when compress_size != 0, compress_type !=
BTRFS_COMPRESS_NONE and compressed_pages == 0.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ada4d24..449653d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -150,8 +150,12 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
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

