Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:29520 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935552AbeE3Ewk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 00:52:40 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E808FAC017C
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 13:52:31 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 123B046E7A0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 13:52:31 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: ins: dump-tree: Use %lld for extent data backref offset
Date: Wed, 30 May 2018 13:55:19 +0900
Message-ID: <7f63f4b1c4c08652ad9bb77ff95b26597e92ded7.1527655420.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1527655420.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1527655420.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Offset of extent data backref in extent item can be negative.
So, let's use %lld insteand of %llu to output readable value.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 print-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index a1a7954a..90173c2b 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -480,10 +480,10 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
 			printf("\t\textent data backref root %llu "
-			       "objectid %llu offset %llu count %u\n",
+			       "objectid %llu offset %lld count %u\n",
 			       (unsigned long long)btrfs_extent_data_ref_root(eb, dref),
 			       (unsigned long long)btrfs_extent_data_ref_objectid(eb, dref),
-			       (unsigned long long)btrfs_extent_data_ref_offset(eb, dref),
+			       btrfs_extent_data_ref_offset(eb, dref),
 			       btrfs_extent_data_ref_count(eb, dref));
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY:
-- 
2.14.3


