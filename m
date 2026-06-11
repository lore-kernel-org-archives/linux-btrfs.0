Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53393BED69
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781187619; cv=none; b=Rp70FGxETTf8ZYZSxKaTzRqTjEjQrQrt/gFJvnIcZzzojGiC2sul4mJWZd2fawSRpyXXuEWcr/oMfBtvXiOep3pE8S9P/SInHBYlT8boN0eFsfvDsacXx4B4KyrO/+Qfv0YVBEka+sK2KWqxEo9bhsi06OUY9hdOsNfMqnZ1Y6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781187619; c=relaxed/simple;
	bh=Y2aDmAJMfT99xqnppm9vIbXG/lcVpqcscaYPCJ4bloY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tWqbjNlkexlG1aA7fEU3BMZgrv6oe5Y4yKP3e/Cgm0+2Qgs/QEuZHZhABhQ2HNe5TRAkc33MuFBOH8HGUKthPzD2nyo7mXzIWceD38ck5Gr4HYqxKxc+HWoYTCjOcN35ZLV0f0YPHzQ6Lf7XbmcI6/VGB/qMBgmt8eaV5V/yuvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VG/b6FIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VG/b6FIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3101F00893
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781187618;
	bh=IqfOpHqh1qXFl9YJ/TBjLfBR1uOAVwxWBXfifAeofa4=;
	h=From:To:Subject:Date;
	b=VG/b6FIwe1rzrDvJ6wzPESi/WsqaWlaOKvL/mO0qglkhAfP2AKkPJb3kwyXjR3P9q
	 Ckmk2gXgc1tkO2qNEmNoX5hV3RhgKlPMkjsex43ttFgwvDzWsltfsYgdm0EHsNlxs+
	 t+P5di/HRFhTcBFIelQa3JY3ipFbM2XB9W208wx58+U9GtdEN/e43sUpwBdXfd+xVG
	 jahIpPUaz30VSLXhUAJhJGaLtH2ZxBEvUV2SPCZbGN3SpAH9sLZgIt54AnXSaUWTk0
	 BYxNxrTAcCOK4T3VLXJ40fGzcYTD0ojNggg5mc2geyXU56vPGhMCDf35YXS0446oW6
	 vxzHL3tD589jQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()
Date: Thu, 11 Jun 2026 15:20:15 +0100
Message-ID: <7508b925a940bed6bd39f6c9eca5e27be7119bf2.1781187556.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we have an unexpected reloc_root for out root, we jump to the out label
but never drop the reference we obtained for root, resulting in a leak.
Add a missing btrfs_put_root() call.

Fixes: 24213fa46c70 ("btrfs: do proper error handling in merge_reloc_roots")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index e962a3ee7a5b..82e64f2763db 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1917,6 +1917,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 				 * corruption, e.g. bad reloc tree key offset.
 				 */
 				ret = -EINVAL;
+				btrfs_put_root(root);
 				goto out;
 			}
 			ret = merge_reloc_root(rc, root);
-- 
2.47.2

