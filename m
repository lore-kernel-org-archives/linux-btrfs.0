Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365703F7AA3;
	Thu, 12 Mar 2026 16:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773332320; cv=none; b=Ry2N+HWyWlmgu5JQ3FB4dd51xMklHlJIsjGfXrSVQ2D+ieqfzuurGnWS4K2Oa1sLEscX5PmHrOWBNx7iA4kwQSnc5veoJmysCPTsk5H9IyTTW8pvv9Ml49Wmub9CbeeA3PbdGuyQfg9RO+AO+X4PIKD/wZPHMoNPEnP5DGIoUiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773332320; c=relaxed/simple;
	bh=xk51tRMJJDjV8HKN7WBOv83nOoyyjCCpQbhatYusSbw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oIdbgtEPTtfJJAXEZELgzuvGHi8MDgdUznnByWK2b6mOGmVdu6Aw1R+2+JabD+2eO3+axiNy08Dyo7jgR1z5WqPJHPKk7ytpFKMh5TOtY93kC9YhMY8C3iVYOYxyPWdupBelPu2X1PVoSjjxtTusMTtnsi0bNZunX6iS7t4ubqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=aGtbaVfo; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="aGtbaVfo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=0H6/PC9NLycqf/POlIHPnmw1gr1N1T/l6m4kpIw3Isw=; b=aGtbaVfotTNP7znBVkZ7vFHpGm
	aXxvouOdeAs14NEnmHtgtOAVhppgSSSniZPEbrS6CpVbl2bZa3qygduFUBEoSnrFbFV0FpGXZPmOa
	JDC8UNTurH2r2G/w4lv9C5KcuSEWD7Xs/M2ODFuO6UPGbePZxKKakvDOuw1sDsRwFV3OWnK3Mjmew
	Nhl/G/wZ07QpVhxk3vpT2eAr0F0nqeUj4GKlYmx9UIWfaQJt5ECBTfeMxEiFuo6Nh/0XTe1N/JF0F
	oT2aDuHMl8f9M1BKH/KwYqlEXF0Ayy/7fkDD7/Zfuo8VdVnDZwSFW+A2X0Yo5JuyR/kOYbETsMUKc
	+MHFTt+w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0ik9-004fO6-8a; Thu, 12 Mar 2026 16:18:37 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 12 Mar 2026 09:12:04 -0700
Subject: [PATCH RFC 3/5] workqueue: set WQ_AFFN_CACHE_SHARD as the default
 affinity scope
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260312-workqueue_sharded-v1-3-2c43a7b861d0@debian.org>
References: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
In-Reply-To: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1448; i=leitao@debian.org;
 h=from:subject:message-id; bh=xk51tRMJJDjV8HKN7WBOv83nOoyyjCCpQbhatYusSbw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsudL6nyu3vy2n//387TV5//nEC+hUeDjV4qbW
 nJB3GeD0UuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabLnSwAKCRA1o5Of/Hh3
 bSp5D/0fDX/gBCGV32XAVSFEIFj8a8n84+Md+6Dw97G5m97UW9sH/PVSgbl1F4bIonbQtKcGlhH
 Kd5ZBiKcRRFpVAvexFmBmQv8dY1Jp+WtkimsEyrjL73ch7A/XF8lrihNsqbwF/EZPWiS1dlOEE8
 0w97YCaoQRrMYFe367rABdrpav5mmLUflcPmY2HiwzHGXxioWnBjVvK99250/IbXj2U5HYi3bDM
 p8G2DEAtDEaL5uNe9w1Ol0lxRNTVbmgcwI2vCvKw6MNGIMZaGv9yyJSYkwMZyZT3pn7AIHsB4d+
 V0LgVoXoGl3VUyefJOz/pBPRVQF/XwIGv/atuV/lg0PWEokoBvivvDyiaSfmlC79NdmxPECwyVK
 9D7h+lRajpwbevM4tu3cwuQX0CHTzUfktCD3qCplq2OOwcDkDqu05yXbxChjVfp3CCUL2ChlcyM
 0tAJeFPiRGrtCVhtDmVBOoYoo5KATZa7BD59JM1CyXiMIw6ki9xFFYYu8Yn8WnXZ3znoxapTy83
 HeMVhZfzna1aZo7zwtZI9TRpMF/Zm7lEFrSlHsLE0fB1yrsLvRhJe44As2ikgcvxUfGlHV0PgvW
 6LI1f9R82OGXDZj66gQxNx+mYrRYLeGrMfsUbCNbfRCyAdH2ZmgXYitGKwzQv0hpyMFG8bOyWEW
 0+64TdKtDiXaxWQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Set WQ_AFFN_CACHE_SHARD as the default affinity scope for unbound
workqueues. On systems where many CPUs share one LLC, the previous
default (WQ_AFFN_CACHE) collapses all CPUs to a single worker pool,
causing heavy spinlock contention on pool->lock.

WQ_AFFN_CACHE_SHARD subdivides each LLC into smaller groups, providing
a better balance between locality and contention. Users can revert to
the previous behavior with workqueue.default_affinity_scope=cache.

On systems with 8 or fewer CPUs per LLC, CACHE_SHARD produces a single
shard covering the entire LLC, making it functionally identical to the
previous CACHE default. The sharding only activates when an LLC has more
than 8 CPUs.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6be884eb3450d..0d3bad2bfdaae 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -441,7 +441,7 @@ static bool wq_topo_initialized __read_mostly = false;
 static struct kmem_cache *pwq_cache;
 
 static struct wq_pod_type wq_pod_types[WQ_AFFN_NR_TYPES];
-static enum wq_affn_scope wq_affn_dfl = WQ_AFFN_CACHE;
+static enum wq_affn_scope wq_affn_dfl = WQ_AFFN_CACHE_SHARD;
 
 /* buf for wq_update_unbound_pod_attrs(), protected by CPU hotplug exclusion */
 static struct workqueue_attrs *unbound_wq_update_pwq_attrs_buf;

-- 
2.52.0

