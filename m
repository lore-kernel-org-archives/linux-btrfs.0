Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709C23C7E19
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617643; cv=none; b=jNXhl6D0epNcnhyUR+jKqUKUCZJ7X2UF/EyhM77BT8PyysHfaMLGeTXqggWIAoWKDVk3enU97Z0SpeN3hDPXQGtCAgA7hZOPAZ2yaWrkSNi68g95gVYelSYzApNnSqAvMxeB9+ZktZgPCgjV6bf+JQh25NIBqO9NhIg0wx1oXQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617643; c=relaxed/simple;
	bh=NmMgkHqeel8gBCXCalVFD7JPoOZ00iX3XH9QHMsWeKk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KZoI/edbcqouZBECLnnXIIWW5o2V/P6lhVPFL6cyVYED3ts9ZffMKSluO0pfvchQyzrkvE8FisoIoke8gVL1cZJtgZiSRzLBBBauVq7ErmMV7w47VlziEkLQYTbQ69v3vLQpqLCunyYYIoaCKwAcUoiJagzq6HQQeYWvm+0dYdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=G9doapVd; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Vx+fmQ23; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="G9doapVd";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Vx+fmQ23"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YA8U1938436
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=YAEw
	vlW4G7rbS9GXrhM21VB8FEsa56Dol+SgMsWIET8=; b=G9doapVd3p46zVap/rBT
	YynUSUJd8hmLHN7o5lK7brKQ2qih5py1Fu3dSvjsNMCU/T71xVvYSLeIDaXpC6ee
	lfPVMzY0D1x/t+NpwDF7IROREZgnOwqdTv12z3s/XZ5nVNQI80MPZ5r/LvPls5v8
	crodKfv7Nzx5dlDNhBLEXRKvW+7h3A91kNun+hNbn2beHSHvm6H9qKriXcZPth+5
	A8W5iq+WLjdWifT37zyvMCP0DwGOOkgBrmzatgvoA2kKztuvp8mzF0Hn/z7DgANk
	zxJjOJx//6F1Pp+01a9yM3tRx8iBSNVq3Gl8zaEPdXligxJjrz2gUGi/fZ0GEnsN
	aA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr33qsscv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:38 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e82060977so77745785a.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617638; x=1790222438; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YAEwvlW4G7rbS9GXrhM21VB8FEsa56Dol+SgMsWIET8=;
        b=Vx+fmQ23dzZKG0iSPzgaThHiT9b2T0s5gqTwps/Q75gQRBBzCGNSwpbEVlhav9wUW8
         qKfynbjQnbngrzRdK5VwRs8U/NvxWypyxj9/0f2Aaz1dGXi9RzYVtKNpfePxTjgM8py2
         AXQ+HjJ31UXj5khk1RlDn3dTvxoK13p7z/Nb+Xl5vmWSsi0WqliFv73SVKvZc37U1uZo
         93q3y/PupGmsCNJSfLbHtOGJIsOd7lvo2lvuExc+xrlBJTJoQyJ5w1v60vFqWmFawh0Z
         Al8tU6lXxfi3d3FKMZCgqn1KpXRSCLRVHtfJq14Kkj5/QCOscIoddI/qK44MFtoPXG1L
         m/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617638; x=1790222438;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YAEwvlW4G7rbS9GXrhM21VB8FEsa56Dol+SgMsWIET8=;
        b=A/+gQimh84NfWRKD0oEzalruNBq5Xpof3w+1KRfr+vBQ2g711/rJsVG2agoYYdlcxT
         OpWCJGCM4j6BdFLYj6iGBLKbmCldxwxFH5pYopY/+HpEjlrT+cEf1EZtEgZ9tENNNvz8
         k+SKR6P7NvOufhfEtl3ZyW+vvdtybDAhi2z6s6npZuR6WyC/EDnRd+h/nK2nBIvGn1w8
         pgdULkrkFvHWO0ZsqLgFIgXLmnR3EbJqLp0GIpJDDwHymUrIQuYFu4GHLr/IPLpRLVEZ
         8vvSXKF59yyzWJ5YIvbV+OWL8ZXxlmPmUzGbjoIvdxQyJLbO7H+BLdejf8ley816usZx
         4TLg==
