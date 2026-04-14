Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD619146A66;
	Tue, 14 Apr 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188432; cv=none; b=e9yl9o5kw5hc+7Xr0Obww1nNLWnSOYNUpcfTfWTdILTW3d4engdMm6Yagkeai84Zb7FMObWuIZrma/N7CrvxUrTsjyn28dmmM+Zr8hLHUSvqt+WhQSzLlwXv0lteAp6Xs0dHGxYHlvtBnGV5ay+kvce4245o+eVFWUXyu/LYMX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188432; c=relaxed/simple;
	bh=IM7wi6nK1/XqNCbhguwlKyoBUk4OtdSkidHefbNZKzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YClPvPBgbuvyy6J3cg/My026rJ/dp79cLyEwx1dzYxzTum3qu4H+BSBvVY8t17NgHhzqL1XGIJuz1/bNv5+ZV6DdaEVjwK1JWbxDlQg4WHMb+1GUrKrG7lqkVxoL+7rzSLRgw+NgTs3tcnnIb2Ikd7RIWxRBzcUxhyP+f6K3O8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pkBwYtIk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pkBwYtIk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H34Qz4t0dOFSEu57O5bBR0ByBGobQOtvzsKeF/dJkS0=; b=pkBwYtIkbRZIjLyneuTW65xL3+
	eeAj/0ArP5i6IeX/Ddqr97HyFgDMUMMcWqEHKrLByJp2q7cqu90awbUiiTzZZp3rdJ3hXqQRCVqKR
	dkixxZmQtAf3p2l2osR32cyGWHqiNOzxR6VmSYO+/DXvCVVE6f7F8w8+SZ6MY8Vt5KYC/O715zIPo
	SpTK10LNJfcI2FuMEV2tetR8QC9MgCRMgwP2GMMs/Q97jyDLvDrO1jkFzAvENmYFzxSmNXjp/ZJMz
	oq9V1ZY6x/wRTEO+CRbUWXCetmHbtZWyLTL0aYGk6OdTIEXc9/94uDh8nARgFwfpGmMzmHaNO1D/0
	4fXCHStA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wChkB-0000000FzXu-1gMl;
	Tue, 14 Apr 2026 17:40:11 +0000
Date: Tue, 14 Apr 2026 18:40:11 +0100
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
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Message-ID: <ad57-5Nqd5cci8HQ@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
 <ad1WTCR5Kld-tiL8@casper.infradead.org>
 <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
 <ad1uK11f_J8sFN0e@casper.infradead.org>
 <c696705c-4c0a-4e3c-996c-358d2f0b7074@kernel.org>
 <1EBEBA57-E519-4004-899A-CBF21A77ED53@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1EBEBA57-E519-4004-899A-CBF21A77ED53@nvidia.com>

On Tue, Apr 14, 2026 at 12:45:18PM -0400, Zi Yan wrote:
> On 14 Apr 2026, at 7:09, David Hildenbrand (Arm) wrote:
> > On 4/14/26 00:28, Matthew Wilcox wrote:
> >> That sounds like more code that was added for RO_THP and should be
> >> deleted?  See commit e6be37b2e7bd
> >
> > Sounds like something to implement on top of this patch set?
> >
> > But with the added dirty checks in patch #2, maybe it's trivial to do it
> > in this patchset already.
> 
> Can you two elaborate? The code from commit e6be37b2e7bd is moved around
> and replaced by functions like __thp_vma_allowable_orders().

What I was trying to say is that this restriction was added because
of ROTHP.  Since we're getting rid of ROTHP, we can remove this
restriction.  No matter where the code has now migrated to.
