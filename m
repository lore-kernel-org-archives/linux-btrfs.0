Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AC63B893F
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617636; cv=none; b=IuRsNWSs2Hwy88G2dXsvS6DooLD6UwbGLQzBdf7P8BI+iOtwnsKgaLuImO/cMlPiYBUc5sqhOKbZVjuOalGcds3dlcfQ1vcHlaaUvPsOGrkTsYgbXpg3v/WXQKp91nu1vmA4VHXlk2TdFT7FzSbDLSiriVZ9v/ocH0zsK0EaTvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617636; c=relaxed/simple;
	bh=7Tr5awOvN8ARMx50qRV4E1m+atUWaPqTPP3CIfJTWL0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mAPMAha34VZCV+R8QFWZUNZGBgGRxVAFP3xo2p1BRd48Iv3qim3I/9kVRa3G5fXAj1Rk2kCV372dlUFhL5p5hDLFxviMCcCDQ6XjCNH1xUY1ulgVEC9DYng3jy+7OQmIIoeDWGR5zIikMtVPimRS8yOUlRlZn4x0+1arw6w2ty4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=enb1oKtd; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=HXdfxYaa; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="enb1oKtd";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="HXdfxYaa"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2Yc2O3509264
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=IRD4
	cvB/PgbqUg8e65DYvGtkTJfIxTG28U1epEHrg/Y=; b=enb1oKtdejsWm4oGJmmV
	tDZmCyDkK5dg1iL6Mn2NTo/hvzs7b1fHSN6+FDQpx/gbdu+STHyy13RZcxauQR4B
	xNNzboNXl3VPY/1Fog9HhMCBXz2DY7TyDwzKFtUr+t+hw4lexKHOzqX8N2FqiURo
	KL4VhxB8U/xiaXRwUwB6jB3FMLzmhAEJd3cmA5zboo/XyzokdStw1q+vipwj+vuQ
	RyZ7biqRch00A2z4ZbwNLh0FiMsgif5daUc7ZObX/3//H9965o7P/JzjUv4OIEY3
	LXEhHeudsGd6Kn85f9aHdlMSUCaFglXIbK1UvuseZawf1mMxrsyTWBRaSBS5eiEi
	Jg==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr3swhcyn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:33 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9105cf082f7so7242046d6.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617632; x=1790222432; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IRD4cvB/PgbqUg8e65DYvGtkTJfIxTG28U1epEHrg/Y=;
        b=HXdfxYaan0MJdMcvQ5RKpt5pEt6qsStSYqzFTM4CAEYzSiDAJQlkKxLk7z3ehaUReU
         /qEvGR5lKXKlOAYbXQhc+5aBEcP/FQom7Y/TAlLZc2uQhu5JD1gxY93XGlL3n1ZuxBSO
         Y4nfhbiZmtzCuZH6ZQe4ha+sF3j/uTc+A3ySgVRdwOcFqBXD8U/JthxoWrdQ7i0UbLuo
         5EgkdczIRGG3vjS9xORK9OiFsyfLudoMDXbL9EPeU0im6v3ORQaZpBPQ+sT6Ko5Mxbgp
         uCnqymxPVU8nqj+TrZRb7cBh6XHEWVIKQIFllvT+J8Cob0IuNHWW4JcMZaTdXKdGWk87
         c4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617632; x=1790222432;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IRD4cvB/PgbqUg8e65DYvGtkTJfIxTG28U1epEHrg/Y=;
        b=gFNk2TCNfmHcVBZ3EG1y0O/dqgZajOgZBxSPMZ873eX5L+9dDB9QHF/8CPfe0cHsqp
         6JVjEzAKc/9K2Cu7mPoKtPbSeofifRUub5h5oo5qW4KHpmpuuNXp77WNTYd/fESh86n9
         rXZUdIKligyeUpSHq1DyihZX+1fR0GFOfNrqTNK40Z4kjzV0k0VaBUxgPQyUCd0GZt13
         66IvpTixqnfMlZ+K1pV7J3Z5bXv1WOdliXoKGsshYADU4z2SXQNFKDbTLB5jlthtrOyG
         PqfPQ/8FXZO1X3dAxIKQonc0nQ1XOuxsTBnFifXe2ngiQfF6YRDJSBZQfwHXoeNBhLac
         ghhQ==
