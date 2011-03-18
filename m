From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: properly access unaligned checksum buffer
Date: Fri, 18 Mar 2011 16:28:25 +0100
Message-ID: <1300462105-30680-1-git-send-email-dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, adrien.dessemond@gmail.com,
	David Sterba <dsterba@suse.cz>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

fixes https://bugzilla.kernel.org/show_bug.cgi?id=29142
reported on SPARC64, warnings like:

[ 1523.941667] Kernel unaligned access at TPC[100e4034]
btrfs_csum_final+0x38/0x3c [btrfs]

Reported-by: Adrien Dessemond <adrien.dessemond@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
Tested-by: Adrien Dessemond <adrien.dessemond@gmail.com>
---
 fs/btrfs/disk-io.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1aa8d6..8065863 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -198,7 +198,11 @@ u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
 
 void btrfs_csum_final(u32 crc, char *result)
 {
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	*(__le32 *)result = ~cpu_to_le32(crc);
+#else
+	put_unaligned_le32(~crc, result);
+#endif
 }
 
 /*
-- 
1.7.4.1.176.g501cc

