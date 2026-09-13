Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12C83AD50D
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334506; cv=none; b=Vvw6n91D5cDuGbtMJiiyBNZ8SLPM+kE7pQo+MBk+2a9QjkbRvCCFr5ePjrmN1wQAv0Dgk3RYGuQcUU/YBTAGECnw/Rxvmzs56GiJ+YfOFI0sKdfggn+kH8WiFVpu81ETwBe60Y/tdb5WjLV8cp9MxqqfqVMTIgtqVPthoQEXRyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334506; c=relaxed/simple;
	bh=IxPtZs7YmG0KTAjKIomldxp3suS2xlB2WlerF1Jtwhs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o8LzHZtG8NGKGvSyycM7Vb41igg8D8XAc3u9DNVOuqBPzcTAAfKAEHpzFZez12hnDn24zqzvnWYaR5xpzzS5nfIS5PGCZk3XpOL4Rq8jOzq+viocvhO71N9eDWk9TITR0uJRyF0vGRUF30pufz4pq0wwDNpGnpEaesn4YyDOOJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=p6ojGcLn; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=f4ObydCp; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="p6ojGcLn";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="f4ObydCp"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKYZUl1192915
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Jdph
	n3uGMtosHUIIlsCZR+S+zVxJ+iV/LKrDbHMNan8=; b=p6ojGcLnacZaWlqJxM8m
	idUPiStf/5BtKyU95PGAXHmuF9+lzN610mKtM/kNwgDMiEwnscgistSHyAeLRuaL
	eOFvZWCB+79CmS1wNqwqgJhduXz9N4aZPYV/GuvOE+1ppF8DQsUI8KmKpJgOMQrI
	L0AlJVyVNzfnKFkUOhWTuTvnyhofKM9NDCptcTKvGkVNXfwaEnPZLG6jBBtq+Jqs
	qgVNmkXq0l0ZkOyqEuwLXijAB4LePSUMbVJUF3qYK5ZBkoc7c8mEWe7n5eV+UTOv
	Heip/B6j+a3/6eW4RRe26FcrWcEZrJz7mY8aD/YZBh5MkmaNxiG19bH1jmaiwWbp
	Vg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gnqqt2s25-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:43 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90c8da50f8dso73021236d6.2
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334503; x=1789939303; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jdphn3uGMtosHUIIlsCZR+S+zVxJ+iV/LKrDbHMNan8=;
        b=f4ObydCpU3Fyots5Yyy8GsVHYfayC+kAqULHIsbdSFINzbHn+k0xm3fLSybZe8X/xp
         7wcMVCoJEo9jmHg74/SNHyjfN5EmdP4OppiuvWw8gs1tg1+q9ATaTITm42cfu9T1FgLL
         RWV05oPcymSFQH02WHaMfJaShf3+QhozUS86xJXFbUzeajrNift/IYGtbDi7WaPCpnTq
         Li/0TCAPWFvjy+tpuAInz3jjLvFlD4t0NKtPDsGM8xVaoNESJrFJiLxFXnDySO6r+IaF
         2F6e+rqORxTtLoARlVZ6JzJAZcRgaJwORVQahUBe8fnvcaITqK0Vx1Z+p51npgZxek6d
         figA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334503; x=1789939303;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jdphn3uGMtosHUIIlsCZR+S+zVxJ+iV/LKrDbHMNan8=;
        b=PR17qxOI0OWkWiVQ+VbcRbgUwbotR5XWr1I2nyxotPd2GImxYlZfyVG4QM4s3dRkmh
         CS5CASCZP6jW8/J2Uf32FlIouIjWJiiBD4jLM/dPJyGDH5UseSDfh+cA6IcDvz5HJ8wd
         anrIjd6fSq7uiUZto2gE9e6dg7YruF7w984ue9N+e9g2AG0tcowFHnZe9zXaS4XTCOI5
         s0EusV0n6PPHVYb52s9eBHis3tUF/qTphmefmjhPe932+Osm3TuQL0hRiRuCl7iy1QbA
         brEoy8iRwqSirZW4H0/7bIfeEC+1edoId9q8QXviHJVAtKHmUFsdnjKfSrwmY/DiM6Su
         Lf3A==
X-Gm-Message-State: AFuF++nFBX7fUAb4+URzerGT5Fc47AuopuQsuYKldVzSH91AkxwEe6LZ
	LHyRYKae8KYdURbVgonU+m75IZ/rtdbqBiqv5/3Bq9rDKvqL/Ai3SjGrtPeKmX+oej0OpBCeiEw
	5pe/2hvuWMyymgke670njH4Qrl6UKImXZ6vQRbeY93XZhsRoLg2gja0JqLCFK
