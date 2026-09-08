Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C185E2DECDF
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830420; cv=none; b=Y86basW5TsRBo6v/Ihr8zjyA1WOKksOWwIKU7iqinyjziVZR2w7EAXl1OOZ1HVPI3knJprS2pbNhYjebJL6Ro+Xm0J+iDOPaAONJlDfvwlqfXVHrdIypsuCF3bXFwnw9y92HpVYMhC17STzJD8j4znOOxrPcsPlbCZJceQSdPCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830420; c=relaxed/simple;
	bh=zFxwTdYCThz/pj4rRJQzgRssc/yjoLDS6oQG1BqOgds=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k7W1BIBy0AAW46i70IZtufZanu7ZqczHB5LREywK00Y86X5qZuFmhaszj/0GExWKHisK6Ds56SsJuRdK+5wMlpF9f2mRWII46+2fveSDz4VLZb8bhyo32juA0zw1WEEfEwIQuBO4p0aw1a5/h2exN0uIJBwRFPUG1vyYg2fu6QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=SWx6llIR; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=kY33UHcR; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="SWx6llIR";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="kY33UHcR"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880uf2e3795728
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=07fe
	Mxoum7S5Ym2PiVCScGldmIwxg5T94sGONJXUkrc=; b=SWx6llIRK4edzFA1nNHz
	Si6bjHFv74o41wQLBUYaGKWIdm7jkSl8DSflVrixwq4Rc+MzrA3+NdKnyLuM/uTw
	4TnHeQ8c0W2/0btJdbfXXdyXduSmdvLY4xUNlzcfUdP5d3Tl+cLfQGP8ugDwpK97
	etz7Ab2Z0qvAculvlbVjDV4aQDzLt7EiOnp73UDNCWwVJZQrUL/uktjbB1U524JA
	4n0mPYXHRtaqWLN8eYJmNLNtNBH1/tLDZYx/K30VyvWCCKPkRdEaRPFwYqSVwfuE
	9uQaHZq9fgLZS7r7m27RjNSkwbFydk53+qBD/zNNhz0WYeat6JT5mdOIKWhF5kfq
	Mg==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gj52xgxy7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:20:04 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9105cf082f7so19380966d6.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830404; x=1789435204; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=07feMxoum7S5Ym2PiVCScGldmIwxg5T94sGONJXUkrc=;
        b=kY33UHcRBm1ykn178KuDXCDKkXr5KjOg5tWPRcPKJ+0zKktbA7CeDolK4USHDkkzUc
         2Q8hzSt/9yTB5NpN+aKWfgvk+3zs9Nkgp+Nl43TeCxHvSyEgh08BomCko4Em6RemZ2cB
         9bK5tQGVWZ1Q4mgyM1MfvIIiqNY6ixtB39veLQQ7Ly+WwCsPbB6rsvES5+4VJaGrKTwy
         IGlsCakqJKDC/d2qjdFOuF6VbaHqro6kVqHA/3Gh4pU1el06ARB5SxKT6wpApbbVwhkY
         Xj3A/MHT0Ta4MtW+jQk8gUIeRxSHDTAs9wnMWkHFMD7/9g3OeHPCv3IZft0H6FEcsIGg
         /XpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830404; x=1789435204;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=07feMxoum7S5Ym2PiVCScGldmIwxg5T94sGONJXUkrc=;
        b=nNRZ48Ltko244HqNwd1KlHUOjEACKEx/PTVABZ2I50ogEiLgWF0P328qawftB2Hnqx
         AQ6uDM/GMW4PbWYTkl0A+EGIbEtof4bVoiznWwY63/kDGjVvkcIU1SGbVqNvE/5rsDuh
         OFK56CK8uQBBKzDLNPXZ0J+Q7FvRMdhlDtnLu9PqO2+6K4/5FDmRUUmi7VAT9oV53894
         ok4LqFlPN+yrzDVWzm08pSQxd9j2wWSNYv0wnsfSqczwTMZGyOXSbTMS0IMAmzWEM45C
         F+bD1LZugeUvEBmMoLEkFBHjtCHVJTXCh7K/qZYQU3M4d8qE9qilOPMKfrKcavzX6W1d
         KXfQ==
