Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10CB3F23BA;
	Fri, 27 Mar 2026 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774621670; cv=none; b=V8HIUhhcAQJV6a6lnhl7ZZRRx8XqKgMs5Vx8VUiNXTvuBOc7wypfoE7Hw2JnRghthHh0M7Y2Oa9q19XJ2j20S/C5U3df0kEs88dcg4IzGxV6fAU+W+jWIpFbLHvoLJUl4L5OB8DavcHGcPA3AlZWLEwBGBAmhQTfhR17E2D4esA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774621670; c=relaxed/simple;
	bh=uMjc7wPnY72/FTyi9HtqnZvAKSirFVCXJFk12jkfT0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YoqP5umL+S1W9ze2vAdj+kw3PElcrR1hBLvWtKm+16Oexk+u/PL3c9uBLahRpaTTXN0uQejlBJ5AXdZTgV9hJXfoXz0pOVP6OtodH58Ds0YBCa5Om95pK4H2ms+MC9o1LILVuniES2Bl1Wr9KwBXCnWvL/P9goG+bEXIHeTlrz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYXIObf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYXIObf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85B4C19423;
	Fri, 27 Mar 2026 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621670;
	bh=uMjc7wPnY72/FTyi9HtqnZvAKSirFVCXJFk12jkfT0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sYXIObf7u8E4inwhzei0ZhB54zhLmqaQJW2Mgn82vk3W8OqKFIGgrWF/voGXxD701
	 iLe5EZtBwbCZ8dVYYHyH4eFg4i9J/28LoZXCw/5KhY8bkJz58uhDxgwrkmyDkvZFYP
	 4PlSOYXOB8vPpr4ZlXBWvmAy7PaEuAJo4hTnqvf7eBb2OcuiOV/594dQ81X6wEpRS4
	 pK4VFeuspmdvPdzQ8hUm7gHqRECSdl8K9R4XF6aa0JK/mPF7vpaiN6bRBkOoSW8fKO
	 8rPObuyN+KIaXZ963D5Vd64yLKJLRPByatVodri9aSPYQbIVQskYwegWRWGjyXEbfg
	 Gl3WCR+Vg9QaA==
Date: Fri, 27 Mar 2026 14:27:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
Message-ID: <4007802e-f87c-41a4-8dcd-9af867eb3fac@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <10748785-08a9-41c7-bacd-88f05fdf1a88@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10748785-08a9-41c7-bacd-88f05fdf1a88@kernel.org>

On Fri, Mar 27, 2026 at 02:46:43PM +0100, David Hildenbrand (Arm) wrote:
> On 3/27/26 02:42, Zi Yan wrote:
> > Hi all,
> >
> > This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> > read-only THPs for FSes with large folio support (the supported orders
> > need to include PMD_ORDER) by default.
> >
> > The changes are:
> > 1. collapse_file() from mm/khugepaged.c, instead of checking
> >    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
> >    of struct address_space of the file is at least PMD_ORDER.
> > 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
> > 3. truncate_inode_partial_folio() calls folio_split() directly instead
> >    of the removed try_folio_split_to_order(), since large folios can
> >    only show up on a FS with large folio support.
> > 4. nr_thps is removed from struct address_space, since it is no longer
> >    needed to drop all read-only THPs from a FS without large folio
> >    support when the fd becomes writable. Its related filemap_nr_thps*()
> >    are removed too.
> > 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
> > 6. Updated comments in various places.
> >
> > Changelog
> > ===
> > From RFC[1]:
> > 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
> >    on by default for all FSes with large folio support and the supported
> >    orders includes PMD_ORDER.
> >
> > Suggestions and comments are welcome.
>
> Hi! :)
>
> The patch set might be better structured by
>
> 1) Teaching code paths to not only respect READ_ONLY_THP_FOR_FS but also
> filesystems with large folios. At that point, READ_ONLY_THP_FOR_FS would
> have no effect.

And also please do some cleaning up of the mess we have in the code base if at
all possible :) I feel like we're constantly building on sand with this, and
should treat every major change as a chance to do this.

Or otherwise we constantly keep leaving this mess around to deal with...

>
> 2) Removing READ_ONLY_THP_FOR_FS along with all the old cruft that is no
> longer required
>
> MADV_COLLAPSE will keep working the whole time.

Obviously everything should keep working throughout any version of this series.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo
