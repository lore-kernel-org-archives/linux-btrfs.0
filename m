Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1C0376BC1
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778226448; cv=none; b=Pt3OzjPGngIPjs7DCEFX5MgB0DMdhK6K+b2k1AET6nwZHL2f3sHi77P+ciyFrMEoE2Mc01AXYOWpU5Vom/9ImXE4/DYTy3+P0V+yd5rq4t3dj8lZCViYqDrBfmkoygE0Ghhq1O3IBDIQX1hSmwFJmmpfvcdB6bJeMTnelbvFG4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778226448; c=relaxed/simple;
	bh=VX0XzmygCP006w30fb/t3PlZoR7eIn8pG4f57T93yMM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pDfrBCFXgeiOls9izDF7xAJBBZ7WeEJ9fvbGOn6iqI2YWIwxhSKtQmzRgoBzlfeOJGT7CUZ0ygC1l7eaDuaeDcMwKJIay03kLPb+I9p5lFA5FgZftyse1RyRAXv0D7w9xbXkv0qs1euxUfOVwWtDaoXZbFGzalGIL5nuaAEXD7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ewXSNaom; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ewXSNaom"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778226432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ywAzvaNWn4c6wjdRn8PKJu6vnrjvK/OKJzqJA8I7cw=;
	b=ewXSNaomo+/VRA3wetbuDv59SQT1taIzdio5CEahqiCz4zhct+/v18Re0BtsLAuGdvyGxE
	B9Fn3h+8B6UTstuCfEXlLMJbXwvumE7KhHFX9T9NMPrhp+T6aNglDmsxIgX9qKdcns2t91
	qQ3MG3ZjU2BcYoTu8TbBcS/+tTpXuTU=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
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
Subject: Re: [PATCH v5 13/14] mm/khugepaged: enable clean pagecache folio collapse for writable files
Date: Fri,  8 May 2026 15:46:43 +0800
Message-Id: <20260508074643.55548-1-lance.yang@linux.dev>
In-Reply-To: <20260429153538.727855-9-ziy@nvidia.com>
References: <20260429153538.727855-9-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Wed, Apr 29, 2026 at 11:35:36AM -0400, Zi Yan wrote:
>collapse_file() is capable of collapsing pagecache folios from writable
>files to PMD folios. Now enable clean pagecache folio collapse in addition
>to read-only pagecache folio collapse by removing the
>inode_is_open_for_write() from file_thp_enabled() and only performing
>filemap_flush() if the file is read-only.
>
>This means userspace needs to explicitly flush the content of pagecache
>folios before khugepaged can collapse the folios, or use
>madvise(MADV_COLLAPSE), which does the flush in the retry. The reason is
>that blindly enabling dirty pagecache folio from writable files collapse
>makes khugepaged flush these folios all the time. It is undesirable to
>cause system level pagecache flushes.
>
>To properly support dirty pagecache folio collapse, filemap_flush() needs
>to be avoided. Potentially, merging associated buffer instead of dropping
>it with filemap_release_folio() might be needed.
>
>NOTE: this breaks khugepaged selftests for writable file pagecache
>collapse, which is set to fail all the time. The next commit fix it.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/huge_memory.c | 2 +-
> mm/khugepaged.c  | 9 ++++++++-
> 2 files changed, 9 insertions(+), 2 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 9b3abb98a7e51..e1e9d59db6e70 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -97,7 +97,7 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> 	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
> 		return false;
> 
>-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>+	return S_ISREG(inode->i_mode);
> }
> 
> /* If returns true, we are unable to access the VMA's folios. */
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 1ee15b48962a3..fb7ff643973cc 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2345,7 +2345,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 				 * forcing writeback in loop.
> 				 */

Nit: the comment above now looks stale. It still says:

"There won’t be new dirty pages."

That was true when file_thp_enabled() rejected writable-open files, but
not after this patch ;)

Otherwise, LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

> 				xas_unlock_irq(&xas);
>-				filemap_flush(mapping);
>+				/*
>+				 * Only flush for read-only files. Writable
>+				 * files can have their folios dirty at any
>+				 * time; blindly flushing them would cause
>+				 * undesirable system-wide writeback.
>+				 */
>+				if (!inode_is_open_for_write(mapping->host))
>+					filemap_flush(mapping);
> 				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> 				goto xa_unlocked;
> 			} else if (folio_test_writeback(folio)) {
>-- 
>2.53.0
>
>
