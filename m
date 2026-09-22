Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B7A576EC0
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096141; cv=none; b=ao+zHmJCJeDWhMlCWO8vUR29+6cHwEzF0U/IWyW0f0nrfYWu/8yMit07s3sTYIdZt8IAA6tjYc9l/cbKL6n4wJlTU7IUy2fplQ8RSHq8by4Uy8VVo922Nq7JFxUuWYnR2yxg2KRCCeVMLUObTQ24mA4cWFiiD/xCOHazhHRe0Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096141; c=relaxed/simple;
	bh=qaHOIkorErUPQXEhyjc3AIIkjx2P6lh/3RhoynUQpQs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUl1IxxVeXOsREWRzOp8TeYY9InBm1/ToqJ1C5crHCVg6MXRFVaK+qQLoOChVnGqt4E1eLTSfPvZ/J1D0ySvtiD8+Fgiu6EoNLLARvH1TgPjpplWOdtS/Sdp3w7+Yq3rDoz21aJtuqG+eQjuLSjwjSnMNq0fv2fICYq8gngAsjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=H+uhAum1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Fbo+M8/1; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="H+uhAum1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Fbo+M8/1"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 9AD641D000E8;
	Tue, 22 Sep 2026 12:55:38 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 22 Sep 2026 12:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790096138; x=
	1790182538; bh=8ahbToRs7AocqmsEKXoBfpkq3TinZUsLod92fbA0Ku8=; b=H
	+uhAum1LvsDbf/ud1Lup3fGGlNQ8BZbHPEn5N0CtLszAyILLEuWqWZ78lNweDNUO
	fJZcw6A2/6Sac2QCPB0bVLSYCXwyoAjobZJXnA0sVmapc8iWSjyHiIoNt1B+N8SX
	uGNhv35MuYSTjHmC5r0MHi73efQ9qPmJkZ2PSyl10btUbohY5tUKwgH6zGIbUVbS
	p4V9iKneu68GiYw0Bw0VzLb8Vu5xCM2QsDFrL03jYUUacCj2xCDWO3M/eOJ7332C
	0npY2OL/7/rEB52szU1H4YAAKX3+AuPfY0ag5nDOOJmPtYuo/+CawnR33+eB6ZFL
	2KyFmx9omgWN+78Fe+MHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790096138; x=1790182538; bh=8ahbToRs7AocqmsEKXoBfpkq3Tin
	ZUsLod92fbA0Ku8=; b=Fbo+M8/1jqZZjgtvidhraYnMBpAmPY5rmdyYFP71TRKn
	SEJ5vQQMi/roiiFsTrQyKwAmEoNCDUc419sKtj1hjzimb4TnkNzs1mJjKaEoPcNU
	616VO+gKkpCt0yJdBDfHfBt9OYUZwW/+zjWzx+aE76DGk5rePQjWuSnGT1iI6pUs
	Ndk8pXlPjaX+JhbG+e8cIWY+NTn6hI38ZdYuSURbsUzDbN8UoPulp7QJT8Z0r0ip
	SRNc99qiF7yu5QKfRlgCZGzK9KYkvtuFAaxpvuqY6ZGf6M7U7gRK4MBMJ1aK5+QM
	QVb0Rbjx/1SUidwuUzDpHKetRnQ8EZ6fMUlFqlgv9g==
X-ME-Sender: <xms:CrOyakCl1C62W9283E1iHz3ngeMpGmW6YHajbQPjYf5qwiynzIRkbg>
    <xme:CrOyash7lazLkCip9IM32OHo84gBZmicXYBCl1-c5fUZpCvezZcj89C2FfxFp3Cwe
    PLojyeUI9ma0an0MYyA8pKL9KKttjjtVvXiKdxtZ8LyJKiMs8bngSTr>
