Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34051391845
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334501; cv=none; b=XQoanhO91gg1BvIj75Dy5V7Uu+AtAVdl0XFg+m2/IdKV+6gCAZyBgq64m2AUX6wf26N59VKaNvzoCm70WHXeh59ERGPqwcH6w6CTCj51xKMDVsgson43sq+tQeMq1MNmVyRwXuhQkffyUy6oL1g7JjJC79r+uKQ60PfEASEjMg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334501; c=relaxed/simple;
	bh=rTEatSh2afYJTS/R+S9oth9gqbiO3TcMxRS2cWJg+9I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OZmfHAtEB79FY8YzibVoCVUvk9q6L6yioRfJWOQxsJ4DtvssBo6NSVX0E35dzjEoY6Q43DNWy6JJyTkWkGNNvBStZbp1KGSttU8A6sBMblMmewlknbDJJSfTR0mOSGPNtCVm7Wj8DA3Gc4Wsf+yc95zUwDCr728EBqTCVAXO9vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Yi2XrKf+; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=VB38oS/B; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Yi2XrKf+";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="VB38oS/B"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKXdhF1191255
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GK6I
	62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=; b=Yi2XrKf+av8ZxyThDfqa
	GJVLeK9JtYYFmAjln8d7+GMzoBS4Z3OCTNUmQPOPSolLcRGHanCXTAldf8SSX8vs
	+xKd1WftY/Qgps8/xiCQs/fGjBei1C2WSsPhPa6txB/bSeJhuIaWYU6HnjKX9KEw
	9g+OO278T5/IJcE150+J05Ol18fkGo7V6VEdicLymlhHZC5w344D+GzXjplHgXt2
	9bTGlBIA1hHg/ZpFLRM17hQXwqROh0z1Awg7o82WWGcPuGhu7U/uILJFfK78MW5A
	L+2+kJc5TAjzTMdHTaMPjxpMKaLB7sQqwXltqgSAopQAbH2wjKnQkqqjOEBK1Xnt
	ug==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gnqqt2s1r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:37 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9104ba8bf51so73762636d6.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334497; x=1789939297; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GK6I62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=;
        b=VB38oS/B0Ek0e/OqyFlyLA/j0qdb5VtXdoXlFHAPgJ+cDIr93uVZUkumaplUiBO56Z
         Bd9zFmAw0skAl2W0F1xEzR36w9QNQvEigg5/4UaSx/eAazPqpqghXBAOex+EeEX7LbcA
         TkuSl9dO8MKGowx283lZgv6vUMI2gnf6lxZY/6Mljw0/mixP9oTfStX1X/xBQ34gcd/A
         IWdIsINfPD06jEwqL+awAPmyJuOZ8rC0XbEuzl+5wZ+STm94ZMxTsKtqOJTBs3dY9atH
         zUPEcq68x7PyLnOfMZ9TrQpQOatdKAdNHZLgZrfxE2HsxZYCHu04DZFHBBdcDenbZC/w
         ylog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334497; x=1789939297;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GK6I62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=;
        b=EPl3JcfexD8/bH7+/QxEwx1HtTW5ESYgBJNWOfD6AYEvCrptaui9r4tVEgeF2fY7R6
         hW/JRy5jccqtfaHagCk8HXpaI6NX6Fs5bD/kzy7y5xdz8U+taxOH+5W0DfZ2aq7AezDo
         ynIir4WugaCsswH+HZBPOCsbeukA4R1eSpEROJjTDtATQoYgSLWG9qLM8H2VaaN4Uu4D
         EL+krPQ/VcMzWpclorgNmqPiF1tNiFRGORO8TY+gA/SHas/xiP5jh7b9/3D9L58P4MVY
         /do1t98UyHx8YNox+CuNc3mqgSL0JAdr3WDgP82cJaMkpJVfjfeOTGMLn4O2+spDpc8Q
         EJAQ==
