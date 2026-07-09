Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0181736DA1D
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783615776; cv=none; b=jOkUSYvtzRNiHdFVLs62BBSF9oUimDkZ7pCcYJAw1AaPHk3724/XrFuysqsMDz6/gHXQ8SmoqhwpyhDjQ1nzrMy0R4Qpag7kYMHp/5S4rtiPil7wD4gz8Nm9ZXvSlQdGHVm89JRmxS17x4tdUCmZP85oF9APbhC9dmyk1TiWMmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783615776; c=relaxed/simple;
	bh=7S/vX/l0pu3gI3Ao22QTMyaYVfP4DD7sZ4u+86imtbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCe0FZFjsKIywCRwgwjmclmKtJSferrhD9yjJ2VX3rPnV4O1HIp2w0nvhUlZ5wbza4lHoDfX/0XZrEMVzyE3QER7cu5QG7KtOKkvCeijmQAKTJKqcuCOIIkktH6ZOZzsr0fh9rhWRp+oZN5yoKv9OVdH9PTY5/BxRhQ8EIqBO/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=BCPIFeqW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=drzFV0i0; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="BCPIFeqW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="drzFV0i0"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 295C71400155;
	Thu,  9 Jul 2026 12:49:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Thu, 09 Jul 2026 12:49:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1783615774;
	 x=1783702174; bh=HayqC2aKG9pR41qNAyd0gHgmsUN4zTi3/4Tx6bT8iSs=; b=
	BCPIFeqWauIDkWp8MQkuf+DGJNkdBYRcmGPJkxx778Bd5NHWfVXIS8r7ko6JHcQX
	nmOW6PmuL99UgiXACHSnciuUA9FRC9hxEsPz9XC6i7QmTBjXYTN1zakbTS15Atg/
	GiIQlB5CzEOuDEsUfGY2sj+E19yI//eUAdpvOMCp+DcFy3a0nIbIhJPvWqh+TOrm
	1CwMaJNugfx6mN06Wt6tf3qBZkVPgvu3KTO0xziAz7slSDPJePEuDJ4ueK7TlPcA
	ZpzWTonF2H2ALLXyvadbGhzi4KAfcSyC8Wshd42Wx89ol4qzf8SYyKIS0hnMfmYP
	6IXEsLtTuMjQHmt+CTuAtw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783615774; x=
	1783702174; bh=HayqC2aKG9pR41qNAyd0gHgmsUN4zTi3/4Tx6bT8iSs=; b=d
	rzFV0i0DmEl/oJPsrlaBz7SyYp9MG6SGbJcqDTt51lj26ZkO+5lbfJoLIlVZvgUy
	8D1+Dc2rY4LDkbE8so6kjSwB8mJLv0Aasc2F9A+08hKQOx8o3FwkrSoxVgD5rKLY
	m0Xv77bBaLfTwoEQkQJTyH+Kgsty9LB0yMXbn/+FmnIcEEqAlGwuZuuqMYWloy3Y
	N/tiA8cvaYrjg1wX1th7vj5vAbw4XvMld6cnfHY0GeejrgOqOuD5v7YsD1kc/WAm
	jYYOurKtQ5VB/ecZVU0AciD7S470taIGLik7va01hzw5E1MKVrIEnAaSuRuR3s8E
	+Bc/6u1tpP0g8EvPMCquA==
X-ME-Sender: <xms:HdFPasJXzVJHxDEYX36da8Lu_QX53EMQ5GcClYm1RrmxKw3jYgqpAA>
    <xme:HdFPajJqTUT3ZtopjHJAy4bzvdaIQEj36aQbqwUyT8xUdb0Ii8YWj1tNuuX2MUfFY
    VA_kZsO1Wfu0jIEpUCtF0Oke6Qxya84bNjeh0zZ-_tr36x0wh9NGkM>
X-ME-Received: <xmr:HdFPahsxYVJfR4sxVz6jhlxpudn3eLzc_w4rUDPg22v_wCXQnt9uyR2aMyk_8EECEEQTt7Fm2Kem5EEYXZcqkMkSgVc>
X-ME-Proxy-Cause: dmFkZTGO9KyJ3NG5tUXPx311TZv6US5DCchJNGHdAaDisistYl2BmHhTcl+LIOgbrdxpVS
    Ou5gG8u5OFQw9KgdPoDsAqjAoTlv8lNxMXhsOV70cjDtJFGoVJjAGu3FSB5rmhqr1TKDQS
    ltpJnip7iTy9bLfq7MSeFLPdvByYJR+HEslTZAc27W6HqD2P37241zWcbM86rdkIeBESCP
    1uBcyQJVZ5GCLCmvSMHXvz2D8XldH+VvgnCUf5bsyhz8tBOWFFqZeHFYz4LSIBMgmwViHo
    q3VVVEnAfnc/gtupk0g9mBQ9VSlZFONT3ZHYmhCjbiMX13vdV9nrbEBhiexWp63ffIHCjf
    hu9aZEMpu3z5ZPMMko/pGpUOGEAd0m51qaP3wiiDXooIar4X9i2WkRUJ48w53FDwF/snq7
    uMPT/sav0GEq2vTW+bOqiVAFCQXDlv31q0lyMDRi+00JxlI7/v0GosB/Mz0FreE24iOtnW
    8PDAWrg0Bk7h8+aomhfBduPx+GLTP8BXth46AyMfGg64YMFnyelADEu+OtZ7V+BjaqKrVT
    qVXaCA/3JvX9tW9qSEhup11d4cF9FWyTrOTpgdO0r6sxmyK066HzMo9xKNlAg80gRC0f0c
    lXmGLPZ43fCuz4SN5xbkVlQG/isrK6zMBMkeHt/j5g2Ba9kGg+jkBRBVc82Q
