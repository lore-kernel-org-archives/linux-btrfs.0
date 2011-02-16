From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: Avoid accessing unmapped kernel address
Date: Wed, 16 Feb 2011 14:06:41 +0800
Message-ID: <4D5B6971.2040006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Juan Francisco Cantero Hurtado <iam@juanfra.info>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When decompressing a chunk of data, we'll copy the data out to
a working buffer if the data is stored in more than one page,
otherwise we'll use the mapped page directly to avoid memory
copy.

In the latter case, we'll end up accessing the kernel address
after we've unmapped the page in a corner case.

Reported-by: Juan Francisco Cantero Hurtado <iam@juanfra.info>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/lzo.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index cc9b450..a178f5e 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -280,6 +280,7 @@ static int lzo_decompress_biovec(struct list_head *ws,
 	unsigned long tot_out;
 	unsigned long tot_len;
 	char *buf;
+	bool may_late_unmap, need_unmap;
 
 	data_in = kmap(pages_in[0]);
 	tot_len = read_compress_length(data_in);
@@ -300,11 +301,13 @@ static int lzo_decompress_biovec(struct list_head *ws,
 
 		tot_in += in_len;
 		working_bytes = in_len;
+		may_late_unmap = need_unmap = false;
 
 		/* fast path: avoid using the working buffer */
 		if (in_page_bytes_left >= in_len) {
 			buf = data_in + in_offset;
 			bytes = in_len;
+			may_late_unmap = true;
 			goto cont;
 		}
 
@@ -329,14 +332,17 @@ cont:
 				if (working_bytes == 0 && tot_in >= tot_len)
 					break;
 
-				kunmap(pages_in[page_in_index]);
-				page_in_index++;
-				if (page_in_index >= total_pages_in) {
+				if (page_in_index + 1 >= total_pages_in) {
 					ret = -1;
-					data_in = NULL;
 					goto done;
 				}
-				data_in = kmap(pages_in[page_in_index]);
+
+				if (may_late_unmap)
+					need_unmap = true;
+				else
+					kunmap(pages_in[page_in_index]);
+
+				data_in = kmap(pages_in[++page_in_index]);
 
 				in_page_bytes_left = PAGE_CACHE_SIZE;
 				in_offset = 0;
@@ -346,6 +352,8 @@ cont:
 		out_len = lzo1x_worst_compress(PAGE_CACHE_SIZE);
 		ret = lzo1x_decompress_safe(buf, in_len, workspace->buf,
 					    &out_len);
+		if (need_unmap)
+			kunmap(pages_in[page_in_index - 1]);
 		if (ret != LZO_E_OK) {
 			printk(KERN_WARNING "btrfs decompress failed\n");
 			ret = -1;
@@ -363,8 +371,7 @@ cont:
 			break;
 	}
 done:
-	if (data_in)
-		kunmap(pages_in[page_in_index]);
+	kunmap(pages_in[page_in_index]);
 	return ret;
 }
 
-- 
1.6.3
