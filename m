Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4BA3BBFAC
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075427; cv=none; b=jRgAmHu0iCBJby5aVDInH8P5J4WQR7hNM3qbsD9SYJKLpjH1uRSOBT90plwkCMbVJGrExbtDis6WLoPE0dFF3peIYpA1Ydr7Op/AmCbZCA2Kyr94XhOzlSC74/WYpR1TGxgW29ERayqX5tg4F9CdVJ0fkSRxSTxNf93lfX6M268=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075427; c=relaxed/simple;
	bh=/8LnYQdGm9RyU3sehDDMGYdFuSg5IKn5y9hvPvTnxas=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c8o3uA/ZJaN+RLCUx6ViVt3pNtjux2CbFTebSkdZdxz93pp8sD5Gm1pfxQjseppGwkVR5gc5S5FiOJawO4QkB8fwczQEvpQpkLYimOV/igMUTdLyKZDHGpa5xNwvEqlTs5GQzz5UaKKzxf7LFlAJyNJPr2bE6b3mtqunJMFyJQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=gN+nwFOm; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=LKRVZDLi; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="gN+nwFOm";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="LKRVZDLi"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEY9EL1419229
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=A9c9
	pAS8dW4pOTgLmESxJejL92M2mxqAmxQGJCs/AO4=; b=gN+nwFOmmqZopplujBe7
	HIDOtp4MbMQ0ugwYVZbwdVLVWHnzMUQNX5k6NRxQFlzK4q9K9m6fmnPKHdtihAxp
	bgq2HS+RXJLSK3+5CV1Jv/PWqvxyJH/IIF/4Y4HpOKJPlZBqqHhO/y8h+e1RAYwO
	pHaIpX/6h3miW+2pdV82ogibUvL2qDnXlhslt4SGN1kctC5cuiGwxWW7idLoTgUT
	Vd/HdFixc51T7FuGkpZOKAce3Z51W6ppdZA9vZY/Q3oFfUI1/ENIVKKGAUvkxQft
	GEYbUAt0J6CmBVCS3uybXOiUBbn0+Ov2xaDLwWOdWRRZCe2uPqyLP60Wb0WITxyP
	Sg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hagkhn7tn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:44 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9196b477c4cso1219956d6.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075423; x=1792680223; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A9c9pAS8dW4pOTgLmESxJejL92M2mxqAmxQGJCs/AO4=;
        b=LKRVZDLiuDfYavTGcTKYZsjvCVXoHIUSIPndW2jKXbafliqgUIklBYauzdfkJe4BP5
         qpr4bQ/lcb7dI6cPLuC4wMW8m3+HgKeer7qnLn9rg+6VrhExVY0sFtEHq3s0+zCCeNuF
         cyytPvPcZALuz1bG4uaqQ80p4hhehc42ODPrZzj4msWViZtPdiG40WUeUMyd6kZalhw9
         4MfARZFh/3qBxwFEL2ltGFO1TmidYBTtmpziE7r6Yl44OiHQ0WsFCV5h3iwOMFz6VxKD
         BYDGKDZlRnZdX2sY7v81TsC56bxnOhIcpilbdMga8tlEgEwGhN3RHYjF3CHXWvjf5w/g
         6pJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075423; x=1792680223;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A9c9pAS8dW4pOTgLmESxJejL92M2mxqAmxQGJCs/AO4=;
        b=ANfTw21eTGO47DF7srbfiXdKnTe1US9QxqRSHJoiRROk5ChO5WU1ZRgriDBjCvdv16
         DlZ7SPZCxuMkK3r8MjUIgOAbbqy378LqOBMXibyR//EpM6/icrAjFz74p+5QeAdJQ9Gb
         SLoATYwWw5zRN2Vth2nSZoAQ2xilobJDk4gOi0LuHagsNpoWhdrDCuPUQ6iW1cXsmCcN
         L72n2b/+osv9USxyQP93qSyNDcAfq6E40awOEfaqZo0owxWNrWgYO8f0bzwHpfR5pWIk
         qwnwM2+AG59YajIwhS857w4rVQPV+wbLuDjoWybmdWZM3xAsROb8MBkYX+RlkJdLWRtZ
         EacQ==
X-Gm-Message-State: AFq9FYIagW6Zmeccyim59Wp9ixf8uGP2bHvDL6NVf7oa8HoGhQDwPgM2
	fPtfj+T+WnABOgpouzkYtwW4pW1/RwsHZ1+k7OT/ckTFFKpEOvDG8hVIasctJWhqGFEtrmL79dA
	+/SMTSPJvyGfpOBOYUDA0UZd3jFAPifYgXaI5PxKNCCH7I5Nqxo28R2luxirD
