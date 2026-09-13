Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1333A2E39
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334506; cv=none; b=FDSzbya8nqOTc40t2XTyu3nKIGciv9aFLDLMgvZSaoTmYQzGxRT01ZVzelw5u9DDHNUCl403S22iC9k+rO46hO3gi1FghJ8pby5RlUjwilly8Umqvj7Y77zy0rD45NchUD8FN2w2cgSBKvpcI6WGEhaSS6UAx48JgnU/lQf00L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334506; c=relaxed/simple;
	bh=UTR8+ch4ryIY7tRDO5W3HY3l+J2/4/c+7TP/kDYrcqQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sdldi730HnX4JFfAjKYq+VEGi1M5Us9CmOoLnCJ63QqRdgc+ZbKK7VlQ/KNge3lmpzFo8xKj9thsdp1pmK8JiWZqIm/zzr8S1mdBCyGmk0i6128Ac6TP1gWR2O8g5o+u13oV+6FUpSMUT7QsZrgNNcm8BoXjb0pwZcvjC8xKydI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=N6aYCz98; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=zJn3UOdS; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="N6aYCz98";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="zJn3UOdS"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKY2DC648307
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Ubm0
	LbdrqVHYg4PE+94rjzX7D+QKZrMTkJ+a2PDrQYg=; b=N6aYCz98usOklcND6VjW
	izjfgVh3jZycdRHSkWmDskMyG04aU1oO9iMRjo3cHQtH+VL6hlmBO7XRoDT9YsR7
	sGZPA9f19riUOzVan/2P7yWzKgeGXfkbYWk5vJh92ixqHeTzyrVlcDOQ9ytU8+SD
	MtBHlBi+J004crPbM0MJDzqe+SlhOS8EzPYT7Rx48jK5bEXVqVLhyk7laQjV+6qe
	jf54gbKL0s2eKpMhIZQFJHtB9ieqAbZC/NFRjyWsWlHErYnXGUtoz+Ke6rCeyoKQ
	ofCOc7F5x/JywvISJHL+YrOxo0cSrzj46cBW/YmonuukVLFowf4IGnYITR9RR8Ku
	dg==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp0qmgpwt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:42 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91064f6e75bso85242446d6.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334502; x=1789939302; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ubm0LbdrqVHYg4PE+94rjzX7D+QKZrMTkJ+a2PDrQYg=;
        b=zJn3UOdSU9pXwDGwOc82teU5yyewsx1izR0Szbi4P2siljX5PPrEm6SBe39TLITpeh
         F0Jq/K43ud+Rzsf5tb5RHjMsDQVJd0D6TWu1x2+YDwuXotOCd/ZyYaWrgJDzkbPybsXC
         tN5SJQE5ctW6bgtu9g74e3qjavDPDEIySlxAdmXvvDKZ+p/Kw8on/unskueRHVApvVlw
         N3XTPCUAIKVl/DDvg8Ew/yZKgd61Aou18bs5PZ/FpWDTnR7zKQsSl4R26d7LB0fE6OUB
         yo1m2Hk7/3h148EIDXOu23Nws/rQSGDVsypMLnWUtyP/ONRkiJDzIQ1106S0ksUrEA7X
         ThAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334502; x=1789939302;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ubm0LbdrqVHYg4PE+94rjzX7D+QKZrMTkJ+a2PDrQYg=;
        b=kmY0J+CDelAgNWDHuWvVdNnFl+TGyh9QqaEdv/nLvITcmWASYmfKPVnpu40Qd1lxTH
         Ux0NraAU/y0WZch7j/AEH0MWsJ79EomACuJMjsLxjGtIU9ZGnlk/Eo88KkNzNomX/sEc
         mocvXZ2wNLSKnomtH/0da5G08IA96lHSNgT7Nbbo2fna6yrUCP00k1+fffEoJRDOJK3Z
         4DBW9Iv+Z6QT6Y94VRdnp1WXh/3N7NvN1Hc2HsOdiqd3o5rWZOppE1tkUnp3DaDYZt8E
         vmFEME6qzgmEqQ7Z5/us93t+d+9wfrffRACWgYDqcDYGJ023xA2XcN+zHefX4rwrEwlV
         4BZQ==
X-Gm-Message-State: AFuF++n0950v0t/5ZEG1jcglvmPQEQb1qXr1uAbUQfbnb+b5424wptoF
	KQuul/I6On4PQm7ECted53M6r5hM0RQyrlrx2QRxmJnIX1yQw6m8Llb/peCI1nXoz+encXqjunT
	Y6N1tJhMd5YH0GAWTaQJFmhAM2b+XO/ZQLfu+tQBrnS/AMKOPNr7dxdEIV1q4Ui0l6gGSmhg=
X-Gm-Gg: AYBFou2O1QV9X3eDpXyfvnGNc3r5qoY8ISFokaLy/wBc130LByZUB1kVmWpqFY15Cmp
	V7DWTw2o9NGwHKZqZQxFW+33JfQ8kKPC8Uh3ytw81PyDISttdui7TNNBSek8aZvYl9HHSpKAytM
	sHU3kkTRneJVgCY0eLtfXSNisUNzXCoyRHy9c1emBQJdFIhD+7qsAC9EpsOLSihs3IZQbhL4Ej8
	lFxrYd2lX/e/tf8lNgK7xir0QVHOqklK14FeONuYkcYrNaE48sQU+eI9RqFP3+oygNESAuFvwMa
	hz+pJoxI4Yn37WluIXdwleGafEdlObFLMFh+zrpTPM28lwYAQwRuVRiGhSsrZVFE+rJQdUz9DVp
	vLiB+9pjSK4C0ZhRDN6sA0zGzsMr5mz4yufEz4pc0Pj7XC0rv87zv9A==
