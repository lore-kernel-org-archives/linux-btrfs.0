Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C188947CC62
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 21:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274207; cv=none; b=Mu6So9cK4goJb/5+gKP678x/kaEejf08u1hDEIkNDC8FrFCAcuTO29EEfNV9Y6OI3fQDBA/Zkhxuk77E4300qtyQqRPHiX9KXnkIIjpFpC7Mxq7QWwcPHSWL8aeCIkzpYW0U4Uc/BoEd+CWaGLZREvC/1m1+x/AoXX1bt3Jlolo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274207; c=relaxed/simple;
	bh=oZ3BFAy9cLxeqXthNExBNBD2GMUwMIJfwvoNUFcW7pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3vmk7SV1pAyCdgxAjNM+uM39pZYPum7267SOKhkpIizLnPDNTxtoa2YLztgqqhY95f9iXteGw5G//XAr5CPZwjb6sGHzKu2r90ml6MxV/sQ2BCJ0JBEeLrcj2txtEGsqLgVCM0uEDVl5ZyjZtRpWaDXLxzYpRTpty+lIh+5tN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJ27kRUq; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJ27kRUq"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4758bd3731bso247200f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 14:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274203; x=1785879003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/6LlJ8gBFfbSI101GpfmueMUxhwNSOZCGEsyX/W5uwU=;
        b=dJ27kRUqiDIFITOKyFRHcZXjEQXZQd8078n61B+WOFepx54B1QQfTdtFcnLAb5gmqX
         /JGZB5gTx3/bAKakbC+JXcObAqyqti7wIVRLweeURnACBYgqIeO8DqGkPiFhxF72v/6F
         wny0i5LcaZbD+Qd9ERN4CjflOIZkO6XumWlDpFwFBydlxpNENspLQan83/6+JsxKezMs
         SbCsOlx/XYxWCbXMqXLyLLQeos2FXtoLi7fXVh9QlYLBjlen6LNNhnAiC7MsQQDSLVKR
         pe6LvsqrK0DCZdz+BRCG1C3ea4e8PlcGhOOmpj2wLT6vV4TsyvsSqYgUd+Ksvva91uSH
         5Y0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274203; x=1785879003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/6LlJ8gBFfbSI101GpfmueMUxhwNSOZCGEsyX/W5uwU=;
        b=N2A6nLkvHJTPAQuG+wgXIF4nAdlDxE8fAW2vBSQ9x+6BL+GSwvBwnZnpK495s3xyf5
         6+a7hECcUahFB4hwft6Rnq2tqLgXxHBJgPMh2NhwLcmWLthcsD9iDsjZeShX8Ek9gphr
         lMq2S7qTelOiokYCWAAm5YVmlJGtrFZWZ/WGOAXTKTeqIb2d731FgFHLGPPQYfDI94rQ
         VAxARbpv8rrcpDJ5FUgd220NBHPrtF0KTEmGalX6YnuSwosRm3JSwuq8frMiBkEFywbx
         Dii29qbNt7Nz2rCN2jtIT++7nwmN9IRMNPrD2jSMC03zCPKV+2gec8obNQMG9zAZ9amY
         3bZg==
X-Forwarded-Encrypted: i=1; AHgh+Rp8rDq557rLK8vCX1/LduV8KdOyEpmqKpWhyEIvyiMnXgKjKBITh47qR3pk9JBvOFYV3Ib6rWumJqZkcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUCzZrZy/I4ewUCHwxsZ/lihdj48IHhX9gf+IBMM53ZHhJdQtw
	ta5/Hm25MWZ8SfM4XX5scHwtZjwdiWmKpiIMmnYq9Pn2JSUmFnQgcb6W
