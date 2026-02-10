Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2402EC57C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770733652; cv=none; b=G2ioNE+KYrwvGwhb+3rBGxbN/WyHXyfL8Thh9IG2TgPwqC2yZJw6T8G8msgrnohtilwC/S2ro+DCZXbtkJVkZV9Imc0mk5TWTOSX9kCpd/g8MeQzs8XuokOzWhAXYQgE2UzYzzGOInWfm82Q2ciQuVTYasIVjAuUqKSbNSx4NR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770733652; c=relaxed/simple;
	bh=XfWH/8jjwVFW6WzU0xIkNtCEKO+9B6pGVWM9Of2lJgk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QQXN0vsB46+uiUeZ5Q5sbnTPfAZu2LR0d7QvHJgk+FB3wGAi+McP4RYQ68s55XrjeYtgpubq1J+ZZ4zUNmlR44zfJPEiN0W00ibWW7YqbM6CNHB22497O8dzVOvUhUsqu0DXV/L7R4FziuZIf1+DLUeMikot5UlqvxY7EWU7AY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYrOB7WQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYrOB7WQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B7BC116C6
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770733651;
	bh=XfWH/8jjwVFW6WzU0xIkNtCEKO+9B6pGVWM9Of2lJgk=;
	h=From:To:Subject:Date:From;
	b=nYrOB7WQPn6ojw1G3jRDwr2FIR/Opo5+YXvN0pwD2G/85A7VLGGWRayovdRJTXgst
	 1JrlF6XFrL7Iv+NpBJbtVsurtMropNPnInQizgh7ThSOLcb/IsNm2mUk1JIWqUOlOH
	 IcPPWQNMH+P/UwU0qyMJ3spwQBQQQ1OKpkDVK2FHf+tWX/r24y/3bc38Xi5Q7L8pAh
	 oKKGSz+PJj03OG9CNxUw2SlL0Bqc02n0+oWa0e1MaFBBBlYMXxLn8v2m/A6L2hncEI
	 INKR3QNI5cqud20PAE58cqnkYiCJPIcka8H5C6EtQRM8taKdPREKX+FVyEuUpnca2u
	 /jqymn8Azi//w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove pointless WARN_ON() in cache_save_setup()
Date: Tue, 10 Feb 2026 14:27:27 +0000
Message-ID: <3564f83a19c18e63f7382bf234b7fb610e454cc1.1770733555.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

This WARN_ON(ret) is never executed since the previous if statement makes
us jump into the 'out_put' label when ret is not zero. The existing
transaction abort inside the if statement also gives us a stack trace,
so we don't need to move the WARN_ON(ret) into the if statement either.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 81a3775603a5..7e2ddb625619 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3394,7 +3394,6 @@ static int cache_save_setup(struct btrfs_block_group *block_group,
 		btrfs_abort_transaction(trans, ret);
 		goto out_put;
 	}
-	WARN_ON(ret);
 
 	/* We've already setup this transaction, go ahead and exit */
 	if (block_group->cache_generation == trans->transid &&
-- 
2.47.2

