Received: from n169-112.mail.139.com (n169-112.mail.139.com [120.232.169.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04DB38229B;
	Tue,  7 Apr 2026 06:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775542875; cv=none; b=AyUJCEq2w1oIZG2zCsv3+6CMsdg1Frhc/8KXzpKFP71/kXdCtB1pDdbeT9WSRICsUmD7Uh12kPs8JBZkTc3YWqgetChJ1KgdyaNFTtOZcHgI0nZEnVZrzE7ITjGGFLMcENkAP0cojcPJRuYbzobXBWOhc1b6P2edcl6nCucX/JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775542875; c=relaxed/simple;
	bh=sB9qVLrq16kFI8urOUKt3d1lbtSt6HnreHDD7GgWgik=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kQrBHl3XFW48ZcAFoTX9XYJ6t85D91VBQ1fesS2Ob5G1wleBFj7iTHEXdhvRi0A8LtrHWf8K4dgR+WKlL63Kufiw0May6kDqftvBUm8HoMbmnyT2bAzOFXyGKj//0CDUIYRXF/2OjJFy9TsJm4J79nWB4qEdA+s3HHkzYVwWFxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=yhApTRRv; arc=none smtp.client-ip=120.232.169.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="yhApTRRv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=yhApTRRvLVMnNe/e66inWF/mV9RguYrg6eolVaLPa5dBYh7GYh+Z45DsQ+51afaX2V4elxTjeAMdf
	 ou+zY6fVaJBVit/7tqrSr5YYfklXSOoF4YXDfTV9YuUcV4FmcWd5AM+acvX6lu3K01GKtKd+mWC6RE
	 d3MzDKnS+sQCaEgY=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-23-12026 (RichMail) with SMTP id 2efa69d4a24b888-018a6;
	Tue, 07 Apr 2026 14:21:00 +0800 (CST)
X-RM-TRANSID:2efa69d4a24b888-018a6
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	fdmanana@suse.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	clm@fb.com,
	josef@toxicpanda.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	wqu@suse.com
Subject: [PATCH 6.6.y] btrfs: do not free data reservation in fallback from inline due to -ENOSPC
Date: Tue,  7 Apr 2026 14:20:59 +0800
Message-Id: <20260407062059.447485-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit f8da41de0bff9eb1d774a7253da0c9f637c4470a ]

If we fail to create an inline extent due to -ENOSPC, we will attempt to
go through the normal COW path, reserve an extent, create an ordered
extent, etc. However we were always freeing the reserved qgroup data,
which is wrong since we will use data. Fix this by freeing the reserved
qgroup data in __cow_file_range_inline() only if we are not doing the
fallback (ret is <= 0).

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/btrfs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cf39f52fc048..3ae77a836588 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -691,8 +691,12 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 	 * it won't count as data extent, free them directly here.
 	 * And at reserve time, it's always aligned to page size, so
 	 * just free one page here.
+	 *
+	 * If we fallback to non-inline (ret == 1) due to -ENOSPC, then we need
+	 * to keep the data reservation.
 	 */
-	btrfs_qgroup_free_data(inode, NULL, 0, PAGE_SIZE, NULL);
+	if (ret <= 0)
+		btrfs_qgroup_free_data(inode, NULL, 0, PAGE_SIZE, NULL);
 	btrfs_free_path(path);
 	if (trans)
 		btrfs_end_transaction(trans);
-- 
2.34.1


