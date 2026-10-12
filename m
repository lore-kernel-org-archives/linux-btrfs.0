Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4564BA9E5
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822537; cv=none; b=JoGwAo3SfN8lIyyEZ8TALbcpZnzm4a1gfDTDMYxguxkW665zOGkuUIT+ZD2qq6jSxUVvv2m9RnwK59Xoz0DdBHLznCPSFB7HnluigdcBWikoc1W6dknpfWrzl9bHtqeG4UEGbR3JlPSEE6urzg5FFBLy+bBBa2snwIEv9a9gIgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822537; c=relaxed/simple;
	bh=arsb3xKreiHkRh/xUZ5DvTISjpW9UKH6nJJTb0TxpNI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LfgIileA0aeJMHP979TBsmV+ruqB2V92wQd2vOKGHJbFDc2Bc8eOJDNFTaBNFXBKCsu4S3qU9Tbvk+9U5clzDyrrnQkm+6mE7p/39Z6Ib8Pdv3y3WZz/7A+9pYbe9NL0jMJ45OgtB+wGChMgR/70X3xf0FJn9avXX2xy3TRLGGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=pieWHkbv; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=x9FbQjLx; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="pieWHkbv";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="x9FbQjLx"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CF8Kkq573033
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XXgh
	lyHKaZSzvCGjJWEbghaa7lm//M8bZyCIqIXgaDs=; b=pieWHkbvBZa+Djn0Ztub
	R+r2n4oAB0IF+Ic8lUy+FED+U2HzpOCEInyK0bny5F4HjSpNBFe9dS6b2v2MJCOY
	r1R4kFlQZvZYo2ch2SjuOfOCJgzr3MMh2ohq3j70SKuvTwXWa7hMAZgEHmNBzFoz
	5YXlF0YnHvnKw0/Ccs1+xdA8ePeidzTY5DKPw8g3UybKB7KW+6QH6NgFnerr+Mft
	AshwgNLd8yNh7IEw1qzld3Ikm7lJgAf6K4DXlkcRET7eOtLg8ryJhBU9IkLV7urw
	c4imkCp4nW5tEgLX59/FNYtDW1NEnzB/RJGvfXOqtztHc5rnmi7X2jPKhora45uD
	WQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h91x6rwde-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:51 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5338cfe567eso45118991cf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822531; x=1792427331; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XXghlyHKaZSzvCGjJWEbghaa7lm//M8bZyCIqIXgaDs=;
        b=x9FbQjLxIc43OWX7l3AFt7KfWfp+JjSYutv7TfXX1PSeGp2ewpPV8WKBX9FLR1pNje
         /cHAutcZPR3bWbu9mSxa9AwMoH0Bz9EDF2+A7Suzx2tVrn5TeglHVEdkx16cUAHxHmri
         iaff6iWwbryE0hC8GTOshnrP8xKMOow7iLBkJaeAO4FxmDtnt78T5MFwEGUtkQ82acSc
         eADQz7wpRP9kvTh94BuQwW0W0X0ZxPBQ2WNiyU6ShYvLpDGKDTFYDjOcZMNo5vDitX4R
         WhW96l4vtou6Gv//pwP6R32BaHVc2imfHTw9yjYYqqFwEvt0YLjKaYeFiuKjLrnLj0Ey
         X4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822531; x=1792427331;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XXghlyHKaZSzvCGjJWEbghaa7lm//M8bZyCIqIXgaDs=;
        b=r2syOZ4D8GyPjkyCI3r3AOL5N2W8N48MfyQ+gIuSMucO0Ft5NjHJbC/ildfslLHRL9
         j9QV9S16g2DbLBpuPqaBFD62IRN+lQaXodpNz6NajMJlf0Ow5F4zRI9jmv8QyiCJpvkp
         C/c+sJJbm6rQ0IS1yJn7hArax7tjdGkN3u4BTREoQL8/Yto3t7ZFTbnfE7zUpG+QVupn
         j/dBqHNSLEFiT8wnHhfC1RKR3EMP7tJ/djDAw0FVZrDHkzYJnYRQ/nfEvzzqQzhTagTR
         0oo0XkGsqHl6n/WctT7EhbWpaxCEpMXnQJ98QxuE4Sf05ByccGdhmZE24MWkMA5YGvwG
         Bl5g==
