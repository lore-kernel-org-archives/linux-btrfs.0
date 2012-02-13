From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/4] btrfs: lz4: add wrapper for context size estimation
Date: Mon, 13 Feb 2012 20:05:36 +0100
Message-ID: <1329159937-23976-3-git-send-email-dsterba@suse.cz>
References: <20120213190325.GJ15350@twin.jikos.cz>
 <1329159937-23976-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1329159937-23976-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Currently 16K for 32bit and 64bit.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/lz4.c |    9 +++++++++
 fs/btrfs/lz4.h |    3 +++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/lz4.c b/fs/btrfs/lz4.c
index e41d0cf..105ea9c 100644
--- a/fs/btrfs/lz4.c
+++ b/fs/btrfs/lz4.c
@@ -808,3 +808,12 @@ _output_error:
 	return (int) (-(((char*)ip)-source));
 }
 
+int LZ4_context_size(void)
+{
+	return sizeof(struct refTables);
+}
+int LZ4_context64k_size(void)
+{
+	return sizeof(struct refTables);
+}
+
diff --git a/fs/btrfs/lz4.h b/fs/btrfs/lz4.h
index bbd5e12..b0f8cc7 100644
--- a/fs/btrfs/lz4.h
+++ b/fs/btrfs/lz4.h
@@ -102,6 +102,9 @@ int LZ4_compress64kCtx(void** ctx,
 				 char* dest,
 				 int isize);
 
+int LZ4_context_size(void);
+int LZ4_context64k_size(void);
+
 #if defined (__cplusplus)
 }
 #endif
-- 
1.7.8

