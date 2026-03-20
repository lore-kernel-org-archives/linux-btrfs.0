Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280643D4122;
	Fri, 20 Mar 2026 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029433; cv=none; b=jpXwTxCljIwjc2c+VHZ1wg+POtPoAmyUuBR5GdM+1Trpk4Ik6roaXadK2+HiCSugMJJ2keqBYGxhF1n/DEl9vIPfj3llJVd8EkIdQ1tpE3Fq7++HTz8X8Zntli1TYPi040iPa7/jw2Y5KKSxhwRgX63B1zrkkXzZs1zxE7RjPsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029433; c=relaxed/simple;
	bh=XXjsLSCYrZPoSfx1FEQORAbrzU8ErrlZmhCUMONwZuM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L+M3VHF3Zlpi/whv5DOeK827+h4HSv2MWN4ZdOepKMW6FiYwngQN4TNYwWA9jsejz3G4UUngAajJdm546YINdju86xKLo3qVpvyao6RTb5dia5g8JWvuDh+EQyW7bnctNgw2tIyuSqa1/eP2IjKThpz9pyqohRB0LMyTkB4zm2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=W3M2t/RK; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="W3M2t/RK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Do267e3m31nTWEqviEIHaZrA779qGfFHwdpybFhU3lQ=; b=W3M2t/RKTspkygxR/jUYXC6347
	3H8klbHTJcmSOooRBpb3msP3ug/h9/qNXyJ/+Dd166veelnSZM2MVC+UwUabULNA1h1ubM0XKZ8+j
	t5lxJnmjcMIOeidaxuY0yEZRlrYr2PqTNk4Ct/4IVpjtbu2g63mVPYtJr9uiAdZgqUKJCXj+vSL2i
	fDDUP7+0PbpmWyY7tq6EL0knJCr9gCObi8AEQLK0PccyUA0d4nQkne3Mn8TWGniv1K3yyv45fQfyx
	yjfx8fSPUn9UXfJdv+YjzCXFNOAcuz4OMz5+geyTwynH6UMCjuINaoG/P1YXsSN3HqjGmTvBLS45H
	bSACarhA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3e5u-005Nf3-5c; Fri, 20 Mar 2026 17:57:09 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 20 Mar 2026 10:56:27 -0700
Subject: [PATCH v2 1/5] workqueue: fix typo in WQ_AFFN_SMT comment
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-workqueue_sharded-v2-1-8372930931af@debian.org>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
In-Reply-To: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=761; i=leitao@debian.org;
 h=from:subject:message-id; bh=XXjsLSCYrZPoSfx1FEQORAbrzU8ErrlZmhCUMONwZuM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpvYpr25bOynY+Sr+/qvB3irCHLXQG5E8n1SlHw
 e/7zJZAAmuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCab2KawAKCRA1o5Of/Hh3
 bdmhD/9NNH/ic6E0JuRUopxRmmavQF1wA/Ne5iqTU9PwVx37zFLnkORYeLafo9hTq7Xi12CnZfi
 bMhK0bAETDdd+n4+PqX5/zTru87IWlfilteloyuB8CEtYS/wlyTkem4Qtn33L44gECpH1fVsW+K
 e6lwW+kPu67z0SdKeWWwc6ItXcOsPqfBWP5aaxv3xjIG4IcREsS+5dcyhlC7FWIu4lqCBqhEO4o
 r6s5i4cEDd09e/nmNomcuvs0Lukkzi68B2bXDlT6mwlDFGzUV0KuZHY4Lwi4UGc+5X/2qqUQyzz
 oaWB5qPuwMXvWtVUrTv6B5/IhXu4gLVXu8X2FWHIvVAVsq7yv3hMJF+HB2+l+uRa0wGsiml9Zfx
 QiD4ZZdj4JZQqWaPdCa6kETJuxNw1fib4/VYPvSzXFfBhthhNM5TjBCCtiJuxK0bL1FMpB8TU6m
 OiFDqUtAyvbxW1WhWO4nsS8DwbigR+QT4edZI2dUCbTn6a/JRwMepqfSDxb/BgVOgF+FJa/10hy
 a0A90tk05WPnNcIdc4JC1mNRDW+f0GyAn4F2m3P0Pe/gL9pR4hzDGjpQQD2tf7LGN9LKsRlE9tp
 Za9hXRKgJjC/GRk31vn8uCfkmIL+TQHJjKyt9zD5+0UKpvkmzkQ00jh+aG7PuULWBo0o221+4xU
 w5H5loLnCYUeO+A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Fix "poer" -> "per" in the WQ_AFFN_SMT enum comment.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a4749f56398fd..17543aec2a6e1 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -131,7 +131,7 @@ struct rcu_work {
 enum wq_affn_scope {
 	WQ_AFFN_DFL,			/* use system default */
 	WQ_AFFN_CPU,			/* one pod per CPU */
-	WQ_AFFN_SMT,			/* one pod poer SMT */
+	WQ_AFFN_SMT,			/* one pod per SMT */
 	WQ_AFFN_CACHE,			/* one pod per LLC */
 	WQ_AFFN_NUMA,			/* one pod per NUMA node */
 	WQ_AFFN_SYSTEM,			/* one pod across the whole system */

-- 
2.52.0

