Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA2B2F25F3
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2026 05:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778045083; cv=none; b=PrzCK9qPKPEVH7QrLm033M6JkqbyhwieWDSAJ7fD0qU3wZM2o5BslWfzb2rcgZaBb0hYJc5Ke1UQt2HYszJWCEeEm09TTKZiTShYvD3vaVuB989xYH1drBSbOssh/sP23bS2608i28EhsY18IZjdTno1hwY6VUVkJNKvRCU/vig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778045083; c=relaxed/simple;
	bh=XSi9GE6KzTKtL3JnuU0hOJ2FsXccbvvkotBnn36FK8A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HGmYU9YxyADLqY1ofa3CXUy2C3XgcComGAgLJgPnoGJv6sTOIe0Df+lulxHcjGJcUyk+8QJ+4xMBQXDA4Ew5a6hFPwaQ47r5vJGZVXNYbGdwZLJZZTndZSPiQ0jhOTbwXa9yWeq7Lty63TcBi0z/W1LDy0zLewH8LNKOZyHP5tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b9UhZIT1; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b9UhZIT1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778045069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s1w2c8Ff4EBVaptmWDiNW5OHkzAexKcOkjAxIk43isM=;
	b=b9UhZIT1mho4iJRIe/NF0Wb22N6oKuFN0uCmJ90L+9ONYFTY/ERbctell74yYE4Bg3x2Km
	jVwm94U2l7uI56nzb3Vu1s3FTQ2JNxPBlIqnC2nJpohkb7saC3QqMYOLYWMRQ3vl9TZ0oV
	mPEz18rGt+0O+mTEvVaQ+SsgfULNh7w=
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
Subject: Re: [PATCH v5 02/14] mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Wed,  6 May 2026 13:23:57 +0800
Message-Id: <20260506052357.91716-1-lance.yang@linux.dev>
In-Reply-To: <20260429152924.727124-3-ziy@nvidia.com>
References: <20260429152924.727124-3-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Wed, Apr 29, 2026 at 11:29:12AM -0400, Zi Yan wrote:
>This check ensures the correctness of read-only PMD folio collapse
>after it is enabled for all FSes supporting PMD pagecache folios and
>replaces READ_ONLY_THP_FOR_FS.
>
>READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
>and inode->i_writecount to prevent any write to read-only to-be-collapsed
>folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
>aforementioned mechanism will go away too. To ensure khugepaged functions
>as expected after the changes, skip if any folio is dirty after
>try_to_unmap(), since a dirty folio at that point means this read-only
>folio can get writes between try_to_unmap() and try_to_unmap_flush() via
>cached TLB entries and khugepaged does not support writable pagecache folio
>collapse yet.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/khugepaged.c | 28 ++++++++++++++++++++++++----
> 1 file changed, 24 insertions(+), 4 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 6808f2b48d864..71209a72195ab 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2327,8 +2327,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 				}
> 			} else if (folio_test_dirty(folio)) {
> 				/*
>-				 * khugepaged only works on read-only fd,
>-				 * so this page is dirty because it hasn't
>+				 * This page is dirty because it hasn't
> 				 * been flushed since first write. There
> 				 * won't be new dirty pages.
> 				 *
>@@ -2386,8 +2385,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
>@@ -2431,6 +2430,27 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 			goto out_unlock;
> 		}
> 
>+		/*
>+		 * At this point, the folio is locked and unmapped. If the PTE
>+		 * was dirty, try_to_unmap() has transferred the dirty bit to
>+		 * the folio and we must not collapse it into a clean
>+		 * file-backed folio.
>+		 *
>+		 * If the folio is clean here, no one can write it until we
>+		 * drop the folio lock. A write through a stale TLB entry came
>+		 * from a clean PTE and must fault because the PTE has been
>+		 * cleared; the fault path has to take the folio lock before

Yeah, try_to_unmap_one() also already documents the required arch
guarantee for a clean cached TLB entry after the PTE is cleared.

			/*
			 * We clear the PTE but do not flush so potentially
			 * a remote CPU could still be writing to the folio.
			 * If the entry was previously clean then the
			 * architecture must guarantee that a clear->dirty
			 * transition on a cached TLB entry is written through
			 * and traps if the PTE is unmapped.
			 */

Lesson learned :)

>+		 * installing a writable mapping. Buffered write paths also
>+		 * have to take the folio lock before modifying file contents
>+		 * without a mapping, typically via write_begin_get_folio().
>+		 */
>+		if (!is_shmem && folio_test_dirty(folio)) {
>+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>+			xas_unlock_irq(&xas);
>+			folio_putback_lru(folio);
>+			goto out_unlock;
>+		}

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>