X-Gm-Message-State: AFq9FYK9j8DS9uMm9zwvGzzh2YghTjBWBI9XjMDRvsNXtakfWC5aKLEJ
	0BgdLxSNIGIyj38aGId0egKbW7TlT5VQeH/YOHbKyjd4ST27QSZyYHipaZ1MkA8kd93xHazg79w
	sQoDbGAI3ysgBrz0ulMSD1G/zcO6vmI+DvORqFV6MxmPXgOtiZX4NkcXtrAnD
X-Gm-Gg: AYBFou1O8Ch80cpn/dLx3UUWxTiRxY2ywupMJUQZHgZdg6AsD4MMdwc9vOG93C6tzOV
	rz4E3e6ZGzF6Fubn+CQIusgWL4rbgT/4Rr3F2OaHuGybQ6tSypM/vBRE3C6uCiHYYR/nCPnJmMC
	k6217fXP2U93GEZB9xhx+R3qrapUqJcEXP5hud9GNQb3UEmKUbyFac6MD8kkzVbATSlv5e98OLP
	Rb5o1uLjE8FBPr5SqLHY39BUu2kDPI9+JOM8ccEBolYkpEPSz8BHA4LlPKCghJued8ygNfVYBbc
	LzHQMsjydML8MDESMkYg1kW77VCiF76ZBnDGqZg1MWSVeMFgpQNeRQYYgQsQM1WTNCtW2W3C4XB
	BTAAY1sZz38DFHpdWNjKeuiU9xyBHYau/KEc5TtHU+et41BY=
X-Received: by 2002:a05:622a:1e12:b0:532:c057:9564 with SMTP id d75a77b69052e-5359fab3627mr169217941cf.23.1791822531168;
        Mon, 12 Oct 2026 09:28:51 -0700 (PDT)
X-Received: by 2002:a05:622a:1e12:b0:532:c057:9564 with SMTP id d75a77b69052e-5359fab3627mr169217361cf.23.1791822530598;
        Mon, 12 Oct 2026 09:28:50 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:50 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:25 -0400
Subject: [PATCH v4 13/18] btrfs: remove
 BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-13-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=3821;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=arsb3xKreiHkRh/xUZ5DvTISjpW9UKH6nJJTb0TxpNI=;
 b=KS6Sz+z1pBnIuEr/wM91RjDbECU3kCa0BtzUFbMa5RwSYt0R2MtdSQV27tQH/WZDb5YTKkY5p
 tbu9tKCoBl+CGsMTUjFMs0b5/r2VwEpgXkvRn4EakqiBvAykjYegxEn
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: rJxoTR9dJmbYm5NMdouKU1aNdf4VAUVR
X-Proofpoint-ORIG-GUID: rJxoTR9dJmbYm5NMdouKU1aNdf4VAUVR
X-Authority-Analysis: v=2.4 cv=DrDDa2/+ c=1 sm=1 tr=0 ts=6acd0ac3 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=BlyEiQbNVX7t3OJdSnkA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX4GGfWXdHZgvi
 iaM6BuSPSAN/b2hoWdaknAPLGCyOb08g8GQjnLx5n+j2AUWgnUfyjHpVPSkk09Hrsk2BxvM9+KD
 DPpnSNWC1aqBitw1MlFCd39djxGRqQZowWQLpDh5QGTzZSIr/hC3lUTqHFnqNRjIqGrGZaJMnmw
 nZnBOwsB4Qav5/e+bBNLGYwPY5pmi+n5JKtLgAHJWnmz7Axf+XuRXExnDYaZ1VxMp1ySswVl3Nn
 62m3GBpWuMj5px+1I5r2tSsz+cHFyYKkM+3195P5woNJ47Al7ZpaFqQUwkINLfhiwtrqlWxpLkW
 xiNAQvz/XVNJ/EAFylqWmnBDsVpvF0LYOgNwUyX9w3XGNuLIXorzHrQLNQvep3DhILSD0IJt3YG
 uoRKRbogxUQmLTT1SkTbZqnqD6qCvzdFdufL0jLQJRFv4kQT7Vy+TSphmQvBgHzYCqloAlHTsGB
 bgrOxloOQz2ze+aDEYQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX2Etqt8zyPJ/o
 SfquBJ4sljjmt8Agz91/OrLcnH/JYqSr5a7nLnxU/LHYyXyYyOW9N1Id+uaxOB/q6CFIfptiVuj
 PqKWCn8dhN5LvLKoJqmyl9Gvl7kBW0qrDEfFv35iTZjm9OXHYp5l
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=10 priorityscore=1501 adultscore=0 suspectscore=0
 clxscore=1015 impostorscore=10 phishscore=0 spamscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120065

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

