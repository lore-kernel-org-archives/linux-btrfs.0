Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3LPQeN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 11:34:13 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CC61EABE7
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 16:34:12 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs: send: clean up dead code
Date: Mon, 16 Dec 2013 17:34:10 +0100
Message-Id: <4d58729f18d34e9fbd9d2e86d12c9428378fdec5.1387211246.git.dsterba@suse.cz>
In-Reply-To: <cover.1387211245.git.dsterba@suse.cz>
References: <cover.1387211245.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove ifdefed code:

- tlv_put for 8, 16 and 32, add a generic tempalte if needed in future
- tlv_put_timespec - the btrfs_timespec fields are used
- fs_path_remove obsoleted long ago

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |   58 +++++++-----------------------------------------------
 1 files changed, 8 insertions(+), 50 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6837fe87f3a6..2c1dcab7420d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -336,16 +336,6 @@ out:
 	return ret;
 }
 
-#if 0
-static void fs_path_remove(struct fs_path *p)
-{
-	BUG_ON(p->reversed);
-	while (p->start != p->end && *p->end != '/')
-		p->end--;
-	*p->end = 0;
-}
-#endif
-
 static int fs_path_copy(struct fs_path *p, struct fs_path *from)
 {
 	int ret;
@@ -436,30 +426,15 @@ static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
 	return 0;
 }
 
-#if 0
-static int tlv_put_u8(struct send_ctx *sctx, u16 attr, u8 value)
-{
-	return tlv_put(sctx, attr, &value, sizeof(value));
-}
-
-static int tlv_put_u16(struct send_ctx *sctx, u16 attr, u16 value)
-{
-	__le16 tmp = cpu_to_le16(value);
-	return tlv_put(sctx, attr, &tmp, sizeof(tmp));
-}
-
-static int tlv_put_u32(struct send_ctx *sctx, u16 attr, u32 value)
-{
-	__le32 tmp = cpu_to_le32(value);
-	return tlv_put(sctx, attr, &tmp, sizeof(tmp));
-}
-#endif
+#define TLV_PUT_DEFINE_INT(bits) \
+	static int tlv_put_u##bits(struct send_ctx *sctx,	 	\
+			u##bits attr, u##bits value)			\
+	{								\
+		__le##bits __tmp = cpu_to_le##bits(value);		\
+		return tlv_put(sctx, attr, &__tmp, sizeof(__tmp));	\
+	}
 
-static int tlv_put_u64(struct send_ctx *sctx, u16 attr, u64 value)
-{
-	__le64 tmp = cpu_to_le64(value);
-	return tlv_put(sctx, attr, &tmp, sizeof(tmp));
-}
+TLV_PUT_DEFINE_INT(64)
 
 static int tlv_put_string(struct send_ctx *sctx, u16 attr,
 			  const char *str, int len)
@@ -475,17 +450,6 @@ static int tlv_put_uuid(struct send_ctx *sctx, u16 attr,
 	return tlv_put(sctx, attr, uuid, BTRFS_UUID_SIZE);
 }
 
-#if 0
-static int tlv_put_timespec(struct send_ctx *sctx, u16 attr,
-			    struct timespec *ts)
-{
-	struct btrfs_timespec bts;
-	bts.sec = cpu_to_le64(ts->tv_sec);
-	bts.nsec = cpu_to_le32(ts->tv_nsec);
-	return tlv_put(sctx, attr, &bts, sizeof(bts));
-}
-#endif
-
 static int tlv_put_btrfs_timespec(struct send_ctx *sctx, u16 attr,
 				  struct extent_buffer *eb,
 				  struct btrfs_timespec *ts)
@@ -533,12 +497,6 @@ static int tlv_put_btrfs_timespec(struct send_ctx *sctx, u16 attr,
 		if (ret < 0) \
 			goto tlv_put_failure; \
 	} while (0)
-#define TLV_PUT_TIMESPEC(sctx, attrtype, ts) \
-	do { \
-		ret = tlv_put_timespec(sctx, attrtype, ts); \
-		if (ret < 0) \
-			goto tlv_put_failure; \
-	} while (0)
 #define TLV_PUT_BTRFS_TIMESPEC(sctx, attrtype, eb, ts) \
 	do { \
 		ret = tlv_put_btrfs_timespec(sctx, attrtype, eb, ts); \
-- 
1.7.9