X-Gm-Message-State: AFuF++lB0JKV2p3SY4nkUdvFr5rSqTu3UuO8SK/4oz4IRZfX1rnCVUR1
	DzRnqSzYvs3qxU/d4fpj0gaFqDyOBXR2nNHcRZLJdHSTu5TX6htVqArB4yxJrnGjUUyr8OZ5kpH
	heeRQp2QS4olVyvyHIk3ikcOTcb3RjJcaMBJJlp5KM5BQqsguy9xVvTUCVqIhLyVekukc
X-Gm-Gg: AYBFou0aSGl/jYu0uRfqueFU+hmW4VxCDJG9TyJAL/jZqlDioCD/fyAQiHtSF+E9wdW
	429ckWDV7ZLOPPJ5a5MEYOf1DnHuq2Ts/AzE1bPITyxkRcuCyNJVBKAgS0vwwu0Vm3SNGh8unR3
	DVbvRptZpB/PJO3pfycMjkjJBhbTVT/MvHIGtJ+x1N3edv3D/VgLtGy1FfQi9LGar4dJGKOT2Kc
	1xHtCnA9ehqBtwe3PhnHG/8c1LzSkeR2VirTl1qcEE7XuXI2KCtWBwbvRbpBKBQDjW3jvmh2xwO
	eeb7mkNxT9lt+0x8Lchw14vorgRIAWm32I9+oOmjd9dv7pSiVI0E9xEVtfBUw3MoZDZUcksqL+w
	0FUkq5FC2hT90tO0hhHoWt9RlHHKpNUR/oAkEbxnWH2CKtQ==
X-Received: by 2002:a05:6214:cc8:b0:90e:94e5:79f8 with SMTP id 6a1803df08f44-9123d79e028mr93938236d6.23.1789617632312;
        Wed, 16 Sep 2026 21:00:32 -0700 (PDT)
X-Received: by 2002:a05:6214:cc8:b0:90e:94e5:79f8 with SMTP id 6a1803df08f44-9123d79e028mr93937876d6.23.1789617631902;
        Wed, 16 Sep 2026 21:00:31 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:02 -0400
Subject: [PATCH v3 06/17] btrfs: drop the transaction handle from the
 prealloc helpers
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-6-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=4704;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7Tr5awOvN8ARMx50qRV4E1m+atUWaPqTPP3CIfJTWL0=;
 b=+YvhKl5q/F2DKSGYcyHuAT9L87K2gWETNb02lNR67EmJD5+t3w2goWZT2rXbNbn2DLYHFoZmi
 6q+bfXlV7UIAQDhajcMNkL672rJkZOoLIewDTOhWDpTYTH0wqCfz++c
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: eDCXT-i-q5UcRM7TYZJI7mxtYMX5wzTc
X-Proofpoint-ORIG-GUID: eDCXT-i-q5UcRM7TYZJI7mxtYMX5wzTc
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX3DVJt7vNlqd1
 orm1w8yotOIbxWKn3Wd244hk7ntVNauPO0fE0+o831Rvi/WVgOLADcT6xd6wA6PrJTIE59jQeyi
 xlVuovwrsm5j8jPVjOvHmeKcsv4Y1e+BNePgEwG6gLHB1cXXFpH8
X-Authority-Analysis: v=2.4 cv=ac30Dhot c=1 sm=1 tr=0 ts=6aab65e1 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=u1qPvHribVpbYRjuRIMA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX2kGd5mbydtnV
 Q/H+1GE6fwGyxLatxepUXo0HR4Fh8lM5agKg2YtFsEIvBpKr38ckAgwS92cj7xE5yiPqN5Y0xo4
 oMCrObS4PdYJFVpgX8M4NQFktBnGAolFZkH65RfRIAwwxhaHTAblWvzn75i4og6SDANej3/brN6
 Qp6aujvz3UjcH8GCkdYDxL1lo/hGBvrfJfBQw8mvx1HUMborpdtptG7lCNkPyQ+2D9hp9gW48I7
 4hW20B3v3Xlj5Mx3m1mITaqEY6uulP29fMAi5g6akrm/BbRooGcoA8l6Mu7v0VzE2++51QLsfnY
 r1kj50BBhBvEhkKpEoWRwX8zHBauniW06oJoV2ftqa0w6T9qLuEYKccSTZY0vMDANkUPW0YMDGg
 lM43IJFhaPDZ4JVSaWMp3amBmSDMcddJewlSOFQ7i0hFczpx97w6fW+q8FoTYUa5B/Rg5l32t1Q
 91CzVLaZap3sixB5P4w==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 clxscore=1015 adultscore=0
 lowpriorityscore=10 phishscore=0 impostorscore=10 spamscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

