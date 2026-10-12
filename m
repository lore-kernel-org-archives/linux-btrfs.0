Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8B24B4056
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822528; cv=none; b=DcQ/mBFPnI9nYoruWLQvQIhBPiUngjSOz4u9dZT5ZBdQDZe6Ou3hmp3MU+JTQqxBdZIYUiotoobFXXE1h5Nru28dz+LBRjofN/tuWboWZzqu/eYeveOmAArF3uAo3ZVjDfCR65+VaEZY6qOH9gmzBrzMnB8j26xH5YTsjdVtRkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822528; c=relaxed/simple;
	bh=uxR57VbSHtp1aqLOsgEPT8x0WECGBWUquczUd2tk5/o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ALhSHOaekODSAESRRHsh2rOTLCdC1C0XhJJ+n0TosqD1GdfG6dIpiwEcgiKQIatV7EkNgEZy30JCNFtdiNYj4G6MxUAPWVixvhF9gQFvsvrCNRkZi5Yz/NrZcvLumCadEtj9Ho7IPBX7axYk5D4/zGe8vDubFidw9IrUAtF2njI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=R+5xAEpB; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=xwgkm1jZ; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="R+5xAEpB";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="xwgkm1jZ"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CFPOFI850042
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=YW5H
	T2u5ekA6cpwOBjjzNZKv4rChZ6o3Jf6QZzjBQvA=; b=R+5xAEpBzyl5ZyMC18er
	GvkuDw7kQWRv3yO+1t1bZbDo+mvZjltuY3L8Ul1W3EA4qBcEMNNW/Au8zgTQzOJ8
	HL8pFzUVI/v0b8hA83mdx7kl/FEcEjjKDkj7ocKq7Bf4ezRdB1chLB/2j7V4CpY9
	gXDSBGRA0rYk2WO0vI6pqIeYjNyPLA2oFJEvw4IWEgzJOcrf05exiTmvI4r1nQPH
	12b3dS7hgtw/OTOSZ3hhgHwkxYvz9vhDqZTmglTb7nhn4J1Rknsk5TYm00waHUda
	yrkc0EFANaa+SAOhaF+n6+LYYSTVwoBDI9op6HHHQi5VXomzAm3c6is1ULxJErJd
	MQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h92680q1r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:45 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93cb71b1443so447806885a.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822525; x=1792427325; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YW5HT2u5ekA6cpwOBjjzNZKv4rChZ6o3Jf6QZzjBQvA=;
        b=xwgkm1jZIJYVRgLAizcnEULdnbNCTPkxqKbXtKbZuxtaANaeUmZEOQhAkGG0cmcz39
         sHFIysKhAjuPxPFTuL4kHwF+Po4dBvucyayrVSDRY4xz6vo7hbzkzFi+iPuwstGN8q6s
         NFM884MxK7THdrJBYWA2Mx9UnwPSxNx26WvLJmDqfLwAVCffK7x0Gw+95lH8JYixgnG8
         dkfcJ6Zzzz6kDnVcQetjxJp9LEcUzrGN4Wwtv057u2/nmZIf1/E2SdnC4zJu3M3Waj/z
         dCfUJC4djUB/E0R5u05wHE4tZZLhNcIvDG/xL6Z/kih11FFSy0G+q5YuZJ3aSb6loDap
         OIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822525; x=1792427325;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YW5HT2u5ekA6cpwOBjjzNZKv4rChZ6o3Jf6QZzjBQvA=;
        b=YRerXXUBXsaVcXwtbf4FFCotzqm9cx05tBD6zDtaR/5gRM4UGgHW8n7R2FNiqv32o2
         d/VwZJ/Akr8ImgsPFOlVboAk+ina5B4jMhw8FkOLc1eMrgo7fzHwSidS5EfC3EzE0QZE
         +VoPZo2s9SQsUOYWvXs/R2lVtwpWrYDoVZh+plQCTc7dXH3aGjQvqN4DqpZWrqZbcZcA
         Ry7sDKDwgaahpRBJiipzQd63zrCjoRiDyD5MaC7BGz+h7pU/FSpgH2lagNwVn+BBhN8l
         kiYvv8crRLFIChNnCt6vcynBScrpFRXZqUmEvQV3/VxPQMkICYXUcADKoExx56Xwuknv
         pu6A==
X-Gm-Message-State: AFq9FYJNkGzgNlKyMlLQN1acs7v3rl/THu2zCIuJqji1AwJ/3c8qS9vg
	hmD1XCiAXlWAI2jT36dX8BeE02TECM0cUgEWmrtZxCNBdZlD/+6UClTtd/YdZfbgjbr+vTlBtGN
	g2NuBlqtekT6/g3c1ciBvYvZ3D+ZNlvLHP9NqQFbv8Pihh1dV+ZAit1xlG9u0
