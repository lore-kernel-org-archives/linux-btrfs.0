Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F223F34D919;
	Fri, 27 Mar 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774621397; cv=none; b=PRxB21kGbyE0qjHhKPDWqSfZq14h5YrrQYFgGk/bSw54BSMDClkC4UdboiYid8np6NZbjY/HB32IYs04GvxemATbPPad9MLgRO9Y4I33S7YLVg+LnA9Ug1zciCh7tEWSTviF7Nn/uQq1J/rprWK2eHQ20aMHZOULc7PxOZ/e7O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774621397; c=relaxed/simple;
	bh=r7LKDcC5C+R3TFKnw7hncNSlu/84qsRHglhM4Cn1oA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHLskPgQJZWSrk7TuNwqQg66R/eiSdh/bWypRhVSzL6TeGXAAuXsxDkvuLCBwNpwsk6eS/I13Ph0SRBcazN0goq4Eys+8L/X1aIijBE74i562ODMD2MxhmEbAK4zZwYohUn7GUkn+tlSladU0IGseDV/NKOi1Xj9BsRX4SzH2JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGZyDgNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGZyDgNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CFEC19423;
	Fri, 27 Mar 2026 14:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621396;
	bh=r7LKDcC5C+R3TFKnw7hncNSlu/84qsRHglhM4Cn1oA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kGZyDgNiexyUER/ZwAIJM0HynG/fCoHSrze6Ap9k93b+3jZ8G1j1JC0no7VH+tjWO
	 oDS/GWWKDWhCMDASGMyvyhBevKFLFQ8Lwgl3Lnz6NEndz+T/8MpbPkjmgbbEPutIPj
	 Qw8C4IF9MmEn7Knlcz12mJpiJvJYttmR6asGO9QFnCGtxcZoZ0CLgg6lasPMtnItFZ
	 773BHK7KlucGhygy3WB7sUNV7Hgq3+FfUPTDD0l3xBFToHousrSNtBNwNQxCDU5Zk1
	 b7gHujNH5RxA2UswwH5lW7XFqkY82vn8O13zvxIwWaelEqtjGbwswTwWZSHBd2qEPf
	 sfiXeTOCPn5Vg==
Date: Fri, 27 Mar 2026 14:23:09 +0000
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
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Message-ID: <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
 <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>

On Fri, Mar 27, 2026 at 02:58:12PM +0100, David Hildenbrand (Arm) wrote:
> On 3/27/26 13:23, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Mar 26, 2026 at 09:42:48PM -0400, Zi Yan wrote:
> >> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> >> large folio support, so that read-only THPs created in these FSes are not
> >> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> >> THPs only appear in a FS with large folio support and the supported orders
> >> include PMD_ORDRE.
> >
> > Typo: PMD_ORDRE -> PMD_ORDER
> >
> >>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >
> > This looks obviously-correct since this stuff wouldn't have been invoked for
> > large folio file systems before + they already had to handle it separately, and
> > this function is only tied to CONFIG_READ_ONLY_THP_FOR_FS (+ a quick grep
> > suggests you didn't miss anything), so:
>
> There could now be a race between collapsing and the file getting opened
> r/w.
>
> Are we sure that all code can really deal with that?
>
> IOW, "they already had to handle it separately" -- is that true?
> khugepaged would have never collapse in writable files, so I wonder if
> all code paths are prepared for that.

OK I guess I overlooked a part of this code... :) see below.

This is fine and would be a no-op anyway

-       if (f->f_mode & FMODE_WRITE) {
-               /*
-                * Depends on full fence from get_write_access() to synchronize
-                * against collapse_file() regarding i_writecount and nr_thps
-                * updates. Ensures subsequent insertion of THPs into the page
-                * cache will fail.
-                */
-               if (filemap_nr_thps(inode->i_mapping)) {

But this:

-       if (!is_shmem) {
-               filemap_nr_thps_inc(mapping);
-               /*
-                * Paired with the fence in do_dentry_open() -> get_write_access()
-                * to ensure i_writecount is up to date and the update to nr_thps
-                * is visible. Ensures the page cache will be truncated if the
-                * file is opened writable.
-                */
-               smp_mb();

We can drop barrier

-               if (inode_is_open_for_write(mapping->host)) {
-                       result = SCAN_FAIL;

But this is a functional change!

Yup missed this.

-                       filemap_nr_thps_dec(mapping);
-               }
-       }

For below:

-       /*
-        * Undo the updates of filemap_nr_thps_inc for non-SHMEM
-        * file only. This undo is not needed unless failure is
-        * due to SCAN_COPY_MC.
-        */
-       if (!is_shmem && result == SCAN_COPY_MC) {
-               filemap_nr_thps_dec(mapping);
-               /*
-                * Paired with the fence in do_dentry_open() -> get_write_access()
-                * to ensure the update to nr_thps is visible.
-                */
-               smp_mb();
-       }

Here is probably fine to remove if barrier _only_ for nr_thps.

>
> --
> Cheers,
>
> David

Sorry Zi, R-b tag withdrawn... :( I missed that 1 functional change there.

Cheers, Lorenzo