The v1 space cache created its inode during the transaction commit, and
btrfs_prealloc_file_range_trans() existed so that preallocation could
reuse the open handle. It was the only caller passing a transaction, so
__btrfs_prealloc_file_range() and insert_prealloc_file_extent() now
always start their own. Fold the wrapper into
btrfs_prealloc_file_range() and drop the parameter.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c | 47 ++++++++++-------------------------------------
 1 file changed, 10 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9c395d075a65..0539f27776e1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9132,14 +9132,13 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 }
 
 static struct btrfs_trans_handle *insert_prealloc_file_extent(
-				       struct btrfs_trans_handle *trans_in,
 				       struct btrfs_inode *inode,
 				       struct btrfs_key *ins,
 				       u64 file_offset)
 {
 	struct btrfs_file_extent_item stack_fi;
 	struct btrfs_replace_extent_info extent_info;
-	struct btrfs_trans_handle *trans = trans_in;
+	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
 	u64 start = ins->objectid;
 	u64 len = ins->offset;
@@ -9160,15 +9159,6 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	if (trans) {
-		ret = insert_reserved_file_extent(trans, inode,
-						  file_offset, &stack_fi,
-						  true, qgroup_released);
-		if (ret)
-			goto free_qgroup;
-		return trans;
-	}
-
 	extent_info.disk_offset = start;
 	extent_info.disk_len = len;
 	extent_info.data_offset = 0;
@@ -9208,12 +9198,12 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	return ERR_PTR(ret);
 }
 
-static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
-				       u64 start, u64 num_bytes, u64 min_size,
-				       loff_t actual_len, u64 *alloc_hint,
-				       struct btrfs_trans_handle *trans)
+int btrfs_prealloc_file_range(struct inode *inode, int mode,
+			      u64 start, u64 num_bytes, u64 min_size,
+			      loff_t actual_len, u64 *alloc_hint)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_trans_handle *trans;
 	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
@@ -9223,11 +9213,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	u64 cur_bytes;
 	u64 last_alloc = (u64)-1;
 	int ret = 0;
-	bool own_trans = true;
 	u64 end = start + num_bytes - 1;
 
-	if (trans)
-		own_trans = false;
 	while (num_bytes > 0) {
 		cur_bytes = min_t(u64, num_bytes, SZ_256M);
 		cur_bytes = max(cur_bytes, min_size);
@@ -9253,8 +9240,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		clear_offset += ins.offset;
 
 		last_alloc = ins.offset;
-		trans = insert_prealloc_file_extent(trans, BTRFS_I(inode),
-						    &ins, cur_offset);
+		trans = insert_prealloc_file_extent(BTRFS_I(inode), &ins,
+						    cur_offset);
 		/*
 		 * Now that we inserted the prealloc extent we can finally
 		 * decrement the number of reservations in the block group.
@@ -9326,8 +9313,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 					range_start, range_end - range_start);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
-				if (own_trans)
-					btrfs_end_transaction(trans);
+				btrfs_end_transaction(trans);
 				break;
 			}
 
@@ -9339,15 +9325,11 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
-			if (own_trans)
-				btrfs_end_transaction(trans);
+			btrfs_end_transaction(trans);
 			break;
 		}
 
-		if (own_trans) {
-			btrfs_end_transaction(trans);
-			trans = NULL;
-		}
+		btrfs_end_transaction(trans);
 	}
 	if (clear_offset < end)
 		btrfs_free_reserved_data_space(BTRFS_I(inode), NULL, clear_offset,
@@ -9355,15 +9337,6 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	return ret;
 }
 
-int btrfs_prealloc_file_range(struct inode *inode, int mode,
-			      u64 start, u64 num_bytes, u64 min_size,
-			      loff_t actual_len, u64 *alloc_hint)
-{
-	return __btrfs_prealloc_file_range(inode, mode, start, num_bytes,
-					   min_size, actual_len, alloc_hint,
-					   NULL);
-}
-
 /*
  * NOTE: in case you are adding MAY_EXEC check for directories:
  * we are marking them with IOP_FASTPERM_MAY_EXEC, allowing path lookup to

-- 
2.39.5

