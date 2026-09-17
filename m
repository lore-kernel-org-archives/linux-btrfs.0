Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1023CC7D6
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617645; cv=none; b=YWlvB8/r5/k369kboloMVuWbJ5qnJ9i/6ochEuuE21YMH75GWCP06E8GHkPqjhgv/Gn7kSdt/u/3+QYWZkWks/xdcelINc3BHnEwRzCqwJxVmGmDqzFavLHuFCxaTnUhKZUeoPLxgVgco3KMU9G0vR5MpzIV6S/qKFIFxW/rfd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617645; c=relaxed/simple;
	bh=rTEatSh2afYJTS/R+S9oth9gqbiO3TcMxRS2cWJg+9I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qXqu4udfyQU3RCKuFOL1HeBmkaCJVVfk0UlyozY90k6cbpxmG2ziW4IHoSYkbW81ixIDDjXjfrp7N72S+6mrRKfcAA01NgN9w6KTXeNN/ccyzCu1HOsd9rolLviCg1xxaVsOrr/kQV+Q5BVNHj/afn9+pRSO02vqcF6Xa2bTUvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=JG8JuXdv; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=QCAmTFhC; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="JG8JuXdv";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="QCAmTFhC"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2Z12R203542
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GK6I
	62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=; b=JG8JuXdveTE70FNJWhkz
	Sj3u9lg2ao+Tn7/gQs77n5OFpQwQcMInHeKOf19wSLgZXuBBr4cAv0W4rPNe6jeJ
	feA9D5tAJCIbN1RrQCpkIJuwEZO/qEAGPd/x/6r/eurXAmHq4d30AIQO6EuAzAGU
	V1c4/lNy6ZpslT8CQQ/mgV5/jJbHHcfu/wIWnFBKgiuUf0nqYkIHwD8cULVo35Yd
	JqyBS1fD7/w4WvM1fE8uC4weZa2P5b2qofmdCFSt452zgBmskoJ8gFILJdGd6tdp
	N4kAlzq319cWlaamidJs3pXXJl/0lgyUhqEdIfrJhrsFFX+1TUFbSiwe5Li+uc4b
	5g==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr1x6adps-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:40 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-939d6c515deso74209485a.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617639; x=1790222439; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GK6I62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=;
        b=QCAmTFhCL/j97kiNFLPj+O4DL3fOpj5z8OWYy3I9ucEjJ9p8wNr9GLoZHIz2FNnAmZ
         JrINxlWUvI3g6xzpnXOrKK7jNayhwQQly7L2U5kqmWHtH+z3xiiV6WADc92wq6wkjk8U
         jgMdQ5M75Y1Q09ielSNMrIX37gZFZvuQgbGRb1EX3jaA1Okp5vqiZ9YipK3aoBsS+xJT
         j5jMDleC2+O3AnMnCXd6R6X81qQNR8MmQfT8X1uFXrFehDu/Lo791CnNJiy6S7yh+55D
         xh5VgbeJ44G+Sa3IchmjNqtOkIafohDM7vu5rSpxkue+PuX4+pS8I/XzCoTvFan4H3zN
         M6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617639; x=1790222439;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GK6I62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=;
        b=2muDNRAqj41+9aee0LvisHBtits02+6DlfwYShS6ACMW38Y3dFv8awVKwpGvLpGZaE
         GAFkmPSGUZWwJ48CnJAEYhZRQqoETEEU9yaMFDHu2enai665CjtpTmVUdZJSg0MDwQrq
         F4mkoSSZnmRThh1K57ka0ZHKx8hLqydHkaGFTvRZI+NaHS+FE4NNsDCrMkDRyt0Sx7GA
         VRiEV3nPuqJYb4Ix3ah0l9wP2xqFCOCduVpqy0vrxP1Ey898t33K1KUJm7rZazJDGNmA
         XarWP3wlQck/gHkM5ofDVjH2CVUYgbgG0t2G0A8xOQzCf+TjQGNvI0QGONB6f3UYIuXQ
         kyIw==
X-Gm-Message-State: AFuF++maNG8Oz0Tc91hKWbeyMfhCSwdYpsf2nIO+rsQEjTY/7GwNqUAg
	wOVSWN7hF79SCnDBMNjxqbwfnxau6y3h6kglg7SjzBqLVvS9SQl8WhT3UKXgFSIGfnOI6wCcMrl
	+0ThNGG4iU3uGimLl9UT/sJuTjXGZ5flQ3N3eXxYpYYuHs3wU+w0TA/RjnUzT
