Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590668;
	b=efrN2cLVDR4Vduu6GhB8/55hWGQU+tnYwJUEZAPdvqLBxudVwVlu34Lrwxh8sFzH661k
	 Yzdp89Bq1gdYZ1BAMio2ELBh41xxNEeAtF5EME5h/CR+c3oJ2gqfVFOYhCVEbY7XwAMWZ
	 THm5XhQfaq3VJ2cjiY9aNDkNHo630qwKtEjCIeP6PBWu/hQanNzBmDHGM+W2QyiMKWPHM
	 M5rWVhTyMyaQirw5BPPG6bbcLcVLwJUu62U83ZIZzxSKaQwxkRJaBWgkl1g3f7p5GV8JV
	 RukR92Ue+TLvomzPkPeSTs7nB/6HqLpOG0HIcXFKHNbBMH36891Z0NELT+VDLmjQybQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590668;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LLR/EDwXQKEdWtvhyV50Ad6jD3rHAPQ8xHcmctpiR3Q=;
	b=bDNspj4DRr2X9WpYYSgjWHtRmme6J6kkrWKbfGH4Czj6KEh5lj4wFiKWdlUDQPVLVO/G
	 LUcWeaafJcHW2QghZ2rofIh0xCxFEY63N9iTEnGCKwiMflDXWYvlUBbDPlUCt6q4BXimx
	 xfwfp7KTkn+p3aMpmQ3nO40uVu2Bzz22mEi4CbU0LmTTIluku21RrahK4K/gJez6o9qvX
	 X5jIstWqQLCcZTjn38hhYqT1o+CkFVpKONFG050WsSLVXgY1MDkAzI1RyivQgNWN0ei+8
	 5GJV885kvxOlj1QCkxFs0UnFUAPtCEUW6VwrztU96XXjwQ78OjnKxSJoBho4zt8lv/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Wl4/qAyh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2831606B208
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wl4/qAyh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537821F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794590667;
	bh=LLR/EDwXQKEdWtvhyV50Ad6jD3rHAPQ8xHcmctpiR3Q=;
	h=From:To:Subject:Date;
	b=Wl4/qAyhy8U5G+2jjfJqcnwKu0WAkYSnkm2JjaaD2h+rOUuAf/bAxmJHBmdZ/vLru
	 Mmb1LvMCH5Phl04k+u0YZoNhkHBYc/heqQwfsNL7JLLYynnlRrtgZvQ0QPg5msCu7v
	 PgDSmGPvitYlpp/jFrfyHiYNFwyoh8ENbDqtkISF4i30yd7a8jUVf2ytagn847HLPH
	 StnX8/eELQsrdAF2QqY8P2qRRXTkhXSOkIUfkmFdLlTOzq6QbtLVZapEFBbPgLyh3u
	 rLlbdWbSnrncklKJgt7sURMN4V5LuHD48PMDdAnIxGBIVaWBc3MV5yBYixvzC3hwYg
	 4Z6F0Ah9+zg+g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: abort transaction on failure to update inode after hole punching
Date: Fri, 13 Nov 2026 17:24:20 +0000
Message-ID: <76a5dcd7dd6a05e2790ddb9ee021ad890e88b35c.1794590636.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we fail to update the inode we simply release the transaction and don't
abort the transaction. This means the transaction can get committed and we
will not persist important updates to the inode item such as nbytes (which
gets reduced after punching holes) and the timestamps. Fix this by adding
the missing abort.

Link: https://sashiko.dev/#/bug/linux-d8b4cb7a-8dfe-454f-9b19-a67af28b81bd
Fixes: 2aaa66558172 ("Btrfs: add hole punching")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f568ded02300..83804dc454b8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2769,7 +2769,10 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 	if (update_times)
 		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	ret = btrfs_update_inode(trans, BTRFS_I(inode));
-	updated_inode = true;
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
+	else
+		updated_inode = true;
 	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
 out:
@@ -2794,6 +2797,8 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 			int ret2;
 
 			ret = btrfs_update_inode(trans, BTRFS_I(inode));
+			if (ret)
+				btrfs_abort_transaction(trans, ret);
 			ret2 = btrfs_end_transaction(trans);
 			if (!ret)
 				ret = ret2;
-- 
2.53.0

