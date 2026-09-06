Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3168F3CAE95
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733816; cv=none; b=lbsIo9MkKu6bwHsXoSm6cqpCIkRceJAWcykCWpL6hTkpnctjjpyOvTA49D8ion3PLkH9LyvA2L8tGwxDaJ2Ai4WiddH/5PE0WMITHIa3bfgImf+/ldsGi4m5VBicJDJHj3uWiiowyZQP3mgf1rulyz5rmSNkBGnk2Fq28ZSUMtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733816; c=relaxed/simple;
	bh=IjfzXRwU/hLOaaljSbSrt1lPEak09RokNBTtFG5ySWA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ng9sKiOhs5TIEMNT5/j6gSE3W0hNn5p+vV64hgk7mq5U2Fwh4VTHUdNcj2C/JHt5wEc/tLX1epccD0SL3CubtIY9QC8uYjM/V1gGWKuPTetum62t0x+RSis9G57eX91lsboHpJxyuT4w18hjjWIw8WT1IDfsWXHKtq7aO0ZGwJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=MJ214Xj3; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=PZWcKyAx; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="MJ214Xj3";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="PZWcKyAx"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686KR0SB454499
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:30:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Wd6I
	wRl9MhkPDhNn3khF2B38jxGMBzWznnvHyyJMLss=; b=MJ214Xj3cft9kaHjwcTX
	9IBNdqJn/dxDCeNiv+hn6jqN2vMASScsXisaN+t1g+fnZ+0r2KyHTusJnubxunie
	KiSSu+aDZZqnWII+Z7cSOWm1HTBz4Rkh8NIbFQs4nVI0xddIYbdrYm1pJxFJ1gNb
	KM7jvWfdu1wfFnVrxVo8tvE8VJUY8mUtVWCU/+bg8mOQmj7+oTcQhyM8zXrby9Qc
	qqoQPOOMFAqzHXC10BLaVhpC/XEBaFE+IjUC9qaUZrwPPkDTw4QjxXJT4m/uOELz
	EL+9BrExI1oOWgef8MfJYCGmJPLeG3PXDeKqANurgUfKSuHKymL2isNRb6txFBdX
	Vg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghf7k0cnc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:30:01 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-53088a3939aso2385781cf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733801; x=1789338601; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wd6IwRl9MhkPDhNn3khF2B38jxGMBzWznnvHyyJMLss=;
        b=PZWcKyAxYmKS8IuvA2fH9oV/+/3JYw11I7SAdnqWwfht+GP+mJndK5pwrfs40QPupe
         KO+2EL4r7zEYqCdScJ9bgmYunEJxJ1z0cVYSU676oROGxz0QJgdol65ZrU0uWoiA+S4l
         FVR2EtBKJP0ZauB3c71eM70+B0YpyVQIWkjJHZfitufxCgF57X04uhEo3tQ7WBZ8w6SN
         C/G4NfPL2x486zr7YS35cP2wUjbcW0ov5n8bf9kYjZr6knRc4ACwtS3NW2SIohUrXaky
         fYB/gOlyY9oH875ZJixj7ACCBDNKIEcXG99StlMyswBtgBsuQ4RCRHdWuN7+nKXEkb75
         xsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733801; x=1789338601;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wd6IwRl9MhkPDhNn3khF2B38jxGMBzWznnvHyyJMLss=;
        b=oK9M/fIdIc6yZ9K0fwdrGj7HQXWnfTXS3tXgnHbvbQdmW1OpfRmGlGn0UyfZutGAWS
         ZNg2TPb2Py68FxKd5tHv5INv/1a4L9bijvMUao8NqW9IWmrfzb4zuxt8Gu7NZrtV7ebo
         r1ejMabUgrbJrGSW8DYYklBIzkK2yxPelV4BeqkzeScGRvtCat/vM8qUc5AN4T9TfTof
         deV8BHYKSsyJ/CPEh4UXz12EYVFeg/AR8YGYyVVXx1H7pSDszfREqfaKYcIjXFZAy54r
         CRGHDfLlQMxafk7duC+/8imta0hPbBnRT3VI+0I4hXeSafUiOkRNCcoN0jwYHWliU0tP
         9FLA==
