Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653023C454F
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075430; cv=none; b=YdLGfurjmTZXUE9S0+DqYRdT5a6/902mNjF5Kpj5gl+LOU62IUrwEjq708kNzK/haYEr3cfPrr47S/SDZZI3sCRnI0DWK/2FClTv8nDxEamYFaYjhU/vpuVb582o1lkhHx9BQoDS/fhTKE6Lzz1+OEtD+aLXMY6uwR9xO1qXPek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075430; c=relaxed/simple;
	bh=arsb3xKreiHkRh/xUZ5DvTISjpW9UKH6nJJTb0TxpNI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h4oNqAtjsijVGc1N1RdvzjYVS/coWVIadDiopthfPYFP9T1j47ZJu3kGUDME2BBnNy6glRWFQVzeXRVb9XbgsckKAi4JEb8FRApNF1qx/paHpIojWRaSnJBkJ2VdCn2HCEXTmihJFdfUsFVQnO/3IlXgAlcUFoH6VsQ8jtns6B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=jtH0VGnp; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nZ6n+rMc; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="jtH0VGnp";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nZ6n+rMc"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEYAFo2220684
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XXgh
	lyHKaZSzvCGjJWEbghaa7lm//M8bZyCIqIXgaDs=; b=jtH0VGnpY3h2/Idwep02
	eQlrpoMOE/uU5JWN4UGkj7s3VJl4H3DBGgXFVIUCF4woXoLal7d5mNG24E1/v36h
	JSBicOz1cOqexZrpMNToPPpzCB/14FTm/F1ka2CScu6dimDRiPu2682oMDD28jEY
	GqNb2n54b17BYJ/bOvGN/3/PTqGeQTY1AMzvXlFGemMQG6oTdUldInOHHSiybVGk
	T0Ef63sarbG+u4n0eFbVmlJ8WYxLOIH/BB5JPf19GdYWoK6Zja22TtWu8FoBun61
	yoHSAwegU5x22PTt4FZHIE0NOhCjP9DqDpy4hTl7W1AavjmKghGxjbM6m2AC7zNt
	Bg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4havrsjag8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:46 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91bc57d4d11so8098856d6.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075426; x=1792680226; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XXghlyHKaZSzvCGjJWEbghaa7lm//M8bZyCIqIXgaDs=;
        b=nZ6n+rMcSYXubXuGpvzr8/YcI0EpN/DD28qpib2kmaSfgGPRBNjCnVaff+fGRcJdme
         l+slY59glmWMWKWoI40MSAz3r3unsEHZZuRgPhhE3+9gL/27sjHS+M6irLuVjEhPVvbg
         FdCZpGnRuzFo+NG/l+omQvOM8NfICJX19Ut7D4q2oRkfiPcx5k/dFFtRDOIB/aqHPYbk
         BojqhwbXb1BA99i32EKGjcJkxwlKtqvYe6ruauLpAGcKaUJd74DjvkvVnEeA3uwuiQ4d
         lKQaHin1utt/5bjt1M5c28yDFGJBOCqinNyk9aWd63NjHUEltWWap6MJbG+DU/8sBllu
         UrNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075426; x=1792680226;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XXghlyHKaZSzvCGjJWEbghaa7lm//M8bZyCIqIXgaDs=;
        b=FOKJlcUidrV9NTiKA9cEo+hmAsf1mM7MUE00sLy27I3gNgEHQPHb7g4M7RiQc3QSxZ
         qn5o2GrkRtUjK2WfeKgE6m0feZzSP7Dbk8VF3lwEz5MCdbha0GjkSSPSjyxRIjJVCp6U
         2Xh5f0VzOk3lC/Ip7yeD5BSWumiJYPU5FoMWVfs2p3Pg5HhODJg7Cj0bpDFlru9wwaJx
         Z25Lx7+wXDvkMfztWhzSjFeqQzOBI2nkSmSVxl+YRNQ49uQSXGabSEzwLMH5h8ujf++i
         iUGEqsHp7fniUqpcwPYbHEWrg1hLiMjDyT2QtOXFYJB/m/psuezzulOKcUFaTMs3+dE9
         m/NA==
X-Gm-Message-State: AFq9FYLF09eVUiZz+43ALcJryXGXQuzZ/xXZPjW2uTY7Q0JgnoN2vGZn
	K5emGkK2WggDZK1Bf3fxjX8AJp50lqzS+Vs7zqQ1Nyy32LDQfyTcYnMKqFIgsLzART3qEZyPvCb
	a2WSCmw+fwrixo47ecXKZuks4cjLXcCp3Hbak5LVBcAfaLFHivtznqqAm0JKe
