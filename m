Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46911 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750749AbdKFGuG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 01:50:06 -0500
From: Benjamin Peterson <bp@benjamin.pe>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: docs: correct grammar
Date: Sun,  5 Nov 2017 22:49:57 -0800
Message-Id: <20171106064957.27125-1-bp@benjamin.pe>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Benjamin Peterson <bp@benjamin.pe>
---
 Documentation/mkfs.btrfs.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index d53d9e26..62f5a5be 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -79,7 +79,7 @@ default value is 16KiB (16384) or the page size, whichever is bigger. Must be a
 multiple of the sectorsize and a power of 2, but not larger than 64KiB (65536).
 Leafsize always equals nodesize and the options are aliases.
 +
-Smaller node size increases fragmentation but lead to higher b-trees which in
+Smaller node size increases fragmentation but leads to higher b-trees which in
 turn leads to lower locking contention. Higher node sizes give better packing
 and less fragmentation at the cost of more expensive memory operations while
 updating the metadata blocks.
-- 
2.14.1