X-Gm-Message-State: AFuF++lf8EOBChfeU9F7mCdk2UGwVt9MGwpbPySlSyV/bcMX1eeoL1Mg
	5/ppBhCeRmxrV6egY5Qb8JhzjEMOldxBc5/fjTLv+fPbpT6DLg+LznGtktRy8KdW6yC7JheXwaV
	5hequH4zaqGPDf1CKB+ww4NN8+myEubYqlhidRUA3qj5a6oW5zISRG0rD/+gM
X-Gm-Gg: AYBFou0tqIVLiaxnrTqNWHigOXr0kyaBmWiiVdThuqgdRuHpMswE1iF8h2RLhuSwAPs
	2kJgsMUFO91tp7fHu2cdtss4FkUwuZiSDSqHfb7GFEWhQpX2lXGmgF1g4aEDJIc+HeGqa4SAFmP
	gjGjuc4zqEga63y4B6UkB38JqzFrz8StikldMeY5qZjqCZKAKz3qUd8iZXv9EKIjPlemX0HCFUW
	+CSd5foLYRgjsZLi36fwgM6ujI8spq0aIut8pa8Ywkh34qhZowLcnzHCDGaEo0LyMx66yyAFNOn
	q4O4KYT9Anm4guhamfATkcRj6L7ZLTaXrixXWPrWkz/P7pMNKKcItSunX3OdD6y0NeaSg2l4QYg
	a2MQl95JhHqh4xebHal4lm07FUNj8sGkncqNMvPUmosyMrHQM/E4DLQ==
X-Received: by 2002:a05:6214:f64:b0:910:3452:d57f with SMTP id 6a1803df08f44-912120efc7fmr263360586d6.31.1789334497320;
        Sun, 13 Sep 2026 14:21:37 -0700 (PDT)
X-Received: by 2002:a05:6214:f64:b0:910:3452:d57f with SMTP id 6a1803df08f44-912120efc7fmr263360196d6.31.1789334496876;
        Sun, 13 Sep 2026 14:21:36 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:36 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:23 -0400
Subject: [PATCH v2 11/16] btrfs: remove
 BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-11-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=3841;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rTEatSh2afYJTS/R+S9oth9gqbiO3TcMxRS2cWJg+9I=;
 b=ZbhxTfceyOk0EoQpTnqyXZfr/fWc5hGSseSPlkPuJw+jo4skgofAAjaaotzC+HWztoppbiEJG
 sBGxD3uyFZWDmkZ8L8Fpq8ZZnQZOAfU6yCR1KVzDsPU1V6jYfNk/dZP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=N8y8hG9B c=1 sm=1 tr=0 ts=6aa713e1 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=BlyEiQbNVX7t3OJdSnkA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX1S4RNznbpNpQ
 yo+nSI3dFHbky8ZnfefcCV4ps05hX/1R1+mGEg4h9FJGcp6/84T6s84SuLUgpWYKmY650duOURm
 qRmOEWVcHpx2cG+LGuN40GSV5VGDLXdv4xYD4DTu5RBsgR89Zapr
X-Proofpoint-ORIG-GUID: QEdE00dB4fgo635EBqz11TOPHwIkaZb4
X-Proofpoint-GUID: QEdE00dB4fgo635EBqz11TOPHwIkaZb4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX6ki59WloZ3GQ
 OOm3cvHpAreZsJe9VNwE40Y5bFPcgJUdRYX10TesiUBlH6K9sBvax129CFZ3BdCFiG03gyN5MvF
 6E8Y8PHSUrnHhQE7SXxUd6Qx6OAg4FcTT9npkiOAO5+yk73aDf8BkQDJSLtBQWDPrGyKXy6iWv8
 ErJsMGCU2aOyTRci6+7crvfZn76AJKeIivcRtRiHfyWiXy5HY4Yr9q84K+Lml6ZH3HEgaBG+AyQ
 MSaj4aJvyycNp3MBNi8g0Hqvrr5eG0FiY1eLX6F59b2rsZZtp+5E6dqSsc7stWhVNniUQ3yU0QK
 gVrpQId35elvSqNDW/C5uHxT5OzEKyHrRsMjbJEn52C3tj/AGcghzXGFLsFa02oyWQ8p+civO3A
 z2yfjs84nFaaCStMWXLyRKtenKP833xT7AbdTEzuiuitPbnMWjiJhS7CMXBGD4jG2Uafv216d8H
 iolhPiaq4s2OVWsGHUQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=10
 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