X-Gm-Gg: AYBFou0RZDhtqqEi8V8/m4ZyCEXBQgBy9SFTZObzZvxCXq9NMzH6vmvjsNlVRbBWq/P
	QhviDo2MSjJ0yC2TzghX+TWmBXMTuvP68g+TjCAeUV/m61IUgPvPBmaAE5Q+xbqXP9P8AgBr29B
	HwPimZBfzeqlqqjbpSYkI+E5St5kOO3Nby6yDFbMiAa4BRAtzywQ05q1eEsyRtrbqFgkzXgt/qJ
	uN5TNWvh+zLJ7IGKo8ppvXO313yPb8y75zI1Cw2ghm+vEj8OUdB8hFI4BLLhHLLnbgXLVMHLVNf
	LqcUm9KuJV56qmRiEdudLToDZjY5ODPHv2mCAU5KvZSxUTf+SnxtC7VdeUvvU7Q7YbeZKKkmRcF
	rE+GvODkXKg1gT7cGtQV9innJm3UgqK5gBZcWccOp9u0FE66ZOWTMQw==
X-Received: by 2002:a05:6214:2307:b0:910:722f:b8b with SMTP id 6a1803df08f44-9121da7621emr122539026d6.21.1789334502958;
        Sun, 13 Sep 2026 14:21:42 -0700 (PDT)
X-Received: by 2002:a05:6214:2307:b0:910:722f:b8b with SMTP id 6a1803df08f44-9121da7621emr122537846d6.21.1789334500804;
        Sun, 13 Sep 2026 14:21:40 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:27 -0400
Subject: [PATCH v2 15/16] btrfs: stop reading free space inodes from the
 commit root
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-15-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=1999;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=IxPtZs7YmG0KTAjKIomldxp3suS2xlB2WlerF1Jtwhs=;
 b=HwDXp2hZAq0UmkVROrNFPxKx1jq+lektak8Bvum3837X4k8O1P211QiJgEpv+APy4/X0vBUSg
 d5RwEzlZPqZAW32Br8ft6qSbpRkneztdVNIf8DMdNUCeslpHrOHW12G
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=N8y8hG9B c=1 sm=1 tr=0 ts=6aa713e7 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=F-rX_8kjA07mH5tGMmcA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNSBTYWx0ZWRfX3DYyIBzf+zGJ
 5P2tY+eGYa/YNwlKsYTu5nFRhGv+2gdmUnQY9pSOMUL1+d3IYJ8lup0FFBudqQGwqX5JiyfxjzP
 cqEeEaXbHW2Od8p3HxQA3TCJgNkaF+4WT88CLEa6a+9nZ3dgb/vf
X-Proofpoint-ORIG-GUID: iCLN0yNLM24XVnHzgCxX2NV4kP55dPuo
X-Proofpoint-GUID: iCLN0yNLM24XVnHzgCxX2NV4kP55dPuo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNSBTYWx0ZWRfXzUP/+IQdktoj
 Dvl9ZUNeO67RXmRvT4m1HMMhk55DYhkzuHjiNt2+ZYbR3hO9eX3hbqLCWqL1fRcOrNVjiMwnh4E
 T4IsebTwk/7cXfSbaAkIJSyycfEb5iZo9P9FQ3/FpPHiuHn7DRLJqK+Ith1zcqhlI7qU0vKhCRE
 QsGUEfdPXOcQ5u7JSgTezC+DTyN5q2+1HiX4d2dTqbk3cl6Hq4itxyUlTo7BQY39TaUc35nl47S
 lj+m5QLPoKSZp9Lh+GSVUJuRKKkOVCSQeukdekVCg1WVzrA1nITQ0h7okJxkN8qalcdRxbu70xE
 om+cWo38fpOif+Hf4fuLv8dwJyv2m3soTx1zRRflhSh191pIH2WmQwsivfMSlTzrS8l/w8LW+du
 wYPbjUSh+CXvH5L8fIH2k/E+RllpNZHhuZfK+Np0tSwe3ktYEqcXL1WdK5gfv2RsSiU7hpf0skV
 oEux2pMFpSjrVehW02Q==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=10
 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130305

Free space inode data was only read when loading the v1 cache, which is
gone, so btrfs_get_extent() and btrfs_lookup_bio_sums() no longer need
to search the commit root for them.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/file-item.c | 11 -----------
 fs/btrfs/inode.c     | 10 ----------
 2 files changed, 21 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index cf50fd623f41..484c04de1af5 100644
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
index 89b50d4e0400..163f26fe36e7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7230,16 +7230,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
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