X-Gm-Gg: AYBFou2gr77Dq3q6tSeHUr9LAZc6TzNvB5obm7/ttlgXDGKToC+fxzCpF+sBlstFvr+
	1aVifOdojwYf2H+K9Wz3zrfMrHUqBhJ/4Hm0XBucLsRRjKAeJ02lUTBIX6GjvVOgcGKiM7DqGOs
	m+DKVwrkBqZWZgEiMVj3K5cg8j4SY0V7mkkI3/M7T2FQsPFl7A3rmFg66raHQhlqQ8AOrttZXfw
	rUj8Pd2RIhbSwjGpoUyN/rkXXxHsCBzv0WtMzGJVctmAwU2kgBvGQpbsbuyD7RJtC2xd5dYYacd
	45C8xO8NymjQrSBMi10Tzbef6eJGfWt8T5A2Fqf4d2tTtM3NTM0FTbgER+5p98zzYcEQU+ZzNTv
	HXz+mMGgtxeoXupmIsVK0v8udE/D3Xm+QaPo3Nwf6RS79EQ==
X-Received: by 2002:a05:620a:450e:b0:939:8373:b552 with SMTP id af79cd13be357-93bb76e6382mr844246085a.1.1789617639542;
        Wed, 16 Sep 2026 21:00:39 -0700 (PDT)
X-Received: by 2002:a05:620a:450e:b0:939:8373:b552 with SMTP id af79cd13be357-93bb76e6382mr844239285a.1.1789617638949;
        Wed, 16 Sep 2026 21:00:38 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:08 -0400
Subject: [PATCH v3 12/17] btrfs: remove
 BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-12-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=3841;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rTEatSh2afYJTS/R+S9oth9gqbiO3TcMxRS2cWJg+9I=;
 b=0E9XVpUBVOquIFrMxLveRVOBGXb0CQOO1+3nXZiVQ69wCdezbEW+0Rr/+6oxxWzurFvt6Ygrp
 gsfyr2XzCAWCUMUTP8g3I7aH6hs47zPvbjNBQKpj2NxD1ZugKE6Qlfa
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX6N1CvOnAnbVj
 4V/CmcYrkVpKgLEZhe6pvBLZ1WQR+GaODoklAw/n4tKwN8/z9cYdwTUFNuPgD4KuKKB9XGe6KHn
 qh3kTkIjk4nBidax1IGOBTpSaGry7AUUG/dJ0RgitaD+BzoCpQVi
X-Proofpoint-ORIG-GUID: XJrLt6Ch7VbD-1fd3SJAk2nnlrSvFMwM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX4uTezM8U0znM
 MSkhty7Mamj6NjTBKJzFhVjP8ISUDkLMIlhUT4Is7Q2An7aAFmWMXF39f3eBtJiXcHVqEYmwnJN
 Rc6LB6NnTwmTBlKYkHihCWQBwSR7vPMkwEBOjR3y6AmS0RA9V+lveophPsl8vlpJ7ZSNIJw2h7M
 HOIcHqYb15d7hej+31YfxpwWTcnFj7txigKST8ocF+Crz7MKBJM0ENtym7raWTMaybwMk5jcH+k
 iNiLv6GmbN9Rd32ZlRhVn12yd5Lyv84z/wHRY4qkWOqhikHClvqJ6HmTG2V1zqdv6G7nHPoJ8Fm
 SJGjqCCywbtIxQZGwP8+2CAO60DgPsVTUYBVgC5OUuxNzdJBVC/N2Ja7S9t8XZUzgnLNcfUoChZ
 HBuso5iRAYLLvEmSuJLBuldNZ205GpMY2kF7HzfJII1fI+5BlkXIVrUPBJhefy9Cb2PC5KMCXKC
 bcmPmNxkfTDPXhLsliw==
X-Proofpoint-GUID: XJrLt6Ch7VbD-1fd3SJAk2nnlrSvFMwM
X-Authority-Analysis: v=2.4 cv=CLS/zhrD c=1 sm=1 tr=0 ts=6aab65e8 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=BlyEiQbNVX7t3OJdSnkA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 impostorscore=10 spamscore=0 suspectscore=0
 lowpriorityscore=10 clxscore=1015 priorityscore=1501 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

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

