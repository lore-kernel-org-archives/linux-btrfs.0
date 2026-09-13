Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC0A38A700
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334495; cv=none; b=KrUKBkiWdAclmnxQJTLo7KieQCa/NefWsHrLyBT0ja+e7NVt9NouABfDfiKu4t5BlRDMzuLz1IBJSip4+rnRSbnV8/VS2jTHkrlAgL9yGuXXBasAnaiXPX30txOKT/B1TV33m9h5u7G8YKS4Ssc8WeQp/49Epjp7OphwKnJVor4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334495; c=relaxed/simple;
	bh=7Tr5awOvN8ARMx50qRV4E1m+atUWaPqTPP3CIfJTWL0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eKwCqxnnZ/Bl0EBt9HvOw/At3QrAfKFraEMqzkceFmMQB6+DO/BkhfYhmo81X6uR0lVlrXzHY0flrcF2L5KtF/dZm7kQ21bV86oF+MdgJRxNqaDUjkxxgLvOrYhKLpfsagmTk3nE27CRqLYhPlOMSXVP3zezsZl/bbKAxnGbB+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=CN72aqt8; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=aYbtVMj7; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="CN72aqt8";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="aYbtVMj7"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKXkUG634526
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=IRD4
	cvB/PgbqUg8e65DYvGtkTJfIxTG28U1epEHrg/Y=; b=CN72aqt8PuaYKVboi7na
	YIn5c07SEL/CzSXJlChDX3benrPGM/Z0tvRDEbeZd25IcEHszE67f0qOC11KE3iD
	EpEZTj2vW9gxDeLFIgBfmBcfgvzpCd57fgtMxfZP0LeXxYhG5rKtg9Ly+6RDrs/m
	ykp5Jel08AhTTrE+uBJ3wIzcQNXy1+JnNdZZ/YbQcg+f5QgnJqXixUvicdekH1U9
	/WhxL0QmzFooVnJc8OCfcawHT7vw7F9Fe4ydT3ASZ9WmS0fWNBwpdDCZUrUIZRoy
	S1BErUJe27L5hEqsFj5x/+q+DxMGJV/k7IumMWZhiHPjLoipPFZAFx9OrSTGfq8n
	Pw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gnwac9nwa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:31 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52ff59f2c47so66508531cf.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334491; x=1789939291; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IRD4cvB/PgbqUg8e65DYvGtkTJfIxTG28U1epEHrg/Y=;
        b=aYbtVMj7TNfYqbSfR9pk9ons+qxrn43s/aSVYY7bWPUPhehcIuCGHMAPvQX8GEmU5P
         Nez2JcFoFV0nPPuBUPFreXi8PkYdRNpIi1/qDev8rJ+wm2H2HDCd4U+JjrXSstWA5kaI
         tGs2jdCaBKrfUngcal2sZCwPEpGowyg9fekcBpic7AEDosS4KUc6EZQCCf50/lPNdzIO
         Fra6poWRWbBq8gjlYPbBkiE9hLvCXdedzRsHOSAh0UiYyg+ansP6sXF3CZJHvXlDWyNI
         lyHLnpqkckSXkyefgaoHhLAyZXZlndErnMB1AYvh/U+ZFfBhMT6UeBnruQowJwkzyDOz
         QFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334491; x=1789939291;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IRD4cvB/PgbqUg8e65DYvGtkTJfIxTG28U1epEHrg/Y=;
        b=B3Vm3294111NG2wK9+1s3/uwHXlOqw6Bn/qshJMIMRdAX2JR3d9DfX2zBCYcHbu0+8
         V+jSAqk3uW+Ekf10+fVMpdTh7w7P/m05hAkQO0KeylAvI55GtkVBWrjTv+hHZIoC0HEb
         /Jgn+M4ZwzZbXYmQ7YbCcbjl3fnTxKAukxKTn7P2HvpYJbsFNOSVyKabWX136tpvY78g
         0v0R2ZFjeihll3JsL5DenEtzphN8vuVhfXpEkhTNzchAQq2wYwRq4iQ8V1fPoLKpn6Y4
         zfRfDOT7qqmu7tjgYdKPF66LGcR7SEUtaZfI87UDpJ+WyIRfvwGxmf6qGlxqaIZpB1Aq
         oDhw==
X-Gm-Message-State: AFuF++kDeJRxwPunFkXXHalE8SYXd3BgvWupE4BR5glkcCicY0URlG1X
	tl8t9eMijjSUTcs5J1zOvUMJZV/hdtO8iywRTXdlM5OoS5q72co0jKs/ra8dys1ND1VHW02A8Cq
	Siz5dT8XKzDSnXnUtFs76U7iYz5su3xDR1ckamZ8F/ftccDxQxPHL2QWOu/qH
X-Gm-Gg: AYBFou0d6xtumA+qSLtDD56Bpi9t4m9W27VnbSgXBRlTVA7f9EqxNCycr3X0a7UGe+D
	ne9l+MaSZuyNoBoe7MvFXH93mfpXrVjmvANoabvBbFz+xYVlTP1IDYD545DaTdQGcNemTLZGqOJ
	BZ7YryPHA1+E74A3cLwOf5y4D3xzgGE5z8zqRUfct1mKUGLWWh3uitobemInmhVFn+Fr0AQmuKT
	EkieSTxZHsqyZpjY5RQ4LQBEnMQqvZWyp/lG0VtgCfKjPya/7r4jOh/83VSGfqwsKJyl4/QcFSJ
	2V4KxefFukPTXf1cU/cwSRYXN/4D0n1FaVPrS93Ur8hO4U5BpqJo31UiIMdYkvhpRmE3DyofUFG
	Meyr4dkq1Y/q4kETyFXWdxvGfdzM2fSxl2klLyaEdqKFnOWC++AW3+A==
X-Received: by 2002:ac8:5a94:0:b0:530:fa1b:1281 with SMTP id d75a77b69052e-530fb6aac99mr41722721cf.38.1789334491179;
        Sun, 13 Sep 2026 14:21:31 -0700 (PDT)
X-Received: by 2002:ac8:5a94:0:b0:530:fa1b:1281 with SMTP id d75a77b69052e-530fb6aac99mr41722591cf.38.1789334490784;
        Sun, 13 Sep 2026 14:21:30 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:30 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:17 -0400
Subject: [PATCH v2 05/16] btrfs: drop the transaction handle from the
 prealloc helpers
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-5-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=4704;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7Tr5awOvN8ARMx50qRV4E1m+atUWaPqTPP3CIfJTWL0=;
 b=zO4kggQ/Z2SBWjDhsYedxSqB2KI4fLyZsw9A+ImtzB18HzhWhX6a4m2JwDWkzzGnRirchb8at
 /mX8xBkwsiSBMGZIX6lZ0NxEayNWJ4rJGw+lwnZg9t2OBVHHJVdOIR1
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=BqQIUoX5 c=1 sm=1 tr=0 ts=6aa713db cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=u1qPvHribVpbYRjuRIMA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: aIsm_uE9ZsVnt2RqHOW-xhxO_i7UQ_mT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX04BnM5dDhAAG
 qRVflWJXIw8YMy42cvzfFZrsRjeUKk73rRXWJRBTmnZ+Uz3pWJzSs1tbruRS3+3hY/REMfRMicf
 6Ne4QCUzGABPzUWlEh9eaIyHkQeb2aHgF14qh/yFl8komsZyXe1i
X-Proofpoint-GUID: aIsm_uE9ZsVnt2RqHOW-xhxO_i7UQ_mT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX2PRwK5n34V2n
 N5NmlPxOEX4k8x2uybVJZKwMHDq9AyfFE0O6VNbq1o2Ei6Rrkx3HFE/cAmhWOHAa6T0WG9/rg4W
 /HevWYk49W5wiaR/RAWA6xERMnrck7ZtCtL8LQaU/xCZ/V2vwgYHDP7SyrZI24Qu3tuD0Fjca/q
 kZWQJEATERLvfe+Vi6NC9V6wlCjGj1R225ilnMsWNK/eZMqTQo74mHzVHQCezO18NclYVdUGBSw
 CEy5EfKtmRM4lp4BIIvXjjmjXJxfybHHMU4OYoi/xY2MS0nxzwS4uMK7O9PoO4zIE3RA7mHCTu5
 pd8Z3jmBK/7nPw1Or37/bjMBQ+BXcbkzNGn2zfON7LaSpV9zddf8sz4/NCXxk8ao92d7L8o5/1H
 EB5w6vCCgQmam8bhP6yvd4jSCDwqoYqgSuwPH+3jNXGccClfU4G1842t3roqQj5z8LfHW90u2Kp
 M3actEX+XUN4d+QtkVw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=10 impostorscore=10 clxscore=1015 priorityscore=1501
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

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

