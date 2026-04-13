Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2B358375;
	Mon, 13 Apr 2026 20:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776111835; cv=none; b=TNddcktoInIeg1r/B+gKizjQ3CqjVMEcLL++60w0kYHKT+BQGAGcFNyB3UAWZ1LKpq+CfQaTUrdc0gcKkUoYTKxazPBEUMWZMx98Ea5KlzDIvB4TaAt4olBGEcC+JtEymunD7Ss/44X5jvpYkv53dfafe2DwzT6IH9TgIt46vdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776111835; c=relaxed/simple;
	bh=0nRYXFDdqwUk7AmNpdU20+c218yTc7h6InwEHAb6ghw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozozWVzNcirChMzPfM0XtkXcgNahyUGJalwSbynayXZzeZbnDVYnMEaDuodfZ+5kTpyUVYWZBWPyEGfCBqhqXiOjyhySk9m0pTX64DXJ7CQm7E90FXsrlqZ4fACN9rV0H57Fxx9C2868Xisg5SsaP6wgXxRi7In6JM4c0agjCGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SzIDPrSX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SzIDPrSX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Go3KR/GxnDhS1WvRjFzC5JY4mv9JDOpGHOi+xw7ZijQ=; b=SzIDPrSXF57/cO6VKzxPi/iAs3
	cYuprt6Bgod9wvN6JE4aFQK1TxBqvZaNiOGYtVpaIFL1sblvslueuM0+CvnSqokGtHVgvoy7ZVtZl
	gPCoVPyYfw/eB8bIgp1ZXUpjqosuYmdEh6nMYrFemmGDTgWsdHg5bZ8iy08NNk4fIA3QJ6BmiI/zr
	QcKn45zWo5LwySVJgr0WDxbxUcoI7t1czaYn7ha94qec/l8T4so9413TPJefem8L5o6Fy9mPGMqtn
	jqd0Q8gTAdnstA0crwWESqCc5k/ZYbQk1Dak79V2UGMtIHjK0fnN53VjTR6AOLrXtcnaShJxY4ZuZ
	GUfF/fhA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCNot-0000000ETYR-2MUu;
	Mon, 13 Apr 2026 20:23:43 +0000
Date: Mon, 13 Apr 2026 21:23:43 +0100
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
Subject: Re: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap_flush()
Message-ID: <ad1Qz7SClkF1CqWs@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-3-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-3-ziy@nvidia.com>

On Mon, Apr 13, 2026 at 03:20:20PM -0400, Zi Yan wrote:
> +		if (!is_shmem && (folio_test_dirty(folio))) {

seems like a spurious pair of brackets?

		if (!is_shmem && folio_test_dirty(folio)) {

should be fine

