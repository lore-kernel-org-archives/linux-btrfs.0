Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049573D1717;
	Fri, 20 Mar 2026 17:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029445; cv=none; b=dXK8SGuObGZO5GRCfcTD0WcSF4wAe1A9GB3gPDaFRhdHiqNsTnrYvtfUU/MzCh0aL/uBkFbwkOkO9pPC7bPunSHqWTGnWBWsA/DI0yw7ezoOSastp5hVz9WW0JpJaxtxwQmUADOwZl1HqrL/KoHcdBhpFflrkkQ/RycWv6gLTWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029445; c=relaxed/simple;
	bh=r+H4nN8FEm5hqBTVEcbg+154s0B6+qEaV7hbQZF5BCU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hh8A1dsyXM3SR7HDauhNNHQrSv54lQ0uZN+i7ve+cBjxRwsuhzWKbNeMTx4yGk21OUo4PDEnRyrtomd10sF4Ru79zF9qromhD1muwbZcf/RuIlM2mrWhe8G0PryeVlFYt3VuUfkRK2+ioUPoIaR4QMIJqMr6teFfyLp8F+QCoOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=krQNtRSi; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="krQNtRSi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=VG0dZbZo9KDGej1wf7CUWCHE5nKIFztp1R/yW2wVRKY=; b=krQNtRSiD4KH6dBUVLTbh5wZ2U
	C59E0ggNcspYLIPiLJFSxlPy4y5mebBSN3oh4TgMMuy9ef3f3bx9+/jWIHAIMjVXwp4fQopXbj6e5
	PC2OqQVB2MDoerbqc3K9UhwUIi3fFm1w8hrV+kfixzf33kz7LvvL1CnTnwgMOn4PcVzNdDSjsWrsr
	AsrtHLZu2YM9DAWTOr5+mB9X208QVH6yaJQPAvLac1lTj05U2Wq0FiS5RRvNrasl5akjawXV7RiOA
	mRCMjD0Nmt7hAVPUhJ1ZFQo4aGq6UhZa81wJPTxnoVwVGgmDHr8yle0Yk8Y6KQHy7rvYOlKhu+55b
	jfqRal7g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3e66-005Nfa-SR; Fri, 20 Mar 2026 17:57:21 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 20 Mar 2026 10:56:30 -0700
Subject: [PATCH v2 4/5] tools/workqueue: add CACHE_SHARD support to
 wq_dump.py
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-workqueue_sharded-v2-4-8372930931af@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1483; i=leitao@debian.org;
 h=from:subject:message-id; bh=r+H4nN8FEm5hqBTVEcbg+154s0B6+qEaV7hbQZF5BCU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpvYpsaFOiO79PHE11A52R29Ux79F3eOeR2ERmG
 JvgdlJ7hMyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCab2KbAAKCRA1o5Of/Hh3
 bc2WD/9POiOiIVo0MVz5JMmDUP5PyXYm/HXvQPxroRnM/xrXp1ZRdNGKW++NTLFQA81nNLBFCig
 YyaFf3CIu1EGi2Hw29yri+b/f4DjeI9ATMlUpBG/orY4z14VGQGqfczUFyzx7dnRlCre4KGh7qd
 B3tGQ36z8UgTwTA8lIVIBonBK8YMILu8bE8pv95GVQHbrD4VGy4CpWUT+aHie255padMuHgW72z
 t6f4kTbZONy49xQAv9cfuxkZT2Nh7QovAZHBL+f3+pSgwI4kgAGaG5ITvMNgATax+OGEYI03O+0
 VyxN2RbdxRX/rgBLQOiHriPrTNAu8H6dQBq7eRchVYu12J5d0/PqYXlMalC2sP+iktpJifcP2sh
 Yg8c1TKlc9dTXdevo44EbStsnxKaMZrVDOltlfX4Tycd9ZjXf8xP370WBQ2OWtQ2XZpVpXSy/mP
 iE5IOTL0XciwRw7NLgX6K3N0sq3U0uE1NCsIYDfUPxV0W0S8DjzLXaAsJCcn6nUUaXhPqQ99Xcr
 FH3zAuUe+x8fz+jPZXm+JKyHVCu7DalST6n0/gq0FrhhADER/jpbXFmcnubGWRtrfatjmDO96OU
 fNYGLWKq9hnw21pnZ2KrKEgO1qbFKDl4wYPZlco/kcFL2bFhDYZXsTHszeXpa92BAtpxX0rTAjt
 8j4e7cYpVg6GrRg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The WQ_AFFN_CACHE_SHARD affinity scope was added to the kernel but
wq_dump.py was not updated to enumerate it. Add the missing constant
lookup and include it in the affinity scopes iteration so that drgn
output shows the CACHE_SHARD pod topology alongside the other scopes.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/workqueue/wq_dump.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/workqueue/wq_dump.py b/tools/workqueue/wq_dump.py
index d29b918306b48..06948ffcfc4b6 100644
--- a/tools/workqueue/wq_dump.py
+++ b/tools/workqueue/wq_dump.py
@@ -107,6 +107,7 @@ WQ_MEM_RECLAIM          = prog['WQ_MEM_RECLAIM']
 WQ_AFFN_CPU             = prog['WQ_AFFN_CPU']
 WQ_AFFN_SMT             = prog['WQ_AFFN_SMT']
 WQ_AFFN_CACHE           = prog['WQ_AFFN_CACHE']
+WQ_AFFN_CACHE_SHARD     = prog['WQ_AFFN_CACHE_SHARD']
 WQ_AFFN_NUMA            = prog['WQ_AFFN_NUMA']
 WQ_AFFN_SYSTEM          = prog['WQ_AFFN_SYSTEM']
 
@@ -138,7 +139,7 @@ def print_pod_type(pt):
         print(f' [{cpu}]={pt.cpu_pod[cpu].value_()}', end='')
     print('')
 
-for affn in [WQ_AFFN_CPU, WQ_AFFN_SMT, WQ_AFFN_CACHE, WQ_AFFN_NUMA, WQ_AFFN_SYSTEM]:
+for affn in [WQ_AFFN_CPU, WQ_AFFN_SMT, WQ_AFFN_CACHE, WQ_AFFN_CACHE_SHARD, WQ_AFFN_NUMA, WQ_AFFN_SYSTEM]:
     print('')
     print(f'{wq_affn_names[affn].string_().decode().upper()}{" (default)" if affn == wq_affn_dfl else ""}')
     print_pod_type(wq_pod_types[affn])

-- 
2.52.0