X-Forwarded-Encrypted: i=1; AKwUvBx101Ek1aRT05dAVgjtTCNadyaw6ABz97eXxWwxlv+8NprlTVQRntdrM9m5OuanOAzvii4uKuAIkfJjiA==@vger.kernel.org
X-Gm-Message-State: AFuF++my2fnZa953N14hABYMGqb2APVg88Gu4pl1sjPUeH54ilvABDxV
	k9RBtwMULntx33/LZnwJ1NTew0yi8MI83kRusD/IBm9cKmB1JgbmYk4TEFds8a4UpCZqCYsuRMM
	kcUrT6jRGN78TP/EBjvU5Cs8DapdZa75DHBs5wRBHlnP6mhk7GBc5m3tOEpU7
X-Gm-Gg: AYBFou2CA9m0fN2v8aYiH8HT27xYuAfb5wD7Bo5Qbk+nsLIeIJgO79vXf386jJ0vupE
	2Figzmdfie3shoenykRWosnATIdmyvTmQp3nnxKDyfR8k6qs9d989xxFBeT2jwlQPgBezywmD/X
	LFP43CDLQbm2YesSWwDw2QLOrQa27IfKWJuUblkhxjaaogxzz3kEcgrykEvePKitqVNqiFJlNqj
	BVO0WPI+WAiEAl0dVX6ym0nsjJV5ilUoOZMSrNyCPK9i4FPswlULOSdp6Yz62jMEtWNUhpqqwUn
	uBmwSsFXl3gi+LTb14CNuw5XiuNbyP5Ze0gxNEz7aoUGU8OJdzKFbfEeDjqWtZU/TZtDzGmF0ie
	yC2q0v+unQVpxJmiFjX4Z13sdeQz9EKk3MoWjp852S9NBKyrE
X-Received: by 2002:a05:622a:598a:b0:52d:f484:eefe with SMTP id d75a77b69052e-530549cdc4bmr225375431cf.35.1788733801417;
        Sun, 06 Sep 2026 15:30:01 -0700 (PDT)
X-Received: by 2002:a05:622a:598a:b0:52d:f484:eefe with SMTP id d75a77b69052e-530549cdc4bmr225375011cf.35.1788733801008;
        Sun, 06 Sep 2026 15:30:01 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:30:00 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 06 Sep 2026 18:29:37 -0400
Subject: [PATCH 10/10] btrfs: rename io_ctl page helpers to folio helpers
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-btrfs-folio-conversions-v1-10-834b9d7b06f5@columbia.edu>
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
In-Reply-To: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=9947;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=IjfzXRwU/hLOaaljSbSrt1lPEak09RokNBTtFG5ySWA=;
 b=rfix7KIOOcwIcJadr9Zc6TTjpfljPWo2ktLWQWhfJJbfyThkqonOxtvV+wHX+E4Q8MvYcEQAT
 ZY9ZpTnuMHZCVHPSbsnwD8zikY7lPKC4iy04QrG5RewgWvEyCdWDO9D
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: bKvCWjLOidjN2ttlRKbCGs2PO9LfUqXd
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MyBTYWx0ZWRfX+4CM54KffXXx
 LK7fgn7qb9ie/rLy3WJF3YBsuDte5NMF+4BAcvBSgDpaJzZc6C9BphXHr3Wg8hLuN4/jmPFFiXq
 +MY1cyOH34ZHas1pwVlW24n4KPrfFVNHMWWBZ+FVfE0OhX8hiV4X
X-Authority-Analysis: v=2.4 cv=QeBWeMbv c=1 sm=1 tr=0 ts=6a9de96a cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=BohlxdOq2c65gZUs6TYA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MyBTYWx0ZWRfX0poV0azTZnvS
 L3QUE3vLsnDubDz8jNrx2OzlTr6lxC0FNANBlEu1BHL6UZ9oRzLuofdeEyt0kU+a6e/f6MaRRI4
 Hyldib/XdGyBkbzATI1fJr9vsv+7P5cNJfTobyHAbbOzjFoBYZvjCEx/Fw35TUoV07PDOafOIMr
 FWqJ6N3JjQaA2fLQRUlOpxEPL5NCtX2rq2IUvOUwCQMYJo0O8DnHSWug96g5TcwWQrrDTh1F4pR
 7zEO4SvHuhdffZpx2g7oTgCLa0fsR/Q/9loantaRxMir/D9VSNVGdU4F5Nci9d9ZZ9ZM0tILEiI
 pfBktpICWYYKoOzTwLKB71Kq3rL419Eob4RPcmOqDBRKMRqmLZy7RnHIPHhtP1P4cFpNH9fRRwL
 E4mHDwRBDMFrMdcSfM15lRydXEYB8HhZ9BzADbi+J3DcwmgeUaPteEB8Kc/MefN96fhfbdEz53/
 PZtS3HmEALnpiyh2Ohg==
