Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F72305E32
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 04:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778129412; cv=none; b=HFLw/V5Px+QloxqnWRaujWf7jmTiDRFtkzQrqL8t3NqFbVda6eRa0l/nGclyr6+ex4yvd87AB9lfYkNONKuvxO6cNc8bauegJyvvVOOVP7bRcvV0B8IOO5rQp0I/4Y+9YXskB3oXRv8dIps6E/70ejCnL3bclQJAUVbb9fP8ccY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778129412; c=relaxed/simple;
	bh=bQB2s8WxmFtpfxZIVw/wVGZuGsPY7l5Dxg6IzHMJ1s4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U0k4BkML7NAPm8G9YjwZKzoHUPcbCghlny3vuFjiIiB6uDMpoECjkO3AALUDsj0r5n2zVQZXaPiVwePG+ajKdmySy5pIZ4+5d2tjExMh0Q/EC3lwubJ0xL1u8RRBnPun1iIrRS6/F3qNVxKD/9vbS2W4Lgmetn0EtsrGl149vjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BQd+lmXA; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BQd+lmXA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778129399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T92lbeSuDJF7TOb0l3mnZYGDplRGv4RFUXtmKR9fQi8=;
	b=BQd+lmXA/f8WxjtF/4MvcydOiZ2rTKsUXYuNzKxVCyqK0llXG8SamTlt4wBud+vNOjd6jY
	DeEajAO4982nOxFQgRyaNturbsK3JjGj9nIf8/wzzwGBS1WHqsGdMgEwwa6AQrffAnCajT
	exWHhM88xlcXdwqUY8+G+f2BslZyrZI=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
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
Subject: Re: [PATCH v5 04/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
Date: Thu,  7 May 2026 12:49:38 +0800
Message-Id: <20260507044938.12529-1-lance.yang@linux.dev>
In-Reply-To: <20260429152924.727124-5-ziy@nvidia.com>
References: <20260429152924.727124-5-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Andrew,

I just noticed that mm-new commit 83f151d1f7e3[1] links to this patch:

Link: https://lore.kernel.org/20260429152924.727124-5-ziy@nvidia.com

but the applied commit only has the include/linux/shmem_fs.h hunk ...
The mm/khugepaged.c hunk seems missing. Was this dropped unintentionally?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-new&id=83f151d1f7e3429100d148fbafc65203294e9f90

Thanks, Lance

On Wed, Apr 29, 2026 at 11:29:14AM -0400, Zi Yan wrote:
>Remove the READ_ONLY_THP_FOR_FS gate and khugepaged for file-backed
>pmd-sized hugepages are enabled by the global transparent hugepage control.
>khugepaged can still be enabled by per-size control for anon and shmem when
>the global control is off.
>
>Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
>IS_ENABLED(SHMEM) in hugepage_enabled().
>
>Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> include/linux/shmem_fs.h |  2 +-
> mm/khugepaged.c          | 26 ++++++++++++++++----------
> 2 files changed, 17 insertions(+), 11 deletions(-)
>
>diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>index 93a0ba872ebe0..acb8dd961b45c 100644
>--- a/include/linux/shmem_fs.h
>+++ b/include/linux/shmem_fs.h
>@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
> int shmem_unuse(unsigned int type);
> 
>-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
> unsigned long shmem_allowable_huge_orders(struct inode *inode,
> 				struct vm_area_struct *vma, pgoff_t index,
> 				loff_t write_end, bool shmem_huge_force);
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 71209a72195ab..d6971ada8f199 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -524,26 +524,32 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
> 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> }
> 
>+static inline bool anon_hpage_enabled(void)
>+{
>+	if (READ_ONCE(huge_anon_orders_always))
>+		return true;
>+	if (READ_ONCE(huge_anon_orders_madvise))
>+		return true;
>+	if (READ_ONCE(huge_anon_orders_inherit) &&
>+	    hugepage_global_enabled())
>+		return true;
>+	return false;
>+}
>+
> static bool hugepage_enabled(void)
> {
> 	/*
> 	 * We cover the anon, shmem and the file-backed case here; file-backed
>-	 * hugepages, when configured in, are determined by the global control.
>+	 * hugepages are determined by the global control.
> 	 * Anon hugepages are determined by its per-size mTHP control.
> 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> 	 */
>-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>-	    hugepage_global_enabled())
>-		return true;
>-	if (READ_ONCE(huge_anon_orders_always))
>+	if (hugepage_global_enabled())
> 		return true;
>-	if (READ_ONCE(huge_anon_orders_madvise))
>-		return true;
>-	if (READ_ONCE(huge_anon_orders_inherit) &&
>-	    hugepage_global_enabled())
>+	if (anon_hpage_enabled())
> 		return true;
>-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>+	if (shmem_hpage_pmd_enabled())
> 		return true;
> 	return false;
> }
>-- 
>2.53.0
>
>