X-Gm-Gg: AR+sD10pNcQjGq5Sp3YFbzykT7iwWCkv0IoEKOloIOsIpveJO7hZ9I6pKDvJpuKYSRl
	A7FaQWK698dgHUvqDv+wplmWdPMq4BV7QxT04+d8sQA/v6cZqpvLKQebjwl0f5kr9e4Nbsm5YRM
	O8CdQ3IGX0Qa0lnw3IelU8a0g6zJQZbh5DfjpnEKhsB6MSn+aej6Yo+khzqDgYnNb985BeogT0A
	XJQ7VVEdzHzLFNIANoX1XZCVpwweOFmhu55Br5SN0bVtd1uPDzP/wwGg0B6m7GNiGUVBeht8jzj
	uuUhY+CyVtIaFtLRy/w/aZgb5+PZNfyXdl/a7PbF3Q2Hh8x2VJqrSuRpVDLPoKvK05dpXDHMH7q
	Vu+l8JmT9eCmavHWtyKhKMqCDJoMJDRTBbj4Lo8jJoWS5No5VioyItrbEsD8+hmALVEFt9m3cgU
	cUBQ/A43nF74blSpgA9/c1vcnKw2+YRpLjf3Oy2vBq9sp653/XmU0b5XftGy0yJPxieBW7VbMjm
	OLomuHj
X-Received: by 2002:a5d:5f42:0:b0:47f:93e8:af81 with SMTP id ffacd0b85a97d-47fb1e913femr4235891f8f.10.1785274203054;
        Tue, 28 Jul 2026 14:30:03 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:30:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v4 10/14] io_uring/rsrc: introduce buf registration structure
Date: Tue, 28 Jul 2026 22:29:22 +0100
Message-ID: <41eda7b5d52e11d307ce4218397763538c1594ba.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to following changes, instead of passing an iovec for
buffer registration introduce a new structure. It'll be moved to uapi
later, but for now it's initialised early from a user provided iovec.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8d0f2ee24e0c..8af371ba6c06 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -27,8 +27,13 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
+struct io_uring_regbuf_desc {
+	__u64 uaddr;
+	__u64 size;
+};
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov);
+						   struct io_uring_regbuf_desc *desc);
 
 static int hpage_acct_ref(struct io_ring_ctx *ctx, struct page *hpage,
 			  bool *acct_new)
@@ -81,6 +86,15 @@ static bool hpage_acct_unref(struct io_ring_ctx *ctx, struct page *hpage)
 
 #define IO_CACHED_BVECS_SEGS	32
 
+static void io_iov_to_regbuf_desc(const struct iovec *iov,
+				  struct io_uring_regbuf_desc *desc)
+{
+	*desc = (struct io_uring_regbuf_desc) {
+		.uaddr = (u64)(uintptr_t)iov->iov_base,
+		.size = iov->iov_len,
+	};
+}
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -381,6 +395,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -394,7 +409,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		node = io_sqe_buffer_register(ctx, iov);
+
+		io_iov_to_regbuf_desc(iov, &desc);
+		node = io_sqe_buffer_register(ctx, &desc);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -853,26 +870,26 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov)
+						   struct io_uring_regbuf_desc *desc)
 {
+	unsigned long uaddr = (unsigned long)desc->uaddr;
+	size_t size = desc->size;
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
 	struct io_rsrc_node *node;
 	unsigned long off;
-	size_t size;
 	int ret, nr_pages, i;
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
-	if (!iov->iov_base) {
-		if (iov->iov_len)
+	if (!uaddr) {
+		if (size)
 			return ERR_PTR(-EFAULT);
 		/* remove the buffer without installing a new one */
 		return NULL;
 	}
 
-	ret = io_validate_user_buf_range((unsigned long)iov->iov_base,
-					 iov->iov_len);
+	ret = io_validate_user_buf_range(uaddr, size);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -881,8 +898,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
-				&nr_pages);
+	pages = io_pin_pages(uaddr, size, &nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
 		pages = NULL;
@@ -904,10 +920,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (ret)
 		goto done;
 
-	size = iov->iov_len;
 	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
-	imu->len = iov->iov_len;
+	imu->ubuf = uaddr;
+	imu->len = size;
 	imu->folio_shift = PAGE_SHIFT;
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
@@ -917,7 +932,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
 
-	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
+	off = uaddr & ~PAGE_MASK;
 	if (coalesced)
 		off += data.first_folio_page_idx << PAGE_SHIFT;
 
@@ -969,6 +984,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		memset(iov, 0, sizeof(*iov));
 
 	for (i = 0; i < nr_args; i++) {
+		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -992,7 +1008,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov);
+		io_iov_to_regbuf_desc(iov, &desc);
+		node = io_sqe_buffer_register(ctx, &desc);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
-- 
2.54.0

