Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43900 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932718AbeCNA5G (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 13 Mar 2018 20:57:06 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: convert/ext2: Remove check for ext2_ext_attr_entry->e_value_block
Date: Wed, 14 Mar 2018 08:56:57 +0800
Message-Id: <20180314005657.28471-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In latest e2fsprogs (1.44.0) definition of ext2_ext_attr_entry has
removed member e_value_block, as currently ext* doesn't support it set
anyway.

So remove such check so that we can pass compile.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Fast rolling distribution (Arch) catches this much faster.
---
 convert/source-ext2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index b1492c78693d..070126ec38ec 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -422,8 +422,7 @@ static int ext2_xattr_check_entry(struct ext2_ext_attr_entry *entry,
 {
 	size_t value_size = entry->e_value_size;
 
-	if (entry->e_value_block != 0 || value_size > size ||
-	    entry->e_value_offs + value_size > size)
+	if (value_size > size || entry->e_value_offs + value_size > size)
 		return -EIO;
 	return 0;
 }
-- 
2.16.2