X-Gm-Message-State: AFuF++kWa4TD0KuRtOvyndaiWwdUmVCdeKlZuzjeaLOpvFmdBbybm1KZ
	7QhxqNuCISrtfLMwxC8EHyEii9ivqTDwMrsxKLW6PjrIj7M58s3VP4g6fTSkj67gLQbT2G7hx5t
	vn4AGkZoYYXBcn3IjHF4DR+/5ZTp34KWH3f9Pt+CRyze6qxGHJPtEBMQLo0yA
X-Gm-Gg: AYBFou1H5T4WkUHRkm8Yv6DzROgi0gYapGE8ClI4PDcuNgWVF9zE2bVeOp8Of/6QlI5
	h1Xhy2ve6U3EObuMe46CNWDJ8mmPKGVP4fzLv2k4+/R4RMd2NFp/9e7v4mdCvcZV6GPkd5TvrGm
	SFT58f7hLGA/w7Gx7eBKNwWR2o0EHJ6QXlp75Nks9pohpYFUyTaHU7IP9CHhzLminoFrpBRqPhB
	XNqhNqz+d5Grhth8LUZJHms+k68NjZWPJGLQcH1JY1WQCht3gbcpC8xKDAfNK9th4BZXjykjXZ3
	JtgFslT3poFeuJSL/F6rJ0tCVBdjheOKAYrAubkFlaK5JMg7Dezm1qOeksbArJiQU6R/UGc0MSg
	3jEaGHjZy0zpGfSapwG0oLRx6NO34ch11ixQMfq+Q0BWkiA==
X-Received: by 2002:a05:620a:3949:b0:939:fbe0:9abc with SMTP id af79cd13be357-93bc6240b9bmr368870685a.9.1789617637471;
        Wed, 16 Sep 2026 21:00:37 -0700 (PDT)
X-Received: by 2002:a05:620a:3949:b0:939:fbe0:9abc with SMTP id af79cd13be357-93bc6240b9bmr368866285a.9.1789617637047;
        Wed, 16 Sep 2026 21:00:37 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:36 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:06 -0400
Subject: [PATCH v3 10/17] btrfs: replace
 btrfs_set_free_space_cache_v1_active() with a cleanup helper
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-10-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=4011;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=NmMgkHqeel8gBCXCalVFD7JPoOZ00iX3XH9QHMsWeKk=;
 b=UhE5YRTp8LlOgNlViS0FRdlQeEHTyl6iIWYpwSfIv0k1RL3bBoho0Yb5wlHlTf5UWEw7XrhFc
 Sn+BrMewnegDwV63jRkFCWb2ANsxH52hqbCAii7onbOgD1Z0q7CXIn/
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: zwiDI0TvwWaU8CEUHZV_OSUF88wWYotp
X-Proofpoint-ORIG-GUID: zwiDI0TvwWaU8CEUHZV_OSUF88wWYotp
X-Authority-Analysis: v=2.4 cv=O72sLx9W c=1 sm=1 tr=0 ts=6aab65e6 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=UPWLJQKup_2xIvwY5mAA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX8GEUWItFnpkd
 VdbKP5tpWKIL+Fd+bUzJucUTqiClXH0m6Il3cvNFh83xTumBupjlZmqh8y1ckyQz1KTbL6VpJWB
 lHx98afUu7rXmhv7EGfyAqdnKt9XXqKiDP+MlGAnMkhLOpJGyVGocyya3ZdB6OYiMt/lkFnWrRa
 +d0GuVV2e6cgQrh+UyjVn7rwUkqY7w4puNvvruMXlxe1J1eR3gi83Www7pdAIKLlm3TeoUxaBqT
 zDarfr5XGiflt9D8Jrl81kuHppfI+jBse4qLMTZQD8RiIjT9RCHBQF5UAte3tIvl0onWIm/Y1sZ
 klQyhxsDLNi9NOj4uAITjV4naKnSBJq/xXl07wcSmmbaf6YdJBzUzIOETk5od690w3rB8hS3vKi
 pDj/1Wlysq8hPD8SDtZic0hKAm1KRbausbhEShV92OiNEmDZn0yjub0ixyhl26y/t6DxjvrIC21
 hFvb+Z5mxMOKzP/cFEA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfXz/w5jOM+Y/jB
 Xn8keYZkNGMfXG3nCGaP0wbPmVFRM8g2B/SVGkOD94kVps0msy9fVwagraTO2fIKv4w2XyoAaNo
 ClSeIqg4RBu3EoM0+Cpsf3jF36aupPz6JUIF7cYZXSqaETPsY9n7
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 spamscore=0 suspectscore=0 lowpriorityscore=10
 priorityscore=1501 bulkscore=10 adultscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

