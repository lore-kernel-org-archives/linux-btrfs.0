Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFA53AC0F7
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 09:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774862156; cv=none; b=C1knimthJpU1cpLBWSuSYlxFGj4mpi0r+XBJeAFIlBnVuWMI8QV92bTDOiF4lBCDhbVUT4J2KiYywnUknyOkOltg2yWZXaZr/4BU0TmrzsCGSyo3LQZYvT55eDuNW6vOVW+PyWXfHpIAIvZpYFtAQdWJ9nPLqeXizkZLxDDG29U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774862156; c=relaxed/simple;
	bh=AzAa6DQjayThxteHcqdm/tmqzwVZZPl7N5KBVY2xBVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGgLa/oYHgP4/LxpfRjOOQD5N/PwPMOA2UpwNcGNxm9oFXKl6CcF7cl0xR3v4dzU9qolvmK1+RBDobqWMqIBvk0w4DfDb7S6Mwt2C9a6KfEvlVOUmYv8L82XkvDYqBRBX0/3+LMayte3b8PrIn1ZZCgGurLiRtVdKOZOn+MoX6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JlEVi6V9; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JlEVi6V9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774862153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LSCJ0gl8vSa6PI9GtiEGiz02O1vonLLeMqbuDT2/pT0=;
	b=JlEVi6V9Dvb4mKdK823yLSF2UnR/iHJ0WcmyNTy0zY2Vi0Iw/QhfgPYo49r/guOUtqs07o
	2wEfzceNfeC0ZghYSXatqvUiQtxgYTkFjR+fQdkCMeaKASv6tP9fKcmehrrBDbe60u65DD
	rd2PAY99ZUhzsT3Xo99AG1Jk0KJicfE=
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
Subject: Re: [PATCH v1 06/10] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Mon, 30 Mar 2026 17:15:36 +0800
Message-Id: <20260330091536.20015-1-lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-7-ziy@nvidia.com>
References: <20260327014255.2058916-7-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Thu, Mar 26, 2026 at 09:42:51PM -0400, Zi Yan wrote:
>Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
>a FS without large folio support. The check is no longer needed.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/huge_memory.c | 22 ----------------------
> 1 file changed, 22 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 1da1467328a3..30eddcbf86f1 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3732,28 +3732,6 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
> 		/* order-1 is not supported for anonymous THP. */
> 		if (new_order == 1)
> 			return -EINVAL;

While you're at it, could we also collapse this block above into a
single condition:

	/* order-1 is not supported for anonymous THP. */
	if (folio_test_anon(folio) && new_order == 1)
		return -EINVAL;

Just saying. LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>


>-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>-		    !mapping_large_folio_support(folio->mapping)) {
>-			/*
>-			 * We can always split a folio down to a single page
>-			 * (new_order == 0) uniformly.
>-			 *
>-			 * For any other scenario
>-			 *   a) uniform split targeting a large folio
>-			 *      (new_order > 0)
>-			 *   b) any non-uniform split
>-			 * we must confirm that the file system supports large
>-			 * folios.
>-			 *
>-			 * Note that we might still have THPs in such
>-			 * mappings, which is created from khugepaged when
>-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>-			 * case, the mapping does not actually support large
>-			 * folios properly.
>-			 */
>-			return -EINVAL;
>-		}
> 	}
> 
> 	/*