X-Proofpoint-ORIG-GUID: bKvCWjLOidjN2ttlRKbCGs2PO9LfUqXd
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=10 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=10 clxscore=1015 impostorscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609060253

These functions now operate on folios. Rename them and update comments
accordingly.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/free-space-cache.c | 78 ++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ab933ee6f19c..73cfc1d1a5c1 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -406,7 +406,7 @@ static void io_ctl_free(struct btrfs_io_ctl *io_ctl)
 	io_ctl->folios = NULL;
 }
 
-static void io_ctl_unmap_page(struct btrfs_io_ctl *io_ctl)
+static void io_ctl_unmap_folio(struct btrfs_io_ctl *io_ctl)
 {
 	if (io_ctl->cur) {
 		io_ctl->cur = NULL;
@@ -414,7 +414,7 @@ static void io_ctl_unmap_page(struct btrfs_io_ctl *io_ctl)
 	}
 }
 
-static void io_ctl_map_page(struct btrfs_io_ctl *io_ctl, int clear)
+static void io_ctl_map_folio(struct btrfs_io_ctl *io_ctl, int clear)
 {
 	ASSERT(io_ctl->index < io_ctl->num_folios);
 	io_ctl->folio = io_ctl->folios[io_ctl->index++];
@@ -425,11 +425,11 @@ static void io_ctl_map_page(struct btrfs_io_ctl *io_ctl, int clear)
 		clear_page(io_ctl->cur);
 }
 
-static void io_ctl_drop_pages(struct btrfs_io_ctl *io_ctl)
+static void io_ctl_drop_folios(struct btrfs_io_ctl *io_ctl)
 {
 	int i;
 
-	io_ctl_unmap_page(io_ctl);
+	io_ctl_unmap_folio(io_ctl);
 
 	for (i = 0; i < io_ctl->num_folios; i++) {
 		if (io_ctl->folios[i]) {
@@ -439,7 +439,7 @@ static void io_ctl_drop_pages(struct btrfs_io_ctl *io_ctl)
 	}
 }
 
-static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
+static int io_ctl_prepare_folios(struct btrfs_io_ctl *io_ctl, bool uptodate)
 {
 	struct folio *folio;
 	struct inode *inode = io_ctl->inode;
@@ -453,7 +453,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
 					    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
 					    mask);
 		if (IS_ERR(folio)) {
-			io_ctl_drop_pages(io_ctl);
+			io_ctl_drop_folios(io_ctl);
 			return PTR_ERR(folio);
 		}
 
@@ -461,7 +461,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
 		if (ret < 0) {
 			folio_unlock(folio);
 			folio_put(folio);
-			io_ctl_drop_pages(io_ctl);
+			io_ctl_drop_folios(io_ctl);
 			return ret;
 		}
 
@@ -472,13 +472,13 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
 			if (folio->mapping != inode->i_mapping) {
 				btrfs_err(BTRFS_I(inode)->root->fs_info,
 					  "free space cache page truncated");
-				io_ctl_drop_pages(io_ctl);
+				io_ctl_drop_folios(io_ctl);
 				return -EIO;
 			}
 			if (!folio_test_uptodate(folio)) {
 				btrfs_err(BTRFS_I(inode)->root->fs_info,
 					   "error reading free space cache");
-				io_ctl_drop_pages(io_ctl);
+				io_ctl_drop_folios(io_ctl);
 				return -EIO;
 			}
 		}
