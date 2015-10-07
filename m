Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:56356
	"EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbbJGMOP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 08:14:15 -0400
Received: from [223.231.216.195] (port=34333 helo=giis)
	by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:AES128-GCM-SHA256:128)
	(Exim 4.85)
	(envelope-from <Lakshmipathi.G@giis.co.in>)
	id 1ZjnUa-0002vc-9d
	for linux-btrfs@vger.kernel.org; Wed, 07 Oct 2015 05:06:45 -0700
Date: Wed, 7 Oct 2015 17:36:38 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: print root item's last_snapshot value.
Message-ID: <20151007120638.GA24461@giis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Include last_snapshot value in print_root(). With btrfs-debug-tree, it 
helps to identify whether its a snapshot-ed subvolume or not.

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 print-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index dc1d276..7ddf400 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -481,12 +481,13 @@ static void print_root(struct extent_buffer *leaf, int slot)
 	memset(&root_item, 0, sizeof(root_item));
 	read_extent_buffer(leaf, &root_item, (unsigned long)ri, len);
 
-	printf("\t\troot data bytenr %llu level %d dirid %llu refs %u gen %llu\n",
+	printf("\t\troot data bytenr %llu level %d dirid %llu refs %u gen %llu lastsnap %llu\n",
 		(unsigned long long)btrfs_root_bytenr(&root_item),
 		btrfs_root_level(&root_item),
 		(unsigned long long)btrfs_root_dirid(&root_item),
 		btrfs_root_refs(&root_item),
-		(unsigned long long)btrfs_root_generation(&root_item));
+		(unsigned long long)btrfs_root_generation(&root_item),
+		(unsigned long long)btrfs_root_last_snapshot(&root_item));
 
 	if (root_item.generation == root_item.generation_v2) {
 		uuid_unparse(root_item.uuid, uuid_str);
-- 
1.8.3.1

