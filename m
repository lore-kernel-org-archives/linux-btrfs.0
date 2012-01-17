From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix decompressing of snappy-compressed inline extents
Date: Tue, 17 Jan 2012 17:07:18 +0800
Message-ID: <4F153A46.70906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andi Kleen <andi@firstfloor.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The first four bytes is the length of all data chunks, and the first
four bytes of each chunk is the length of compressed chunk data,
even when there's only one chunk, which is the case for inline
extents.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/snappy.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/snappy.c b/fs/btrfs/snappy.c
index d6bd607..35b877e 100644
--- a/fs/btrfs/snappy.c
+++ b/fs/btrfs/snappy.c
@@ -392,12 +392,16 @@ static int btrfs_snappy_decompress(struct list_head *ws, unsigned char *data_in,
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	size_t in_len;
 	size_t out_len;
+	size_t tot_len;
 	int ret = 0;
 	char *kaddr;
 	unsigned long bytes;
 
 	BUG_ON(srclen < SNAPPY_LEN);
 
+	tot_len = read_compress_length(data_in);
+	data_in += SNAPPY_LEN;
+
 	in_len = read_compress_length(data_in);
 	data_in += SNAPPY_LEN;
 
-- 
1.7.3.1
