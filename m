Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8D03A6B99
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 22:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782254216; cv=none; b=Mc6Rnf3jze6babxUntfubdJjcg04UvAJeagj253DHc9n4RujcISIYC1eC7GR0xjvw5rZ611kqLTUx8WQVv+CpTxte0gGxEJXAzfT3P7UTGoh1+BHC9CcnqHJPM9Lk9IiwE9b8ZZdUnKIOCwIy9L/1k7sfRrmktxoD0DBGzhHVJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782254216; c=relaxed/simple;
	bh=NoRagoYk8ZYycM9K8qgrY7GO8X4fSsZFwkkLGeQyaGE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTimtyOLI2ZBuIlEv4D9aV/HhSwWCEneY7UO4Wkbzm7WdhTeWPJBQZNL8dq758KwsY4tDYp+UdSp347r6hMjwqEjR3RREbFECGgslmbhxA9Z/ZQYshMLRNMfqruPOwSVKiVwfd87HInit3Ud19cPJdFn4EoOBfxxfxHhF7f1s8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=AlPL9VM/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LDeEKVAY; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="AlPL9VM/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LDeEKVAY"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6CCBB14000BD;
	Tue, 23 Jun 2026 18:36:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 23 Jun 2026 18:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1782254214; x=
	1782340614; bh=znwvP5DFZ+iFLNau69oi5qGMOj5Rl7AUikbR5GzxPPI=; b=A
	lPL9VM/LAtCGsjs03XplqCLsfuQTAJamzB6WOLM9fKkSubNYR3ewgnQTDSNRgOLh
	KK8/k9BsdNNaPA9yN59LHgsebbtqA4Ii1OKO7xcHaARuijsaXNwk9XqT3JRkqiB6
	dYEMbwV1jAh0t/7N2kJ8jLWCuar4bh/47H/FLdtz1XGVYIyNfbrN7GiNIY387BVA
	5lgt7Z1ba+LxuZCOTMOnE7H3iFcjAIA+OKxIDWWzRsCRb4hxHxXER8PGOYqf7tQX
	aYbT9MBln8FshiQR0H8UAwVkd1Nb8kQk42fzEKEdJ3psF860rPwfq2xVYsQ2Va81
	0ZjXwv2Hcq2GdtGo8Xhlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1782254214; x=1782340614; bh=znwvP5DFZ+iFLNau69oi5qGMOj5R
	l7AUikbR5GzxPPI=; b=LDeEKVAYS7odxlJ2JmJ+84q0olq5/bawp3cvcdS9cPDa
	x7HzSSTIsPtomoYleYgg+caWa3JnZiEyHqEtpzqrBt8cYEf5JTkLYpVPzXXqZQgV
	RYxVPciR1xqhOFY5aXgUyX/esdlz7hSyeFnDDbPqjBOnQH+BiFxLpFhYlrecDi/n
	j/Jy6ATAJ7Ba1lXmR4ZvJHf1JReCu82rUTku3/i8txX9kjwl3TY0V2mVCAE5krjY
	UvsT2q1pKl8iZifaAWPys6jG2rmwtPxPmYJ8QY2/TcZDMK8uuLxYsrVFP87l101I
	+kTI0qiUrq06dLLr4zJzHTPwurDaCja0vEmNTU6hqA==
X-ME-Sender: <xms:hgo7amigO4N6Sd_DpS1rUk6IPcoOA9__dUMwui_qIEhBGAIw-usPDw>
    <xme:hgo7atBb9FpJ_YSRbejVNVvb645etcsRNYsCfF7029_A7uK7oU4pKP9VTLL5gLWKy
    gQbSuhVjWYNvWU_AEBRz74NuOCRlJGmwDa0JC_wpYEX45fkGRPWS7c>
X-ME-Received: <xmr:hgo7arvtkHyqfJq7TTPDv8ErTG1ZeTuCvdw4KGcQ4encIdn8A_hFztfHUQp7KjWnEdt90DmM4vCwqMkP5eWfau1E7qo>
X-ME-Proxy-Cause: dmFkZTGwKjVnY/xwOUtqyO2hAklZ2MB9j6/G2weDdvmdpFnu2uNd4AE/cMUPrN+fqkpPGI
    DrTrwNBoapQ8yx8baMIORA9lT5be9hjUGha9CIl5NrosF0cuJgG1hSkwZShbgtbcTrWzia
    7/wPxG6eYx/WaPNA7JyvYY/BbH6NyR8cxueJ853E+XgESFLQeNo+K/b/b5AHWfrcri2cZX
    Pllgh0tLD5SI5ku8otxlzFoTZ8xuCoMdz+x7de/otxchHbIZfBdUOXZmLLNNa40+TlEMps
    Jbnv5Xl4wbGktuP+lor28OI9sJRGMNuzYy3xXgAen+dn3gNQ0HKi5hqQWJmwsxXqiL8/BS
    at0c+BuCf/u00JU1P7TVOTKPUsne2vc9bDwu6MnP5JF7tPVpVZ3Ig9E6UFG9e2AgsUI/hO
    3SQfac2XMzB3PoPaw7Z9YGYL1BgU5uF4ZtIou4LXmvN4d11wWgoXnoWCdrhOnodzhItWDB
    Hrp8TnkNyg0D2lROV5BFxvhYdFaSqouG6AfjlJ3O+oB26Dd2TxVnbN9jJqrqSh4tu40Xa3
    Tbu6HpHyt+dBTZE0F+pidnR/8DHQgr4nqXkswvsWHPWS3OoJhVlb3xmTQTSRaRrapASH6U
    AaOfqDC2Cv8P+z8RyQorwokkrK/jkHq/Pt27QHhOKHlIFbXF4f2aW7E/6H+w
X-ME-Proxy: <xmx:hgo7aqaDibkJhtDX_xPCJBSK7OuI1RgRdcfg6VSL3dWdi58uinYyTg>
    <xmx:hgo7amWvosbkg_bveDdMCtYf2zz6uO31kpQuTIoTqFJSBDxq3rA6_g>
    <xmx:hgo7am5XjaHaYZg_myDPzXI1RSWV5HhOUueyTFmyIONdnHVcMh-dlA>
    <xmx:hgo7apjAt57um3CzdSKKrxd5VOvmglFIHYHJV9ImANGMYkZmfEJH1A>
    <xmx:hgo7ajGORQFYxgQhculx9cY8IJydykN8vbzRwxL36LWamrPaBbH7GMs2>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Jun 2026 18:36:53 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 4/5] btrfs: probe with GFP_NOWAIT for tree block readahead
Date: Tue, 23 Jun 2026 15:35:39 -0700
Message-ID: <e1a8f2e2b28326f7cfd96a1e414ebe73805705eb.1782249000.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782249000.git.boris@bur.io>
References: <cover.1782249000.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

extent_buffer readahead should not be able to painfully stall a
search_slot and hog tree locks by getting stuck in direct reclaim.

If the allocation fails, that is fine, we simply fail to do the
readahead in that case.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 94fa9a6c3978..b40d3c47eb0d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4737,7 +4737,8 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 		.level = level,
 		.transid = gen
 	};
-	struct btrfs_eb_prealloc pa = { 0 };
+	/* Readahead is best effort so prefer to fail rather than block in reclaim. */
+	struct btrfs_eb_prealloc pa = { .supports_nowait = true };
 	struct extent_buffer *eb;
 	int ret;
 
-- 
2.54.0

