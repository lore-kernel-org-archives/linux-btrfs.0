Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351023;
	b=pOIU/ZrLP8gnuXTPZr4/DlvzLeKZ1IOABWTz9A7RMJcE8ylsHeKaqttYEtNYdXmRYCqZ
	 +I+JNymQbOVqEMTPHbfoshwKK8/Y9uTwsBIWudv+rdaJf5CZiGjV0NHxXBFFgwomolIa4
	 zTsoqtzoyhGDQLNy4Tac/KtLcrmtL7rt2unb7Eme3q7DrZtJaYZRVqV0aNJgcAGrxOGrt
	 4yvGXvltQYRFn9JlOVALAbaogsbYnf9DPN4ypewBDWyDpNf7SVe1oei1H9wbrcgtJiJm2
	 4bWrB6Z3QinSCDJDi2bjLnfgaLtjSg4d0XjP+zWjBqR+4ajK/44NIvNUDxGLsP9MkNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351023;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VgE5LzN9xzJim2uqTnz9Gfdh520StPiU3eUGsd+szKc=;
	b=f2f+tS1qqHwPFXot8BwLtJiz3+VtvF9pTH2699TLYqhyDzESP2UioCOmEWxfyahDXa7S
	 fpllkDUQpnVVIeoSTX21aWLSlQQo1YLDaQOUMDQ84wNAs0kmT5a63Dm5Y2idsptqzqAhv
	 LgDstZG5Jec1ZNPo3Hen+oDGzwJhrhv21QVp/sbd7gliTx9oROC+cbg4HI5bqmaL617CO
	 D5mEPJJZqo/Vfs+kDpXAjcq/l+8grkL9+VpGfXRWnytM8jvDSYNKidxs8wq8qiz4sDfAi
	 jse8VB+FtJaKFuHuMvlmGH81LoaAHa9XpdJnJfA5B14TWHhcdv1kbl1s9ffnDBES31Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Igb8IylO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03380606A33F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Igb8IylO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620D21F00A00
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794351022;
	bh=VgE5LzN9xzJim2uqTnz9Gfdh520StPiU3eUGsd+szKc=;
	h=From:To:Subject:Date;
	b=Igb8IylOm+72PfsHDPt8CgPJLWCDkfjnnvpkzx5ZRqs7wITIsQSms0lZlCCxHRbkd
	 uv944Wy56xKkuUu0E0qBdAUulp4lMRljk6wfdhi6Z9UugL0fcd9bSOK2WqmJ4GZIJy
	 nX+Je1DxWz4gGj8IwDtiNRVe+rsaHOC0loe7gkLBHmDu6Srlc2p+bNdnwI8UjlEU1a
	 +a68EUSdQGV8FmxUe2emD07pQwEq7MlHVAXrHsqMm3UFk4LP3sVP5/QQ6Lj7oUgUJ/
	 Cn61t4K1TCGIL/ju93ih8Grk4ljg7p8ssPV5wV/U2bE7WgjjRmsziQJKmISQtV8lwf
	 ThkRe+Obs9eBA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: zstd: remove unnecessary early return in reclaim function
Date: Tue, 10 Nov 2026 22:50:20 +0000
Message-ID: <13284885928812954a694ac399f3186b76806fbe.1794351010.git.fdmanana@suse.com>
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

There's no point in having an early empty list check to return immediately
since all the code that follows can deal with an empty list and does not
have any overhead. So remove that check.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/zstd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 8756b19f37b6..e4937f6fde29 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -116,11 +116,6 @@ static void zstd_reclaim_timer_fn(struct timer_list *timer)
 
 	spin_lock(&zwsm->lock);
 
-	if (list_empty(&zwsm->lru_list)) {
-		spin_unlock(&zwsm->lock);
-		return;
-	}
-
 	list_for_each_prev_safe(pos, next, &zwsm->lru_list) {
 		struct workspace *victim = container_of(pos, struct workspace,
 							lru_list);
-- 
2.53.0

