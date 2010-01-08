From: jim owens <jowens@hp.com>
Subject: [RFC PATCH 01/01] Btrfs: add decompression code for direct I/O.
Date: Fri, 08 Jan 2010 12:10:22 -0500
Message-ID: <4B4766FE.40405@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Direct I/O needs to inflate compressed temp pages with the
uncompressed result stored in not-necessarily-aligned user
memory. Add btrfs_zlib_inflate() to do this and expose
struct workspace, find_zlib_workspace(), and free_workspace()
so that multiple extents can be processed using one workspace.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/compression.h |   20 +++++++
 fs/btrfs/zlib.c        |  143 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 155 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 421f5b4..afd262d 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -19,6 +19,26 @@
 #ifndef __BTRFS_COMPRESSION_
 #define __BTRFS_COMPRESSION_
 
+#include <linux/zlib.h>
+struct workspace {
+	z_stream z_strm;
+	char *buf;
+	struct list_head list;
+};
+
+struct btrfs_inflate {
+	struct workspace *workspace;
+	int (*get_next_in)(struct bio_vec *vec, struct btrfs_inflate *icb);
+	int (*get_next_out)(struct bio_vec *vec, struct btrfs_inflate *icb);
+	void (*done_with_out)(struct bio_vec *vec, struct btrfs_inflate *icb);
+	u32 out_start;
+	u32 out_len;
+};
+
+struct workspace *find_zlib_workspace(void);
+int free_workspace(struct workspace *workspace);
+int btrfs_zlib_inflate(struct btrfs_inflate *icb);
+
 int btrfs_zlib_decompress(unsigned char *data_in,
 			  struct page *dest_page,
 			  unsigned long start_byte,
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index d7bdce5..779a259 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -41,12 +41,6 @@
 */
 #define STREAM_END_SPACE 12
 
-struct workspace {
-	z_stream z_strm;
-	char *buf;
-	struct list_head list;
-};
-
 static LIST_HEAD(idle_workspace);
 static DEFINE_SPINLOCK(workspace_lock);
 static unsigned long num_workspace;
@@ -57,7 +51,7 @@ static DECLARE_WAIT_QUEUE_HEAD(workspace_wait);
  * this finds an available zlib workspace or allocates a new one
  * NULL or an ERR_PTR is returned if things go bad.
  */
-static struct workspace *find_zlib_workspace(void)
+struct workspace *find_zlib_workspace(void)
 {
 	struct workspace *workspace;
 	int ret;
@@ -90,6 +84,7 @@ again:
 		goto fail;
 	}
 
+printk("JIM workspace allocated %d deflate %d inflate %d\n",max(zlib_deflate_workspacesize(),	zlib_inflate_workspacesize()),zlib_deflate_workspacesize(),zlib_inflate_workspacesize());
 	workspace->z_strm.workspace = vmalloc(max(zlib_deflate_workspacesize(),
 						zlib_inflate_workspacesize()));
 	if (!workspace->z_strm.workspace) {
@@ -117,7 +112,7 @@ fail:
  * put a workspace struct back on the list or free it if we have enough
  * idle ones sitting around
  */
-static int free_workspace(struct workspace *workspace)
+int free_workspace(struct workspace *workspace)
 {
 	spin_lock(&workspace_lock);
 	if (num_workspace < num_online_cpus()) {
@@ -622,3 +617,135 @@ void btrfs_zlib_exit(void)
 {
     free_workspaces();
 }
+
+/* inflate compressed data for one contiguous file range from directio */
+int btrfs_zlib_inflate(struct btrfs_inflate *icb)
+{
+	struct workspace *workspace = icb->workspace;
+	unsigned long out_start = icb->out_start;
+	unsigned long total_len = icb->out_len + out_start;
+	struct bio_vec ivec;
+	struct bio_vec ovec;
+	char *in;
+	char *out;
+	int err;
+	int wbits;
+
+	icb->out_len = 0;
+	ivec.bv_len = 0;
+	ovec.bv_len = 0;
+	if (!workspace) {
+		workspace = find_zlib_workspace();
+		if (IS_ERR(workspace))
+			return -ENOMEM;
+	}
+
+	err = icb->get_next_in(&ivec, icb);
+	if (err)
+		goto fail;
+	in = kmap_atomic(ivec.bv_page, KM_USER0);
+	workspace->z_strm.next_in = in + ivec.bv_offset;
+	workspace->z_strm.avail_in = ivec.bv_len;
+	workspace->z_strm.total_in = 0;
+	workspace->z_strm.total_out = 0;
+	workspace->z_strm.next_out = workspace->buf;
+	workspace->z_strm.avail_out = PAGE_CACHE_SIZE;
+	
+	/* with no preset dictionary, tell zlib to skip the adler32 check */
+	if (!(in[ivec.bv_offset+1] & PRESET_DICT) &&
+		    ((in[ivec.bv_offset] & 0x0f) == Z_DEFLATED) &&
+		    !(((in[ivec.bv_offset]<<8) + in[ivec.bv_offset+1]) % 31)) {
+
+		wbits = -((in[ivec.bv_offset] >> 4) + 8);
+		workspace->z_strm.next_in += 2;
+		workspace->z_strm.avail_in -= 2;
+	} else {
+		wbits = MAX_WBITS;
+	}
+
+	err = zlib_inflateInit2(&workspace->z_strm, wbits);
+	if (err) {
+		kunmap_atomic(in, KM_USER0);
+		goto fail;
+	}
+
+	ivec.bv_len = workspace->z_strm.avail_in;
+	ivec.bv_offset = (char *)workspace->z_strm.next_in - in;
+	kunmap_atomic(in, KM_USER0);
+
+	/* use temp buf to toss everything before the real data we want */
+	while (workspace->z_strm.total_out < out_start) {
+		workspace->z_strm.next_out = workspace->buf;
+		workspace->z_strm.avail_out = min(PAGE_CACHE_SIZE,
+				out_start - workspace->z_strm.total_out);
+
+		if (!ivec.bv_len) {
+			err = icb->get_next_in(&ivec, icb);
+			if (err)
+				goto fail;
+		}
+		in = kmap_atomic(ivec.bv_page, KM_USER0);
+		workspace->z_strm.next_in = in + ivec.bv_offset;
+		workspace->z_strm.avail_in = ivec.bv_len;
+
+		err = zlib_inflate(&workspace->z_strm, Z_NO_FLUSH);
+
+		ivec.bv_len = workspace->z_strm.avail_in;
+		ivec.bv_offset = (char *)workspace->z_strm.next_in - in;
+		kunmap_atomic(in, KM_USER0);
+
+		if (err != Z_OK) /* Z_STREAM_END is no-user-data failure here */
+			goto fail;
+		cond_resched();
+	}
+
+	while (workspace->z_strm.total_out < total_len) {
+		if (!ivec.bv_len) {
+			err = icb->get_next_in(&ivec, icb);
+			if (err)
+				goto fail;
+		}
+		if (!ovec.bv_len) {
+			err = icb->get_next_out(&ovec, icb);
+			if (err)
+				goto fail;		
+		}
+
+		in = kmap_atomic(ivec.bv_page, KM_USER0);
+		workspace->z_strm.next_in = in + ivec.bv_offset;
+		workspace->z_strm.avail_in = ivec.bv_len;
+
+		out = kmap_atomic(ovec.bv_page, KM_USER1);
+		workspace->z_strm.next_out = out + ovec.bv_offset;
+		workspace->z_strm.avail_out = ovec.bv_len;
+
+		err = zlib_inflate(&workspace->z_strm, Z_NO_FLUSH);
+
+		icb->out_len += (ovec.bv_len - workspace->z_strm.avail_out);
+		ovec.bv_len = workspace->z_strm.avail_out;
+		ovec.bv_offset = (char *)workspace->z_strm.next_out - out;
+		kunmap_atomic(out, KM_USER1);
+
+		ivec.bv_len = workspace->z_strm.avail_in;
+		ivec.bv_offset = (char *)workspace->z_strm.next_in - in;
+		kunmap_atomic(in, KM_USER0);
+
+		if (!ovec.bv_len)
+			icb->done_with_out(&ovec, icb);
+		else
+			flush_dcache_page(ovec.bv_page);
+
+		if (err != Z_OK)
+			goto fail;
+		cond_resched();
+	}
+
+fail:
+	if (ovec.bv_len)
+		icb->done_with_out(&ovec, icb);
+	if (!icb->workspace)
+		free_workspace(workspace);
+	if (err == Z_OK || err == Z_STREAM_END)
+		return 0;
+	return err;
+}
-- 
1.5.6.3
