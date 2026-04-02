Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21C5246782;
	Thu,  2 Apr 2026 01:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775091834; cv=none; b=Mw+zpYvFtyqT4ZCbCSvrO5Z8GKYiiWRT+Kyv75bandb+BuF8Xg5P2YKCdHZEHOSQVfPO5WPbLv+Yw2QklPN8VZ2Zj4nvKddXvhE9OP1WkW+ZPK+L4yEw6f8xVasqHVhZVON+f289zYRpclyeUDt2/b1Xl3V42I+TI8vZkY199E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775091834; c=relaxed/simple;
	bh=rclsxU6clkDHoiMZVx46nR3oO7v9vqI3oxlCqDzoUAM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WoPbjeFO6ebTi9w95240nNB3GymY0Ub1mvetDc3rAHV17V/dSryQTifX/94GddsQmvLRtZkz1BXDYYoDPw39SAYFAUjD0jX8cA6mPgGgUYbi/gQhMT74RLz1C3tGLgvajWrhfBqsR68Qtqpg52lWIdvDlSPFYiFy/9ISnYioehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=nN8Y0VMG; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="nN8Y0VMG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=nN8Y0VMGXZbG4qPIBNAKfjUJz+sklfNog8SCnp8ar9by+bZCwZfulf5xdZBDRWYG/t/a4PFlqHwFa
	 jcldxvu2L2BeKOyR2ONwXWh86OgI+h1QRdsjmSFJ6cN5AqTbMsQk7gjB9Bi8r+C4YhxhvnUx+9019c
	 s61Z6WfO2j7xh0T4=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-05-12083 (RichMail) with SMTP id 2f3369cdc06662b-0265c;
	Thu, 02 Apr 2026 09:03:38 +0800 (CST)
X-RM-TRANSID:2f3369cdc06662b-0265c
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
Subject: [PATCH 6.12.y] btrfs: do not free data reservation in fallback from inline due to -ENOSPC
Date: Thu,  2 Apr 2026 09:03:37 +0800
Message-Id: <20260402010337.340100-1-1468888505@139.com>
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
index 4bff5d5953ed..73b950b58005 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -717,8 +717,12 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode, u64 offse
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