X-Gm-Message-State: AFuF++miAjtHMzZB7lnqEgrGKtS8Wn7U1o41Tus/1VsDx/NNK2dhxsqy
	gdZDd8paElOOW4maqPCov+JE+I5U+2K2qExdI0iSnmTLfTj40aOJSxMD9F1RT9ER1Mk+VpycVxo
	S6foHLVwsG9Gk9RGpF0JDveT0sFXbYCD+SevW2lloJPejIEyC7RFNI5ew950w
X-Gm-Gg: AYBFou3skczZycaMrb6VpcCtSY+ugCit2B0ngSGzFecZlDKdBwbm8Ckz2foxI+TP4nJ
	icQA8vkSmN/Nt7xOZe24O6IujczK4fz1ygD3Gq9icHzJ9x0I1qXSZinxmVHRyowWA9HwX9qacQx
	tuN4+MemETDU2y+Yhk0QZYFcsyo5RwflzR5adJxO/60tw7aDliEfXv4Qwkcn3fQu3PLr+rcrNTc
	k4Kj2pLiXs45EcsUieQ3TgnaF4IHsrzsOaDepIpgj7SN+Aue+WQMEzoFi48A/82azDPT3Xoypk2
	vx2bHDEKBjU8pLIZ7bqKNcffgDQldKEY2cdL4rLDPyEcKCH2BYf0hsCPgxFc5FtzUYgi54AegdJ
	fCpNDESjrzcYrdBswieUmfKKTyqnwUyuXk/57xN0pRBSt/g4Ekww=
X-Received: by 2002:a05:6214:6005:b0:907:dd19:fcb3 with SMTP id 6a1803df08f44-9103ef703d2mr286489746d6.24.1788830404429;
        Mon, 07 Sep 2026 18:20:04 -0700 (PDT)
X-Received: by 2002:a05:6214:6005:b0:907:dd19:fcb3 with SMTP id 6a1803df08f44-9103ef703d2mr286489416d6.24.1788830404052;
        Mon, 07 Sep 2026 18:20:04 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:20:03 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:30 -0400
Subject: [PATCH 15/15] btrfs: stop reading free space inodes from the
 commit root
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-15-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=1999;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=zFxwTdYCThz/pj4rRJQzgRssc/yjoLDS6oQG1BqOgds=;
 b=wPWNzByVne0lc0sbeWWmpxkE22+H9rq3HTAyhtftQA1WXlPMbQcO5iaLkEunryOkJQwXyOB2S
 tflMgvDGgPVA0XtFuyc3HEVthT3tT5XpcAjxH9vsGUFk+HqQ2IbhTMk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=MLRQXsZl c=1 sm=1 tr=0 ts=6a9f62c4 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=F-rX_8kjA07mH5tGMmcA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfX1csCIzYxQIp5
 Km1vjdgVi5ZvGQL6UVIySghUAtYTRDzLM3o/5Xlq2kxfkNjZXITDAEO4/FC/poyhFxJWbxkHXKF
 rPoBgqcuqHuXi+VFsS6Pu9FDXADS1OjD1PY5GlIw8Bo6R5g5w7iT
X-Proofpoint-GUID: ihp4QtK5fkEqWRtRpapGpwvPRW9hulyZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfX8hLILO8jz3OE
 FvKRPLopFVQnxvEl9FIjQMl7HTvI/ga5e8C0s835q1STYqP6TUCLCCM2Qk+hjbbV44aMKCo7D/G
 c/X3mZ5IW6Z4JH19JN/+WFErSkSud2l+lE9phjae59IIoTfur1IMCP5sWZSlQSFBLWG5naAeiDl
 8XdZ1X86OUmam9lE1LtthXcMY+Zh9zOL/Cdrzf44UxR/VMzC9VWGcB4elBxiD5n4RyfMOBaRFZb
 KRM5yqHhbuJ53SDnNA+UNjZE9SXRpAftdna5Rol12ZkotpkoxwmA2ze90Iv//AFOa8USmVblpVY
 niw45hc9Y3Gr9719EdaC//V4w03k1MRMNlhPgvRAI27bLa7Hp66PNOXz5AbmUjORBeMqryieM6e
 4+MglY2rIaA5UasxmKLLlCXAsY5IniAsmvoMdvT5pjSjg3VlnFo/lar+UZaCFJeoK/xVcvuxWqe
 IOete7H1i0lfsJdcFIA==
X-Proofpoint-ORIG-GUID: ihp4QtK5fkEqWRtRpapGpwvPRW9hulyZ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=10 impostorscore=10 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=10
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080012

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
index 3a1230b777e9..cdac30f574d3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7215,16 +7215,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
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

