Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752156AbbEKIJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:00 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87aFK028743
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 01/13] btrfs-progs: Add CHANGIND_FSID and CHANGING_CHUNK_TREE_ID super flags.
Date: Mon, 11 May 2015 16:08:42 +0800
Message-ID: <1431331734-11714-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add these super flags to info kernel not to mount such unfinished
fsid/chunk tree id changing.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced.
---
 ctree.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ctree.h b/ctree.h
index 10dc838..8dc70a5 100644
--- a/ctree.h
+++ b/ctree.h
@@ -307,6 +307,8 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 
 #define BTRFS_HEADER_FLAG_WRITTEN		(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC			(1ULL << 1)
+#define BTRFS_SUPER_FLAG_CHANGING_FSID		(1ULL << 30)
+#define BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID	(1ULL << 31)
 #define BTRFS_SUPER_FLAG_SEEDING		(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP		(1ULL << 33)
 #define BTRFS_SUPER_FLAG_METADUMP_V2		(1ULL << 34)
-- 
2.4.0

