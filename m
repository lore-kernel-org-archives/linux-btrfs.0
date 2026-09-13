Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD48391E7B
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334499; cv=none; b=dsELam1pwOXbDQ/A7x/hcJRx9ml6He1gpnIiTmAbziufbx8ugb9T5QoYjGcW+ClnkiKH435mndRg4fF0PkepK7nmEQ8fOWv3/hjVnB57kOkql7a0l0nysUHu3GKRkoP715zSNNxOQKatyNkN1h28TSs/hc4ydeFmICYk0nDtb4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334499; c=relaxed/simple;
	bh=LuBTan9y3xIHGem/hBUH0BrWE94YbZlpNQ0hZxPS8Yk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fxVipcgo5LXuF+cxa7oQdoFfOb+NtXwMHR7QZED/hYuEX9xJ98n23Blrf1UFrZxRz1mnEZ8jNcjqpB/6M7BKezbiGysJzzfmvNpUW16NERhnFviOQNVh/dhzEl8ReNRpt8d0HLlhuivTJ7iDCVg628rpG3y/FpOBVhfzMEOvLdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ivWDxcDs; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=apgKnky+; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ivWDxcDs";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="apgKnky+"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKY2DB648307
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=D30r
	uv+yKSOAMmMucte1JDQTKk9fW9AMM4RyOBGX0vc=; b=ivWDxcDsdmYDVW4UHE1c
	NNXK7VPqHl1K+iC1GpI39qaJnq+n0q56sbSE7ThGx00VwUK/dBDNlI99ccRpcNU+
	EGizDj9v2/BIZh3a8hsIA0X8EwLGW+fopAksNufvOYjwTMLWmbBQe4KUlrk2MhrW
	V1bQ4RDFUEV6z1Tt2ga9KtIXdLEiKijXb88sjDdnFMz+wzvSSROLK0MYipEYIC46
	lsg94rhE/StD9+pWyLNbnAsSLAYSexeIcCwL4+KYw6cGjn+pBxIBUOKqaEWUb/WS
	9vXUGAAyo8XNbIGxlGD1NwEV8/gFwIw+2LNeq1oRrmz386OeMAaP7VjapI8eDvNl
	cg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp0qmgpw9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:35 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530d912b923so46347101cf.2
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334495; x=1789939295; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D30ruv+yKSOAMmMucte1JDQTKk9fW9AMM4RyOBGX0vc=;
        b=apgKnky+ULzwl464VgRc4obMnWeZDnNj8rQ4kixHUFfcibENfTrVS266I3KSN6TLay
         Cy7tMLnf+b6KEjhSYhNxWleTcwvuJ/tTmgDlIlA26j1dKKMdgOwhLOu10KgJzCk5tJyw
         NA2FwKqTFqhNDKcO9RaPSwzsbc1/V5nTgUzxLkJBnRjkL7G31VHgP6MDwF7Bd1OUEOer
         cmPnyuOGT5T+Gm2TrdQnutD/o2vgifKGfQVqNgwQAP+0CrVas4ZI0aVsr4B9nkwnekWB
         rMyrXbbjUIjGNgUwqRu01ZnLYanWadqPhN7bxUZ37c4jEIGihrzt3/Go60TBQEBR9UDP
         KNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334495; x=1789939295;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D30ruv+yKSOAMmMucte1JDQTKk9fW9AMM4RyOBGX0vc=;
        b=XiMEAAfRvPkfUUlf2ueOjm1L5EGOzIUR5osXoUWPv0pJpwPBmaJYaD41h+jikdMyjN
         eKN6UJkrSs2HIaDbtHAn+haei5szPhtcLzcdqA44UMBtUoNmLM7E9RlwAPLcPQmK2gqp
         W1fUjZyYhV1yazvQufbYrqIf5ioQvW5Cc3U29kKjywN8vTgEcAGSRVTwXrwj+ONfSVt4
         Cbj7x1e1lMtzN7eO3RGRqO6TdGFmCbsth1O3/VT2zHIiHR4Sp4a6QzN94Wj7PFH+Js51
         mUBTS4qfghaPBGgurh+7I6z7HPA3dTYluayeqty+Ap8e2+bJicfIk2LLHD6Ki9800FwF
         tK2Q==
X-Gm-Message-State: AFuF++lCIMPW2/1dSKUxu83PWjamcy9b7BMuEBavXFJx3jwVo6fmsNwd
	3b84X3VGduYUS5P5qqxhhsTfXMb5Tt6V27JYtVro1e4/3CNwgGNCW1HvnlHbQfDhOxzUWnbomRN
	rV6R/tLDrVwk5Q2PL4oNLQT1z7Zo2Ivi9EZXg417Mx7r9Ayr6oP78NjDbhXspJQdPzQV8gEc=
