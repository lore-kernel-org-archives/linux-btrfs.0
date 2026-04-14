Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBD03D5672;
	Tue, 14 Apr 2026 10:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776163130; cv=none; b=tamkhWUxikY4Y3exz8Sd+ddmB2CGt6Z3fRG1PuOfVtlL2SwLbBEx3OkfD5VTebLSChAXK8SPT6s4pmqrakpjTxDM5wz85sP+uuVCGorVmjw7gbkhfFhYq6PUQJm+I30+ANW7LzUcobqWKcGlkRk7apLBR8iam9HMCkcTl4HoAGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776163130; c=relaxed/simple;
	bh=Fpa0Zfgr+E7SENPxMZuDK0p/58ygV0eXyPaZzP6kQGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nW5bzf4fbAP5eb8PjGbVlVD3A5Xx174vnZj0JdCvyVApzBOKgcH/2sCu71GfOkdU+a3Aous+eMWThMbbx7yFbtBqAWeeNx4aZBCCwj19NmJd2uRaec9uJFI+slDM0+2MxAYXwU21vjypfZPScax4egQrs8eKNO5I3kUSOOTnASA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pAWzK//L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pAWzK//L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770FEC19425;
	Tue, 14 Apr 2026 10:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776163129;
	bh=Fpa0Zfgr+E7SENPxMZuDK0p/58ygV0eXyPaZzP6kQGQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pAWzK//L9cM5Om4kXfUxOJPX6jJBWQrIiRX860Pmdh2vrJRv1GERL6Ipg05z7qq8e
	 sGqWqeleqN5i6FSasfB7ZB+ugGAcsjLY44ymAKvEHtz3gbRysqihqaYhmYg3c/sftj
	 63/n8L+AyKcZakDZxDJCXkcFtGlVQRX5gM6pyE608gN+nKV+Bi4onlR2BDj68+jBEq
	 2QGokokdGa7wCcsYzjcRN+RrjczDP6+CfOWRLUjSWIa2FxiLieYDQhfW7eeMn0ZAyj
	 JCQq7i+UZHjZxOgiHeT2IiL7PB/ykEZ53RID7zjOGHzpGkQsrD9JkZHGZqTs/YjSem
	 zuCzXRtzOUpqg==
Message-ID: <10aadfeb-86c6-47b2-b6ab-b86657aafb88@kernel.org>
Date: Tue, 14 Apr 2026 12:38:39 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap_flush()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-3-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413192030.3275825-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/13/26 21:20, Zi Yan wrote:
> This check ensures the correctness of collapse read-only THPs for FSes
> after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
> PMD THP pagecache.
> 
> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
> and inode->i_writecount to prevent any write to read-only to-be-collapsed
> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
> aforementioned mechanism will go away too. To ensure khugepaged functions
> as expected after the changes, rollback if any folio is dirty after
> try_to_unmap_flush() to , since a dirty folio means this read-only folio
> got some writes via mmap can happen between try_to_unmap() and
> try_to_unmap_flush() via cached TLB entries and khugepaged does not support
> collapse writable pagecache folios.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/khugepaged.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d2f0acd2dac2..ec609e53082e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2121,6 +2121,24 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	 */
>  	try_to_unmap_flush();
>  
> +	/*
> +	 * At this point, all folios are locked, unmapped, and all cached
> +	 * mappings in TLBs are flushed. No one else is able to write to these
> +	 * folios, since
> +	 * 1. writes via FS ops require folio locks (see write_begin_get_folio());
> +	 * 2. writes via mmap require taking a fault and locking folio locks.
> +	 *

maybe simplify to "folios, since that would require taking the folio lock first."

> +	 * khugepaged only works for read-only fd, make sure all folios are
> +	 * clean, since writes via mmap can happen between try_to_unmap() and
> +	 * try_to_unmap_flush() via cached TLB entries.


IIRC, after successful try_to_unmap() the PTE dirty bit would be synced to the 
folio. That's what you care about, not about any stale TLB entries.

The important part is that the 

So can't we simply test for dirty folios after the refcount check (where
we made sure the folio is no longer mapped)?



diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b2ac28ddd480..920e16067134 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2089,6 +2089,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
                        goto out_unlock;
                }
 
+               /* ... */
+               if (!is_shmem && folio_test_dirty(folio)) {
+                       result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+                       xas_unlock_irq(&xas);
+                       folio_putback_lru(folio);
+                       goto out_unlock;
+               }
+
                /*
                 * Accumulate the folios that are being collapsed.


I guess we don't have to recheck folio_test_writeback() ?

-- 
Cheers,

David
