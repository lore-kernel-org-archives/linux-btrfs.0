Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6EA3B3891
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575939; cv=none; b=lrIx1ganT6IP0+blzxBnpWCmyVmrSbMbqMqVRovKEbg2zeN1pg9VLoUQ2vFsT7oyyTxsTjdxNU6WhrPr7lG3QnjuI/oQu7+/c9A0UHh8KGgSMu5yv0UklGlAKMfJL4UDZJ21C999YGywN+YcdHXPucrApW0Pzp82TA0qeUqdMO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575939; c=relaxed/simple;
	bh=lyt5do45apQHylMzvJeV61RR+VYr0OWzWgKDoNe4wkY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OSAmolFCNCQdYkIS2324g6XAgbhrRcVzG+IbT6sX6/bUz8sBeK73xBosZu9y/5D1qHv+729uRi2Yi4ldOufzxDC6Ov4cdqULMjCG1H6/mv3enFniwuXglo4b7gGRWPO6t94oXCvy71vJOr4+3bfiF+k+dniYIyAF73EEdmME82I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8faVYhE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8faVYhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBDD1F000FF
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789575937;
	bh=tPBfJ/NV0yrxzvvHCyXdhZWAB8gdI0jz3PWhSZ0OlYg=;
	h=From:To:Subject:Date;
	b=e8faVYhELxu6vjw+MDGgzzrVJxE2UETZJtiNuSFpSBU7w0MJ4JI+W79S6fhQV1zQm
	 5PS42m7rA1C/5N/XDf72hpMJEeKFbm/JmVuENWWaJ5VuhotZfTlSx0XYse0v/GzTLx
	 3VKZ0BxJug6I6I15rnQKu11xxMXQklMkwvb8ETKzgIJJfmSQaf3yKL2ZB8EAipUIFX
	 PiI7nvCbM3u0/Ms6JAN8rS851slMqcVBsaaWsWBnnudVgii8m9G4Mrv1Np49LHpOum
	 nkBnrPsDzwzDnYoltO88JMC3hraLw2R5gk3/Ogj9pTfSopqgk+F00gRgodEMEzHuOE
	 vIcLv1VzYk+vw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove reduntant eb generation check in btrfs_buffer_uptodate()
Date: Wed, 16 Sep 2026 17:25:35 +0100
Message-ID: <9d46a922c893b72ffcd82c82ee552b661b163be0.1789575886.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

It's pointless to check if the extent buffer's generation does not match
the value of 'parent_transid' because if it does, then we have already
entered the previous if statement and returned from the function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 21b72c90bd90..fe2209f8abfb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -125,14 +125,6 @@ int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid,
 		return 1;
 	}
 
-	if (btrfs_header_generation(eb) != parent_transid) {
-		btrfs_err_rl(eb->fs_info,
-"parent transid verify failed on logical %llu mirror %u wanted %llu found %llu",
-			eb->start, eb->read_mirror,
-			parent_transid, btrfs_header_generation(eb));
-		clear_extent_buffer_uptodate(eb);
-		return 0;
-	}
 	return 1;
 }
 
-- 
2.47.2

