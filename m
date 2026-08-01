Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6FD329C7B
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 15:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599448; cv=none; b=sOiaZpFmZNsZQ8hAphRe+g/RyZRsOorvmStNePGcB1EkTKGRCXBiq0a+ZJGgZok4Ndj6ZeCKuZbf82Z7eyBD4cnDm7i66sKEGWno+qMfti4hTisS0vyKS551yOv/GFUQir1yfY2mPcD6RwgT8QHQfG78lKINcl6HZxz+J20pZyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599448; c=relaxed/simple;
	bh=x+OUwPvED0A9WpApYgDpbJAjUumA7PzzdtZ3Hd4LWNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHNim8gY0cd3hFRCrevlMBQ4L9WybHmrrV5vKDIdR9b1nhBDRvcEfTUW1E4CbLG+OFIgW2aUhCsaqHrg8/BDB8zikYrfB+w5Lj/0EgDQskseSSsAnoV8snS9ckQljYwoEdlHbte3Cvl+SOlu0StW8p6IPpN1N5INIWrfdpc3r6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jAQnFFZE; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jAQnFFZE"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cf27856f9cso20472885ad.2
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2026 08:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599445; x=1786204245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rSOyaa4+UsoEyQf3LWEsLm65BesmXLGHIq97BZD3zcI=;
        b=jAQnFFZEe92YzJjuyl5ExhN/f4TgMsnYItGtGyaqfnzkv0mxjQh5jKP8KtGKTZy4zi
         +S4cIe/HlKY4pic324hCiieASW84ic48OH6M8Uk8WqyuQ/bjQN5bfgN6Vm6lgWxPceSE
         lXHzxCs6ZCvP6wms2CcRIHT/z2hJIP+KbfSJnKcteJ8QiNdrEYekaCV3IOyltgalLwmV
         6DYYxvWUdEUB8SLv+i81otpdSdoSV5I41yy2yjDjMpmufl1Hyu7HT1ydE1QV0C/qf6Bt
         T8ZEVkB+HBw0BpWcbjouOErJx0mQSy8HHsqW2Iysv0hEJzml1m2RsDPT4cGQmECa0wGg
         RDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599445; x=1786204245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rSOyaa4+UsoEyQf3LWEsLm65BesmXLGHIq97BZD3zcI=;
        b=tLM3YZfeM5lBUu8Y/nHMtVz1E+InJ4qPmiSHd8+L/ykH8uGUr3ZzpVB9D4LlO04Inw
         93eBLVVy+Io6m0G3XS2Vh2V9b42GvUYoycdU7FS7GnZxHCUlAT0ddT5SHz4K+RwDjIvW
         4r0bY46e69FeGXfwtlnKedYo/bycwCBVZhmMXBKBIayP0IJqOAiDIZnLiOtR1KPWjudR
         t+OeFgEnL82p18bvsSgdzoy8hR8yEy0F87y+wqyoQ6TZq7dVRkx7Yt5nXbnIkoGWHf9q
         KcnmNWwryfXSPGmGSoxxbzoVsQYC5jKDq1obWT8qb5TLvSbNmnE+w2p8UyRZPMRL0dRp
         dHag==
X-Forwarded-Encrypted: i=1; AHgh+RokRYzWNCkiMQti8Zc1csfbmCcXoLOaWjqz/gh0AED5zyNE2pJ7NYi8KZFPSmCvaE4x/S2fNOMjhfIzCw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/DaYLoY8CRe2z8Rsq5mTkGlQ5X2JqnYW7L95kkSdfnqvuUOpW
	uO5Jm7en9xXFBrxrWZC83uSO/NSSmOYzx0zIQiiCyxNPw9bMb92moiCT
