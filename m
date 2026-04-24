Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC0A23ABA7
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777043863; cv=none; b=sIA9fNB4wLgBNWHnwGEeweaSjtY4WMKLR/sqOXiE8sAG2ea9GGzECTtqLVFBn/pVwFgDP1GzZCtwKg5ic7EjjVgwpOfbILdyPg9yqveJUvFVyXcWrY5LByNDlJCmq8S/mWXDyXh5/PyeMLd9rGKpDQtmy/Iz5A1ib8UsYjU4pGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777043863; c=relaxed/simple;
	bh=GUj9t6LAcwETWdFhcv1CRrY7Smi9OBlR4UwhMF6RpPk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=m++ZxmxptLzLF52SbLrphr7nv/eCSrGeFYu8dtouAupPTct2jh7B/zieIv7xoQiXkTXzHMcT9GHHnVZaHZUr9vdu9cJik9Mz0OFyC1urVnaqBLgmQx94FWcCel9/WOSGWnRaNMRg/4l2dKwDNwlNF5wL/jOoc1T9K/rDw/xz+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVk6lh/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVk6lh/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C560AC2BCB5
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777043863;
	bh=GUj9t6LAcwETWdFhcv1CRrY7Smi9OBlR4UwhMF6RpPk=;
	h=From:To:Subject:Date:From;
	b=fVk6lh/lpoURexEsohEFGJMH2OFSniQKnbP68DD5GdSl6VP3clLOp9z3nK4rwbhXx
	 qfkb3XbK5pD+wLLCvumqbh1WFGS2xrVUy8yBcbL8qfkZGbTKu0glWyxBfaHUQVD9Z8
	 XhU8UQ2Ee+zlkd1LBXDTaZ53Y+3AHA3R02TQfjKOph/6NmVltNIMKkAGkpHiNNHw4Q
	 ak5q8Ypqw6Pb0NEN++/jPDptmwZhfZiegnfaBQss5RULpD+KUJQ7u33pyOnPxPSLw4
	 TapAsDyvQjzBizF+jfURv34zDhBz8bJyPO8Xv/nVNupNbaQffqlw/J3c/V3Sx3Vx60
	 4l0RMSw2WG9kQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: make sure report_eb_range() is not inlined
Date: Fri, 24 Apr 2026 16:17:40 +0100
Message-ID: <5082990dc32613cf128c27ef01086178edcf4e24.1777043747.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If report_rb_range() is inlined into its single caller (check_eb_range()),
we end up with a larger module size, which is undesirable and does not
provide any advantage since this code is for a cold path which we don't
expect to ever hit.

Add the noinline attribute to report_rb_range() and while at it also make
it return void as it always returns true.

Before this change (with gcc 14.2.0-19 from Debian):

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2018267	 176232	  15592	2210091	 21b92b	fs/btrfs/btrfs.ko

After this change:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2017835	 176048	  15592	2209475	 21b6c3	fs/btrfs/btrfs.ko

Also, replacing the noinline with __cold, yields slighty worse results:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2017889	 176048	  15592	2209529	 21b6f9	fs/btrfs/btrfs.ko

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3d20e2d418ac..b6a92c9a17cf 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3976,15 +3976,14 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int mirror_num,
 	return 0;
 }
 
-static bool report_eb_range(const struct extent_buffer *eb, unsigned long start,
-			    unsigned long len)
+/* Never inlined to decrease code size, as this is called in a cold path. */
+static noinline void report_eb_range(const struct extent_buffer *eb,
+				     unsigned long start, unsigned long len)
 {
 	btrfs_warn(eb->fs_info,
 		"access to eb bytenr %llu len %u out of range start %lu len %lu",
 		eb->start, eb->len, start, len);
 	DEBUG_WARN();
-
-	return true;
 }
 
 /*
@@ -4000,8 +3999,10 @@ static inline bool check_eb_range(const struct extent_buffer *eb,
 	unsigned long offset;
 
 	/* start, start + len should not go beyond eb->len nor overflow */
-	if (unlikely(check_add_overflow(start, len, &offset) || offset > eb->len))
-		return report_eb_range(eb, start, len);
+	if (unlikely(check_add_overflow(start, len, &offset) || offset > eb->len)) {
+		report_eb_range(eb, start, len);
+		return true;
+	}
 
 	return false;
 }
-- 
2.47.2

