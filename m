Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBED2D7DE9
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599468; cv=none; b=YcGgHAwV4+AL7Bk696Pb28ouVVHH8+BtD829XX5akqeg16HiKK8GYW9+Ys/SCuK4T7GvnvFxO0+RsZFQ8N5a4TyCXIt1r1dc7PvUudI3vbVzThZh13UgoamSkGCID5Tq/zdeaPe5UknyHgCkyQ0+5Sm4pMXbFDRY1Gwtrws5D/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599468; c=relaxed/simple;
	bh=oZ3BFAy9cLxeqXthNExBNBD2GMUwMIJfwvoNUFcW7pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptyyrrFTcntJwIs7PFfcCvW4In49gYHYAQW+sNu0U6JTXTLZVz4YXEbEWO+pDpHJHAXAm/pAc9WlQtm9atgPfMeepKLjq5MdiQ9KVlcOoaebnPyQLtJMZbVVZoBLVlXYos+0eqMPXBe0Ss43kYqUdXOk5WqlGN7sK9/HlUUdwTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hTbetJY9; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hTbetJY9"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2caed617615so25875255ad.3
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2026 08:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599466; x=1786204266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/6LlJ8gBFfbSI101GpfmueMUxhwNSOZCGEsyX/W5uwU=;
        b=hTbetJY9iLmkAok3xbBOyDoHCromjW74NdSsghiynUF1G9VDZcJQlX+D6XPTP9xrfE
         g8Zqvku7qkq5mDv7Zdmm85ifBGnCgAkIix9iSN84hxDThi5JYoaTQ/2RtFM4G9+mIXxB
         g0mnjEH0C//eQBda+9B8EkGEs48Vhef06stN3G1aEW9CDmeUQDwRp84f2yEx8/y+eMbP
         QdeWQUqWPridDHMU6UKjqTq7EHmxKgvL4KSuJyIGYtE9MVD8XcXvCj3O93DC2wYMcUfx
         1MxFpI4xuHsgvNTtTE0fcAhuEyIjR/2ZKukPK3lFskBs5y2qxf4rm8UW6kv0mN9NvpFm
         /J0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599466; x=1786204266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/6LlJ8gBFfbSI101GpfmueMUxhwNSOZCGEsyX/W5uwU=;
        b=sB+UePBZWw0xVs+xfHnnH7DUMlJRSrbDjnnPzPvQjcT+aWxbgpZa649eMAXAMvpIwS
         2kZeM0Tf7DZeNjP3r+1pxdhK23RJ3uoiPWxyUAWi35gtAgHfH4guseWkCShWd4nHgh8I
         8Pyp9HkyNrhWbXQFX/pWP/FWMvFsJDlwegC9IijBXskfOjmnT1T4Ea87Zt+lIWKfkV0c
         zmV2cMzLkr4L5UambKSkodYONlI0W6P43mdZlghIlH5FD/5enTp0GuxCCKbtOCICA8Xl
         qte/F+XAfjfZalfpi/IsRTgM9NYJoHY77cUgtABLQlVw7oVAspmTCaJqFflZeygpn6lO
         v3Sg==
X-Forwarded-Encrypted: i=1; AHgh+RoHNBBx+dZymQ/HMcs/DKH1SgLy5BuPv6SiW9LmofAfm+1TKVrHokXj1HfBwUwqWXL3col+ysGh2OyHhw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yye/+W87n2gd/mgiOYcSv90OX4yUZ8YzeRfwtnXthLc1/ociVHd
	StddvvYnQKLfF9GUu1TVwEKLTwCOdMKCs1OmHTAhXUobojtwpTXRFT1V
X-Gm-Gg: AR+sD11twEhniG2S57zluqUDvEcmfG9Ck884TRbd8lIXNPAKv9RBVgtFPp51TRZnwXD
	ELfHnejzSX3MQ+yCUqjX6kerZ7eios01C8L9GjItG3TVyDtYKtJjl3dRwX2lv4g7diY/NM4xJju
	aBuOPOLFsWqQnSjUmbeLl+7M9hlj/ThV3ipeljGVMawv/OuhIsUYHcAsvvF2EB+7EOiko1qVX1v
	Cdy1tHHxqoZeybaRwk9yeXd5kTz3q/mQIQLfy11G3l2W1a2IBBPVBKXAN5A6nSPeuutVvO1FJgg
	BrDJKapwl+rDQTNFRrRt9u5rMqkSQ0Jw2tJx2vVlcZkAyJ4hnHL7Lyp5u+2v1WxTntAGPm9Bv8S
	gAQ6RKGt04gJYOnDvtXTufXMr3KG8nWUg1uGNNxJUVJd9JKJxyju/c4WmBZVothctxWCQHtj2UD
	R9aFzEb12Tr8MZPxksQM7x25YIhqdOWmlO6EBPBEJSV9wi+TQYjs8e5nnW/ZXnf6/0HrcO92H3y
	Aoum/stMK8kup9BUstGYFXjs6vo0l3Ad92RmGhqW7ZMwlg=
X-Received: by 2002:a17:902:d544:b0:2cf:b330:e0e8 with SMTP id d9443c01a7336-2d0521bc383mr40814585ad.10.1785599466354;
        Sat, 01 Aug 2026 08:51:06 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:51:05 -0700 (PDT)
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
Subject: [PATCH v5 12/16] io_uring/rsrc: introduce buf registration structure
Date: Sat,  1 Aug 2026 16:46:24 +0100
Message-ID: <d98dda2783b62151880ed463eaa0e9b1c90af3bc.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
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

