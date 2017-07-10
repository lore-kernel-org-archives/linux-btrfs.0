Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36652 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754764AbdGJV3e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 17:29:34 -0400
Received: by mail-pf0-f171.google.com with SMTP id q86so56010645pfl.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jul 2017 14:29:28 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: abuchbinder@google.com
Subject: [PATCH] btrfs-progs: Tighten integer types in print-tree.
Date: Mon, 10 Jul 2017 14:29:09 -0700
Message-Id: <20170710212909.31559-2-abuchbinder@google.com>
In-Reply-To: <20170710212909.31559-1-abuchbinder@google.com>
References: <20170710212909.31559-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are likely more places where the wrong size types are used, but
these tripped Clang's warnings because they eventually get passed to
printf.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 print-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index a0d3395..82d6572 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -197,7 +197,7 @@ static void qgroup_flags_to_str(u64 flags, char *ret)
 
 void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
-	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
+	u16 num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
 	u32 chunk_item_size = btrfs_chunk_item_size(num_stripes);
 	char chunk_flags_str[32] = {0};
@@ -336,7 +336,7 @@ static void print_file_extent_item(struct extent_buffer *eb,
 				   int slot,
 				   struct btrfs_file_extent_item *fi)
 {
-	int extent_type = btrfs_file_extent_type(eb, fi);
+	unsigned char extent_type = btrfs_file_extent_type(eb, fi);
 	char compress_str[16];
 
 	compress_type_to_str(btrfs_file_extent_compression(eb, fi),
-- 
2.13.2.725.g09c95d1e9-goog

