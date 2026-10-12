Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39C74BD36A
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822540; cv=none; b=O7MyHERiSqSZ/AKjxDeoo6VXd+VoKg+a9zoZW6decZ7s6+ARdSVD2V+X1puhVvMF63G2ifoMO3UJIFm3drDK5tAhExzRQ13oYJgI1vHE2WgaNZhzNpjoMdkRjD163f8KBwXculBdcXiov/Y9tbY8Ns4rXL/5wd6uS7/NryLauJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822540; c=relaxed/simple;
	bh=H3qnpwwk3wmibX/HXhwBzKOCXHBXCtQ9FoTXfdAk790=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=raWqAxsVTwvWQ/HLajziwoApmph2jQiyHFBuiE28KooKEzu3YgRrYDQjmJQlHGlwuYmfHbJeD8NkLi32Ex4wpDU+JeTYrqyd5gx1gh9gt6PVNU3687gW+F3zb16Dk9EiJv3AeQEPj5r2KWGxdO3X/4hl6+OvUVyVY+DXtEOVktM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Q5G9UYw0; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=XJ/07b39; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Q5G9UYw0";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="XJ/07b39"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CFpx20778967
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=lCIo
	nd31+IYCI1CsdE51i+Rzoi6YEhIrulQ6Cr9ZkLU=; b=Q5G9UYw0FO+Uv3U7Xzkw
	nE/6Y26Cwh8DUzhZYxj1dYGJu0Skj3jsayngqtAIWthN+6Ah4TRqCFrK2apnMnWG
	sdN41wTTnHpxayp8l67LTblxPVvCv1VYF5KCUGEPC1hb26c3BawCIrG8f0PCWuo1
	ayQy3+YHTv6CQFEXZi+LeKLWKl6IJFX2rhwXi0xxuLHFXSOplwCNQYH5zl/Wm3O9
	zzDO7RCFpwQHDCHdeIS0Rf4XXfJ3IYAYh5m8jrr6T4ZXAtK2WYoBh2ERlr1ZiAEb
	jTsA5NAgZ3b5J2XZHFDMUUopbD6ocRE14dkxMOL2OvhSnrjzdWoMN0AQqErB6vlI
	vQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h92jh0cqy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:56 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-917a7fffbe0so50341296d6.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822536; x=1792427336; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lCIond31+IYCI1CsdE51i+Rzoi6YEhIrulQ6Cr9ZkLU=;
        b=XJ/07b39R7MqtZbEZTOjs7QrszZSfeablONFbJh2gKUDCSIg6ZWgs3D8DZQMaQSQ7n
         tf5tWbOL9C327tHWShQeezWDZGi5GrM/LhMM7svUgPYJDq8bizRDXuOMMqhCaMvUbRc9
         KmQoS+LkDfdtjdjbIdGTA9FwTC5eNrm6CCEf+1UmnPuKOJUyxB4AmvAqigjQu1HEqx9A
         ZXZ7m1bt3D/vpTC26J8ecVDMjUpW0H5CgUZlHRpDcz2j6hFFmCHty9O/S2VbR3BPEIJC
         SJrGSXoCLKI1VceQnSNIz+DTVepima+wHKTbirIPA/hUORRDbur/H3+lCIIlDxjkc7/u
         23Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822536; x=1792427336;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lCIond31+IYCI1CsdE51i+Rzoi6YEhIrulQ6Cr9ZkLU=;
        b=VihK+ltYzbeAneJ3amFSaMSdPP3lIEI1kMkfGTXEG9pRDgYpT6MRhiFn2TOU4D5sS0
         9leRGncGAvQQyoYASWsfDsf0d+EaA49p9EXtau17EGChQ8m0Q8fapPXfuQvyDzZAUA/o
         qFTLu8ESkNCPshYXXCeCgBPCY20WQk8kXzYQArla96bK/seyOyiTZTpI3xZ8f+2ZLkZU
         JzBOMitRhq58z1edxvKhDLkXUhkSJsx0/dYJpqibRqBvju6IXjnEAx4NRi7qTxrN2yyb
         ScSpan0Bqg5DOhKmS5KC1q9VZO3OGFZgVlXcgN7kct+oktbck8WngRmrJwMenb2Rb/TO
         y2Bg==
X-Gm-Message-State: AFq9FYJXy85t6EBBMrCAfLl4Y0bvSer7YPJv+PejOFcr6MRtNfJUu1N+
	4QBzmbK7O9GjP/neSDxL3XcB6QzMHl9QKSibIU3JCo2GPW3b6fa8A3MPSkmkTHf9OOrntvA/C0Y
	/gpSPO/W2XnuxwHu9yy2+kaMu+Qkm0oepjJ7ILHmjXjLU/Ln5f6Eg57/8/oTO
X-Gm-Gg: AYBFou3sep7pmrC+224Mz+5y7Ci2sJq0L7wawOxu/btbMtC5+dW/Oz2PUc6ZcccX10D
	L/gHbRiwyksu93utDIP2QcvUa9q9BpKJg+SpFBE9aEXIlbyV+eF43W+5j9H+MBQ/eh0QHXD/rCQ
	93HoluV+ctqt2oGAjA7jw4PHw081Rfk+fYurwNR8Z5fUXS7nwGhwAYnU84hXHC/UAc8hjOYA9fn
	Qi0YSDJW7Hk3ES4dpMba57ZPx5pgHm14j1xZ2ZpRsg60w/flM5+EbifGwmIdX6qTamMVgofWn1X
	fp8QaGinmCtXOvQKno5EPjW3mXdTSb/uvP/p+BUbaqdMHyDnK126iPhVXfNy+2LyzBBNIsrC5cN
	4OPnkO2gJ4cprnydzUYFzknezvUWaHOuofdhQgnMoIOezKFE=
