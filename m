Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:40865 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbcF1DGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 23:06:07 -0400
From: Weigang Li <weigang.li@intel.com>
To: linux-btrfs@vger.kernel.org
Cc: giovanni.cabiddu@intel.com, brian.will@intel.com,
        Weigang Li <weigang.li@intel.com>
Subject: [RFC] Btrfs: add asynchronous compression support in zlib
Date: Tue, 28 Jun 2016 11:06:20 +0800
Message-Id: <1467083180-111750-1-git-send-email-weigang.li@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces a change in zlib.c to use the new asynchronous
compression API (acomp) proposed in cryptodev (working in progress):
https://patchwork.kernel.org/patch/9163577/
Now BTRFS can offload the zlib (de)compression to a hardware accelerator
engine if acomp hardware driver is registered in LKCF, the advantage 
of using acomp is saving CPU cycles and increasing disk IO by hardware 
offloading.
The input pages (up to 32) are added in sg-list and sent to acomp in one 
request, as it is asynchronous call, the thread is put to sleep and 
then CPU is free up, once compression is done, callback is triggered
and the thread is wake up.
This patch doesn't change the BTRFS disk format, that means the files 
compressed by hardware engine can be de-compressed by zlib software 
library, or vice versa.
The previous synchronous zlib (de)compression method is not changed in 
current implementation, but enventually they can be unified with the acomp 
API in LKCF.

Signed-off-by: Weigang Li <weigang.li@intel.com>
---
 fs/btrfs/zlib.c | 206 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 82990b8..957e603 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -31,6 +31,8 @@
 #include <linux/pagemap.h>
 #include <linux/bio.h>
 #include "compression.h"
+#include <crypto/acompress.h>
+#include <linux/scatterlist.h>
 
 struct workspace {
 	z_stream strm;
@@ -38,6 +40,11 @@ struct workspace {
 	struct list_head list;
 };
 
+struct acomp_res {
+	struct completion *completion;
+	int *ret;
+};
+
 static void zlib_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
@@ -71,6 +78,119 @@ fail:
 	return ERR_PTR(-ENOMEM);
 }
 
