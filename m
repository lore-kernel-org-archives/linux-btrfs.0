Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBCD1A840A;
	Thu, 12 Mar 2026 16:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773332312; cv=none; b=BiKiUIO+WSHIw/SXXVhje/BiaZrBNNPYHYj5O7bJzv3BGPBKWJXgbv8T6JOf0/seWOYZZ2Fp0gJQKfstOZIaYWiaDZ2vTYO851u/iEAAL6EImO4678D12SvnO9vJhVENoVXHtMBTIg2EX2CPiHlEePEpptznKgSUwmS/HJF3wAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773332312; c=relaxed/simple;
	bh=V3jtJrPXZl14ViLFqwIBk+7KYJV4qJ1TdSb5KiASj14=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JPY7ioV5VBbsAqjdanJZJ4upojA1AuuIshU3YwQctB7UzkTlvu1rYPD+sQg3rkoxwZXnhekHgDAuvK28Uy2pOM6+AUx2CMKfN/upU8CPvv/K6l62lLHHCCfmjz+dvVw2YNknxxYy/vSfWCZInUwTTodGMUmTVmPk2Nj3Swp0FYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=kuogqekX; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="kuogqekX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=+zvab4KFQlKv1qZs2xhxlP0HAajHsKybqOSHyuJZ5VU=; b=kuogqekXPh4sawAZLMoF3tpuOr
	orBMpfsDjko7kLjFsIhaXBVXy3OpU0j4QPEM6CGdZ1EIz0jiHysdr0lCDJb4hk9cZin7866h6Lkhq
	oWAC5quEs6i0+9LvjKxs9CxztTVlIcCMiTlwWkgaiXjUSCtlZuedpTbB6aQPTB4p4cv+j4XLyOsFg
	jkoIdobmysPHzGnBrzCkUWqQdHyO4YM0CCox4eP77tmR7TvpdwpFvqr1M5uPKRK6D/LpnDcxPLs4E
	Owu9+Y/B1IguLSYBcY92qmYeO6iRKEbbgsANdnVzq5Lc4EqdJMEXODXR+YCAHA/yjj0XQjZh8pI4K
	fD+4t83g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0ik0-004fNo-V3; Thu, 12 Mar 2026 16:18:29 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 12 Mar 2026 09:12:02 -0700
Subject: [PATCH RFC 1/5] workqueue: fix parse_affn_scope() prefix matching
 bug
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260312-workqueue_sharded-v1-1-2c43a7b861d0@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1927; i=leitao@debian.org;
 h=from:subject:message-id; bh=V3jtJrPXZl14ViLFqwIBk+7KYJV4qJ1TdSb5KiASj14=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsudLxsyud32dXZ5G3MiHEhCZKnipiEracsPWJ
 fvgnjaKRaCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabLnSwAKCRA1o5Of/Hh3
 bXWOEACTU3VY+YMm03hIJ4LY0+9A+Jd6aYWkEc1EXPuwmYUW/V8hts/ypRFfVzm99iydnETghJZ
 ceaShHA92e4JmO+JUbNmhma261zvl1nFiJLw/3+pvEUzGJNwntWhnuzY/xzv8SN6QvmA4CMeWJc
 Hhm6eINC+adFiYY3AMKKUinCQNQlAlh1ZNe6bLAAdfJPLAQYiKuqt6nBHASsD76/TPynCnT4JfJ
 IT29cisfIOsnUYRY9dzbJrOaVFv7maZF1lK6EXStNgq8imuQ8BozEU3+zpkKaqHjVhUOlOAaz2E
 tr0oTPhodo4w9kXQ1RO3IeG4ODr6Fcw+0M1XBNLprwCHpzmz7Ohk/wBErOea1DvUhUaVYczWA7Z
 u6Rb+0EobJ935+5V2xoLWiALTv4lUyZfIQxYRPsIZQF129HiR6DJT7+gTWobAqqSygPl3aTAhkp
 5a19aTVtFKnAIiI5zPHgpP9mLuVQn8ifcW5YvlELSiafi7nKcyo+qTLp8WapucuhgFcZ1dS2mGC
 qDEgu5393LOufMploSnTrz4ZHIO722l3m131XUDUMXUrJ5PDQp3h5rpPq/ka5K8kAvQh+sn/jPv
 Gq+9S3WAoT5RroxlJg1DcOCQfCbpFkqbp7co++7LbK4OEy2uiC184m7Q4Lzpe88XfuoZmzx7G/p
 K6bBV/yvoorFXnQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

parse_affn_scope() uses strncasecmp() with the length of the candidate
name, which means it only checks if the input *starts with* a known
scope name.

Given that the upcoming diff will create "cache_shard" affinity scope,
writing "cache_shard" to a workqueue's affinity_scope sysfs attribute
always matches "cache" first, making it impossible to select
"cache_shard" via sysfs, so, this fix enable it to distinguish "cache"
and "cache_shard"

Fix by replacing the hand-rolled prefix matching loop with
sysfs_match_string(), which uses sysfs_streq() for exact matching
(modulo trailing newlines). Also add the missing const qualifier to
the wq_affn_names[] array declaration.

Note that sysfs_streq() is case-sensitive, unlike the previous
strncasecmp() approach. This is intentional and consistent with
how other sysfs attributes handle string matching in the kernel.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/workqueue.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index aeaec79bc09c4..028afc3d14e59 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -404,7 +404,7 @@ struct work_offq_data {
 	u32			flags;
 };
 
-static const char *wq_affn_names[WQ_AFFN_NR_TYPES] = {
+static const char * const wq_affn_names[WQ_AFFN_NR_TYPES] = {
 	[WQ_AFFN_DFL]		= "default",
 	[WQ_AFFN_CPU]		= "cpu",
 	[WQ_AFFN_SMT]		= "smt",
@@ -7063,13 +7063,7 @@ int workqueue_unbound_housekeeping_update(const struct cpumask *hk)
 
 static int parse_affn_scope(const char *val)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(wq_affn_names); i++) {
-		if (!strncasecmp(val, wq_affn_names[i], strlen(wq_affn_names[i])))
-			return i;
-	}
-	return -EINVAL;
+	return sysfs_match_string(wq_affn_names, val);
 }
 
 static int wq_affn_dfl_set(const char *val, const struct kernel_param *kp)

-- 
2.52.0