X-Received: by 2002:a05:6214:d68:b0:915:4229:17a3 with SMTP id 6a1803df08f44-91b5555ff58mr186621246d6.25.1791822535737;
        Mon, 12 Oct 2026 09:28:55 -0700 (PDT)
X-Received: by 2002:a05:6214:d68:b0:915:4229:17a3 with SMTP id 6a1803df08f44-91b5555ff58mr186620846d6.25.1791822535315;
        Mon, 12 Oct 2026 09:28:55 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:54 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:29 -0400
Subject: [PATCH v4 17/18] btrfs: stop reading free space inodes from the
 commit root
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-17-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=1979;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=H3qnpwwk3wmibX/HXhwBzKOCXHBXCtQ9FoTXfdAk790=;
 b=RCCa2TCImaB9jZuWXZOpfA3qnS3BnA3pLtPGrm4U7O7IxHsuiub36UUlCAio8F2MG+aYMgd4o
 p8fPFsG9cZNDXMvMHvYmGn/RjG5Z4+GPmzlOsB/jssn6gv2uGHiZlfm
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 32c3SHy1eJL0ScniZCgR8Yg5B6uXqP-j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfXwfwFDVFcH/Dr
 A6ZmrgBFDw5mF9DC9Z7dnBduXV0YAsr2Xce94hw9zZx37biLVcq5xF8x/MC5+EQBgGTrmtQzSbg
 NbhPWEr1T9TJdB2vdI+bxRYi9Qx594Hq200BlRVzfWN1pztWNhFaGa9Qjr2/2NR/mI76QqsaOiM
 MPSRhkLIhAGnlsR5YFeIWsUuXnO77JXlYHl6J63Grp0dXsn1P9wvnbpsTcVLTQhoC8+YgXPSW5T
 JVa38GjlZwzUF7604DQBKvsbD/UYZXPoT/dWVZ/7W2M9mb5qtCe/7+zJ9bUls5ZOhOb0GafaJ0h
 igJjpbRhuBVLhPszsXnuGqM40dUV3VbjSgHW3T89iL6I7e0SXLne8Tz6Y40hzk/tvHR0zF1LvhZ
 BZ8bilW7reVmfkvh1MyteW4IR6VB9bA+MkahWHQK9kp2Xew8PRvNmj+5pY3GzU4L50O8fCnEEfW
 RmxdaEplApyTdLlZqiw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfXwXP+SiNhGBQq
 ZtYJmlu5XKtpR+Dg3aEqkVk4zMBvOM026dQ1atrdJr0gCPNsp+TNqUyEgFksARQRXs20Iw3uBFi
 2o5dRvMpYoTHkpl/OyybckyxYrma2sHQ4zMe8RgQCDxBH7xNoJgo
X-Proofpoint-ORIG-GUID: 32c3SHy1eJL0ScniZCgR8Yg5B6uXqP-j
X-Authority-Analysis: v=2.4 cv=T8YZ3PKQ c=1 sm=1 tr=0 ts=6acd0ac8 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=F-rX_8kjA07mH5tGMmcA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 lowpriorityscore=10 clxscore=1015 malwarescore=0
 bulkscore=10 priorityscore=1501 spamscore=0 impostorscore=10 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120065

Free space inode data was only read when loading the v1 cache, which is
gone, so btrfs_get_extent() and btrfs_lookup_bio_sums() no longer need
to search the commit root for them.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/file-item.c | 11 -----------
 fs/btrfs/inode.c     | 10 ----------
 2 files changed, 21 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ae1fd4da38d3..ff8f8cad00fc 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -396,17 +396,6 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	if (nblocks > fs_info->csums_per_leaf)
 		path->reada = READA_FORWARD;
 
-	/*
-	 * the free space stuff is only read when it hasn't been
-	 * updated in the current transaction.  So, we can safely
-	 * read from the commit root and sidestep a nasty deadlock
-	 * between reading the free space cache and updating the csum tree.
-	 */
-	if (btrfs_is_free_space_inode(inode)) {
-		path->search_commit_root = true;
-		path->skip_locking = true;
-	}
-
 	/*
 	 * If we are searching for a csum of an extent from a past
 	 * transaction, we can search in the commit root and reduce
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e715b52fc60d..55be986dac15 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7228,16 +7228,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	/* Chances are we'll be called again, so go ahead and do readahead */
 	path->reada = READA_FORWARD;
 
-	/*
-	 * The same explanation in load_free_space_cache applies here as well,
-	 * we only read when we're loading the free space cache, and at that
-	 * point the commit_root has everything we need.
-	 */
-	if (btrfs_is_free_space_inode(inode)) {
-		path->search_commit_root = true;
-		path->skip_locking = true;
-	}
-
 	ret = btrfs_lookup_file_extent(NULL, root, path, objectid, start, 0);
 	if (ret < 0) {
 		goto out;

-- 
2.39.5

