Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671D74AF9C5
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822534; cv=none; b=YifFBoI+dcrHCj+xeZOxKHljxQz5eNeetZElSakleJvccqxu/j8xMFKzH1G7VHcqWjzOA7pzOYQFPqit/PrmLXY2HaImCCyFtou/VliTinz4OPGhwbbCCtnx/FjpehPs8LNogkl7COjQPBiv9PlQqCdCyy4A8MhAFCS3FD0lMUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822534; c=relaxed/simple;
	bh=t/1qXHqPAP/Urz20U/zIZ8LAIlub4sRCOV1AEiPOFxs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sk1c+387szX4s3+ybCLtu8IrYtZaoEDClv1VpcA85DjVynkG0ujYkkfU6JVq84OsEJdD+8ciVCWyqdzRN0DOiBYTjE9LllMFD6XoEzsbagLipBb0G4XXFNIUjHfF0Gd/E8awsjs0d2WysKeweM5TL+cnPy912DnJHvr6yvyz/dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ptiAvaWs; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=jidRC5AF; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ptiAvaWs";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="jidRC5AF"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CEgULT1222175
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=OarH
	MLWkaYP4TAlNUVRIlFRJzmzfQJVnWwIlyBQx2ho=; b=ptiAvaWsS/w9evX43PR2
	a0/y6CPAwXNM/W+j+tlLE99bJKJaYc7EOh+0l9o3ZoA2VdxKtxIqnF3D5gHq57tG
	/BDpJb19I2fVbW22DZngXaUxMjEQq2RT1FSSENM0IYsKSFPbx11UlP7H/lMHK6R1
	93nYebnO6CPBibibxgTsITxU7YkaUgi938hj6IDBX5wQBwBBG5GRiz5fd7LQb0ZU
	smYAUFphd61rMoHJ7cHeo4pgwUXFXF7jsBMLBs7k2bHYkMmM4m/wDXNLTMMrZkBG
	9YcC4cE7/szKpgZ05aahsTcQuUxX86qWvWDEJ2Wnjd5DK8SpqHTWlelTJXO3LekK
	+Q==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h8y4w2suq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:50 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91786abb5abso34997526d6.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822530; x=1792427330; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OarHMLWkaYP4TAlNUVRIlFRJzmzfQJVnWwIlyBQx2ho=;
        b=jidRC5AF9o6HOTJNfAIZ639qxviCXQB/ZN7FtAHMhTQ0iAnmUDfbcNid5NvJnI7eCk
         fh1WKdL2QgVp1kMF35y4uXcqwuF1dJwmOAUhyaI7PfNO7MDrftzGFhvOVejiJFbBG8P6
         KW+1zM0TBdyj8kdXIn/3+CPk9M+/Ami4FF6IoDy6RCqIkzSHA/A9RqbbBtsM1sbrktv9
         stbSpDYuQMVzKHc7xyaCq0KBRz/D4cge5q07Dt66E6dn3XuGSacCZ25mYX8odBIwXA5A
         /jwRq5uoVo1I9+1mQSxI5zMxh/4cLQV04F6ztGqZ7ELg3dhmHHCE2cd/gHQ4zdoSuz/J
         JD4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822530; x=1792427330;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OarHMLWkaYP4TAlNUVRIlFRJzmzfQJVnWwIlyBQx2ho=;
        b=vlpAT/JZ8O8c9/HhNr5J/Mx0yXKrbOeoxjw4dgXpUXrctcajXPNJsA7mbHszSzLHSM
         KiOHEluIJO8HH8mP+DzN5JEIYZstqgBmQcHN0oCFCaVPq0e7+M/0qU4/4mEGu1Z0vQ0n
         Sw5dYvxhC106BepIj9L4EYreyWAFJ6Cpv8BrQ9etaeSfEx5JSONAnOsuKvaXnAexYErI
         CwO6YtFqdT/TRxazH++NV9SUPfeklj3ard59EZ2QN1SUPmuyg6oUc+06zBqJ3TJTqgQR
         LJn6rb/3kNNQFeTxjPIbydbcVbIGrYdooZgBBxyT0R45RjsfgziPNZmyVFUrGZu3wBzl
         4jqA==
X-Gm-Message-State: AFq9FYIvBap/Gbvwa2jzGUNk7h79ELgYZda8uJWEeG9Js5YCVjl+rWFZ
	v6psTCb96B1MtsuLBteAfXmJMoZPtPeoneE17bYZqTsNJvyL1XynLaWDOOjWOnvLDARcn9Qqn3h
	QWd//6m14aWKXgaioqVBMPbfOz/vkGc2IlzKt0YGz+5v5z8ZyP88ODP/10Rvq
