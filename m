Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938AD3C3C17;
	Fri, 27 Mar 2026 07:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774596586; cv=none; b=T3govNXwxOShUxfud9uQDcHcueaAhvj3ckKQFEXC8NsMZpBHUZrx/joyzm5ltL9l5U4LUDRVekpGPZOX8st7Qe8y3EmfDpZQtbEsV0dpFy7S0OOtHavTVgTR4c3ltvDIsHlKDVggpuAecn+SCsMCGX52crnTZqNDRIHArn5p1gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774596586; c=relaxed/simple;
	bh=9lurGn1lSpzBgjH0/+dePgyNKRaFTinujHYU3qgSCgw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2ndI+jMuh1hxJ23eSpRSAn0Wt6693b7bWzZmyLDjrsjNModstB6V1iT0yLW7nLl/bToKHZiZoUblsvqcS+pw9bT3LNRk8LOxWlK5awz8fhtS11l1tfQUQTRubBwg2Ga4sT5B/TQtRGpuRU3LUckma6CUFKyxGDm5DmK0JRv+xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ox3nCwo8; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ox3nCwo8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774596565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PVUMllx9roLVYGuErAn8ZTvJWl2ucu/IWwrTH7LZxM=;
	b=ox3nCwo83xjPmHsH25jtZvfi47UYkpcpsgdfU0K+K5oldz/OcHPPSHjnn5pFX42Wls5vXc
	rNFIQR8MoOh0foEg6JFagB5C7tnJiClvkiS15v7LnC6EeNv12LdziqkhNU90QcKELv89uZ
	YGP/nfRe6E9BvTuukXmXKEdDLOc/mbQ=
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
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Fri, 27 Mar 2026 15:29:17 +0800
Message-Id: <20260327072917.68630-1-lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-3-ziy@nvidia.com>
References: <20260327014255.2058916-3-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Thu, Mar 26, 2026 at 09:42:47PM -0400, Zi Yan wrote:
>collapse_file() requires FSes supporting large folio with at least
>PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>huge option turned on also sets large folio order on mapping, so the check
>also applies to shmem.
>
>While at it, replace VM_BUG_ON with returning failure values.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/khugepaged.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index d06d84219e1b..45b12ffb1550 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 	int nr_none = 0;
> 	bool is_shmem = shmem_file(file);
> 
>-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>+	/* "huge" shmem sets mapping folio order and passes the check below */
>+	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>+		return SCAN_FAIL;

Yep, for shmem inodes, if the mount has huge= enabled, inode creation
marks the mapping are large-folio capable:

	/* Don't consider 'deny' for emergencies and 'force' for testing */
	if (sbinfo->huge)
		mapping_set_large_folios(inode->i_mapping);

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>
