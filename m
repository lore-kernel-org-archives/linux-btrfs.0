Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315696;
	b=ZrHhlJS8PqeZSrpfO+jnRfKhlu65HOvj4rAcIJp2EQ6nD6V5/+ceXBt3RroBYgzZd/YK
	 GTIXfUAtFiwPTKrA0EZk2e1vUQFbgDdg2/bC7ifnM29AP6nQ3l4T8L67ht4oSzv6i2Uwk
	 BLov0aZZeXRlc8qAluFiVhRSsIpMfU9m9Xy2mVbnfhbrbX5BD/OHIrsTVnDy4g2PUXw+R
	 pOMYpgN4WL821S/S2SsNy6xC6za91MUPd3Isu9DPhlsCoBzyas1CZz/2m2pI/aB7nlcir
	 SnGdrg2rbfP4PkFLTzipLOujToFC20B2q43HUcv3LDh1ushAvPhMfSU759s+Xt7qJag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315696;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=E9PD9aOANTvQHboEG3uZgcAavMQLIgieVrLH9GH/oL0=;
	b=1g08Eq1QFbHJnvG67KyHySwtrdbwa8+VxrocQgZqlqEUOZ4lbxFo4Uixt0Af+t2WwElH
	 iCFUqpxscrFORjH9VVCGh9PgWjKlntwsqTxQrPLU1Tos363LLzBry0wcRjz0tr+D2dNTi
	 qIKJIz3wSzc6PHCz8H04qxaxyq5FI7vPo9tsSHNw6ejK5p/Wfnch051EXzFBTdTqJfjik
	 mY71yt+8I8SFE4CthcRgvFx7pmXC7u7uJOiSUIKhGDSdfQtH/K2DB5EGWc99lyr/o4K6E
	 l0L/jz9+mAghbFaRLjiUunNVYhYUGJzDTnZSEvJr8oyZ8LLutbdtHjvh/nqPxI4x0hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vh6p6hz+;
	arc=none smtp.remote-ip=95.215.58.218
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C46E60A2624
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 02:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C46E60A2624
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vh6p6hz+
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gqIN7txgscTN3NZxToZ9cIdy5PReEg1UWTFzKR5TdBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315693; v=1; x=1795920493;
 b=vh6p6hz+QC7kt4cKEXLjj/gDKNipkYbr+4+Smh8XNRgxwXfkPvvgmAmYgsYyhz7R3RLxeIlk
 B20/wOUqhg7oiduHUlwUtd4lygNKMBS7yp9kJ1W+dnc3n3HQtO+zLT6doeOM2m411cPwI4y8EYI
 V8IdtCGBZ6JBhugZbTcZLmXg=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 943718c149af7563;
	Sun, 22 Nov 2026 02:48:13 +0000
X-Mizu-Trace-ID: 943718c149af7563
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/7] selftests/cgroup: make test_memcg_high_sync check that throttling holds
Date: Sat, 21 Nov 2026 18:47:37 -0800
Message-ID: <20261122024737.2741569-8-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
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

test_memcg_high_sync mlock()s 200M with memory.high=30M and
memory.max=140M, and expects memory.high to throttle the call before it
reaches memory.max. But it checked memory.events right after the first
high event, so it passed as soon as the handler ran once, even if the
rest of the call was not throttled.

That hid a real gap: with THP=always and the default defrag=madvise,
THP charges skipped the synchronous handler, and only a few page table
charges ran it. In a VM, usage reached 85M within 115ms and memory.max
about 2s later.

After the first event, check for 5 seconds that no max event shows up
and the child is still running, then that memory.current went up.
Counting high events isn't enough: one handler call can log many while
it retries reclaim. Also kill and reap the child, which may still be
throttled.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 .../selftests/cgroup/test_memcontrol.c        | 39 +++++++++++++++----
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf0..1af984761a02 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -771,14 +771,16 @@ static int alloc_anon_mlock(const char *cgroup, void *arg)
 
 /*
  * This test checks that memory.high is able to throttle big single shot
- * allocation i.e. large allocation within one kernel entry.
+ * allocation i.e. large allocation within one kernel entry. The name is
+ * from when this was done synchronously in the charge path.
  */
 static int test_memcg_high_sync(const char *root)
 {
-	int ret = KSFT_FAIL, pid, fd = -1;
+	int ret = KSFT_FAIL, pid = -1, fd = -1, i;
 	char *memcg;
 	long pre_high, pre_max;
-	long post_high, post_max;
+	long first_high, first_current;
+	long post_max, post_current;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -811,17 +813,40 @@ static int test_memcg_high_sync(const char *root)
 
 	cg_wait_for(fd);
 
-	post_high = cg_read_key_long(memcg, "memory.events", "high ");
-	post_max = cg_read_key_long(memcg, "memory.events", "max ");
-	if (post_high < 0 || post_max < 0)
+	/*
+	 * The first event only shows that throttling started. For 5 seconds,
+	 * check that the child is still running and doesn't reach memory.max,
+	 * then that memory.current went up, so it is throttled, not stuck.
+	 * High events don't show progress: one handler call can log many.
+	 */
+	first_high = cg_read_key_long(memcg, "memory.events", "high ");
+	first_current = cg_read_long(memcg, "memory.current");
+	if (first_high < 0 || first_high == pre_high || first_current < 0)
 		goto cleanup;
 
-	if (pre_high == post_high || pre_max != post_max)
+	for (i = 0; i < 50; i++) {
+		usleep(100000);
+		post_max = cg_read_key_long(memcg, "memory.events", "max ");
+		if (post_max < 0 || post_max != pre_max)
+			goto cleanup;
+		if (waitpid(pid, NULL, WNOHANG) == pid) {
+			pid = -1;
+			goto cleanup;
+		}
+	}
+
+	post_current = cg_read_long(memcg, "memory.current");
+	if (post_current <= first_current)
 		goto cleanup;
 
 	ret = KSFT_PASS;
 
 cleanup:
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		while (waitpid(pid, NULL, 0) < 0 && errno == EINTR)
+			;
+	}
 	if (fd >= 0)
 		close(fd);
 	cg_destroy(memcg);
-- 
2.53.1-Meta

