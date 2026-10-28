Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793210152;
	b=meukmYuAU8Zbgb8eKtua5xqZrknagL26mk4G3LDDGUiSupVOW0vTlRqN8nI+2bBqPTzT
	 /KRz8VmVjtk8CBAbU8duRJamsEKY+H1jw0EY+dQToTkGqA1xBAa0Y8xNCwe0s0100aZ9n
	 MD1TK5O1/2xrommuG5IVBffgCdX04gTveMODcdNIvv71W17g8AkpWOTUoVp294ahkLqvz
	 1Q+p5AgUAPRoIOAJKvejOVgdJrEgGLswD8xQAykJ8CpsNHv/H/arWCdas93xa+aHpV2zD
	 8gweUygI9SU/CxGbIGHORuKS9w8HZe7x0sRQC2Sm+WjuDe2zdDm8trBu1W74ZgWGHPg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210152;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jCwdFFAk7cO3b4/5/yWM/E+7msGcjMisvh+RoNy9MPg=;
	b=fs5FaLcwBbpNeFVz0x5Fl7o3/nC5qleQgdTJjeE7ZRyPDOqeT7CexR7Pq06E5WSONwex
	 N3tjmQmSKT7FufAzFZLl/y9eYjHM2UfblnlRL5Iz0Xr18BuZX3RwY5LNI3bszirVjF/4L
	 8Fe5RYPPnZ1N6yBIT/0c5cSFyw0fxL+7Gv9J9HNq5HOm5nR0yX/p9E61qEqQ0zaspHBn5
	 ID4pv4Xd7pSvt9lVvagu3lWAQxXgloMDKKUbQa7hiP8rethrSuSgVr/jSpn66xeI+6fAD
	 1ZubmDEMNVQnvPRmcPh2IxE0uQJtOc+aK15rretghSuxCVelWpmr4V0xf0rvDcFZWIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOvEQre0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D101B606A321;
	Wed, 28 Oct 2026 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lOvEQre0
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793210151;
	b=0YDEQvFj1/rMhxtcPKQdGYC96YlVcq55ty2u4vVXC1AfA2aaH/dMXSYOkAcEy48YEbnZ
	 Kd7REQvaPMeNVrsqPZtxs4Bk3rkyvwhxbUb4Vl43DiCkXhj5pHfTK3IRKP+EqDPKltDL8
	 hfPdt/n+nFvlmRvRdKDlKqKqp4vLKKyuuRUzjhuAUCAPPJydxWJxl3QEHjmT6lVFE5W7Q
	 NPqovO0EQouktBtQJIFhefWX/ZLPIsrzFgQSJYRoCUXi3r49FxM8CltSqTXCh78mDptvB
	 KpMMgb5prglj6axQ1t/xPPbaxde6OoSvex3rYTjQGYI8EivX00SQRhTkvYyUiOsNPVQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793210151;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jCwdFFAk7cO3b4/5/yWM/E+7msGcjMisvh+RoNy9MPg=;
	b=2XeUDd7JVPt/CNmpSRsBUcrOR3WZWmbMlN0ZOSC1jWsYgPOZfCJXLGG1SfEFMQfdkVv/
	 x1nFT+T74hiYEjfu3HE57Lp+FcSFJN3kT9qftJWZG4+T+JyuOb5PJ6IB36fw0w6hK1oTd
	 SNh0bOXXBpSJVoUgcZjl+guOemyVxlm6L96sKYY+JFOxZz8sKwaUBcvurfuMVl2WyHvs1
	 BlAqLwvNCTtLsn3kFD8KVFiQYBkyjtXUWO+8d5lcw3gOAUe3LRZqMU6p41yrLswxKsONz
	 S6KsRJkauNWUs4pB8U6umZeS6qZJPKVCgeUsWo+EtszJMLhkAVSARy/6Ym6FL+K6jyA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E6A5A1F031E0;
	Wed, 28 Oct 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793210151;
	bh=jCwdFFAk7cO3b4/5/yWM/E+7msGcjMisvh+RoNy9MPg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=lOvEQre0ZaumLbA0DXYVH8icCzAA1vfzvCUdAkWrGx2BP+RFd4hvKeWAnTK5yW7gP
	 sbNRoTS1TEx5SAsUVx3rCQJyNZHubfsYxS35ojY4mfkP9J3F9ovJ23+3D0+r+Gxsp9
	 vqIinvFcctlpHNPUCdvcHFteZjkDEbv1RmrPSevDx/av8MZLCQQCGH5sW184QGj6TZ
	 KeWO7i78d+Z7z3wKv/Rw1LGiic2aUvsfcbd6J6vqX5FP0BGK7aFkG+0eg1V+V/jjzS
	 b8uxukstl7gRrB9tBOhuyNWlDmDYBJvxnTjTw71G56Hkxea0pKHzz5aguIs6e9dLPH
	 cLKlDum6UGxrA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7316145528;
	Wed, 28 Oct 2026 17:55:50 +0000 (UTC)
