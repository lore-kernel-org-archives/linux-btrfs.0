Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8169D4C33C4
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778357; cv=none; b=VA61QCiEU4CYaNPCESuc4BfunqmlxfCrlwR/KFl+8/EJnvY7xFo+Pe2czbiLemLHXh8SDEdk/R+ixLnsCGwHR7D3dj8ucKv/peL3R5kVqUUKrK24MRytfKDhK6H2pG9prucef8Qr0OzgO8mtWDP0sgBUfIY92ApllnuSZSR07rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778357; c=relaxed/simple;
	bh=ioYty78J29GwzdWTRh/EZSsZUJ4VVqRyXW/I6C7nb9U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQEacvwArWNDm0ZnXGQhcMibj6Fg9a+XRa3irA+EtILacM3hbqbKlpc0iieisKTQip1R0/CPU95lYDDjHcXEqwBWC2rl8csNVc+Qax4RatCkQ3s1jf1spqlX99Wr1t+x5wtGYD16gL5MjWGefKZlUuuddIYN41sqDrcWp8cdMXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtOI8qZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtOI8qZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A088A1F00898
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790778345;
	bh=GdSYaV2Bcq/zaDo7iT6Uyzk3l8o3HCnqf4nDaUwq5ms=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=UtOI8qZw2kgw5IBw0aF48VHNlHqsYxlyYM1oM6sLfrFxnXv4EooOaLTSsJ3JN0vwt
	 Kg+mZG6jfcL2GUZiL0BVvCEFw5/2SpRFeNPyTwHS2nGT8BUEGPBsqtO75mh6R0KtqM
	 N0yJRwm0/9EsvSRugw+wCZXC1yFaiXIzTC2SBeZk4aPEDhnJgiVo1Q34Egj+iyxkQJ
	 in/e76/sJ+vAI8GaqyjNwuQVvfSdrq9OFCvN3Qt6qTuHybX5rGdkoaMcCGg98l7mlD
	 LhiTEN/qh8EJvCTTWPrCJ/amUDoqyILZb0QLEiuiPyaDgMGBaum7UWLlo5i6KXd9If
	 2LCDPDrlpa6pQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] btrfs: fix duplicated code in fs state string in logged messages
Date: Wed, 30 Sep 2026 15:25:35 +0100
Message-ID: <0d0ce12914e11b0138e81a95b0f56415159cef16.1790772326.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790772326.git.fdmanana@suse.com>
References: <cover.1790772326.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are using the code 'E' when the fs is in an error state (transaction
aborted) and when it's in the emergency shutdown state, which is confusing
and not intentional. Fix this by using an unused code such as 'H' for the
emergency shutdown state and add a comment over the fs_state_chars array
to warn to not use 'E' as its use is not defined in the array but instead
in the function btrfs_state_to_string(), since the fs state error is not
defined as a bit but as an error code in fs_info->fs_error.

Fixes: 9b2839451dfc ("btrfs: introduce a new shutdown state")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/messages.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 6debf0d4acad..5fe5d34ab629 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -13,6 +13,8 @@
 /*
  * Characters to print to indicate error conditions or uncommon filesystem state.
  * RO is not an error.
+ * Don't use 'E' because that's used to signal that there's an error stored in
+ * fs_info->fs_error (see btrfs_state_to_string() below).
  */
 static const char fs_state_chars[] = {
 	[BTRFS_FS_STATE_REMOUNTING]		= 'M',
@@ -24,7 +26,7 @@ static const char fs_state_chars[] = {
 	[BTRFS_FS_STATE_NO_DATA_CSUMS]		= 'C',
 	[BTRFS_FS_STATE_SKIP_META_CSUMS]	= 'S',
 	[BTRFS_FS_STATE_LOG_CLEANUP_ERROR]	= 'L',
-	[BTRFS_FS_STATE_EMERGENCY_SHUTDOWN]	= 'E',
+	[BTRFS_FS_STATE_EMERGENCY_SHUTDOWN]	= 'H',
 };
 
 static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
-- 
2.47.2