X-Gm-Gg: AR+sD101Mm90usQ2+1qTNgsIWJ77cVnWEJTce28jhO0PFLhDJKs1EP5oz/D5kjXophJ
	Dps+gqO+XZDeNbChYCgBVv5jqFgkO88l4lMTmDqeJqUg4DKHQ43qhlzBykIKqyHn/CzF4fYyzYs
	y599UDy24NADj6hQ5h/cmgy5PX2M2dLBaQCEDLoK0SQGIl5dwk2mAHwQR9qAOc3jmK1ey2Xm/jX
	jy+wBt6JU9yOphABm6EeayYyetu3SR+jGguGJ4hy1HusS/l6dxXqOutm02eJ/o717k8bo4Eq67B
	a5mTVe1fZqfaF/rdic4ovQZEGrDS1O0sGRK6ounAKtQmYouy0B3+sLtYiW2eD2WmD0hpiQYB98P
	lFwCFVinZrHMVAQirt6+hh/TXBSPr+HJlVGID6324aCVDpkuO+tXeK6cODzbvvNv2yk32kC7q/A
	789iZpCJV+IcP+HIFJXD9EWuIpdXhMVhhUirV68wqz7LXRCBCpNKbpKvKYJROQ3BnfbYs05OcPc
	q5+SAKNlK/ufo2KVWOcQ7s1PtkPJ8KPBUFhDI2BgLvpzS4=
X-Received: by 2002:a17:903:1b43:b0:2ca:d820:b9a6 with SMTP id d9443c01a7336-2d05242b8a0mr39311295ad.23.1785599445373;
        Sat, 01 Aug 2026 08:50:45 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:50:44 -0700 (PDT)
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
Subject: [PATCH v5 11/16] nvme-pci: add SGL support for the dmabuf path
Date: Sat,  1 Aug 2026 16:46:23 +0100
Message-ID: <aa8c58a3f7da3a36af31f6e3b48853e59d9facc1.1785596451.git.asml.silence@gmail.com>
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

From: Anuj Gupta <anuj20.g@samsung.com>

Add SGL support in addition to PRP for dmabuf-backed requests,
building the descriptor list from the mapping's sg_table.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/pci.c | 153 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 149 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7b8ed101a13b..67e26d6e8f25 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1287,12 +1287,18 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	return BLK_STS_IOERR;
 }
 
+static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
+		dma_addr_t addr, u32 len)
+{
+	sge->addr = cpu_to_le64(addr);
+	sge->length = cpu_to_le32(len);
+	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
+}
+
 static void nvme_pci_dma_iter_set_sgl(struct nvme_sgl_desc *sge,
 		struct blk_dma_iter *iter)
 {
-	sge->addr = cpu_to_le64(iter->addr);
-	sge->length = cpu_to_le32(iter->len);
-	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
+	nvme_pci_sgl_set_data(sge, iter->addr, iter->len);
 }
 
 static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
@@ -1303,6 +1309,145 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
 	sge->type = NVME_SGL_FMT_LAST_SEG_DESC << 4;
 }
 