X-Gm-Gg: AYBFou3rYE8M3giKAJHytWbhj++ajMr8uTNt+0d7IFFtupDQtYnu8oSa19uSWhtKyRb
	g2wTH7TMm8kEPGl3eSAKDhzgcSU03+N+7toYlUPjZWVj/5njtGA2TuluobVjjTXRdqS0E/bSclE
	e1fDYa5RpL7t8WgSe1COgF/tLXvvy4G0v0duzoFRK1HjF+cz/BcVknu6i3THM/riREy05bAV9Kg
	oJPGGv4RdgGau6hazjQKPxRvTpJND5eUXwYiiN+fwoEIqDABSYwo9vesqCIrZR/NVb311KFSGlt
	7DZCBSB5cCbXQxzCPDqz/rqRKLjNhbx+tC94AzWkf87k5/qfDtnEoo7XWObJo48t7mDuLXIwyua
	6ulnxw7yZXJMlD7bnRMbNMlkNICUvfmeuTxMuPCDluIqZHKn0MSJmmw==
X-Received: by 2002:ac8:7e84:0:b0:530:35dd:d6e with SMTP id d75a77b69052e-530c8525cc9mr216212141cf.7.1789334495265;
        Sun, 13 Sep 2026 14:21:35 -0700 (PDT)
X-Received: by 2002:ac8:7e84:0:b0:530:35dd:d6e with SMTP id d75a77b69052e-530c8525cc9mr216211821cf.7.1789334494785;
        Sun, 13 Sep 2026 14:21:34 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:34 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:21 -0400
Subject: [PATCH v2 09/16] btrfs: replace
 btrfs_set_free_space_cache_v1_active() with a cleanup helper
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-9-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=4011;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=LuBTan9y3xIHGem/hBUH0BrWE94YbZlpNQ0hZxPS8Yk=;
 b=CciFdnVe6cwEgYXGnMnIPHVwh8wh4/+Bu1rfFb59+zEZW2GdRG6ISs37OTzdP8uTyKN1nOIhZ
 g3wuUpe5OKZAXfDTnedRn15x44ZpoT4eC3NOSWey+7KgLy1f7TxNWgn
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX01cigeqnnLhw
 /XTzimi/G3eanNWYCDBpQajsCYyv887WAgPaubVaK+l0hZArYxboShCKxg7D5mo/Ud6RrS+rJo4
 NYv2Q9XGvX/igbI+a8dNdsKbe2wSE8pMiBuq/Z/5Uqh/3PUZF6dW
X-Proofpoint-ORIG-GUID: oihTztBbd_648uYb4ypjnbi-5XJV8QKL
X-Authority-Analysis: v=2.4 cv=EJ6TQFZC c=1 sm=1 tr=0 ts=6aa713df cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=UPWLJQKup_2xIvwY5mAA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX0umLv+6NjqT0
 O8YWY1bvQ+P/SBr7v5K8LWX0XqXj0xOEMOsrt6dWofs0R7sq04dmMI+HOGFC7rWlKmc/i8Hflvh
 Jv8VVbBhfLh26N+/9/mfdqFGU5Gt0vSmboig0uLOSqIzNFftpDjeSq6i7IIu/t7Ykev5aBeFkL4
 qs91WbI1QL3tLGewSCGI0KkQG9Q1ilmHY1Yr8nFfT5s1J9pzzhoNwFu41BSaf+DM5uHgmfMMx1u
 GGxyMNLY1ntj+9xvDK0Y4BEOiXbBIPCybmdlnifDpDWtb9Hxvam/zrkmoIlsSXehgkjSHJTnCAj
 nEl39eUk/OvRspcGIa8VW/LqK6h5hw5fcPplJk+gw0+3Q10TTlks54gGOxH/lGryz/nNDF91BXO
 eKEE6D5fWbnXOJhEFZl5j7IUhQqQQ1VQ8oszt2MB7I8uaUJ9H97kIw+mr416OHIql9bc8gcUMAf
 hCK9/1H7BpQAXyvRYmQ==
X-Proofpoint-GUID: oihTztBbd_648uYb4ypjnbi-5XJV8QKL
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 malwarescore=0 phishscore=0 clxscore=1015
 impostorscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

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
index 57991a413f82..a36d0465510d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2898,47 +2898,29 @@ bool btrfs_free_space_cache_v1_active(struct btrfs_fs_info *fs_info)
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

