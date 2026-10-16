Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D5F360EFA
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168649; cv=none; b=PldZV+UPEoiESexcFdXkKywa0prDfRHNAhOHWcrDpXF8q7CCLEISop6ek/4QaNlj1VxTNkqou9QeG63Ync/dUe5YTGQ0fenErT5HQ3qax6h6koUBMvJWgzZuj7WhPWmOeKzgUh4Q5PWBhcVwjfIP2rQmIUJgr4Xb/nM17DlSWXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168649; c=relaxed/simple;
	bh=Iu6DeOKw1sZa5TPDIXiQRMLq8cn5WcbdN06Lk5WBTvE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jeMWIUb+rPS/Rz33VAqSALAd5gjDDNeqBJwswxzg4r+yL+XOqvsNJn5YsaVMhK2IBzAXKSKsvddKZKO7ZU/LGB9kThARDAKJ5nQN8NAwff9ZqTo2i3QrGZcMDVhpHQEWkYyZBtQSU/+VGRgkhvQ1Eapv8KV5FBQDsd2VNPfWc7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXW2kI4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXW2kI4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AEB1F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792168647;
	bh=W/RlXxqSzcaoN4MvIvnpIMOdoNx86e4Loy6OYu6zxHU=;
	h=From:To:Subject:Date;
	b=GXW2kI4CyWc1szfjlxxz7obcB83bY+6nJP3CS7tcr1p6aTuluHv3nUbXyKWvAgbpO
	 Uaz5O9U1pTXNDDLM38ejhpcAksDCjkucEK/PzMnH5G/53w4/F1urimLyu4H670/amT
	 +JHZw2yiEo1mEiHmkMy8Bw0p/jREZA0oCdhFUL/ZVpIQf4A5R11AgeFXtdjTfTeZW/
	 07l+cZFWq+yL3XgMJT88SLjzAL05TwYVKfeFXcxNvmgnHfkFKppKEZOhXYqAL43H5E
	 VdRZBvPEbV8F1M6+lnNWglKUgugTKs/J1WK/XJ2emjcvTpsWhxQ1pAQWoHS1PwwAE1
	 atT3vgwYrRqJg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: scrub: remove unused first_free member from struct scrub_ctx
Date: Fri, 16 Oct 2026 17:37:24 +0100
Message-ID: <cbc634179ac86780dfe0aff9c5e2cbd3c96f5235.1792168617.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

It's not used since commeit 001e3fc263ce ("btrfs: scrub: remove
scrub_block and scrub_sector structures"), so remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 05768e28fd95..0eb30625439b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -188,7 +188,6 @@ struct scrub_ctx {
 	struct btrfs_fs_info	*fs_info;
 	struct btrfs_path	extent_path;
 	struct btrfs_path	csum_path;
-	int			first_free;
 	int			cur_stripe;
 	atomic_t		cancel_req;
 	int			readonly;
@@ -460,7 +459,6 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
 			goto nomem;
 		sctx->stripes[i].sctx = sctx;
 	}
-	sctx->first_free = 0;
 	atomic_set(&sctx->cancel_req, 0);
 
 	spin_lock_init(&sctx->stat_lock);
-- 
2.53.0