+static unsigned int nvme_pci_dmabuf_sgl_nents(struct request *req)
+{
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	struct scatterlist *sg;
+	unsigned long tmp;
+	size_t offset = bio->bi_iter.bi_offset;
+	size_t remaining = blk_rq_payload_bytes(req);
+	unsigned int nents = 0;
+
+	for_each_sgtable_dma_sg(map->sgt, sg, tmp) {
+		size_t sg_len = sg_dma_len(sg);
+
+		if (!remaining)
+			break;
+		if (offset >= sg_len) {
+			offset -= sg_len;
+			continue;
+		}
+
+		sg_len -= offset;
+		offset = 0;
+
+		do {
+			size_t chunk = min(remaining, sg_len);
+
+			nents++;
+			sg_len -= chunk;
+			remaining -= chunk;
+		} while (sg_len && remaining);
+	}
+
+	if (unlikely(remaining))
+		return 0;
+
+	return nents;
+}
+
+static blk_status_t nvme_rq_setup_dmabuf_sgl(struct request *req,
+		struct nvme_queue *nvmeq, unsigned int entries)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	size_t length = blk_rq_payload_bytes(req);
+	struct nvme_sgl_desc *sg_list = &iod->cmd.common.dptr.sgl;
+	bool pooled = entries > 1;
+	dma_addr_t sgl_dma = 0;
+	unsigned int mapped = 0;
+	unsigned long tmp;
+	struct scatterlist *sg;
+	size_t offset = bio->bi_iter.bi_offset;
+	size_t remaining = length;
+
+	if (!entries)
+		return BLK_STS_IOERR;
+
+	iod->cmd.common.flags = NVME_CMD_SGL_METABUF;
+	iod->total_len = length;
+
+	nvme_dmabuf_map_sync_for_device(nvmeq->dev, req);
+
+	/* entries == 1 fits in the inline descriptor; more needs a pool. */
+	if (pooled) {
+		if (entries <= NVME_SMALL_POOL_SIZE / sizeof(*sg_list))
+			iod->flags |= IOD_SMALL_DESCRIPTOR;
+
+		sg_list = dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
+					 &sgl_dma);
+		if (!sg_list)
+			return BLK_STS_RESOURCE;
+		iod->descriptors[iod->nr_descriptors++] = sg_list;
+	}
+
+	for_each_sgtable_dma_sg(map->sgt, sg, tmp) {
+		size_t sg_len = sg_dma_len(sg);
+		dma_addr_t addr = sg_dma_address(sg);
+
+		if (!remaining)
+			break;
+		if (offset >= sg_len) {
+			offset -= sg_len;
+			continue;
+		}
+
+		addr += offset;
+		sg_len -= offset;
+		offset = 0;
+
+		do {
+			u32 chunk = min_t(size_t, remaining, sg_len);
+
+			if (WARN_ON_ONCE(mapped == entries))
+				goto err_free;
+			nvme_pci_sgl_set_data(&sg_list[mapped++], addr, chunk);
+
+			addr += chunk;
+			sg_len -= chunk;
+			remaining -= chunk;
+		} while (sg_len && remaining);
+	}
+
+	if (unlikely(remaining))
+		goto err_free;
+
+	if (pooled)
+		nvme_pci_sgl_set_seg(&iod->cmd.common.dptr.sgl, sgl_dma,
+				     mapped);
+	return BLK_STS_OK;
+err_free:
+	if (pooled) {
+		iod->nr_descriptors--;
+		dma_pool_free(nvme_dma_pool(nvmeq, iod), sg_list, sgl_dma);
+	}
+	return BLK_STS_IOERR;
+}
+
+static blk_status_t nvme_rq_setup_dmabuf(struct request *req,
+		struct nvme_queue *nvmeq, enum nvme_use_sgl use_sgl)
+{
+	unsigned int entries;
+	size_t avg_seg;
+
+	if (use_sgl == SGL_UNSUPPORTED)
+		return nvme_rq_setup_dmabuf_map(req, nvmeq);
+
+	entries = nvme_pci_dmabuf_sgl_nents(req);
+
+	if (use_sgl == SGL_FORCED)
+		return nvme_rq_setup_dmabuf_sgl(req, nvmeq, entries);
+
+	avg_seg = entries ?
+		DIV_ROUND_UP(blk_rq_payload_bytes(req), entries) : 0;
+	if (sgl_threshold && avg_seg >= sgl_threshold)
+		return nvme_rq_setup_dmabuf_sgl(req, nvmeq, entries);
+
+	return nvme_rq_setup_dmabuf_map(req, nvmeq);
+}
+
 static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 		struct blk_dma_iter *iter)
 {
@@ -1398,7 +1543,7 @@ static blk_status_t nvme_map_data(struct request *req)
 	blk_status_t ret;
 
 	if (blk_mq_rq_is_dmabuf(req))
-		return nvme_rq_setup_dmabuf_map(req, nvmeq);
+		return nvme_rq_setup_dmabuf(req, nvmeq, use_sgl);
 
 	/*
 	 * Try to skip the DMA iterator for single segment requests, as that
-- 
2.54.0

