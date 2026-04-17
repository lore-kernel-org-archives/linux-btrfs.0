Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86AF334C1C
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 06:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776408097; cv=none; b=sZscm9dnIMiYVohSSDXJGpb+d8NiU/N45bZUzS28W4gh9v7SQKdOPSWr2dype/qNAMgt89fwdlC1508KHvvr74cnV0iSe6gKtBatIXIYV0Ck1Ip2985Qlj7fRIhSgU8dyFeqJG9mNZ34Nbw/wYiKGOqzN4aQW3bXUL/7LLk9Vi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776408097; c=relaxed/simple;
	bh=PrHFcodLUW22QqwB/WgnpTAP4dLsvW5hw8xI+PsrNDE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ZmR09KA5zjqglz6noYZ9PLhXG7a+j4D2Suk+Mtfv9abdLdTQmAwd7R6FaDDKfqGG2BZBBQ1xHqM8dObImLhwcZ6gH4L0PoY38BlXwULB+Wwn87Y49f7VXdxUI6iHyQM/v+KuJRiKkh7tpxs2/vciRuvixRMGokj1JzTRoL5Tz7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=XgaKbdkJ; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="XgaKbdkJ"
Received: from 10511-DT-003.. (unknown [10.17.46.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4fxldz1hyFzJ13D3Z;
	Fri, 17 Apr 2026 14:41:27 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776408087; bh=PrHFcodLUW22QqwB/WgnpTAP4dLsvW5hw8xI+PsrNDE=;
	h=From:To:Cc:Subject:Date;
	b=XgaKbdkJxAMLEUt4KH0dlAX0kcPz9Y9y1u6X9NGLiS4dhgqORtCd73eUpGO0K+bM2
	 2YxJh6S9uQwxoO0IOgYHeae49CH3xsLrTGqTScj/8gxMTuNTDjp5YnWN7ef6YZFen7
	 694oXkAvyySB1RB/NiCc5J6eKofo3ZBv8Y2gQ2VU=
From: tchou <tchou@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com
Subject: [PATCH] btrfs: preallocate extent changeset before acquiring extent_io_tree lock
Date: Fri, 17 Apr 2026 14:41:19 +0800
Message-Id: <20260417064119.1316463-1-tchou@synology.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
Content-Type: text/plain

In btrfs_clear_extent_bit_changeset(), the extent changeset ulist may need
to allocate new nodes. Currently, this can happen while holding the
extent_io_tree->lock spinlock. Although ulist_prealloc() uses GFP_NOFS to
avoid deadlock with filesystem reclaim, it's better to preallocate before
acquiring the spinlock to:

1. Avoid potential allocation failures while holding the lock
2. Be consistent with set_extent_bit() which already preallocates both
   extent state and changeset before the spinlock
3. Reduce lock contention by not doing allocations under the lock

Preallocate the changeset ulist node before acquiring the spinlock,
mirroring the pattern used for extent state preallocation.
---
 fs/btrfs/extent-io-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 626702244809..b5ba650cdb55 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -663,6 +663,9 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 		 */
 		prealloc = alloc_extent_state(mask);
 	}
+	/* Preallocate the extent changeset ulist node before acquiring spinlock. */
+	if (changeset)
+		extent_changeset_prealloc(changeset, mask);
 
 	spin_lock(&tree->lock);
 	if (cached_state) {
-- 
2.34.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
