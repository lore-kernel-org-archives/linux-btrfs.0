Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E17240F8CE;
	Wed,  1 Apr 2026 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048667; cv=none; b=Hk+hDwKknQBqjd373JvcMv3wIfYtprQpLhzD03RIEgOxm3emAPL6ToeMnmriCI0J6THXr/QkeyO1O/RlGJGgCV9JSQ36wyrXFxYIFkJKcBueTfviQF6CMTw//1qQWa/vehgJk6hq1rp79Sl0Tyhf+iY3/8drYl6Fffs9MIDPeag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048667; c=relaxed/simple;
	bh=DxEMq1saeg34BF3Yzy95iKoy3ZKirsE09XMJF+o4lRM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=frzxugTQ0vWnJuGwzhJmAPByX6x56Ivg5/6SXU+rG/IYN3SBrQCuwDFfKDkuNCe6ikR1slRe+P1W3d5pZVRV5VOXcOwRUWs8hIvlAJ+ofN1l3zGLbpP+rwAYbKX/0GUVFOK8GquuJRWCKb5aBHgB/dhzcoJoDECLMjK6JUk5sjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=bBDdmxnz; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="bBDdmxnz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=eHESwEHIq+qhqnmRErI38j145fir3UHyhCm3AZu26Jk=; b=bBDdmxnzHSnNVcUYWLaioq1bY6
	vF3q5xvcsOqs3uTDMawJHICgbcltevWEUOWIDWeyCtNU4l8aF6HQ/v+6shgrXTW8/4qtmikXbJEOi
	vZFVdjGePfi8/mHa2xZx+5skkgD/Kr7Ig7V4EVEZ7SgMxsHl3/CwRkXnRT/JlQHQZr6gCLNzE2U9+
	zy45xGIjHr/uaE9AfK9bJyvySOhGNfN4JaZjL0Gb7ILZHWCvcXRGm8Vxq9m3wTbenFFrScS1q5rxL
	D0gh+6ydqbUnQIqeBnpCdmcnVZf12mdJcCWU25wg+DPOj51duJb9BR/YVJzCKl+zPnzieGWn7Y/fb
	IIXtHBnQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7vFC-0030Pp-0B;
	Wed, 01 Apr 2026 13:04:24 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 06:03:54 -0700
Subject: [PATCH v3 3/6] workqueue: set WQ_AFFN_CACHE_SHARD as the default
 affinity scope
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-workqueue_sharded-v3-3-ab0b9336bf0b@debian.org>
References: <20260401-workqueue_sharded-v3-0-ab0b9336bf0b@debian.org>
In-Reply-To: <20260401-workqueue_sharded-v3-0-ab0b9336bf0b@debian.org>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org, 
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Michael van der Westhuizen <rmikey@meta.com>, 
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=1448; i=leitao@debian.org;
 h=from:subject:message-id; bh=DxEMq1saeg34BF3Yzy95iKoy3ZKirsE09XMJF+o4lRM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzRfI1GonAFW4MAKAztm3cYO921irGE2DYuh3x
 ceeVLV42HqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac0XyAAKCRA1o5Of/Hh3
 bXatEACobQ1fDniF0Fy1IiXb+Jku/flGZS3t759U9j47WJKr7CuLkMUBO+RY8EWmdLf+/EeBHnM
 trCPd5KwUMLfq6gp9BL/N1lIai/d49Im/oAFd1hPCy1c3+ewg3CjlKasx7W09uMe5vWVintdbE5
 uqNCvAkfhotuDsiGA5aAb59NdA9V0IoPNe8vKblDm2AmnEGFN+p9+/WqBbVT0ZzQKLQip3mjHj0
 1MSyuU08XHJv/8zECXGVoFBOZVou7pQDX5haNyhMLh2AiODxUGo0NHS9T42/3cJl8cJfFXdgw0j
 WuJkjFZ0WZUyJoQc0dPmSMHcArYDv4Ho83mvRyeyKR3fxqCykXB5bHv4AQLAWK0InyNjYQVOl+1
 jdqNP2m5xB++vE2rlHBRaagQrwMqQlajJZ4XhsaLgyKJ5RmeR1x/LVD+6AnaBooGG4edCMCIjCb
 7dSrCtwbxZRJWOTysp/byjyYT3eXiTe6FAb26GuXv9uL/AcdnIz0UpslROA2yANcfBcJiOfD4E5
 elRz1bDe3yzvy9Ah7dd2iWp+e9kS0++rAGg5UaaHn0erYI7ScjR4tARcB0+sigAb5otLwTaKgTD
 4G2OFG33tQMZSst1elqE3I/fKMc7ghqZTB4jCvJyqR14pczP5Mau8fPS6mk4pv2fMG+i/zwqU6y
 40wuQLCM50CS6dA==
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
index 5b1d42115e20..3b5b21136414 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -449,7 +449,7 @@ static bool wq_topo_initialized __read_mostly = false;
 static struct kmem_cache *pwq_cache;
 
 static struct wq_pod_type wq_pod_types[WQ_AFFN_NR_TYPES];
-static enum wq_affn_scope wq_affn_dfl = WQ_AFFN_CACHE;
+static enum wq_affn_scope wq_affn_dfl = WQ_AFFN_CACHE_SHARD;
 
 /* buf for wq_update_unbound_pod_attrs(), protected by CPU hotplug exclusion */
 static struct workqueue_attrs *unbound_wq_update_pwq_attrs_buf;

-- 
2.52.0

