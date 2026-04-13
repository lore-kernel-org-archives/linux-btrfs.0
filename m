Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200CE355F44;
	Mon, 13 Apr 2026 20:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113245; cv=none; b=oo7LMdGFm50OCc9X8pUHA639uR7rwDifamT9MyZJhClaWhLMR+MmZrqMr+XGoqwU/NoFQDgxfcqX36jHshAMujiwMkClbnAFUkNUIbQaqDRDyjMxt+VZZ+a/uXYX6WwquGVlB3iI+9vHOlp6XNDYlrhN2VM1s0qmquZBAsiwXxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113245; c=relaxed/simple;
	bh=VxhbvJ5AP4t4moorZVEJXVqPK41ZjxG3YEkr+d3ntZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DT+FghUx1+0EvoDrAXEFVLUGXKA1rYGf6ASSTFaGOH9J3ekeJwAz4snH6WEmWDxdjra/ceowW2ZXqLBZtF34kSOR+nCa17xsasFxMFOUNj5YCkiiC5ytEXASM9dstvV/cLeRlsCZakKMcwqG56JrILTOKm6SaOBnOLvnpyZ/23U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=io9etQAO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="io9etQAO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f/FCpeJbPHpze89HqlHi5GGx2Gbv6ZaMe5dTP7Neskw=; b=io9etQAOSXXNPIpcMmQYDPy5lo
	jct8aeQuAKRQ+BSF+8HGBx9hSwdoNq97aKTc4Ljl5O/l/sI1UOozNx+TNO0sxrsGwMzyULsoSoYxU
	XLm95gjTIq19FjQU0zcNHLLnHT1zC3368JWp/oaoQnDL4QwOcBxe++WDyKKtfanNZYEvTg9vGzYHw
	pRHFmh8i1NhzxB9qtWFRQU91gjqiZLXiRpXOHQ9FUsPAALOK1k8jZvGcdsG//LHPAbKoKIiwJqImr
	h8h0TuHIKE2hLMHvhfTHAMCgB4uslx/iSHEt+w5ro0dh5oTi0gIlhFGSVoXgPDaicNfQPNTUovTyn
	JKT96BUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCOBY-0000000EVEs-2c1W;
	Mon, 13 Apr 2026 20:47:08 +0000
Date: Mon, 13 Apr 2026 21:47:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Message-ID: <ad1WTCR5Kld-tiL8@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-13-ziy@nvidia.com>

On Mon, Apr 13, 2026 at 03:20:30PM -0400, Zi Yan wrote:
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
>  
>  	/*
>  	 * We must close and re-open local-file backed as read-only for
> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
> +	 * MADV_COLLAPSE to work.

Is this true?  Does MADV_COLLAPSE refuse to work on writable files?
Should we delete some code here as well as fix the comment?  ;-)