X-Gm-Gg: AYBFou19Oil7pdRVOSPDf8BURSadCPGedRlaa5tvSIWKhJDJOGq04ghsKnVEm7YViSY
	wj4eXLYqWoKCKeAUlL9kl6sHoqyjGmLZlcj8h9S+mRXXVSWNmQCIPxYGZrA4BrBDOf5B/L7QWsB
	MV5DHUXVTKxS2qUWjSh3KDDoXXiT5TSNp6lD3ORqAk0Gd1JID8mQCM7Gx4IYeQS2Twi5JI5ccBd
	beZjqQq3HVX/0PJWmPIZzMfSoEwSYas/jmNDTw9xd+NT1Jy/WAZ9VH+WQt3B8Fourc4jt2SK0R3
	ffCMOBAYLHCseASDzFPx2/b2ebDbrKdbpEuyFpy9R9O+AQpOz0FcsQYQOBKmciFw26uHRCBITN8
	5hxzRE+dzxpQgLYj6LhspVSfpLfXq4+tts9e8xeGdtxD6
X-Received: by 2002:a05:6214:2606:b0:91b:bcf5:a733 with SMTP id 6a1803df08f44-91bc91a3d6bmr5034786d6.2.1792075423619;
        Thu, 15 Oct 2026 07:43:43 -0700 (PDT)
X-Received: by 2002:a05:6214:2606:b0:91b:bcf5:a733 with SMTP id 6a1803df08f44-91bc91a3d6bmr5034356d6.2.1792075423139;
        Thu, 15 Oct 2026 07:43:43 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:42 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:25 -0400
Subject: [PATCH v5 12/19] btrfs: replace
 btrfs_set_free_space_cache_v1_active() with a cleanup helper
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-12-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=3991;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=/8LnYQdGm9RyU3sehDDMGYdFuSg5IKn5y9hvPvTnxas=;
 b=Ng+QQRVAt6AerhUz34y4Af2BMA2Q8CoGoupjP/oyRTBosibmiiaPpcldc1HqEuZBYwv88ckq3
 DhIW4fKyvM3AtlhjkcMvz4zssvCaioE599MWTZPuI2qoKYJcekK8w3d
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Upr2pOwB c=1 sm=1 tr=0 ts=6ad0e6a0 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=UPWLJQKup_2xIvwY5mAA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: b6zpGmrD1-Lz3AVAevODtuQ3b9Q52LYC
X-Proofpoint-GUID: b6zpGmrD1-Lz3AVAevODtuQ3b9Q52LYC
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX2oCEwPJEGnct
 QrmCjbtEUmgFpt2TCQtA0cQNixar05IuiC1Uv8PcF5dtEVC9SzHmUJ1/hk+K2C36B3xRXjUbyfi
 4MrWuSLMBnatDT9IpgYliWCcJE5BnluFCYGROJ+WVA6pkQaLsVDb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX/lEEFF/g9SY6
 6a3ZpcFAwLC7kzBMfiXR2qXDDTIOIv4eel75s5Pp94RZrR/PpVFF1yXmfF34DW20EvriXZ2iZoB
 N+/ZHiImeWjaRZ2kjxxGaSOYE4Y+eU93TqYbedoHx6EdM/inraKD6RsUxqws581GLpTDDGqeYlB
 tEMlI6lrGTvPjJ4VdC6E2/weCZNVydBbr1mBHJ6lzXEP3wWM/frpxXQ+WGr2vpPA3dJwteh4lP8
 wpr36FFmk0+Ijxzib67vpPn/T6FJ2+D87Oh11KuBj43+A2wNVrdGxu2ADls/8+2eqTj6C0raED/
 D+thOCbIYmChNIVlQ+wz4hN5oh5G65x6jNqdKWoqGwMlRt3yz5Cc4CsNXZJjiHznWfGFXNpQpnL
 BjGptpML7ZmBZ63kIStHK3ZjpGNRqR4QiHc9XUQMewo0OxmY53xuBTkINHNodUjNRUnCNH7i21h
 RfrRePQpLLNxZMD2UcA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=10
 impostorscore=10 clxscore=1015 malwarescore=0 lowpriorityscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

The only caller passes active = false. Turn it into
btrfs_cleanup_free_space_cache_v1() and fold the block group loop into
it.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/disk-io.c          |  2 +-
 fs/btrfs/free-space-cache.c | 42 ++++++++++++------------------------------
 fs/btrfs/free-space-cache.h |  2 +-
 3 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 23a17b829d98..c45cda4290d5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3152,7 +3152,7 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 	}
 
 	if (btrfs_free_space_cache_v1_active(fs_info)) {
-		ret = btrfs_set_free_space_cache_v1_active(fs_info, false);
+		ret = btrfs_cleanup_free_space_cache_v1(fs_info);
 		if (ret)
 			return ret;
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e82216ebd5d0..4dcbefb0bfed 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2901,47 +2901,29 @@ bool btrfs_free_space_cache_v1_active(struct btrfs_fs_info *fs_info)
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