X-Gm-Gg: AYBFou0zQloc+1hNa+AiG0j812YCGxX+Nck5pRtl4eV7GI1sIankaVuI3JpZw5RxA6E
	NX0A58ywycBimLiQaguddJUhLqYKzuklvIhu8m6AxLYxn3YekimH4cQEPxlJLTioa+jagbFpvrK
	/bBA7esgNhEwJS82oRKVDVXWaYC22j5SiTNPAfhpl0TuhHnHHof79K16GRArtipOXy8Tsry+yoR
	ocl9tU9uOQRcF4Ti714VXHl7epxjuNc8AeF8mB/JoE+kvJFFi9jkKjnebzQb5+YkiAMZl74BGwb
	vMLM53fNdMx3yCvUz3xYjyuvh1iFZPtKzeXr3xZAwC/6+Bb+3ImTlmlu9ggXk30ypG+y/0aMXyq
	8iV2Zfzc+XhnG15TewRlfuFP/b6jCsIKDStDASwNwoP7dA3Y=
X-Received: by 2002:a05:620a:2612:b0:93e:6723:9de8 with SMTP id af79cd13be357-93ebd2aad11mr1447147485a.59.1791822524870;
        Mon, 12 Oct 2026 09:28:44 -0700 (PDT)
X-Received: by 2002:a05:620a:2612:b0:93e:6723:9de8 with SMTP id af79cd13be357-93ebd2aad11mr1447143785a.59.1791822524330;
        Mon, 12 Oct 2026 09:28:44 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:42 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:19 -0400
Subject: [PATCH v4 07/18] btrfs: drop the transaction handle from the
 prealloc helpers
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-7-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=4684;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=uxR57VbSHtp1aqLOsgEPT8x0WECGBWUquczUd2tk5/o=;
 b=1OpsHLI1+pjS+AnFeYXBQPbrknn7LAoncIh+qbwK8YH7UyuZbLDXJgoH7g4Akm+mlQ03GMF5l
 vp4cg1NU43gCA/dXtDCx1IK6lBJyaEdSwSShPW8FTXlMkpZbP8s3UdH
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: r-MIiWuH931hBba3jTdXbgUEIljYcGFI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX/ch6N4iLmW9L
 bUn++NHrAQ0vK4urXzAH46EOW2soWRg9Rb+SHt4JltfhTO6wbUOtp4yZyeFs/1M1OI7ZRwLxTig
 5+DiRY+kmCaFMmIhWFJqAe3oV6Yzswdjc4LaB8S2s0ngTTvvNJtI
X-Authority-Analysis: v=2.4 cv=EbZd0/mC c=1 sm=1 tr=0 ts=6acd0abd cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=u1qPvHribVpbYRjuRIMA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: r-MIiWuH931hBba3jTdXbgUEIljYcGFI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX5zEdpR5HOaxi
 6nzFBfzcSEzoGFCyx0Q9Yhb1UVws+Br/JPQKA/AHJzimt9Q2COoq1iLOs8yLIqMFSX48k8hHKWp
 SVJViJ5Q8hFLYCRsuSEC+RzqwU6Kc/YeEUn1TjjwdBbUMx/buCgfgHuquKFCfpiADl3EytiT6Ga
 gje993tOS3i3PJZF1nrhzfmiaCUSJafJrRH19ongNmp2Qdj2rf8jBzVvyryeBMUmCV2/5vsfvWq
 h9/gwzjAeFQ6L8PKLW4BgnTC4le+juh/5HzcSWlAPMLXC2/k7CHCD1LOCLWqzLJfl4i96UyNy8C
 vHJjRXucRdNY/IgNP0EbaifMPaG4s5ZLkGFXgy/+tQEFweeh7Errj/3TnjVq+81PFwsdji1MMDm
 pHLXFS9A9RgRW5dVPUhEFd7RIKpe0vVQ6vR+OOC6wgjQQbDlwcCL6kBkoVebE4jlHaNIkRFLuWz
 LornSKWW5SgjIEgR3sg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=10 phishscore=0 spamscore=0 malwarescore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

The v1 space cache created its inode during the transaction commit, and
btrfs_prealloc_file_range_trans() existed so that preallocation could
reuse the open handle. It was the only caller passing a transaction, so
__btrfs_prealloc_file_range() and insert_prealloc_file_extent() now
always start their own. Fold the wrapper into
btrfs_prealloc_file_range() and drop the parameter.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c | 47 ++++++++++-------------------------------------
 1 file changed, 10 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c28642c6aa0e..c20cdc4e6a89 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9156,14 +9156,13 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
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
@@ -9184,15 +9183,6 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
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
@@ -9232,12 +9222,12 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
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
@@ -9247,11 +9237,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
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
@@ -9277,8 +9264,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		clear_offset += ins.offset;
 
 		last_alloc = ins.offset;
-		trans = insert_prealloc_file_extent(trans, BTRFS_I(inode),
-						    &ins, cur_offset);
+		trans = insert_prealloc_file_extent(BTRFS_I(inode), &ins,
+						    cur_offset);
 		/*
 		 * Now that we inserted the prealloc extent we can finally
 		 * decrement the number of reservations in the block group.
@@ -9350,8 +9337,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 					range_start, range_end - range_start);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
-				if (own_trans)
-					btrfs_end_transaction(trans);
+				btrfs_end_transaction(trans);
 				break;
 			}
 
@@ -9363,15 +9349,11 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
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
@@ -9379,15 +9361,6 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
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