X-ME-Proxy: <xmx:HdFPaoQ4hO3vSF9FlRts8fhQNaRQc1yj44mtKm8qT2TOwjkM3bb5_w>
    <xmx:HdFPavPdAytOk2WGEygDc0IUnNY8lzAYYrGQBJF5n5aJ6QICeV-4Qg>
    <xmx:HdFPalYgqG5pCwU835CML7hGvr_4xKOtThi0Lpn0fMHjTnXVbq1VTw>
    <xmx:HdFPahwc1hUqOHfhsB0cqzycatIpOlIB4EZIAOxWeLlAtIG6B8CacA>
    <xmx:HtFPatDnfcGd3BeeOwxqecIpjJ_-Mr9FM0cWX4GbonkQvN5m_Z6FReqW>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 12:49:33 -0400 (EDT)
Date: Thu, 9 Jul 2026 09:49:47 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, willy@infradead.org
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
Message-ID: <20260709164947.GA1552049@zen.localdomain>
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
 <27264cb6-3172-4cb5-819a-705a3d607cb9@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27264cb6-3172-4cb5-819a-705a3d607cb9@suse.com>

On Thu, Jul 09, 2026 at 03:08:49PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/9 14:01, Boris Burkov 写道:
> > Commit 095be159f3eb ("btrfs: unify folio dirty flag clearing") replaced
> > the folio_clear_dirty_for_io() call in extent_write_cache_pages() with a
> > plain folio_test_dirty() check. Besides clearing the dirty flag,
> > folio_clear_dirty_for_io() also calls folio_mkclean(), which write-protects
> > the shared mmap PTEs mapping the folio.
> > 
> > Without the write-protection, a process with the file mmap'd can modify
> > a sector while it is being used by writeback in a way that expects a
> > stable folio (checksumming, compressing, copying, etc...) which
> > manifests as a handful of concrete bugs.
> > 
> > For large folios or subpage sectorsize, this will result in an invalid
> > checksum and later corruption reports on read (if sectorsize ==
> > folio_size() then we will always be in the case where we call
> > folio_mkclean() when we clear the dirty on the sector, which is the
> > whole folio).
> > 
> > For zoned submissions which are done in batch separate from the main
> > extent_writepage() loop, we also risk csum violations for those
> > submissions.
> > 
> > For inline extents this will subtly risk losing writes that happen
> > after/while we copy the inline extent but before we clear dirty on
> > the folio.
> > 
> > For folios spanning EOF, mmap could tamper with the zeroed bytes past
> > EOF and cause them to be persisted where future faults would impoperly
> > see them instead of zeros.
> > 
> > Finally, for compressed extents, we risk modifying the folios while we
> > work on compressing them which will result in corrupted compressed data.
> > This particular gap was introduced by a second patch in the same series:
> > Commit a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")
> > 
> > We cannot simply restore the call to folio_clear_dirty_for_io() because
> > that also drops the dirty flag off the folio which violates invariants
> > introduced for large folios by
> > commit 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
> > and results in failing to invalidate clean folios past i_size, resulting
> > in deadlocks.
> 
> Just to mention, we can workaround the problem, by extracting the real work
> of btrfs_invalidate_folio() into a helper, with a bool parameter to indicate
> if we're called from the writeback path.
> 
> Then we would have a better chance to rever to folio_clear_dirty_for_io(),
> but there could be other things involved.
> So I'm totally fine with the current hot fix, but eventually we will still
> revert back to folio_clear_dirty_for_io(), to align the code to iomap.
> 
> [...]
> > +#ifdef CONFIG_BTRFS_DEBUG
> > +/*
> > + * Writeback must write-protect a folio when locking it for IO, before
> > + * anything consumes its data (zeroing, inline copy, compression,
> > + * checksumming). If this fails, then an mmap writer would be able to
> > + * modify the data concurrently while we need it to be stable.
> > + */
> > +void btrfs_check_folio_write_protected(struct folio *folio)
> > +{
> > +	if (folio_mkclean(folio)) {
> > +		const struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
> > +
> > +		DEBUG_WARN("writable mmap PTEs, root %llu ino %llu pos %llu order %u",
> > +			   btrfs_root_id(inode->root), btrfs_ino(inode), folio_pos(folio),
> > +			   folio_order(folio));
> > +	}
> > +}
> > +#endif
> > +
> >   static noinline int lock_delalloc_folios(struct inode *inode,
> >   					 struct folio *locked_folio,
> >   					 u64 start, u64 end)
> > @@ -332,6 +352,8 @@ static noinline int lock_delalloc_folios(struct inode *inode,
> >   				folio_unlock(folio);
> >   				goto out;
> >   			}
> > +			/* Locked for writeback; revoke writable mmap PTEs before using the data. */
> > +			folio_mkclean(folio);
> 
> My question is, why we need the call here?
> 
> Isn't folio_mkclean() called during extent_write_cache_pages() when we're
> writing back the folio?
> Calling it here looks a little too early, as the folio may not even go
> through writeback later (e.g. being truncated).

The idea is:
1. call it early when you lock to not call it too late
2. it covers compression and zoned batch write in one unified spot with
   a describable invariant (locked for delalloc <-> cleaned) so its more
   future proof against future refactors or writing models.

This patch says v1 but on my git tree it's more like v6 :). Including
variants where I tried to do it last second at every relevant callsite
(basically where I put the asserts) if you want that instead, it's fine
with me, but I personally liked this the best.

> 
> Otherwise looks good to me.
> 
> Thanks,
> Qu