X-Gm-Gg: AYBFou2lY17s7SSrPgVG2Lz3Io9s7+bMgfpy4r1aUEf+HYyW2kW2A89nUObPrrosKgx
	168wjNyrbPH09ld3hbtqodA4ckfsZl7/56V8sKkavE6amygrnf9ELBWeLDtdlkqf/99oRtRy+EZ
	3G417Kc8o761AqzOHjhZxBPHlozYolZYZFw0sYhQ0y/RDZnAZPo3X1kNzcutfSF+N/eUzuX+74s
	eFYmw+GB1xmOLrWWa/D8rqIk3q40zZJklhR0i3NQmlp0e/Nx9hfOa4JTzVwXZQiHKQ9QdaDhI5f
	8NJi8xWHLB3mOVc/CNbZ6XfLJbg/DsLZ9gm0egY/XSJRHSrcgCBtxM9Swj2wsyJh3d9We15D4ST
	LBC+G2+t4v+Jsh21mLm84q+idXVQ6vzD4ps0F6aQa/n5K
X-Received: by 2002:a05:620a:4692:b0:93e:95ce:539c with SMTP id af79cd13be357-93ebd0e4018mr3138024885a.2.1792075425831;
        Thu, 15 Oct 2026 07:43:45 -0700 (PDT)
X-Received: by 2002:a05:620a:4692:b0:93e:95ce:539c with SMTP id af79cd13be357-93ebd0e4018mr3138017485a.2.1792075425188;
        Thu, 15 Oct 2026 07:43:45 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:44 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:27 -0400
Subject: [PATCH v5 14/19] btrfs: remove
 BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-14-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=3821;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=arsb3xKreiHkRh/xUZ5DvTISjpW9UKH6nJJTb0TxpNI=;
 b=76d/tE5axxvCeg18TWbuXemy6PFkIvesdTS004ipsi/4w6eP0dZstjqo9tNDyhDc0rohrmsWo
 DYSfztTIraSBJvGhGpje3xbsJ05FMQjJbD5Lk1fIyWcK4arude3hXJ2
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: fOcbh3FlCa_Z4KCgig6TdMzpvEiRpuKe
X-Authority-Analysis: v=2.4 cv=L/KI0OT8 c=1 sm=1 tr=0 ts=6ad0e6a2 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=BlyEiQbNVX7t3OJdSnkA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: fOcbh3FlCa_Z4KCgig6TdMzpvEiRpuKe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXxg1SSLIm6urs
 So7VjK/sSz7yHDP685wmSGeyWURRC0kcPkGOBmy4eqz6k2buGXAomMoPmRBtKhHVbBCWzEwbXW3
 H7dX46t5X3SbJT7lcdwx6Vrt2z7PMof0jo0jp2AnYBk+spohl0W6BeB/5rgiIiJObhftMSQGP89
 vkYcGSnidrqQeXZeXE25BDpSdrDgpVA+pMD6AbjQNmWGmN+LY8NOyjmuhnHg98vJZmsRgYW4ZWu
 +Rc5ppCrnhyLVa8TXP2UHXap20n7A1jXPaxsuh6N4GfcNd4ju58h/yawKb8Urd9n9CewB2bwoUD
 4++7Rvvc2WdhcaTix9NQTL+scdpVopDJcbzy4utlkVTmkTl622DMsxfScjnpASD6G2xczWC9Jcw
 KHqSNujUgdow9PXjIVPF9dgB1F12Gf46mcVaIXT+lCkS4YazPHtQnIY3PRKMv/phKeQE62cAias
 tFZY+mWBR7Vornpb2+A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXzbNLTCaEsF8j
 Vym35KZoG52OY0g7BsNho3AzCC9OO8AhLdPfQjI/48tUd0yeVAuMtAN+Wz7hsolcbi3lEQH5+bP
 TwMjbk8E7gN+wLARTTULEM0I8KjfNb7Lg2xPVudMsjWjCWT1IWVw
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=10 adultscore=0
 spamscore=0 bulkscore=10 lowpriorityscore=10 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150057

Free space inodes no longer reserve data or delalloc space, as nothing
writes to them. Remove the flush mode and the special cases that
selected it.

Assisted-by: LLM
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
index 72fa01502461..82d4ac418a2d 100644
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

