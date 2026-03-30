Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0283B6C19;
	Mon, 30 Mar 2026 11:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774869486; cv=none; b=RsxySQXJj+MzshpVBnBN/iNRWFJcMCLjz4F7331gmJeFaP8nc7KOt0bx327NwSF/P7QLwFZY7ZMrHPTim2mXz1rMfNPWps92gdjGkh+wvKhw1s0UzaoZ2ztsc99qN9pDms1D3nFvDt5IhKW97v+5mwMap68QLHxsbwxf+qSgyCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774869486; c=relaxed/simple;
	bh=bcehu9930zv7akkD3oS1tlm215YYcd6YLKnqN2zQwhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2gWZlfSyimb0n7ZspbyG8NGsA98j8EI4rRM+QjMWMQF0ho9tpOGcB2RM5uO2tXkfl5rp+H59AiiS51Jd0PvbaUKxjdFs0/BUaiLL2QHCqrhUHpwRWXQjw+560mEQacpIBTi3yZrgviV5DXDwFCKCEBFQ8xTrvKvucBi36lgmqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlm89U4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlm89U4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC25FC4CEF7;
	Mon, 30 Mar 2026 11:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774869486;
	bh=bcehu9930zv7akkD3oS1tlm215YYcd6YLKnqN2zQwhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dlm89U4FcOq9CCM3y3iJOU23PncWWcU9P3CA6Ls3Wwm8CcxQHAJKAp+okUduyKLTR
	 awCb/XkUaxKoK4q2Tiprz2PZb7dpp334Ovi1SG22va6xcetBu31JZeroLegZ7tui4p
	 gbhMv5TGGdtdnKNUaHzAlcxeNnAqjIKXkN2kmti0b6faHVyvBw2Z4ZWiQFcjE+EGnf
	 bvd57kjV8JEh0GLzZgunjm9vDT7oq186s3TFMkyoaJ6p4uVuWH9NOo+tvD706lgp4G
	 zCe4eIj8ama1T1KI/JbQLy+nh4sTzc3H2mNgW9mL/LS5GVGlJXP78qIGk/fT4C/5zx
	 UzI2PcGDSQPmg==
Date: Mon, 30 Mar 2026 12:17:57 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: WANG Rui <r@hev.cc>
Cc: ziy@nvidia.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org, clm@fb.com, 
	david@kernel.org, dev.jain@arm.com, dsterba@suse.com, jack@suse.cz, 
	lance.yang@linux.dev, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, songliubraving@fb.com, surenb@google.com, vbabka@kernel.org, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <32679321-b2d3-44d7-be2e-f7a6a166a510@lucifer.local>
References: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
 <20260329040742.17269-1-r@hev.cc>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260329040742.17269-1-r@hev.cc>

On Sun, Mar 29, 2026 at 12:07:41PM +0800, WANG Rui wrote:
> Hi Zi,
>
> >> Now without READ_ONLY_THP_FOR_FS you're going to:
> >>
> >>                        |    PF     | MADV_COLLAPSE | khugepaged |
> >> 		       |-----------|---------------|------------|
> >>  large folio fs        |     ✓     |       x       |      x     |
> >>  large folio + r/o     |     ✓     |       ✓       |      ✓     |
> >>
> >> And intentionally leaving behind the 'not large folio fs, r/o' case because
> >> those file systems need to implement large folio support.
> >>
> >> I guess we'll regress those users but we don't care?
> >
> > Yes. This also motivates FSes without large folio support to add large folio
> > support instead of relying on READ_ONLY_THP_FOR_FS hack.
>
> Interesting, thanks for making this feature unconditional.
>
> From my experiments, this is going to be a performance regression.
>
> Before this patch, even when the filesystem (e.g. btrfs without experimental)
> didn't support large folios, READ_ONLY_THP_FOR_FS still allowed read-only
> file-backed code segments to be collapsed into huge page mappings via khugepaged.
>
> After this patch, FilePmdMapped will always be 0 unless the filesystem supports
> large folios up to PMD order, and it doesn't look like that support will arrive
> anytime soon [1].

I think Matthew was being a little sarcastic there ;) but I suppose it's
hinting at the fact they need to get a move on.

>
> Is there a reason we can't keep this hack while continuing to push filesystems
> toward proper large folio support?

IMO - It's time for us to stop allowing filesystems to fail to implement what
mm requires of them, while still providing a hack to improve performance.

Really this hack shouldn't have been there in the first place, but it was a
'putting on notice' that filesystems need to support large folios, which
has been made amply clear to them for some time.

So yes there will be regressions for filesystems which _still_ do not
implement this, I'd suggest you focus on trying to convince them to do so
(or send patches :)

>
> I'm currently working on making the ELF loader more THP-friendly by adjusting
> the virtual address alignment of read-only code segments [2]. The data shows a
> noticeable drop in iTLB misses, especially for programs whose text size is just
> slightly larger than PMD_SIZE. That size profile is actually quite common for
> real-world binaries when using 2M huge pages. This optimization relies on
> READ_ONLY_THP_FOR_FS. If the availability of huge page mappings for code segments
> ends up depending on filesystem support, it will be much harder to take advantage
> of this in practice. [3]

Yeah, again IMO - sorry, but tough.

This is something filesystems need to implement, if they fail to do so,
that's on them.

>
> [1] https://lore.kernel.org/linux-fsdevel/ab2IIwKzmK9qwIlZ@casper.infradead.org/
> [2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc/
> [3] https://lore.kernel.org/linux-fsdevel/20260320160519.80962-1-r@hev.cc/
>
> Thanks,
> Rui

Cheers, Lorenzo