@@ -492,7 +492,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptodate)
 
 static void io_ctl_set_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
 {
-	io_ctl_map_page(io_ctl, 1);
+	io_ctl_map_folio(io_ctl, 1);
 
 	/*
 	 * Skip the csum areas.  If we don't check crcs then we just have a
@@ -521,7 +521,7 @@ static int io_ctl_check_generation(struct btrfs_io_ctl *io_ctl, u64 generation)
 		btrfs_err_rl(io_ctl->fs_info,
 			"space cache generation (%llu) does not match inode (%llu)",
 				cache_gen, generation);
-		io_ctl_unmap_page(io_ctl);
+		io_ctl_unmap_folio(io_ctl);
 		return -EIO;
 	}
 	io_ctl->cur += sizeof(u64);
@@ -539,7 +539,7 @@ static void io_ctl_set_crc(struct btrfs_io_ctl *io_ctl, int index)
 
 	crc = crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
 	btrfs_crc32c_final(crc, (u8 *)&crc);
-	io_ctl_unmap_page(io_ctl);
+	io_ctl_unmap_folio(io_ctl);
 	tmp = folio_address(io_ctl->folios[0]);
 	tmp += index;
 	*tmp = crc;
@@ -561,13 +561,13 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	tmp += index;
 	val = *tmp;
 
-	io_ctl_map_page(io_ctl, 0);
+	io_ctl_map_folio(io_ctl, 0);
 	crc = crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
 	btrfs_crc32c_final(crc, (u8 *)&crc);
 	if (val != crc) {
 		btrfs_err_rl(io_ctl->fs_info,
 			"csum mismatch on free space cache");
-		io_ctl_unmap_page(io_ctl);
+		io_ctl_unmap_folio(io_ctl);
 		return -EIO;
 	}
 
@@ -595,12 +595,12 @@ static int io_ctl_add_entry(struct btrfs_io_ctl *io_ctl, u64 offset, u64 bytes,
 
 	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 
-	/* No more pages to map */
+	/* No more folios to map */
 	if (io_ctl->index >= io_ctl->num_folios)
 		return 0;
 
-	/* map the next page */
-	io_ctl_map_page(io_ctl, 1);
+	/* map the next folio */
+	io_ctl_map_folio(io_ctl, 1);
 	return 0;
 }
 
@@ -610,24 +610,24 @@ static int io_ctl_add_bitmap(struct btrfs_io_ctl *io_ctl, void *bitmap)
 		return -ENOSPC;
 
 	/*
-	 * If we aren't at the start of the current page, unmap this one and
+	 * If we aren't at the start of the current folio, unmap this one and
 	 * map the next one if there is any left.
 	 */
 	if (io_ctl->cur != io_ctl->orig) {
 		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 		if (io_ctl->index >= io_ctl->num_folios)
 			return -ENOSPC;
-		io_ctl_map_page(io_ctl, 0);
+		io_ctl_map_folio(io_ctl, 0);
 	}
 
 	copy_page(io_ctl->cur, bitmap);
 	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 	if (io_ctl->index < io_ctl->num_folios)
-		io_ctl_map_page(io_ctl, 0);
+		io_ctl_map_folio(io_ctl, 0);
 	return 0;
 }
 
