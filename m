Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0F754B1AD
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 17:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170571; cv=none; b=hO72N08EARYqbgevU/ygBg/p+r4foayWiK2QgryrVoFAQiBUtGQYpXZvFzaWbyR+uF/fcDWcI4UGOx9Kj0pQNB2yEfB1u1hEKA2E0T0SnavbpLUd4PeSwokqkfL9Btx7pggLa5s4RLxvn0zlXL/2MubjSKtJhqTRGOD0xG9LHRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170571; c=relaxed/simple;
	bh=jhwIF/b9ppV2yf+JGlXxNUGi4Cyg90ADEIEByV+83j0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZbamqaH+4RrSgb16Wz4f8TE2SHE9Mlg/oQ2Od7JAMghJn9CMBJ0bLHC2lRsfUPHbsPwBgJF9Jv4xBlBIe3A+Afm38kacXt5fNVSI8UIwL/Fg/kEvj5FzOpB5K+XbMdeuvD4qcy0pIcTSgC6GpdEmxVNAWhIEdC8VHveQdWrE0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEftRmOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEftRmOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC211F000C4
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792170570;
	bh=wSCkOVKWT6WECmGT/m06T+WdWgYaK73P09bUosJtgvw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=hEftRmOYJA4V4Osogqo6grmVqF2vvJuEDkOsCFM15zPkNX3iSUjzOi6NCBmkwhAG6
	 uLoD5qlvEn0yVhInSD8x8y112iDO0QjP+klKjpwjzpA8MUtA1sP7n+HNVo505MJSRD
	 O8oGavwnvaerS4HBbWWupbisv0t7OuYiC7ehVmYWHcmKimnYvJHMdB0d3UoL2jFsU0
	 wwQhKELe4toV/PNVqd/1+rvPX/LL9WijvzzHL1DlfFPPk/vG3e9Tkqo8wVe0jCtwXv
	 RG67eBlrHtgANSs69BaXk+LFFxX32nO95i5e7S+FjbVreJFTURVWcb6x3T05FUl0ZJ
	 eA7BaBDMBV4JQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: scrub: fix race between scrub and scrub progress ioctl
Date: Fri, 16 Oct 2026 18:09:26 +0100
Message-ID: <9e108b4bf1d4ecb1420521ffaa0603c6f9159ab5.1792170434.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1792170434.git.fdmanana@suse.com>
References: <cover.1792170434.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The scrub progress ioctl is copying the scrub progress stats without
acquiring the spinlock that protects it and a concurrent scrub can be
updating the stats at the same time which can lead to load tearing
issues. So take the spinlock when copying the progress stats.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 389ebb5f7d61..e9ef17d4d43b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3296,8 +3296,11 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 	if (dev) {
 		mutex_lock(&fs_info->scrub_lock);
 		sctx = dev->scrub_ctx;
-		if (sctx)
+		if (sctx) {
+			spin_lock(&sctx->stat_lock);
 			memcpy(progress, &sctx->stat, sizeof(*progress));
+			spin_unlock(&sctx->stat_lock);
+		}
 		mutex_unlock(&fs_info->scrub_lock);
 	}
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-- 
2.53.0

