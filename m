Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5BF3822BF
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 07:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778223731; cv=none; b=PmrIojcbKURvR+JRIqeaFaYVxhNJg7l9GPwTHL1o9vfNFrXjrvJjjtmZWJqDqdUZ7GVa4Nrzc1ZCo86LKE06JogM7DWgaEqFUo5ejmJQvaS2/wvrtF8W4cid9a5XAGxi9HNZT/c4K+CA+X9ixWuqmJiZyRwGXi4e5rbFMQlfDbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778223731; c=relaxed/simple;
	bh=NjihaeD76Jsi8Lwgt5xatfktO5NhR9x51duFuCUS48I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AzUicPAbzZ0t2C2OfeZsrdCAUAjA7Genw11AFjhA4xAQ8kIE8vkIs0nE2dCBEbjADF6VBkpaDQb+DrrQTsRt35SakENArf0fyy7CDW5/U0QawxYVvE7ZCJcJxM1fAsg3FbOPxXE2/y8HTKmZ90Lh/mjZ270ycdgxSLxC9R5rf1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iha2P92R; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iha2P92R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778223712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NjihaeD76Jsi8Lwgt5xatfktO5NhR9x51duFuCUS48I=;
	b=iha2P92RrzX66oAtKsbukb/2Sw0Jn2it2q2sfp/ztwpYbr2+hf03kOW505Mxcb1lEHH1Sa
	H1TGMGI6zu6hxwo9RaHB1CDDQ/KHNSUQH0b270vEUH3aUWr6DvDhuP75QME4ASoJjvxk6b
	dgjJoO36+YMmfKBxkU3JaBgkcX19mnE=
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
Subject: Re: [PATCH v5 09/14] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Fri,  8 May 2026 15:01:27 +0800
Message-Id: <20260508070127.18666-1-lance.yang@linux.dev>
In-Reply-To: <20260429153538.727855-5-ziy@nvidia.com>
References: <20260429153538.727855-5-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Wed, Apr 29, 2026 at 11:35:32AM -0400, Zi Yan wrote:
>After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
>not. folio_split() can be used on a FS with large folio support without
>worrying about getting a THP on a FS without large folio support.
>
>When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
>appear in a FS without large folio support after khugepaged or
>madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
>such a PMD large pagecache folio is split and if the FS does not support
>large folio, it needs to be split to order-0 ones and could not be split
>non uniformly to ones with various orders. try_folio_split_to_order() was
>added to handle this situation by checking folio_check_splittable(...,
>SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
>READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
>READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
>with FSes supporting large folio, this function is no longer needed and all
>large pagecache folios can be split non uniformly.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---

With that gone, large page-cache folios should only exsit on mappings
that support large folios, so folio_split() with
mapping_min_folio_order() is enough :)

LGTM, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>