-static void io_ctl_zero_remaining_pages(struct btrfs_io_ctl *io_ctl)
+static void io_ctl_zero_remaining_folios(struct btrfs_io_ctl *io_ctl)
 {
 	/*
 	 * If we're not on the boundary we know we've modified the page and we
@@ -636,10 +636,10 @@ static void io_ctl_zero_remaining_pages(struct btrfs_io_ctl *io_ctl)
 	if (io_ctl->cur != io_ctl->orig)
 		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 	else
-		io_ctl_unmap_page(io_ctl);
+		io_ctl_unmap_folio(io_ctl);
 
 	while (io_ctl->index < io_ctl->num_folios) {
-		io_ctl_map_page(io_ctl, 1);
+		io_ctl_map_folio(io_ctl, 1);
 		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
 	}
 }
@@ -666,7 +666,7 @@ static int io_ctl_read_entry(struct btrfs_io_ctl *io_ctl,
 	if (io_ctl->size >= sizeof(struct btrfs_free_space_entry))
 		return 0;
 
-	io_ctl_unmap_page(io_ctl);
+	io_ctl_unmap_folio(io_ctl);
 
 	return 0;
 }
@@ -681,7 +681,7 @@ static int io_ctl_read_bitmap(struct btrfs_io_ctl *io_ctl,
 		return ret;
 
 	copy_page(entry->bitmap, io_ctl->cur);
-	io_ctl_unmap_page(io_ctl);
+	io_ctl_unmap_folio(io_ctl);
 
 	return 0;
 }
@@ -797,7 +797,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 
 	readahead_cache(inode);
 
-	ret = io_ctl_prepare_pages(&io_ctl, true);
+	ret = io_ctl_prepare_folios(&io_ctl, true);
 	if (ret)
 		goto out;
 
@@ -869,7 +869,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		num_entries--;
 	}
 
-	io_ctl_unmap_page(&io_ctl);
+	io_ctl_unmap_folio(&io_ctl);
 
 	/*
 	 * We add the bitmaps at the end of the entries in order that
@@ -882,13 +882,13 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			goto free_cache;
 	}
 
-	io_ctl_drop_pages(&io_ctl);
+	io_ctl_drop_folios(&io_ctl);
 	ret = 1;
 out:
 	io_ctl_free(&io_ctl);
 	return ret;
 free_cache:
-	io_ctl_drop_pages(&io_ctl);
+	io_ctl_drop_folios(&io_ctl);
 
 	spin_lock(&ctl->tree_lock);
 	__btrfs_remove_free_space_cache(ctl);
@@ -1280,7 +1280,7 @@ cleanup_write_cache_enospc(struct inode *inode,
 			   struct btrfs_io_ctl *io_ctl,
 			   struct extent_state **cached_state)
 {
-	io_ctl_drop_pages(io_ctl);
+	io_ctl_drop_folios(io_ctl);
 	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
 			    cached_state);
 }
@@ -1297,7 +1297,7 @@ static int __btrfs_wait_cache_io(struct btrfs_root *root,
 	if (!inode)
 		return 0;
 
-	/* Flush the dirty pages in the cache file. */
+	/* Flush the dirty folios in the cache file. */
 	ret = flush_dirty_cache(inode);
 	if (ret)
 		goto out;
@@ -1402,8 +1402,8 @@ static int __btrfs_write_out_cache(struct inode *inode,
 		spin_unlock(&block_group->lock);
 	}
 
-	/* Lock all pages first so we can lock the extent safely. */
-	ret = io_ctl_prepare_pages(io_ctl, false);
+	/* Lock all folios first so we can lock the extent safely. */
+	ret = io_ctl_prepare_folios(io_ctl, false);
 	if (ret)
 		goto out_unlock;
 
@@ -1443,10 +1443,10 @@ static int __btrfs_write_out_cache(struct inode *inode,
 	if (ret)
 		goto out_nospc;
 
-	/* Zero out the rest of the pages just to make sure */
-	io_ctl_zero_remaining_pages(io_ctl);
+	/* Zero out the rest of the folios just to make sure */
+	io_ctl_zero_remaining_folios(io_ctl);
 
-	/* Everything is written out, now we dirty the pages in the file. */
+	/* Everything is written out, now we dirty the folios in the file. */
 	i_size = i_size_read(inode);
 	for (int i = 0; i < round_up(i_size, PAGE_SIZE) / PAGE_SIZE; i++) {
 		u64 dirty_start = i * PAGE_SIZE;
@@ -1461,17 +1461,17 @@ static int __btrfs_write_out_cache(struct inode *inode,
 	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
 		up_write(&block_group->data_rwsem);
 	/*
-	 * Release the pages and unlock the extent, we will flush
+	 * Release the folios and unlock the extent, we will flush
 	 * them out later
 	 */
-	io_ctl_drop_pages(io_ctl);
+	io_ctl_drop_folios(io_ctl);
 	io_ctl_free(io_ctl);
 
 	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
 			    &cached_state);
 
 	/*
-	 * at this point the pages are under IO and we're happy,
+	 * at this point the folios are under IO and we're happy,
 	 * The caller is responsible for waiting on them and updating
 	 * the cache and the inode
 	 */

-- 
2.39.5

