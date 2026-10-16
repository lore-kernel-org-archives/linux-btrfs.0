Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5731A39E6F1
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168547; cv=none; b=I0DmhR/fq4PyoUKJktLf/8pKJlbPgAfPluPWtGba4PdAjw0oV67gNmQfuys2840f08UQqWpnSvQFUKS9YdapPbjOUZ7Ryue1bOeuqgh8IpBh86iYhb49ekYiAoyiYqK1L73WW4K87/ueweakJymGTUz3gcKXOZyhp1ReY1oqhWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168547; c=relaxed/simple;
	bh=eMD2g/vfcZ0ne79qL7b07TP/9rXMdoSQXZg/LVTUCEw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UfR0Uo+Y91s2bD1AiauVOJ4Ed/hSICun9XFiMQrGaF/dzoi1b+6caOrDNINDax9D13oJ+f0gxEPc2X9YSxIyPGbKil3WQpDosJAo6MvceO8NXdQgGsCjTv0nxjRRB+lLKQadwrrdxDVH+psgBt/nYTYHU3rByb7x2V/kT1djPZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=laFbL+XW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="laFbL+XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDD81F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792168546;
	bh=69aSvb/cq8BRM7ZMINYD2kFbL2YeuWbKzD0neRFZkbc=;
	h=From:To:Subject:Date;
	b=laFbL+XW4MsT2A6Y6EfGgY0QyW0eP2Sf+6ducbRhfR3ptaY3J0SgnpbsezpxDilRL
	 cv1Ql8Z2ZWRuDlMJU7MqmPwj1BJfo+MgFBOaVaxuekdlLAQYpRnZQjwQtr9QnN8b9+
	 p5pIPkFKyNl9AQvm/V5Qnu36hM9pFCbar+YfQVZ6KUkmKpTSccwINGw4AZ88cSGadb
	 g0GzJTfNSc1fgWFHIqYuPL7658fhNIGfSY1yJCjZUeW6vlvAjJq8gjUE7uHMpUcXi2
	 dtbC2+58VLC9aUiEzj02ILNiSpHYNDsCTAfAMDl53aBaXjzFXbn8+1GRfIBdaLp6UE
	 xK/RxWLH1gjog==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: scrub: allocate stripe buffer with GFP_KERNEL
Date: Fri, 16 Oct 2026 17:35:41 +0100
Message-ID: <b0a3de02865070789659fb5613150de53cb3b9a2.1792168516.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In init_scrub_stripe() we are allocating a stripe's buffer with GFP_NOFS
but we can use GFP_KERNEL instead since we are not holding a transaction
handle or any locks that could cause a deadlock if GFP_KERNEL triggers a
transaction commit.

So switch to GFP_KERNEL. We are also doing GFP_KERNEL for the allocation
of stripe->csums just a few lines below.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ba2e27cc5351..8c7404bb9636 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -356,7 +356,7 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
 	atomic_set(&stripe->pending_io, 0);
 	spin_lock_init(&stripe->write_error_lock);
 
-	stripe->buffer = kvmalloc(BTRFS_STRIPE_LEN, GFP_NOFS);
+	stripe->buffer = kvmalloc(BTRFS_STRIPE_LEN, GFP_KERNEL);
 	if (!stripe->buffer)
 		goto error;
 
-- 
2.53.0

