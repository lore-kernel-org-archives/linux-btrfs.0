Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01D4373BE0;
	Mon, 23 Mar 2026 21:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774299771; cv=none; b=GqlOQ6V8I+RHi4MyeyX2dn+DoG3d7yxN1YG7D8MNFhQ5y5OmLo/O2pTtVHGGwNPdwk/SAuXbxoXooMPcGZ06v1/QXvWSjZTmGcl6/sS82lFYLmUQVpcsbBZMXbCVsFhj3TUqP7kyK2qmyJZ7Rrlnp4Zfn7/mKEjsPKXSyWYt91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774299771; c=relaxed/simple;
	bh=gxAcHrsgrKbfz3TCdlmAFAjObaKlzuQOhvmQdjK9DnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owh6qyzfe2KVtvTKwSWF5iqmQJAeDbzAXZ7M9FN4IIGg/XopV6pQhMP6JGea5qg1HtgD9Wp9qsiN2pRTPyoUwJ0s3n0JRWCvzYvj5VCodWoIdywvtvBQMdQkSYJPkiE8Wkl336Zfs57jcy2J/+gHzZolua/NcAYT5Jm71dJgWzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hMFNFZka; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hMFNFZka"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3AOsenzNPAeVFjUaTF+EAsvLlXdttCRQbifAIz71hTA=; b=hMFNFZka51FeDea+aaAXkA2sMF
	Xw1RTmW14PACkldpXstX1oEG7V17NRMgrH1Qhur8aqWusYInZoN03g2Z6340NcVy2mw4TpwjSBezp
	WaNtfFjPeEzZsvs7EvK7QeT5a9JJUOI92MC9ntRqcpID+pqBqOGJIdR10b0nYjZyqHAQiusU/oenP
	J2Jp2DwPzXYy1NYC5ZruGx2qP6kHRhpGbcb3oMRJ+g6uzyWnMs79pAWiFeLP1v7l4/1O4wtoq0CZs
	h6eg3GZYjQsVZBVlAvJfHnW1SitoXoTr3Ri9pJLyzCIhAOKJOBWXY/5xfXaOMqSG3p0ynbuZzSNbF
	YTSxQfbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4mQ1-0000000CsDl-3RRd;
	Mon, 23 Mar 2026 21:02:37 +0000
Date: Mon, 23 Mar 2026 21:02:37 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 code in collapse_file()
Message-ID: <acGqbeSjktT4biku@casper.infradead.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
 <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>

On Mon, Mar 23, 2026 at 04:24:26PM -0400, Zi Yan wrote:
> On 23 Mar 2026, at 16:13, David Hildenbrand (Arm) wrote:
> > I assume so, because for executables you would have to be lucky to get a
> > PMD THP? So I don't see the non-khugepaged large folio support on par
> > with khugepaged support.

Not necessarily that lucky; if you set VM_HUGEPAGE,
do_sync_mmap_readahead() will allocate PMD-sized folios automatically.
On busy database servers (and is there any other kind?), khugepaged
takes too long to run and find opportunities to collapse text pages.
Like, days.

> It is more like turning on READ_ONLY_THP_FOR_FS by default for
> FS with large folio support instead of removing it.
> 
> OK, I will give it another try.

I think the test needs to be:

	if (mapping_max_folio_order(mapping) >= PMD_ORDER)

as there can be cases of filesystems which support up to, say, 64KiB,
but not all the way up to 2MiB.  I disapprove of this situation, but
this is where we are right now.
