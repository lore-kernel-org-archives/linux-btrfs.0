Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2677539446F;
	Mon, 13 Apr 2026 20:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112717; cv=none; b=Chq6Cc26xSqh3m1ynA4UBpgNUGFnJbbtmHrEh6mpHGOb/X/i9RfjCyiDHByyd6+xClOUPdvd3YzzePOMOOas35b+3LV1O7grs7EETyMooa7hPs7dvyhBnWGrstjkbt/cihg/4aXvouxxdOeLtuGcTQuyBcdplW7hE7N9rfNfd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112717; c=relaxed/simple;
	bh=shqzzww8efu125Fz4bPAww698eDKVAA5AF6kD5vHNcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTDvHeHBmGIe9kpKeDfIaLL88DJCpMZFgMtQE9fpiWM56ViGKWmIJYwOVOZ/xA9LgDbcIL14KLkYV4uVqWSCd86p7K1ipnCUZU5Wkh6J+Do3Ofl0JlJKcOfOzlKOFwM1x520K7alFF4rgLZpUM70zutHnqokzUGxmJqbhB+W4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HyRxFVuz; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HyRxFVuz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=shqzzww8efu125Fz4bPAww698eDKVAA5AF6kD5vHNcQ=; b=HyRxFVuzIo3nZP4w5dJrvfv/Xf
	/LF1ktymMWmns85j1OtJrOMy89vy0HpDVZZxfy1GpTV2GGdDOamZdspK0+5xNxMvcYue+HHyStGHq
	MH6C2w/rL96USv1cxaU00MIr687cwhZUnpEzUItaEgiSFuRadLw/+M/lhovP6UXF8n0ZGoZYHlVH6
	7cdFfgm8esi9lqVJ5rnJez7z4XIRlbbOXIb3xaAUSd5zLXLWFccn0VigkdVVZk2ni/UrQvo2OvYuu
	r3jd9HbUgUyftndyw3ADlm87pijqqL2NkALTAQOThIZ54PODyexR3ZHxgU9ivIRAZ0J3/vcsnI5uB
	1Oeu2vVw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCO3B-0000000EUaQ-0JvL;
	Mon, 13 Apr 2026 20:38:29 +0000
Date: Mon, 13 Apr 2026 21:38:28 +0100
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
Subject: Re: [PATCH 7.2 v2 07/12] fs: remove nr_thps from struct address_space
Message-ID: <ad1URJ0B0SOUX7Sj@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-8-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-8-ziy@nvidia.com>

On Mon, Apr 13, 2026 at 03:20:25PM -0400, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it.

... this shrinks struct address_space by 8 bytes on 64-bit systems
which may increase the number of inodes we can cache.

> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
