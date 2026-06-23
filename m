Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B573D371D11
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782254217; cv=none; b=S7RFH2WE5wb6p6T209fqiErqIT9JBLbkVFjcMYF67aLRgCradN2hNnICawcVmIzg9aKNS3eBqTM4GPuzETNbICbzgGNvelUzctFQOYHH97PskdHjPISyU9kgM22w85wFjx5xsb7b1HuMcNn2RLPvZY9rNaCHhKQ+6HdqDLC+uaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782254217; c=relaxed/simple;
	bh=x7jCRnN+XPWxJpKnJd2Srd42gmTnPbhqg6N4Jy/kqSM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnRmGypBzXm4QiLlojWyr1toe5W9xDNqEIXhka0oqe6rb5P6hxH9CU74pvHwRsXN348jXj+YKUDuRMKE3Tcu94AzymPRIYjf6ANEeu+vUuZHTS6dBzg5lLeWzp5kI5AnKlEuHIfR9DmfKC1nQTMMptALOlkUMsbsV8T4K91tVvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=lSvGIgc3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bQvngjBp; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="lSvGIgc3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bQvngjBp"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2CF1C140001D;
	Tue, 23 Jun 2026 18:36:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 23 Jun 2026 18:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1782254216; x=
	1782340616; bh=HVtzrckv+RKbyADjK59ExVkEQ3JZTQcy+o9xG7iWMXk=; b=l
	SvGIgc3IAuKnydagNzw/X/x52Xbf10QBb6Ibtq2gLHkfj1Q0gDtCchpWf+xDlV9g
	WvmdUyUGCHzvG00Gg29/7oK0QybcZu9VodwCZiDssnkquZtkIIM2uFb/VoJuBx+L
	N9xFHM7ZqUyfNA/ZLqQW6IwX9g45b8Wm6QJERc/i2lq3DlmgcIm8bYFvwpHtk7I/
	n7+V/YdaWb80In6GnfjsRiOHD3whKDys5kD9sT87deuaJCALUeOk2hliSDnptEKr
	symUz4uPKKF7AC16VLRmTLLsBFvwvBv1eLymhz5sUoN0ebNfLdup5tUIYVYpEXxl
	qJ+GXlzySy3L4aVTqahtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1782254216; x=1782340616; bh=HVtzrckv+RKbyADjK59ExVkEQ3JZ
	TQcy+o9xG7iWMXk=; b=bQvngjBpdH+XUWrFrdrSmMFOgfBC6Xj74Wqp1fDayvDA
	j8rA4/9uO/S5pkf/NrVDqATKLKQse8vcq07HcoffeDQL4DOWQPEseVNvP1yDnF/8
	53NKBAJGKQ6vK8At8gl+rEjiyLZY1yOqM6SYkorSTW5WrZwAix37T7iBhBOKD7vd
	LeTPXJal/WY/9qznDyscoYpTiEwNn/mBvTEEgX8pCLivgcDawQy9CgjBtEezlWyH
	c9owA5DdbXgHKkvRUeE5zL1xFUCGDZJkWsXYvtq5nTykv2gIvuKhj10ngCcwq1ux
	H5n5+8Qdo/kDXDi73bu+gFidQwdvaJGteyEqiiVPgw==
X-ME-Sender: <xms:iAo7an7XwGNgaTB96SaIssoxeiwYPPz2kHzMAwCoIzwtGxk1Sq4t3g>
    <xme:iAo7ai6Ucn9JPSM_y6tBgVBpNwwKANL6DQPORC7SH7aTree8TwvTUaSdKaBqLSxGK
    CvRYp1o3ha28I5jpXONx7AS5tAeoPFDjbFyJu7iQNlB5SMNVjSC3w>