+static void acomp_op_done(struct crypto_async_request *req, int err)
+{
+	struct acomp_res *res = req->data;
+	*res->ret = err;
+	complete(res->completion);
+}
+
+static int zlib_compress_pages_async(struct address_space *mapping,
+					u64 start, unsigned long len,
+					struct page **pages,
+					unsigned long nr_dest_pages,
+					unsigned long *out_pages,
+					unsigned long *total_in,
+					unsigned long *total_out,
+					unsigned long max_out)
+{
+	int ret, acomp_ret = -1, i = 0;
+	int nr_pages = 0;
+	struct page *out_page = NULL;
+	struct crypto_acomp *tfm = NULL;
+	struct acomp_req *req = NULL;
+	struct completion completion;
+	unsigned int nr_src_pages = 0, nr_dst_pages = 0, nr = 0;
+	struct sg_table *in_sg = NULL, *out_sg = NULL;
+	struct page **src_pages = NULL;
+	struct acomp_res res;
+
+	*out_pages = 0;
+	*total_out = 0;
+	*total_in = 0;
+
+	init_completion(&completion);
+	nr_src_pages = (len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	src_pages = kcalloc(nr_src_pages, sizeof(struct page *), GFP_KERNEL);
+	nr = find_get_pages(mapping, start >> PAGE_CACHE_SHIFT,
+				nr_src_pages, src_pages);
+	if (nr != nr_src_pages) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	in_sg = kcalloc(1, sizeof(*in_sg), GFP_KERNEL);
+	ret = sg_alloc_table_from_pages(in_sg, src_pages, nr_src_pages,
+					0, len, GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	/* pre-alloc dst pages, with same size as src */
+	nr_dst_pages =  nr_src_pages;
+	for (i = 0; i < nr_dst_pages; i++) {
+		out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+		if (!out_page) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		pages[i] = out_page;
+	}
+
+	out_sg = kcalloc(1, sizeof(*out_sg), GFP_KERNEL);
+
+	ret = sg_alloc_table_from_pages(out_sg, pages, nr_dst_pages, 0,
+				(nr_dst_pages << PAGE_CACHE_SHIFT), GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	tfm = crypto_alloc_acomp("zlib_deflate", 0, 0);
+	req = acomp_request_alloc(tfm, GFP_KERNEL);
+	acomp_request_set_params(req, in_sg->sgl, out_sg->sgl, len,
+				nr_dst_pages << PAGE_CACHE_SHIFT);
+
+	res.completion = &completion;
+	res.ret = &acomp_ret;
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					acomp_op_done, &res);
+	ret = crypto_acomp_compress(req);
+	if (ret == -EINPROGRESS) {
+		ret = wait_for_completion_timeout(&completion, 5000);
+		if (ret == 0) { /* timeout */
+			ret = -1;
+			goto out;
+		}
+	}
+
+	ret = *res.ret;
+	*total_in = len;
+	*total_out = req->dlen;
+	nr_pages = (*total_out + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+out:
+	for (i = 0; i < nr_src_pages; i++)
+		put_page(src_pages[i]);
+	kfree(src_pages);
+
+	/* free un-used out pages */
+	for (i = nr_pages; i < nr_dst_pages; i++)
+		put_page(pages[i]);
+
+	acomp_request_free(req);
+	crypto_free_acomp(tfm);
+
+	if (in_sg) {
+		sg_free_table(in_sg);
+		kfree(in_sg);
+	}
+	if (out_sg) {
+		sg_free_table(out_sg);
+		kfree(out_sg);
+	}
+
+	*out_pages = nr_pages;
+	return ret;
+}
+
 static int zlib_compress_pages(struct list_head *ws,
 			       struct address_space *mapping,
 			       u64 start, unsigned long len,
@@ -90,6 +210,11 @@ static int zlib_compress_pages(struct list_head *ws,
 	struct page *out_page = NULL;
 	unsigned long bytes_left;
 
+	if (crypto_has_acomp("zlib_deflate", 0, 0)) {
+		return zlib_compress_pages_async(mapping, start, len, pages,
+						nr_dest_pages, out_pages,
+						total_in, total_out, max_out);
+	}
 	*out_pages = 0;
 	*total_out = 0;
 	*total_in = 0;
@@ -210,6 +335,82 @@ out:
 	return ret;
 }
 
+static int zlib_decompress_biovec_async(struct page **pages_in,
+					u64 disk_start,
+					struct bio_vec *bvec,
+					int vcnt,
+					size_t srclen)
+{
+	int ret, acomp_ret = -1, i = 0;
+	struct crypto_acomp *tfm = NULL;
+	struct acomp_req *req = NULL;
+	struct completion completion;
+	unsigned int nr_in_pages;
+	struct sg_table *in_sg = NULL, *out_sg = NULL;
+	struct page **out_pages = NULL;
+	struct acomp_res res;
+
+	init_completion(&completion);
+	nr_in_pages = (srclen + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	in_sg = kcalloc(1, sizeof(*in_sg), GFP_KERNEL);
+
+	ret = sg_alloc_table_from_pages(in_sg, pages_in, nr_in_pages,
+					0, srclen, GFP_KERNEL);
+
+	if (ret)
+		goto out;
+
+	/* build out pages from bvec */
+	out_pages = kcalloc(vcnt, sizeof(struct page *), GFP_KERNEL);
+	for (i = 0; i < vcnt; i++)
+		out_pages[i] = bvec[i].bv_page;
+
+	out_sg = kcalloc(1, sizeof(*out_sg), GFP_KERNEL);
+
+	ret = sg_alloc_table_from_pages(out_sg, out_pages, vcnt, 0,
+				(vcnt << PAGE_CACHE_SHIFT), GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	tfm = crypto_alloc_acomp("zlib_deflate", 0, 0);
+	req = acomp_request_alloc(tfm, GFP_KERNEL);
+
+	acomp_request_set_params(req, in_sg->sgl, out_sg->sgl, srclen,
+				vcnt << PAGE_CACHE_SHIFT);
+
+	res.completion = &completion;
+	res.ret = &acomp_ret;
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					acomp_op_done, &res);
+
+	ret = crypto_acomp_decompress(req);
+	if (ret == -EINPROGRESS) {
+		ret = wait_for_completion_timeout(&completion, 5000);
+		if (ret == 0) { /* timeout */
+			ret = -1;
+			goto out;
+		}
+	}
+
+	ret = *res.ret;
+	btrfs_clear_biovec_end(bvec, vcnt,
+				((req->dlen + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT),
+				req->dlen % PAGE_CACHE_SIZE);
+out:
+	if (in_sg) {
+		sg_free_table(in_sg);
+		kfree(in_sg);
+	}
+	if (out_sg) {
+		sg_free_table(out_sg);
+		kfree(out_sg);
+	}
+	kfree(out_pages);
+	acomp_request_free(req);
+	crypto_free_acomp(tfm);
+	return ret;
+}
+
 static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 				  u64 disk_start,
 				  struct bio_vec *bvec,
@@ -227,6 +428,11 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 	unsigned long buf_start;
 	unsigned long pg_offset;
 
+	if (crypto_has_acomp("zlib_deflate", 0, 0)) {
+		return zlib_decompress_biovec_async(pages_in, disk_start, bvec,
+							vcnt, srclen);
+	}
+
 	data_in = kmap(pages_in[page_in_index]);
 	workspace->strm.next_in = data_in;
 	workspace->strm.avail_in = min_t(size_t, srclen, PAGE_CACHE_SIZE);
-- 
1.9.3