X-Received: by 2002:ad4:5cc3:0:b0:910:3453:d4a5 with SMTP id 6a1803df08f44-9121daaa77emr124611766d6.31.1789334502017;
        Sun, 13 Sep 2026 14:21:42 -0700 (PDT)
X-Received: by 2002:ad4:5cc3:0:b0:910:3453:d4a5 with SMTP id 6a1803df08f44-9121daaa77emr124611556d6.31.1789334501613;
        Sun, 13 Sep 2026 14:21:41 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:28 -0400
Subject: [PATCH v2 16/16] btrfs: remove TRANS_JOIN_NOLOCK
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-16-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=3141;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=UTR8+ch4ryIY7tRDO5W3HY3l+J2/4/c+7TP/kDYrcqQ=;
 b=YXPUciB67uSyqLI9Un79rZpTow+H/No65LW1qiYVQ7f51090sdxJIx7JufFADXGN8Zf/x7Fk5
 1fXGTeA3qE+AjWlrOoOOQ73h8x7w2TPLdlL62Cmx+JUiiNR4cRhu1Oi
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX4krKoVLKSpGB
 4LK0oaswpfgJscgDyc5sn2A5JvGovz1Cz97I6t0evLEKSVgLk6Zeasxu3Dk6/7jSBt/O+filejx
 +aZxB58l2YbfrVvu7c7MqEOYaoH33jP7dv0JornKu1mRgFrJFND4
X-Proofpoint-ORIG-GUID: GHpUzxNh-EUD17_iXhcIdsCK_yEUpoRh
X-Authority-Analysis: v=2.4 cv=EJ6TQFZC c=1 sm=1 tr=0 ts=6aa713e6 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=bdDZCe7T2lofFMgrKTwA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfXxCkJTeK+EKvM
 VT7ZmOTj8s4KfWAeNnWgpNPA8HvHySegRW/Dk8ArPWbckSh+frdRNPZan0BykztRgWgBGpUDYOL
 SyTqXsSpsl3SYCvEljsmF2d5Cftu69Sg1hkOM4u6FqTeTcKlMkDAlWxUG4f8iUYpKWg9D8tWNOs
 W7qesSUzApI/x4EpKcnF9oXlj/iuQ3NPYHIhULhBxl1eYA4Dsb+cDqFv7mCBBKbCxDE77mEErfK
 0RsOvOMbydSkye0KCkZBUnJo5gGLjXt31O3VnI/IBQiOj56wHaL4YifH3lhQui5+aBgJ4akwnJt
 o0HjJTlnC4k9RzqMOZcPEyeKlXuNVzAODkyqdzErgDJswk9AykhSCae3LwG72puOu8WnWGFMFpm
 bkQOJ/lkNsyl9+mq/kfzPzo1rKVe8x3TLytbdIHmJIjtaVsCDJFyomThwRUT/A7bdw6RfUuGcMz
 G+PDLPH49CI7lDYeItg==
X-Proofpoint-GUID: GHpUzxNh-EUD17_iXhcIdsCK_yEUpoRh
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 malwarescore=0 phishscore=0 clxscore=1015
 impostorscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

btrfs_join_transaction_spacecache() was the only user of
TRANS_JOIN_NOLOCK and is gone, so remove the join type, its entries in
the blocked types table, and the special cases in join_transaction() and
start_transaction().

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/transaction.c | 17 +----------------
 fs/btrfs/transaction.h |  2 --
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ccc8d5840355..01d577cc13bc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -125,17 +125,14 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_UNBLOCKED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 	[TRANS_STATE_SUPER_COMMITTED]	= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 	[TRANS_STATE_COMPLETED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 };
 
@@ -310,12 +307,6 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	if (type == TRANS_ATTACH || type == TRANS_JOIN_NOSTART)
 		return -ENOENT;
 
-	/*
-	 * JOIN_NOLOCK only happens during the transaction commit, so
-	 * it is impossible that ->running_transaction is NULL
-	 */
-	BUG_ON(type == TRANS_JOIN_NOLOCK);
-
 	cur_trans = kmalloc_obj(*cur_trans, GFP_NOFS);
 	if (!cur_trans)
 		return -ENOMEM;
@@ -708,14 +699,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	}
 
 	/*
-	 * If we are JOIN_NOLOCK we're already committing a transaction and
-	 * waiting on this guy, so we don't need to do the sb_start_intwrite
-	 * because we're already holding a ref.  We need this because we could
-	 * have raced in and did an fsync() on a file which can kick a commit
-	 * and then we deadlock with somebody doing a freeze.
-	 *
 	 * If we are ATTACH, it means we just want to catch the current
-	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
+	 * transaction and commit it, so we needn't do sb_start_intwrite().
 	 */
 	if (type & __TRANS_FREEZABLE)
 		sb_start_intwrite(fs_info->sb);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d2e2dd6101bc..813f0a261b21 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -100,7 +100,6 @@ enum {
 	ENUM_BIT(__TRANS_START),
 	ENUM_BIT(__TRANS_ATTACH),
 	ENUM_BIT(__TRANS_JOIN),
-	ENUM_BIT(__TRANS_JOIN_NOLOCK),
 	ENUM_BIT(__TRANS_DUMMY),
 	ENUM_BIT(__TRANS_JOIN_NOSTART),
 };
@@ -108,7 +107,6 @@ enum {
 #define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
 #define TRANS_ATTACH		(__TRANS_ATTACH)
 #define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
-#define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
 #define TRANS_JOIN_NOSTART	(__TRANS_JOIN_NOSTART)
 
 #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)

-- 
2.39.5

