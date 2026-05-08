Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9F4221DB3;
	Fri,  8 May 2026 20:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778271241; cv=none; b=kkYPtTDum72NQ8XvKCc626jd71xwbk4kS9TnjZAMtBaJyA5ozdOtAx9L937LKCLd/are55JePb47XNB7iAOWNuXHYXLfUnvJkEbR8I0WSQBL4N+nqZRRoWWQV+cb5tR+hBz1pCkw006zDGucLmT912ty5EOMRLO4AGjHg1lJOkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778271241; c=relaxed/simple;
	bh=hxYgkYjG67gsdnfV7iJptPK6UKCqEsrTTyrjyXlkR1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eyWEOF1/sgj06Z6Uxx2oJ1KR2D8Gcw0m77QBdT9cGC5DtHXpxQ+NOyjEqNhGGmAJ3PF5oKipGAi+fzR60TjTEf/2460XdwZWShdLbB/ciLNRDxFC26NgsbqtAemKgvLkntnzbINP1Wzwc9d9hxBY5NhpHwzE9SEvZ5/06J7lWpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHtvnfbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHtvnfbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C735C2BCB0;
	Fri,  8 May 2026 20:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778271241;
	bh=hxYgkYjG67gsdnfV7iJptPK6UKCqEsrTTyrjyXlkR1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LHtvnfbUnAn1itMO5JnsxJvmwUVGU8cIc09e/GNdS5u0N99UZQaOCu1FUn5eHyLFz
	 kiU1yWY7UdIgcbhFWm7ChdnCjgQoBWHtva/iyb0ZXmrpL7koLNRthngO4y0yswIGhO
	 gBpNjkIkRCIu4C4olmSvuEFzfuQOYLoXP/evhxI5czz1aKF/LlwtwFCqwQwVLe2HP1
	 WrQ6sctqlZh29QqtfiYzSuvlvwmjcnEMCegSO4qlxxZlKGVV4pmFzhRgPr2wAvgADU
	 V/0MOSyp24Uwypku5XAbLe7Gcbntnvmp6eV6HY7xVvKUyKnOp8mtXHsJdL/tnjixjT
	 M3ekFqMx+v39A==
Message-ID: <b8a3c3eb-f241-40fe-9121-4ae5a1097807@kernel.org>
Date: Fri, 8 May 2026 22:13:50 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/14] mm/khugepaged: enable clean pagecache folio
 collapse for writable files
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-9-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429153538.727855-9-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/29/26 17:35, Zi Yan wrote:
> collapse_file() is capable of collapsing pagecache folios from writable
> files to PMD folios. Now enable clean pagecache folio collapse in addition
> to read-only pagecache folio collapse by removing the
> inode_is_open_for_write() from file_thp_enabled() and only performing
> filemap_flush() if the file is read-only.
> 
> This means userspace needs to explicitly flush the content of pagecache
> folios before khugepaged can collapse the folios, or use
> madvise(MADV_COLLAPSE), which does the flush in the retry. The reason is
> that blindly enabling dirty pagecache folio from writable files collapse
> makes khugepaged flush these folios all the time. It is undesirable to
> cause system level pagecache flushes.
> 
> To properly support dirty pagecache folio collapse, filemap_flush() needs
> to be avoided. Potentially, merging associated buffer instead of dropping
> it with filemap_release_folio() might be needed.
> 
> NOTE: this breaks khugepaged selftests for writable file pagecache
> collapse, which is set to fail all the time. The next commit fix it.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 2 +-
>  mm/khugepaged.c  | 9 ++++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9b3abb98a7e51..e1e9d59db6e70 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -97,7 +97,7 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
>  		return false;
>  
> -	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> +	return S_ISREG(inode->i_mode);
>  }
>  
>  /* If returns true, we are unable to access the VMA's folios. */
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1ee15b48962a3..fb7ff643973cc 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2345,7 +2345,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  				 * forcing writeback in loop.
>  				 */
>  				xas_unlock_irq(&xas);
> -				filemap_flush(mapping);
> +				/*
> +				 * Only flush for read-only files. Writable
> +				 * files can have their folios dirty at any
> +				 * time; blindly flushing them would cause
> +				 * undesirable system-wide writeback.
> +				 */

That comment should really be merged in the comment above.

Also, there we say "khugepaged only works on read-only fd" ... which is now just
wrong?

Please revise that whole comment as you incorporate your comment.

Apart from that I guess this is fine ... or we'll learn rather quickly, haha.

-- 
Cheers,

David
