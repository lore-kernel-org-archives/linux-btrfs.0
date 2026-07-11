Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79521255A;
	Sat, 11 Jul 2026 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783784525; cv=none; b=XOGodYEcOHWNBbm9ffbj2Czbpr6GU1XkwGLja8+GsTSUSU6mP9BUOf99v3CkhS9s9K31KDvUtg5z53n2BWTcS4XKeeLZmE1PAUiuuIKyYSbnzdN9PnnS6Tr1OE8QskRhZ7JJaVBOpcY7RhywgrYGAvD37xHGFP5+CG6i52g0p2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783784525; c=relaxed/simple;
	bh=oBMHflvFSFyDDo72+ZiVm9pCRYyDGuXmUSYYOI0MfpY=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=c91WncqMzVEIDZnYQmQJtP1z/9sW3bX2Muoo2LjrBPouYBZ4cr6uOnInPqXeGOkKgvN+pnvEFJRs3AyXvTvAUDfSIJILvOAeAfReJMyA4CZtox0X5CnuhFDzRudX2OAetVKVQohSf9HxLJubMW7Mad6svP6b/DFTK4an8A0eU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=lmsGzOYc; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="lmsGzOYc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1783784511; bh=wk3rr/qzo6rbgPnqkOkEjaDRlCo7UQO/CRMCCE5/iOo=;
	h=From:To:Cc:Subject:Date;
	b=lmsGzOYc+3oQ2QjXi5SHbR0LDz0/VLxbl0pk35FJncf+EyEnF6c3fAZhacoJSoJqN
	 23H0GEtu2B4C0HbE9MCh2/UTKY2u8QxVKxG6548ErutLp0Zo32KIymoMyQBmfMDMCf
	 icRgR1K+HxfkD2ze03YQGo6kc4nF1gwrc31OUxPo=
Received: from ubuntu.. ([123.52.25.101])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id A70932B9; Sat, 11 Jul 2026 23:41:48 +0800
X-QQ-mid: xmsmtpt1783784508txp3ksdox
Message-ID: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
X-QQ-XMAILINFO: MeukCuWaRbQlbkblCeW0u3pnFrOwenNSj8SJkDHTWnSSboNNDqTqBW0LbS0UkQ
	 dUwIQfo+K1yDGLLae8bNv/CyTtDZx+emh6FJU6K67JodWkhtENyoA7+GwdBSELJzS9b3GaQ7ZiAo
	 HconNZQEYlcgl6ZCNRVNL66PA+eT8pElUIrADsVQG8Qkv1uU6mxxwHRNXOJqEswTHXVhqk/0/7eP
	 Ht2WSYh5CtOslbsB5bgjJAQnd1eG8fc8tB+wkH0GfInb5DgaQbUM8sb4VXfyZMq+0uFvzUkRAMkx
	 5VkJKlxOAnepERXillLDqSxkc/4QHzq6NMsBKIImrU7NTQDqD0qOqEGwf/zPqBQTUvZI7Z/tS/Ff
	 S/iysL2KasU6t9mESIKiiBHGcmXwXmNLAuMMZz++yrPtVCsjdyV7osbvfOc+UPxCkMlUC1cLOplk
	 FPvygrES0evbjf+TqBzS+sEeOIDKU+ghh7d3/CTPMd1QtgbpPMIk+A9DARZCTz7lG+2Jvc6ocD3q
	 RqJ9yvmUfRNR218Ds6UunwGI80vMTyyP59tLp0nRCjSCzLrObQr1DnShvvL7Q9ciObbWgp23NBmc
	 UJX4cayl28zZX8to24AafgUu3BI8V+2H617VL320OemFnfrG0Azb8rRZdaBPfJgiy7XG6ko3R2Lj
	 nOTweUvh1jEbHXQm2WI26z0mJXIvE6lZ3TjDO29HFZs0wcLV6LNyB5WK7l6sVl/mEHHpbWs+Hffr
	 lgAN8fZAifnpw7veGsPBzadmQ9orkvb8rWQe/9d5os/9n2GR2ViJ6kNGlzfGjzMq2HjHbTg9PWpm
	 UYq2II8yzCwTSQIN93oEPBte98t7f2ducVwRLXHPlBw2/IkbJJP06h3UsspfgS6uhkSg84fBPvGd
	 dMdT0CB6sjhCM/FWdStQINzC4q3iseFcU6tD1PaHjmjRv0SsvjL2pEAT9AvuzmPqrcG+6Nfg436I
	 8c1QjvSRVyFqO/MVohSBdBxBDLKqnxkXEXSX3vAXpmzjsLk3LuQf8FQTBCQx/QzmOXxp1aZ+ViVX
	 SJq9B8nOUcX/cwRwteNx4rIIM8AZN3UyhLce6yUw==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Guanghui Yang <3497809730@qq.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH] btrfs: free mapping node on duplicate reloc root insert
Date: Sat, 11 Jul 2026 15:41:43 +0000
X-OQ-MSGID: <20260711154143.1509494-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__add_reloc_root() allocates a mapping_node before inserting it into
rc->reloc_root_tree.  If rb_simple_insert() finds an existing entry, it
returns the existing rb_node and leaves the newly allocated node unlinked.

The error path then returns -EEXIST without freeing the new node.  Since
the node was never inserted into reloc_root_tree, the later cleanup in
put_reloc_control() cannot find it either.

Free the newly allocated node before returning -EEXIST.

The callers currently assert that -EEXIST should not happen, so this is a
defensive cleanup for an unexpected duplicate insert path.  If the path is
ever reached, the local allocation should still be released.

Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fb85bc8b345c..7e451e587726 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -588,6 +588,7 @@ static int __add_reloc_root(struct btrfs_root *root, struct reloc_control *rc)
 		btrfs_err(fs_info,
 			    "Duplicate root found for start=%llu while inserting into relocation tree",
 			    node->bytenr);
+		kfree(node);
 		return -EEXIST;
 	}
 
-- 
2.34.1