Free space inodes no longer reserve data or delalloc space, as nothing
writes to them. Remove the flush mode and the special cases that
selected it.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/delalloc-space.c | 13 ++-----------
 fs/btrfs/space-info.c     |  2 --
 fs/btrfs/space-info.h     |  4 ----
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index d357ed7efd99..77781852e417 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -132,9 +132,7 @@ int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes)
 	/* Make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, fs_info->sectorsize);
 
-	if (btrfs_is_free_space_inode(inode))
-		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
-	else if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
+	if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
 		flush = BTRFS_RESERVE_FLUSH_ZONED_RELOCATION;
 
 	return btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), bytes, flush);
@@ -155,8 +153,6 @@ int btrfs_check_data_free_space(struct btrfs_inode *inode,
 
 	if (noflush)
 		flush = BTRFS_RESERVE_NO_FLUSH;
-	else if (btrfs_is_free_space_inode(inode))
-		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
 
 	ret = btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), len, flush);
 	if (ret < 0)
@@ -326,15 +322,10 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	int ret = 0;
 
 	/*
-	 * If we are a free space inode we need to not flush since we will be in
-	 * the middle of a transaction commit.  We also don't need the delalloc
-	 * mutex since we won't race with anybody.  We need this mostly to make
-	 * lockdep shut its filthy mouth.
-	 *
 	 * If we have a transaction open (can happen if we call truncate_block
 	 * from truncate), then we need FLUSH_LIMIT so we don't deadlock.
 	 */
-	if (noflush || btrfs_is_free_space_inode(inode)) {
+	if (noflush) {
 		flush = BTRFS_RESERVE_NO_FLUSH;
 	} else {
 		if (current->journal_info)
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 39a28e1bec8a..01018152c054 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1704,7 +1704,6 @@ static int handle_reserve_ticket(struct btrfs_space_info *space_info,
 						evict_flush_states,
 						ARRAY_SIZE(evict_flush_states));
 		break;
-	case BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE:
 	case BTRFS_RESERVE_FLUSH_ZONED_RELOCATION:
 		priority_reclaim_data_space(space_info, ticket);
 		break;
@@ -1968,7 +1967,6 @@ int btrfs_reserve_data_bytes(struct btrfs_space_info *space_info, u64 bytes,
 	int ret;
 
 	ASSERT(flush == BTRFS_RESERVE_FLUSH_DATA ||
-	       flush == BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE ||
 	       flush == BTRFS_RESERVE_FLUSH_ZONED_RELOCATION ||
 	       flush == BTRFS_RESERVE_NO_FLUSH, "flush=%d", flush);
 	ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_DATA,
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index aa836e8a9d4a..d0130c8ba3dd 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -66,7 +66,6 @@ enum btrfs_reserve_flush_enum {
 	 * Can be interrupted by a fatal signal.
 	 */
 	BTRFS_RESERVE_FLUSH_DATA,
-	BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE,
 	BTRFS_RESERVE_FLUSH_ALL,
 
 	/*
@@ -82,9 +81,6 @@ enum btrfs_reserve_flush_enum {
 	 * priority flushing for this, because otherwise we can deadlock on
 	 * waiting for a ticket, that cannot be granted, because we cannot do
 	 * any allocations.
-	 *
-	 * Apart from being specific to zoned relocation, it is equal to
-	 * BTRFS_FLUSH_FREE_SPACE_INODE.
 	 */
 	BTRFS_RESERVE_FLUSH_ZONED_RELOCATION,
 

-- 
2.39.5

