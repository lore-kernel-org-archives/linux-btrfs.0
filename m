Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8DF377014
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 07:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776411526; cv=none; b=Tux+TxkwmgJ3nTCPF5dc30XNPt3DG7M5xNaZdSQ7LdZ9vq3Y702TmXAT5r8Fn7eXTyUncjnS8DR98X82D7odnibBlGCdvmxd9tmIPX6Ohjj9W4gwF/wcExWQG+KuJLojP896gwvUgqYc5+4kpQG7dK14d5ur2Yti+AiMviwviqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776411526; c=relaxed/simple;
	bh=tMSedbWmgOdh3Y3SG235tt8K+aEEwyI7+70ATb9W2Kk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AmQnp0rH4c4wyoinXz2rC37Eovx24IuxmiF8c8Emu7iU6PBSr8V/bXH5T37vgJegmI89Br35JC7E4/DlsjWDW2EbEZck/liOrP54FCrqkAewDnqm3cxZfdcR6pIsp/IjlubXHl/iRF29v/CHRrHpXNAIzdmNkR3/x1bBqrA9MSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=tjhTFRMC; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="tjhTFRMC"
Received: from 10511-DT-003.. (unknown [10.17.46.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4fxmw32ngJzJ15qnf;
	Fri, 17 Apr 2026 15:38:43 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776411523; bh=tMSedbWmgOdh3Y3SG235tt8K+aEEwyI7+70ATb9W2Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjhTFRMCdJ6Z9XHFuG+6DjGM9ry5qGc20IYaFUc5LecIyeJ8PLJ/nSMe87uzoYam+
	 iNzzSc3ogEoGBzMS+lzceKWdOLz8rMUveMbRw2DBGU2xGBrTUYsUL4Hm2Hq2aKa41n
	 zLrreYPe0QErSzrESBx+oJ61X2t0ZF4nXt1+AShg=
From: tchou <tchou@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	quwenruo.btrfs@gmx.com,
	Ting-Chang Hou <tchou@synology.com>
Subject: [PATCH v2] btrfs: preallocate extent changeset before acquiring extent_io_tree lock
Date: Fri, 17 Apr 2026 15:38:36 +0800
Message-Id: <20260417073836.1320467-1-tchou@synology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260417064011.1316310-1-tchou@synology.com>
References: <20260417064011.1316310-1-tchou@synology.com>
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

Signed-off-by: Ting-Chang Hou <tchou@synology.com>
Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
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