X-Gm-Gg: AYBFou0k6snsA1QINe6wImBPXNjN0qbklpPzYBWbmeP3w3NKRYGTqXRbR12rjoV3AsJ
	T7OohbRWdjtcsRLZIff3ep8ssfczUo8lW6UZ4Y3iigqCA5J6Y8Tey23hw60viFvF7FxpjyGAw4D
	VTMwfDfeWviogM7sHWr2oec/EHo7hWNtbVdaEwCoaVS5QGmQtH4HaP2fO+slCeMIcWMRByj7b2v
	e1oQhvbuMT63mBLFT12bp0a2pL6zFKKd7H7wiiVjyAg3mlsl2mkTHIjuBtvKL6wRe2xP6UUA9Hn
	w33dEYgV7YKuoauYYQNAKr42VXSMzB5V8ZElMN91MJH36sr54HuEg7gVheasGRjutRQiab7ayyR
	LuB+EeR+NeE+01565FUGGpoN/Jf/BSFCUbsW9g9J2IqY1i+I=
X-Received: by 2002:a05:6214:5712:b0:912:517b:974d with SMTP id 6a1803df08f44-91b5557488emr176337956d6.39.1791822529533;
        Mon, 12 Oct 2026 09:28:49 -0700 (PDT)
X-Received: by 2002:a05:6214:5712:b0:912:517b:974d with SMTP id 6a1803df08f44-91b5557488emr176337696d6.39.1791822529116;
        Mon, 12 Oct 2026 09:28:49 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:48 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:23 -0400
Subject: [PATCH v4 11/18] btrfs: replace
 btrfs_set_free_space_cache_v1_active() with a cleanup helper
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-11-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=3991;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=t/1qXHqPAP/Urz20U/zIZ8LAIlub4sRCOV1AEiPOFxs=;
 b=yL9uEtTmT2DXy+bWkC+6ARKbVi8ANNoLpF7pxlXjWqrOploCT7kL12lOshU1VnLeQiFHOp+CA
 ngMrXNfDcQ2C81dkY66gVJzh8du5+IuqtfpQiMcC1rHoHJRM0li0vMP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX51cb0ZzH1xmX
 uYJIeb0SxKme7x1/usZatusUPSCl77fWpZvUjB4c1bOs9G3KPmMX6IQYoDOeEN6UueFRRXqronz
 7xuDiGct2XgcDLB3kCTxfqMgo7qo38xzaNsSE8KmCpSCDhWqxOPx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfXzox2I0m6cAOI
 DQg8L+SRm50j1qTrCqzRXO8df5Q74vxJedPgD857rzzRTaLUkw4gkZ7Zkf6R9cXtAYQUROCJV5U
 Tam/PmFbF4Aur9d2Uv7NIOyzwMVH7BAarLNmjNYgxaduaG6cDKmEthW8frtRnf+JK+a9+KZyX3w
 FPVJfHT/j/T6bicnpLBWkGn2J1NCjdusDJMj3Xr1ZFmo/irXlXEc0K3K3BBmBWWiXQDW4R8VZoP
 I14O3ZRU8ofb7swlWgpfpRBSpas/DeLKrqETnD0CIW+F0EvrWN44RDd4cZkTa8yFTfnqc2zhS7x
 h8E3E0rzKN3rPEWxyKryahF7Q0eItp4hAX9c4KVEz7boWaOfw0Y8GXbBaKQEA40e3mV29gWzdwb
 mKjIzO6mbGzUYwRLkaGovPIT8Ag0E6MQi2NrF1Kkfe9+e9ZBpns/tjkvXVPvioUaktXOPp31+6C
 qSfxQjKMeiJ7CzyawrQ==
X-Authority-Analysis: v=2.4 cv=GOydgeNK c=1 sm=1 tr=0 ts=6acd0ac2 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=UPWLJQKup_2xIvwY5mAA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: lic5j8M1hmsVWqp8uEBw09BcxnjPNOue
X-Proofpoint-GUID: lic5j8M1hmsVWqp8uEBw09BcxnjPNOue
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 phishscore=0 adultscore=0 impostorscore=10
 malwarescore=0 priorityscore=1501 lowpriorityscore=10 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

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
index 760d6c5b6b19..15339de1c186 100644
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

