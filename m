Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5643D38D68F;
	Thu, 23 Apr 2026 08:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776933080; cv=none; b=Kvsv8UZxhdGfqbJanMgTKwHJGjBk4/viOJus4ronPVT7kOQd9MQsdhrwERDjbz9A7c0s2K6iXP37WXB9fyGUzvGVbAoHWZJeU1QGQyjYTs+xJkg2suQXWyATWPfVrxXKuupkKOvE4jwW/t/gEHxBwwXkwieS0bhjPdBmqp+Mr78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776933080; c=relaxed/simple;
	bh=0mGuKowfe/XKCihGyX/x0JPopKQmhoso38DXB1vAdFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nl0fpfx1ogWSYAu60FourKE0G3+WO86IK+KeEe64IA4nqegGmA+j5Cmrif+nXT//h3p0iQo5gEPRBpT7ykws9/Am4K1JgwZoFnbk1sQGV1qYdH7QN8fPxc1hQjl7DNi5zL3T1hpBjF4vuQD8cNx+qmhVCzyKCamamuBK6r9Yekc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bE5bcvvO; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bE5bcvvO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776933076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8YwT2J6y8VB+nAR+GUBhFBsu9Q8obY1raNP6TplLRG0=;
	b=bE5bcvvOtZaF4jMACv4gJWXGy9pHyr8ZxjVjWFRr+w6XlHcOtheOUgxbQgLv+svPUFqb4T
	GokyuelKSqLfKOt2rGQAUf3T4tMyRE7867WB0u62bDlpEYJXjKkepMxOSQNZFnhG3YNhsv
	dANjm0XSetWNnKHvHhvfdfBZT807gF4=
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
Subject: Re: [PATCH 7.2 v3 02/12] mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Thu, 23 Apr 2026 16:30:50 +0800
Message-Id: <20260423083050.68509-1-lance.yang@linux.dev>
In-Reply-To: <20260418024429.4055056-3-ziy@nvidia.com>
References: <20260418024429.4055056-3-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Fri, Apr 17, 2026 at 10:44:19PM -0400, Zi Yan wrote:
>This check ensures the correctness of collapse read-only THPs for FSes
>after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
>PMD THP pagecache.
>
>READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
>and inode->i_writecount to prevent any write to read-only to-be-collapsed
>folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
>aforementioned mechanism will go away too. To ensure khugepaged functions
>as expected after the changes, skip if any folio is dirty after
>try_to_unmap(), since a dirty folio means this read-only folio
>got some writes via mmap can happen between try_to_unmap() and
>try_to_unmap_flush() via cached TLB entries and khugepaged does not support
>writable pagecache folio collapse yet.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/khugepaged.c | 25 +++++++++++++++++++++----
> 1 file changed, 21 insertions(+), 4 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 3eb5d982d3d3..1c0fdc81d276 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1979,8 +1979,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 				}
> 			} else if (folio_test_dirty(folio)) {
> 				/*
>-				 * khugepaged only works on read-only fd,
>-				 * so this page is dirty because it hasn't
>+				 * This page is dirty because it hasn't
> 				 * been flushed since first write. There
> 				 * won't be new dirty pages.
> 				 *
>@@ -2038,8 +2037,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 		if (!is_shmem && (folio_test_dirty(folio) ||
> 				  folio_test_writeback(folio))) {
> 			/*
>-			 * khugepaged only works on read-only fd, so this
>-			 * folio is dirty because it hasn't been flushed
>+			 * khugepaged only works on clean file-backed folios,
>+			 * so this folio is dirty because it hasn't been flushed
> 			 * since first write.
> 			 */
> 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>@@ -2083,6 +2082,24 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 			goto out_unlock;
> 		}
> 
>+		/*
>+		 * At this point, the folio is locked, unmapped. Make sure the
>+		 * folio is clean, so that no one else is able to write to it,
>+		 * since that would require taking the folio lock first.
>+		 * Otherwise that means the folio was pointed by a dirty PTE and
>+		 * some CPU might have a valid TLB entry with dirty bit set
>+		 * still pointing to this folio and writes can happen without
>+		 * causing a page table walk and folio lock acquisition before
>+		 * the try_to_unmap_flush() below is done. After the collapse,
>+		 * file-backed folio is not set as dirty and can be discarded
>+		 * before any new write marks the folio dirty, causing data
>+		 * corruption.
>+		 */
>+		if (!is_shmem && folio_test_dirty(folio)) {
>+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>+			goto out_unlock;

Looks buggy :)

This runs after folio_isolate_lru() and after xas_lock_irq(&xas) ...

If not missing something, "goto out_unlock" would leave the xarray lock
held and the folio off the LRU :)

Note that the block right above does call xas_unlock_irq(&xas), and it
also does call folio_putback_lru(folio):

---8<---
		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
			result = SCAN_PAGE_COUNT;
			xas_unlock_irq(&xas);     <-
			folio_putback_lru(folio); <-
			goto out_unlock;
		}
---

So we should follow the same cleanup as that block here, right?
