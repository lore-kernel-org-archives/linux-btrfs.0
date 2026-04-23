Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDC41096F
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 02:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776912223; cv=none; b=TWqEBkIzMgOahctGzP4Ua4EQMjEotAWcD2g7skVP+6HILlaqKytez8povnDgqVrlEz0LNIojYyL42Z9jLKgSSGAaMia/TaUM8OR6JnFS9HCjlVJd37RwYXWwLrjL9EzHoUHnQ45isuhbC1eE5LvMktByP6R2MsgLdqaXlFSGl5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776912223; c=relaxed/simple;
	bh=f5Ela3h3SmwpTpGrcI9Z0tlKA/R88o+MOdI07JVimvc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M/8bvunipQeMFj9IBUi4j7/pAxZzxpPLvvMXflyLaiZ8OytRPbJMQuFU/+a2Ot473kuLFCqI/z/p84X7XuIGpuM/5I7cQRYyo40Jenfzx5R4evH1s+VS0J4j6QDMGSms+BpfS0KBfJec+MYWzXlhxlXyKTATmCO4g9uHvvR7lWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dbVPz/70; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dbVPz/70"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776912219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMukq5Ux3ezv5Tyfl0FoaOXQcgnvMJcY/OsebFof9qE=;
	b=dbVPz/70tYHnFMXxFY25JlFErOfD2J4+flnFzZWIC+GFQLAapotxsFxlAWVXDzN/3tqSgp
	7ZkBqd9Q4CRT3BAfi8roSgJ3+PwfRM3RTMma7KOb7LXwjYwl89WkYLG6UjTE0BMSSNEtUh
	o25vpDGVCfCldSri1nd6fxpGOgDUlW8=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 23 Apr 2026 10:43:24 +0800
Message-Id: <20260423024324.51588-1-lance.yang@linux.dev>
In-Reply-To: <20260418024429.4055056-2-ziy@nvidia.com>
References: <20260418024429.4055056-2-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Fri, Apr 17, 2026 at 10:44:18PM -0400, Zi Yan wrote:
>collapse_file() requires FSes supporting large folio with at least
>PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>
>While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>
>Add a helper function mapping_pmd_thp_support() for FSes supporting large
>folio with at least PMD_ORDER.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> include/linux/pagemap.h | 10 ++++++++++
> mm/khugepaged.c         |  5 +++--
> 2 files changed, 13 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>index ec442af3f886..c3cb1ec982cd 100644
>--- a/include/linux/pagemap.h
>+++ b/include/linux/pagemap.h
>@@ -524,6 +524,16 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
> 	return mapping_max_folio_order(mapping) > 0;
> }
> 
>+static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
>+{
>+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>+	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
>+			"Anonymous mapping always supports PMD THP");

Nit: afraid not, at least when running on architectures without PMD leaf
entries ...

Maybe better to say this helper is only meaningful for pagecache-backed
mappings. Anonymous mappings should not reach here.

>+
>+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
>+}
>+
>+
> /* Return the maximum folio size for this pagecache mapping, in bytes. */
> static inline size_t mapping_max_folio_size(const struct address_space *mapping)
> {
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index b8452dbdb043..3eb5d982d3d3 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 	int nr_none = 0;
> 	bool is_shmem = shmem_file(file);
> 
>-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>+	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
>+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));

With [1], can we drop !is_shmem here as well? shmem would then always
call mapping_set_large_folios(inode->i_mapping):

---8<---
diff --git a/mm/shmem.c b/mm/shmem.c
index 4ecefe02881d..dafbea53b22d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3087,10 +3087,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
-
-	/* Don't consider 'deny' for emergencies and 'force' for testing */
-	if (sbinfo->huge)
-		mapping_set_large_folios(inode->i_mapping);
+	mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
 	default:
--

But we can do that in a follow-up, once the revert lands :)

[1] https://lore.kernel.org/linux-mm/b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com/