The only caller passes active = false. Turn it into
btrfs_cleanup_free_space_cache_v1() and fold the block group loop into
it.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/disk-io.c          |  2 +-
 fs/btrfs/free-space-cache.c | 42 ++++++++++++------------------------------
 fs/btrfs/free-space-cache.h |  2 +-
 3 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2ac0e7c2f1e4..323fbbea48e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3149,7 +3149,7 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 	}
 
 	if (btrfs_free_space_cache_v1_active(fs_info)) {
-		ret = btrfs_set_free_space_cache_v1_active(fs_info, false);
+		ret = btrfs_cleanup_free_space_cache_v1(fs_info);
 		if (ret)
 			return ret;
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3ba9ed4a39d0..fb6ff3db1241 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2891,47 +2891,29 @@ bool btrfs_free_space_cache_v1_active(struct btrfs_fs_info *fs_info)
 	return btrfs_super_cache_generation(fs_info->super_copy);
 }
 
-static int cleanup_free_space_cache_v1(struct btrfs_fs_info *fs_info,
-				       struct btrfs_trans_handle *trans)
+int btrfs_cleanup_free_space_cache_v1(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_block_group *block_group;
+	struct btrfs_trans_handle *trans;
 	struct rb_node *node;
+	int ret;
 
 	btrfs_info(fs_info, "cleaning free space cache v1");
 
-	node = rb_first_cached(&fs_info->block_group_cache_tree);
-	while (node) {
-		int ret;
-
-		block_group = rb_entry(node, struct btrfs_block_group, cache_node);
-		ret = btrfs_remove_free_space_inode(trans, NULL, block_group);
-		if (ret)
-			return ret;
-		node = rb_next(node);
-	}
-	return 0;
-}
-
-int btrfs_set_free_space_cache_v1_active(struct btrfs_fs_info *fs_info, bool active)
-{
-	struct btrfs_trans_handle *trans;
-	int ret;
-
 	/*
-	 * update_super_roots will appropriately set or unset
-	 * super_copy->cache_generation based on SPACE_CACHE and
-	 * BTRFS_FS_CLEANUP_SPACE_CACHE_V1. For this reason, we need a
-	 * transaction commit whether we are enabling space cache v1 and don't
-	 * have any other work to do, or are disabling it and removing free
-	 * space inodes.
+	 * update_super_roots() zeroes super_copy->cache_generation while
+	 * BTRFS_FS_CLEANUP_SPACE_CACHE_V1 is set, so this needs a commit.
 	 */
 	trans = btrfs_start_transaction(fs_info->tree_root, 0);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	if (!active) {
-		set_bit(BTRFS_FS_CLEANUP_SPACE_CACHE_V1, &fs_info->flags);
-		ret = cleanup_free_space_cache_v1(fs_info, trans);
+	set_bit(BTRFS_FS_CLEANUP_SPACE_CACHE_V1, &fs_info->flags);
+	for (node = rb_first_cached(&fs_info->block_group_cache_tree); node;
+	     node = rb_next(node)) {
+		struct btrfs_block_group *block_group;
+
+		block_group = rb_entry(node, struct btrfs_block_group, cache_node);
+		ret = btrfs_remove_free_space_inode(trans, NULL, block_group);
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			btrfs_end_transaction(trans);
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 29166cc09b90..f5f18e397b13 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -136,7 +136,7 @@ int btrfs_trim_block_group_bitmaps(struct btrfs_block_group *block_group,
 void btrfs_trim_fully_remapped_block_group(struct btrfs_block_group *bg);
 
 bool btrfs_free_space_cache_v1_active(struct btrfs_fs_info *fs_info);
-int btrfs_set_free_space_cache_v1_active(struct btrfs_fs_info *fs_info, bool active);
+int btrfs_cleanup_free_space_cache_v1(struct btrfs_fs_info *fs_info);
 /* Support functions for running our sanity tests */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 bool btrfs_use_bitmap(struct btrfs_free_space_ctl *ctl,

-- 
2.39.5