From: Luca Stefani via B4 Relay <devnull+luca.stefani.ge1.gmail.com@kernel.org>
Date: Wed, 28 Oct 2026 18:55:50 +0100
Subject: [PATCH 2/2] btrfs: don't report failure when trim is interrupted
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261028-b4-btrfs-fitrim-interruption-v1-2-bf5c53738b3a@gmail.com>
References: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
In-Reply-To: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Luca Stefani <luca.stefani.ge1@gmail.com>
Cc: Robbie Ko <robbieko@synology.com>, Filipe Manana <fdmanana@suse.com>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhiwei Liang <zhiwei.liang@zliang.me>, Qu Wenruo <wqu@suse.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793210149; l=1270;
 i=luca.stefani.ge1@gmail.com; s=20261028; h=from:subject:message-id;
 bh=SHRYs75MlS7h15FzpDG0vGMIMQ3guuhpE4HMc+f+OLg=;
 b=PqMIpIsvrDz40U2W8kqPvIIUiPvJl384C2hgujzHQfvCa78g9smaGobCvkjcJb5ARaj9kwnD4
 LtACyEsLihdAxU1shFVoLAH5KkOvKavqdgLPOLRFCW7Luu38T+iiiNz
X-Developer-Key: i=luca.stefani.ge1@gmail.com; a=ed25519;
 pk=0OIKU9oiaC0ALN4kqvw7ZbPFXqsBLvWm7MhEDYv3PyI=
X-Endpoint-Received: by B4 Relay for luca.stefani.ge1@gmail.com/20261028
 with auth_id=1347
X-Original-From: Luca Stefani <luca.stefani.ge1@gmail.com>
Reply-To: luca.stefani.ge1@gmail.com
Content-Transfer-Encoding: 7bit

From: Luca Stefani <luca.stefani.ge1@gmail.com>

Treat cancellation as a successful partial trim as ext4 and XFS do.

Reported-by: Zhiwei Liang <zhiwei.liang@zliang.me>
Closes: https://lore.kernel.org/20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me/
Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
---
 fs/btrfs/extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 242db255cf1c..90e581c29609 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6926,7 +6926,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 			bg_failed, ERR_PTR(bg_ret));
 
 	if (ret == -ERESTARTSYS || ret == -EINTR)
-		return ret;
+		goto out;
 
 	ret = btrfs_trim_free_extents(fs_info, &group_trimmed, &dev_failed, &dev_ret);
 	trimmed += group_trimmed;
@@ -6935,9 +6935,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 		btrfs_warn(fs_info,
 			"failed to trim %llu device(s), first error %pe",
 			dev_failed, ERR_PTR(dev_ret));
+out:
 	range->len = trimmed;
-	if (ret == -ERESTARTSYS || ret == -EINTR)
-		return ret;
 	if (bg_ret)
 		return bg_ret;
 	return dev_ret;

-- 
2.56.0