X-ME-Received: <xmr:iAo7asFhm-cXgSHHX1v-gIq_Vo455OQ0Bbn4TC-2igZ_LnCLC912uElgAljDYXw6vzWJLOpjWPFOxNLBTSNfg505p1w>
X-ME-Proxy-Cause: dmFkZTFM0Wp6sPpJEkK9bsyZ6YA6pQQcGXcfVMo4LIrpl/vE+Yh8DM6caFGBxxRGtS3Stn
    xYgxFiBgxns8eaaAUvVS7iRn5Gi5QnRO3iWhoiIDAsm10q//73fvsXO+rADefuA7Gqhbrx
    vjIio6OLwdHUEJoK4JyAA+dS9g6z+j5E9JeVRu9TU8mQN/a0t43WDCDjSzKH8Q8Jd70YQh
    YXFZRiZWtCZe/AgrYmt6Yzf6FJUG2jxv+LnTt1iksDgfXV/HmRrGIBUDUh1kEef3r5X6sR
    8v7CJIUK8W5eOshC6IfmD0GDbKS4pwhq9P5oURR0uZWzafqsY7J41BglfGtsyOYvVn7nGE
    mf3p2kztDTCFcDL2KT3BGc1+SpgWzYc9xXyuoio5qGpsMuRhJdBC1TYihhW1C1kiKmnPGw
    1GMh5X4ipg0rYRgXXB4kSHDeBBeeKZtXh86aljelNoRNpK0eq07Weg0IjbGBCqr3Xtd8oU
    z3YZepQyYjL+xp7wBHNnEoBzKDgSFKR9Tsa+7EVDhs+8Rk2FoCTtDgpIXmlv/zBqcDhqNW
    OAQtQCP0bJxQU/g2yNEBGT/c/OEiK8yyy0DFAztRncBWGLi5CsQL7bqwYPIziNj1E56pfh
    8qhUtLylhIj08cseNz19JkxCMLbbY2XL1jnbK5wGsuMQgUszBFX2hGNqVgew
X-ME-Proxy: <xmx:iAo7ajROwtqzwBfx6XWPC2JPSoz1r_JPQoTbjrg0njUwkwCnGXZTSA>
    <xmx:iAo7atuBtNC3InvUplLwJnZ0ZHB7GB-2NsoWamfOYb0tkl6-jH3_SQ>
    <xmx:iAo7aqz3AUcM9yhImG63UpTi4ul7oonCMX-MTTW3Nqml0S_IEQ8pww>
    <xmx:iAo7av6uf1YegYMssX4K_ueY8ev6gUmFaVJhKcqA2WJD48PRkYGsxA>
    <xmx:iAo7aqfT72tgfrS2Z55BT8xV7uGgu3nxD2a_jXwWMPlIRq14JQUVmUKX>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Jun 2026 18:36:55 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 5/5] btrfs: use GFP_NOWAIT when inhibiting eb writeback
Date: Tue, 23 Jun 2026 15:35:40 -0700
Message-ID: <1f4545756c36e7b3e7aab1f6ace60d72de1ed7cd.1782249000.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782249000.git.boris@bur.io>
References: <cover.1782249000.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Inhibition allocation is already best effort and done while holding
locks so switch it to NOWAIT.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_io.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b40d3c47eb0d..43c361ef61a2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3002,10 +3002,11 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
  * @trans:  transaction handle that will own the inhibitor
  * @eb:      extent buffer to inhibit writeback on
  *
- * Attempt to track this extent buffer in the transaction's inhibited set.  If
- * memory allocation fails, the buffer is simply not tracked. It may be written
- * back and need re-COW, which is the original behavior.  This is acceptable
- * since inhibiting writeback is an optimization.
+ * Attempt to track this extent buffer in the transaction's inhibited set.  We
+ * are called under eb->lock, so try with GFP_NOWAIT rather than entering
+ * reclaim under the lock.  If the allocation fails, the buffer is simply not
+ * tracked. It may be written back and need re-COW, which is the original
+ * behavior. This is acceptable since inhibiting writeback is an optimization.
  */
 void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans, struct extent_buffer *eb)
 {
@@ -3021,7 +3022,7 @@ void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans, struct extent_
 	/* Take reference for the xarray entry. */
 	refcount_inc(&eb->refs);
 
-	old = xa_store(&trans->writeback_inhibited_ebs, index, eb, GFP_NOFS);
+	old = xa_store(&trans->writeback_inhibited_ebs, index, eb, GFP_NOWAIT);
 	if (xa_is_err(old)) {
 		/* Allocation failed, just skip inhibiting this buffer. */
 		free_extent_buffer(eb);
-- 
2.54.0