X-ME-Received: <xmr:CrOyalNahIluo4XvIuCJyrlYHRx_U0uNtrGg-RE9jJToQlgNvTKGvpc>
X-ME-Proxy-Cause: dmFkZTFzVj0YWmnvojXoK2+EpfJGJ4LTWfQZsTwohPIv7eWyRhfgORymsHnHB9dDZWX2IQ
    /sIfcno29CCLth9xSzFS73wZjFmXhOntAZsLL3/2WHdinDBLPcnlj2rLCs9dU8NlEM5b8q
    8VO8TT8MmrZneCwQJPfBz88qe9wqcExmmXJzCZYrjp8vcaXdWlDJp7QYZ1HbpT0EiRs2Lo
    b85Rg6d/aq66O8Ofe2SRMvVSBWNwqtUz8T5rm2xURre+wTjAlS2g8bqIk7VAfOZKV48Rpv
    Nv38umI2nWP/0QIZAmZBUzOUz45gA8mfTJimGkqH4XxX8bsKtJb5SBSkuUxHw8AA1+HGTk
    8C+uU65GnRbyXQs4377e+1Mi6l4ho1IFCR65qxtEChCS5tV5GdArkmgwRnAuUvLdc+cfId
    qHKd4b++ynduiMjcDTLCdQ8+PmQl1CAwXl13Xo8wockgvkMOZAVJZPlX9y3uiCt2QCxx8l
    6q8BTYW5SL5KW6Hdr0H3E3cP2ZRO8z1AhwD/n4sVEtieDUKH+vdI4nGJMPyxhKp0Cvd//Q
    3+qsaEuomnoiInl3PSyYHR2dlYB3Trv/ofSujqW1535mHb43ExjnMbo4SoMfRzxUHQoZS2
    yzkDEPIECIWv7dA6JOnoYb/afF//WU5K3yBu4YfANry8WI1DlFVou88Dsbew
X-ME-Proxy: <xmx:CrOyal5Q39zIbvCEJz4Gk2kuO_aZcgwZXBLkpZndYiWIJFcH2Ib82Q>
    <xmx:CrOyar0puDH6O7YR-7h-HAq1NiUJby65CqHQXUUv5lEW8SZvuSixPw>
    <xmx:CrOyauZ-vZ6qsT2hkIvhvWtODcAADpb_pfPmPCZN95ohKKKZW5ZhZA>
    <xmx:CrOyarBeTiJEtyOV7_XMDBl9Q6lXs9fLUW-3-PpwVoIGg0KE06vWag>
    <xmx:CrOyamBaDOZAzclON3_QfePUYFIHCxckOcAnrYwkLPnJKP4Aulvem6NK>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Sep 2026 12:55:38 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 2/2] btrfs: commit after deleting an unused block group if system space is low
Date: Tue, 22 Sep 2026 09:55:38 -0700
Message-ID: <e86535ad0a4c4587f63fd6dff4b04d49161a2275.1790095812.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790095812.git.boris@bur.io>
References: <cover.1790095812.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the device is fully allocated and the system space_info has no room
for a second copy of the chunk tree, deleting many unused block groups
in one transaction aborts it with -ENOSPC in btrfs_remove_chunk(). While
we can get ahead of this problem in practice by allocating the system
space more aggressively, that doesn't help a system that already got
into this state anyway. In particular, this would be a problem on
systems that got into this state on old code from before that
improvement, but it is also a backstop in case we do mess up and still
end up with too little system space.

The way we end up needing a lot of system chunk space in practice is if
we need to delete many bgs at once, resulting in touching many
nodes/leaves in the chunk tree. Therefore, if we detect we are in a
condition where we are low on system space, commit a single transaction
deleting a single bg, which should not need much system chunk space.
After this we have the freed bg and can proceed as usual. Any additional
chunk allocations (for any reason) will also check the system space and
are very likely to allocate more system space, so this should be a
relatively robust mechanism.

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/block-group.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index cf26dbeaabdb..fc95903646b4 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1596,6 +1596,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 	LIST_HEAD(retry_list);
 	struct btrfs_block_group *block_group;
 	struct btrfs_space_info *space_info;
+	struct btrfs_space_info *system_info;
 	struct btrfs_trans_handle *trans;
 	const bool async_trim_enabled = btrfs_test_opt(fs_info, DISCARD_ASYNC);
 	int ret = 0;
@@ -1613,10 +1614,13 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 	if (!mutex_trylock(&fs_info->reclaim_bgs_lock))
 		return;
 
+	system_info = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
+
 	spin_lock(&fs_info->unused_bgs_lock);
 	while (!list_empty(&fs_info->unused_bgs)) {
 		u64 used;
 		int trimming;
+		bool low;
 
 		block_group = list_first_entry(&fs_info->unused_bgs,
 					       struct btrfs_block_group,
@@ -1864,7 +1868,18 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 			btrfs_get_block_group(block_group);
 		}
 end_trans:
-		btrfs_end_transaction(trans);
+		/*
+		 * If we are low on system space, commit immediately to get back
+		 * unallocated space to greatly improve the chances of
+		 * successfully allocating a system chunk.
+		 */
+		spin_lock(&system_info->lock);
+		low = system_info->total_bytes < system_space_needed(system_info);
+		spin_unlock(&system_info->lock);
+		if (unlikely(!ret && low))
+			ret = btrfs_commit_transaction(trans);
+		else
+			btrfs_end_transaction(trans);
 next:
 		btrfs_put_block_group(block_group);
 		spin_lock(&fs_info->unused_bgs_lock);
-- 
2.55.0

