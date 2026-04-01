Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30282410D32;
	Wed,  1 Apr 2026 13:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048679; cv=none; b=Jy7+P+Tg7v1yBBvvPfCdjMJNT8TzxxlkkfZux7jhcAwobGFNm9PZEvw/4w4SV0FUlz2CAQb3F5M4svh/sxYZMbl7z63UbenF+xl7lQTCw0AhPpVElNGPMqd0/TY37L7zEw5Z0bjOV7ufPd7ct7s/zoXb996FgROL30km0khDj9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048679; c=relaxed/simple;
	bh=5Pw4JTjMHoWtFOnOgkDdj2OLNGdWfnbSS9HL1wXN6fA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=crPON1PXSjskE/zSwmV4c64WsTyKBb/UftM5m/suZ7hiOhlUuAZPtRLT+j2kxj4LZWbizgtw8XAK7CsO7jZjycjkirUyh3eko4g/qa16jA/jzN6dQPo5XrO8miu1NPYnnLYqj3sN5G/C3DzXFdIvYRFAIgrR5mUApv6bpS5JQ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=raVGemIX; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="raVGemIX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=s/JzVv7uX+jn9sxECGXmsOIbTtkpN1VlGTlQ6CcanAw=; b=raVGemIXjkoaXp3kqEXPNh32vv
	bSsRlbb3hj7AhmjgzUefJfd1qkzYqdGBAL+aZT8mPvEfCD5O0ASYKjsHIUAfAixK6KzS+DP9KEKyk
	Ank5qssWSwKp+UdNBRMGWQ6XJS3VlhS7d/IPabgiiiFPGU0f1UlOSg4Ytb3xMG2YjTbjS+D30fsLc
	k71Vu35hGrIPjPVnYqodva2Ze35w0qd8dfENabLZdqVjxFiidC+soNuTvUdAGnSpZaEF6VUU1vfnM
	FLnrp8wmZQfhXVtInLwDz+Ap6atPitzMeVURJ1kSIQSiRQqKZeMdtblk+4ek21FHHaFaGxadg8qab
	t1dRcWfA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7vFN-0030QM-3D;
	Wed, 01 Apr 2026 13:04:36 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 01 Apr 2026 06:03:57 -0700
Subject: [PATCH v3 6/6] docs: workqueue: document WQ_AFFN_CACHE_SHARD
 affinity scope
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-workqueue_sharded-v3-6-ab0b9336bf0b@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2720; i=leitao@debian.org;
 h=from:subject:message-id; bh=5Pw4JTjMHoWtFOnOgkDdj2OLNGdWfnbSS9HL1wXN6fA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpzRfIamkTVw4lb7Hti3QtVvpTg5VUO54ETqF1I
 Z3lWumpoeKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCac0XyAAKCRA1o5Of/Hh3
 bRC7EACVTGz1PZijw5iSKF4Eq+dqiMj8aBZGYF8UsfMj2bjwdXy9j57Ll9umpW8NYRtrSdZefLz
 Cu2fXNAq63vWMacwseuaky7OQTue4Ah7IeJUTN2soyleqHmZrlGJinSTHFgqALzE2uhXikM4IN0
 oBVdEmIQjY7gzMJ7jYC6PtQoFawr7vEX6Xkz+5yNGHAHSSo6wWvShzmuy9bZkFsWqSd/jsSOt/D
 BysiupPARA7eoUetHac3igg+3+M2COSQFhnBHwdILv/dHV4fAJEbKeqhcJJUbDbtuAfebHWwBj1
 EOQUsEsB88x3qa2skYCPsBLqpBMvNIGOUI3Lr+/Na4JV6s9jgTigOIO/UE5A3bjSvGq8E+7tsqk
 W2JF1DTmRWxi1N8g7OJGm2gTn3wJY9ffahc/aGrT0PFf0Y0a0tSAW1nOw8UgraacvwACsh1hmem
 JS46KW5tGylXfCTk5fE0GAqOQu2FcfqgDF4gtXm5rvHSTyXkKG6yR3uJEiZ/Iv9wKTndoi9YgyF
 WW5pxHzUXCe3VccXN6yBWBBaMYn4+AGOBlV1aUiWoQI5+5rcmeg0tyVDEEhukyyY6Svtcq4nyQE
 gIb3C46OldNE/ZxCbxMT5gxFOWZRXxxJD6UdogTEBwbdSY3wfbuRPmcA+RC2fj1oLjpyoMN8j+Z
 /U3YEhahJpWWevA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Update kernel-parameters.txt and workqueue.rst to reflect the new
cache_shard affinity scope and the default change from cache to
cache_shard.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  3 ++-
 Documentation/core-api/workqueue.rst            | 14 ++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 03a550630644..b2558f76b7bd 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8535,7 +8535,8 @@ Kernel parameters
         workqueue.default_affinity_scope=
 			Select the default affinity scope to use for unbound
 			workqueues. Can be one of "cpu", "smt", "cache",
-			"numa" and "system". Default is "cache". For more
+			"cache_shard", "numa" and "system". Default is
+			"cache_shard". For more
 			information, see the Affinity Scopes section in
 			Documentation/core-api/workqueue.rst.
 
diff --git a/Documentation/core-api/workqueue.rst b/Documentation/core-api/workqueue.rst
index 165ca73e8351..411e1b28b8de 100644
--- a/Documentation/core-api/workqueue.rst
+++ b/Documentation/core-api/workqueue.rst
@@ -378,9 +378,9 @@ Affinity Scopes
 
 An unbound workqueue groups CPUs according to its affinity scope to improve
 cache locality. For example, if a workqueue is using the default affinity
-scope of "cache", it will group CPUs according to last level cache
-boundaries. A work item queued on the workqueue will be assigned to a worker
-on one of the CPUs which share the last level cache with the issuing CPU.
+scope of "cache_shard", it will group CPUs into sub-LLC shards. A work item
+queued on the workqueue will be assigned to a worker on one of the CPUs
+within the same shard as the issuing CPU.
 Once started, the worker may or may not be allowed to move outside the scope
 depending on the ``affinity_strict`` setting of the scope.
 
@@ -402,7 +402,13 @@ Workqueue currently supports the following affinity scopes.
 ``cache``
   CPUs are grouped according to cache boundaries. Which specific cache
   boundary is used is determined by the arch code. L3 is used in a lot of
-  cases. This is the default affinity scope.
+  cases.
+
+``cache_shard``
+  CPUs are grouped into sub-LLC shards of at most ``wq_cache_shard_size``
+  cores (default 8, tunable via the ``workqueue.cache_shard_size`` boot
+  parameter). Shards are always split on core (SMT group) boundaries.
+  This is the default affinity scope.
 
 ``numa``
   CPUs are grouped according to NUMA boundaries.

-- 
2.52.0

