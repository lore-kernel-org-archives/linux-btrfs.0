Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbcECQMy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 12:12:54 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 13A91AB9D
	for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2016 16:12:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs-progs: kerncompat: introduce get_unaligned helpers
Date: Tue,  3 May 2016 18:12:37 +0200
Message-Id: <1e55bd34e72df64877490d68abf9e1eedf023e4b.1462291729.git.dsterba@suse.com>
In-Reply-To: <cover.1462291729.git.dsterba@suse.com>
References: <cover.1462291729.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 kerncompat.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kerncompat.h b/kerncompat.h
index ee65aa72ad6d..574f468226c2 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -334,12 +334,16 @@ struct __una_u32 { __le32 x; } __attribute__((__packed__));
 struct __una_u64 { __le64 x; } __attribute__((__packed__));
 
 #define get_unaligned_le8(p) (*((u8 *)(p)))
+#define get_unaligned_8(p) (*((u8 *)(p)))
 #define put_unaligned_le8(val,p) ((*((u8 *)(p))) = (val))
 #define get_unaligned_le16(p) le16_to_cpu(((const struct __una_u16 *)(p))->x)
+#define get_unaligned_16(p) (((const struct __una_u16 *)(p))->x)
 #define put_unaligned_le16(val,p) (((struct __una_u16 *)(p))->x = cpu_to_le16(val))
 #define get_unaligned_le32(p) le32_to_cpu(((const struct __una_u32 *)(p))->x)
+#define get_unaligned_32(p) (((const struct __una_u32 *)(p))->x)
 #define put_unaligned_le32(val,p) (((struct __una_u32 *)(p))->x = cpu_to_le32(val))
 #define get_unaligned_le64(p) le64_to_cpu(((const struct __una_u64 *)(p))->x)
+#define get_unaligned_64(p) (((const struct __una_u64 *)(p))->x)
 #define put_unaligned_le64(val,p) (((struct __una_u64 *)(p))->x = cpu_to_le64(val))
 
 #ifndef true
-- 
2.7.1

