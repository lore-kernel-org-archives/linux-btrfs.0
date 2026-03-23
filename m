Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001F92D7D3A;
	Mon, 23 Mar 2026 21:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774300081; cv=none; b=j2Sf6KmLVzOyJsbXiHWBiKBh065SX7c8xtO7n159HUX4dRx0ZwFl6e3wltohH3U5aEjxjiCL+RTd1MuCriGKC2tVfc7Qlv4dF0k3p2Xv5hnXN0KM6yHzDh45AtwyNg04Dr3CGd1laZWemwrcPHdIwH+a934R/ta8WvP1Gdgf4+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774300081; c=relaxed/simple;
	bh=9jV7hk/q6vvi2T/XuzKcjoXfovlzRslr4qCUrbsJ/A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtXIUM8J2UBRgADxjW/cFEvzhVQr8DyO/iyxBIFH5dw0+nlpiiq4oxxDCMzgBo7bCHdiYYhcozTgrFHWcK281ITrZLMj8cIoFfNdlVYWthBAaQALqznwFswM9mkP5xlrD7Ih6eZ3hhTXQwyVcOIv9vj5lFDbFQkjB43KVRXxMBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RFZdu4G+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RFZdu4G+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KNBJuuzzq0GPbd2BLBr03j+XIuHlYuWDg25dI5hkPwE=; b=RFZdu4G+/00qiBpkU8fCw68Rrm
	W21rPmkkxyeKei7zPQ6uFrp2Ilx/Ygk8xHRAFFNsfW/OTOcLGh88XbvHxkn1siM2RE7hhwdfNiKwL
	kW6sIpIjUmF7cVGoDqi0UBijZ+pECnyIfuo5Vel1dAapffmjCAD7Wz7IUqvoVcsVhlCa5gFNw2zc7
	tOBW0lRvr92PV2NOlCMtO6MRR6cTJtnNTGP6Q9gcvgfA0IsLjFsneRQ63bLvWtKJxnhNO3Ppr1cmR
	LOdsbhkMZ9gjCjgF/7FerOwR9HbMfmtljw53vvxc2Zsid5VhsSG0Wvq6dX0TskhRYjxo5LeOPkNvL
	jHKwwSVQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4mV0-0000000Csy9-2jBe;
	Mon, 23 Mar 2026 21:07:47 +0000
Date: Mon, 23 Mar 2026 21:07:46 +0000
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
Subject: Re: [RFC PATCH 10/11] selftests/mm: remove READ_ONLY_THP_FOR_FS test
 in khugepaged
Message-ID: <acGrokwjvIHqDmSP@casper.infradead.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-11-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323190644.1714379-11-ziy@nvidia.com>

On Mon, Mar 23, 2026 at 03:06:43PM -0400, Zi Yan wrote:
> READ_ONLY_THP_FOR_FS is no longer present, remove related test.

Um, surely we want to keep the test?  It's no longer conditional on
READ_ONLY_THP_FOR_FS being enabled, but we still want to collapse
mapped files.
