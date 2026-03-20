Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3412B3D412B;
	Fri, 20 Mar 2026 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029441; cv=none; b=gEzEqV2PO58JNDSzDfdVRzYE7iOis681CKmVQ//XFvyYiGUGp+KseRoALiKSt4RiOUsnEu61n9x4o0312GeN004ZKXKStqwbPeGCMMAV9ZOwhGne5aKb9talNMXU1xi3XUj/8SOve3CBtLIFZw7Wxj5KUNF6gOi5yNIwVx8PRSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029441; c=relaxed/simple;
	bh=tWaivwO7eYrAhEpG850irKoR/4A9GI66PGQUBK2FMKc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eF6gNRR4AaRAJIxn9N6YSexMBkjBkT0MuE46OaqyBBVaQ+z/WmuFefIArxPSUdgW2NBrKSbAE4FUIkFrX5/43HNBQ1GTfudEmHt/ZqGbT7IMtRupBhYSMhsZ36nH8O+gJOvtmnsMkBRhaTLsIMZr78h1/BjSl+gwxP5vpKEH4Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=tsUKn/wy; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="tsUKn/wy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=6xcF3MQiuG3CLGaEv7iVARfMqvoKDRBWve22AacWJmc=; b=tsUKn/wyH0UGLcorRH+T4PzRMw
	e1M6DBlJ/T7lmyG9h13ym7VkZaafkZ5/aZPSnRwUeM7w95+DBXLk5zBCY16xMwvJM5WmDhtZcgaAC
	XjsP4P/UDiE7W/r8Fjh/NdeDw7u4D+ClZdYmaink+rMJdh+jOEaVoAxTVDDU/yskLeijv7eb9+U1A
	a2jx4R3wg1FeLPWRrqXJJ5Cwm9NwWqLv8dujh3khTOgElkD7c2xDWPO0TN5w47QhtE6lV4Bsp/cSH
	Xvq7oD6loSV5BKXh05d3SKbMjoT5REYZ1jiTmdO720dTJ6K57SEc0Owz1QzSJiX/FeRMw4mjUysSt
	yCU2dUJQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3e62-005NfM-Jn; Fri, 20 Mar 2026 17:57:17 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 20 Mar 2026 10:56:29 -0700
Subject: [PATCH v2 3/5] workqueue: set WQ_AFFN_CACHE_SHARD as the default
 affinity scope
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-workqueue_sharded-v2-3-8372930931af@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1450; i=leitao@debian.org;
 h=from:subject:message-id; bh=tWaivwO7eYrAhEpG850irKoR/4A9GI66PGQUBK2FMKc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpvYpsn1Y3Ww10kwqKV9aI6PgYujQbenq4ZHTlV
 BwBuegQxY2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCab2KbAAKCRA1o5Of/Hh3
 bRRvD/9aW4YO9WVdtr8xDWUMohBa+lxGoJwhiJ4Uyx/YtbrYyUzZeJbJ9nSH7Foy4+ODlYCOM09
 rw2tZRPdL8gqOo6y/WagwF/3djozVdntnEfZhZJhjIWdOGpFQWw5hhNIA+u0ptUhO2IRDP6Txv7
 RXws+sZ03ZVv9pSFvdqWsBnuJCONpsnw71Q8LGaQa6yqd03FdNZwfjyZIPfkHDP31i8b0i8YlTu
 Yk/S3wbjJj3Efy1fQnZhJGJhnHiK/Zt3n4AKlCydV+pSmlCCmZwYT17SWwKF3o9hFj0AhWnZmg9
 ZgQH7M0ZKJyBzG6ZObpc9EasP8BQlS1cgdy6zptBVad2JiSmFBzoS6/kLeIXocePvJqfuXQaOD6
 sWUH9a3QT/fmA3KS/QGL6F8/tLrMUfVeC175Zi8K74hWKx00CUxla2XwRckMhBwKu5rrDwRRKy4
 8LRN7zHCT1Q6XUVboerdx8LrqKIFGd1POQSbCMgWi+L+ZItOzQS05eR2xBAAFsg22zt7RWjtD0w
 y5VNiAeohcB03ehjLVy9ZspA9NvPnkilA+aDT9VTozvkFa7G+dxgWPRamgPL43oYsdly8367p1W
 PCXQpj8b7Abr+6meZIsewsb5v8qSC6AcAZKCrayhbk7LQ7eQmi+1EAXmbh4puwLev5PQfQoHR9k
 IpbY1ZuK4ks6ewQ==
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

On systems with 8 or fewer cores per LLC, CACHE_SHARD produces a single
shard covering the entire LLC, making it functionally identical to the
previous CACHE default. The sharding only activates when an LLC has more
than 8 cores.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ebbc7971b4fa6..6bc2e69dd5cc2 100644
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

