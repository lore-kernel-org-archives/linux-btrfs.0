Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA7D4C81
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 23:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783468113; cv=none; b=Zc/rjRRe48E25DYSKcykbiw6fJ545ksBbehrH0WIcQ+k6qcjP9uHCjZVb/L6CkPKm6owXEUJ4mwBX/h7rGH7pAD1qxlLvWv4jQo1bSTOt7BP+wYc5LUnVZVmNhf5N+qahTgcjhyaW//MsTYqKRvdSlbFcDXA19h5HLPLlVaTIZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783468113; c=relaxed/simple;
	bh=hSqzf4eAi85U8Cm+wXT0NqXuCn3y3lD1700LS54HO8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvPYomPGIX951PvlhCIyWowHhIHXMsfpumchO7qYzEYWkICRuX1W5AQzq0Lg71Mi60mMzIgZ/unNmEy+U+oxeIab+ouRKxQnV8RDyJqfrYWss2udWBYju8O7OJFOpLLrSvuPGa6Dg1mC8KjDcW4NHkzhjCGq0XOePxa6NB3Ipoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=LI2WuxuL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dZVpWbhU; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="LI2WuxuL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dZVpWbhU"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 7F6F71D000AC;
	Tue,  7 Jul 2026 19:48:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 07 Jul 2026 19:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1783468110;
	 x=1783554510; bh=mXGEdFISvRH3pz0C0zODiJ4mGT9VVRy3XcVQPSl3z/M=; b=
	LI2WuxuLIDN0kxYRMBbUW6FSedEWUiObbP1f0AVxS7KiHXW7KdGFXImyEt67X73d
	swZk6+L7mmS9+dqWSrbbwykUemtoEdQC+Cj0LnIbPNUwjIeDuWvjzEFO6Xe9KGx7
	sqrqtBAzV1/LAL0f+H1WIc8fi4foj2KdzfPx1H4NvrzS3XiQ5IfcbVm/ZGZrpPlg
	hzySMkteMbIZDuKCA9Y39WTBAHsoSpYBiPC41Nn4rzWH+wjtln324CUpQfaVNNgg
	lvPlaWMfeNsaLZDXOIHc3SCXzNi8ZT82s7m48iIS3eij/Pu082c5o5i+7qN/T6gi
	81qd4RT6SWC2Egu14/0BdQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783468110; x=
	1783554510; bh=mXGEdFISvRH3pz0C0zODiJ4mGT9VVRy3XcVQPSl3z/M=; b=d
	ZVpWbhU3evIjeb4OQ9cD7dYlMATxhyr1HdbiFQs0TX5qmApnXWMi+oLFHNILDdT6
	pTQr/MjUNA13txAbgO/dpSxf8riRIQCEYvoVhJanDxy221hq8idwaKq5nIF3VRLr
	nUNJv6d7xHwl77I7snsh7Pp8CKI2j6A+xXiEmpK8E6S+2HjPHbCOFBu3DWuVhBQI
	BfoUxJPpw439xPlfNbn6BteLsUtUniW4BJKOenMal5Im+w7CAO8vc1ksxPOXt4r+
	cmimT2AwXJMFzBYBpQVH3KghoG5w8KYhYig104vZ7d9LWi7mypWbWU1Rnk8Zv9xW
	N23yBjekd91WWWVeCOU9Q==
X-ME-Sender: <xms:TpBNaiitfayBmTdwj_rhZE0ObPbdm0K8Ac4uIoqRNRmJAqM2yaihoA>
    <xme:TpBNamSycuCrqKZhIChloJKeRql3qNbF6026RfhiuDpTARmpLwb_8OYWbuGJxgrs4
    ywU-k-sYroZj5ys8h9Kq0ykC_caMwZr8AdB19L-NTzA3ZjDyUx6DRw>
X-ME-Received: <xmr:TpBNajhQFrKIhQ6smG-vfYeZo3lidkOzpVVQnB16JcZbBkGotoSV_i0JGAU6xM9dNZzSeXQ21bwwgUAs-1R_x3ytBIQ>
X-ME-Proxy-Cause: dmFkZTF2ZEWfGCHRUaFtlys0DFl1bSS1fM+8pb7Ri7sIam14w67yz+RxkPHpwZu7WslBP4
    uEFPiQEb0sOMHvGYYWpjKirMdk78aOqKJJESwxKZtyq2lUg5JcGdxRqF4dAE+YtM0GgkL5
    8sbo5MagZYSSuClsP3JWHE2Rz4dUZ6C622BVleX57rOb/dVLBJYuQSlrp9quIlMMjBVdO4
    oH1bH6PmeJ5SrWdcr25nhY7cPUcE3y+ZAkDayv4ytvwajTc1YBk/Ae34r4A6o3EQuQab7Z
    im7U/LB3XMvv4lIMFLdyfuOovipL+qAYSjox+2tc3+pAqtTG4J/rncmC1HnFaUMDcqsZmR
    X6SKxIa04OVaK/Avpz1XjTvj4P0LODRJxpkd2zmlxUMKUcCbTtDG5+aA6rurAmtZiK7Qg6
    M3JDvYMNL069qW141ZQYVitM3wsFH8l/u6fFha3w2IJci1Aip30VaQptNrbbLZiaKnpc54
    51g68oLNnjGN2tDHLbbr4+PRQvCpYqTDel526a32b1JQ1zOS/t26dCv7yAVAuJK+d3hg7G
    PESh9ZXB/iahoGelmkwqQ2043TxrNDOtd496yHnwzP691sS4B6c2TYqSJGGJkkQU+7Wmuv
    EVhqhbN7tP7PtrUm4aMwD9zcPQO2kSVMN6QJhyCfy0kJStDT0k8RF72UzrhQ
X-ME-Proxy: <xmx:TpBNam7zk81HBGxVwdECf5jEKM6oPpTWL9ZVUOS5N96N4b9gcwA4jw>
    <xmx:TpBNagD7rEyLQ0rWjg68VH8zJwWqlkVfBabxXH_Qtmyj_PiM4S52NA>
    <xmx:TpBNatbo--DAcsBxMusSMl9enJgOso2ilnltqQkOH2o8wMJlvs1VCA>
    <xmx:TpBNarYn6bpW8WajcGUH-hL0kuZWTNAKhz7ZtzI3ioZNvaHdayEC-A>
    <xmx:TpBNajlC8VvfOlHHRb2VO7ssrAaB2QTs0U25omVciMX89YeBYQSJGK8G>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jul 2026 19:48:29 -0400 (EDT)
Date: Tue, 7 Jul 2026 16:48:46 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
Message-ID: <20260707234846.GB83688@zen.localdomain>
References: <20260707191208.GA516053@zen.localdomain>
 <58a76be5-12b2-469e-a9a0-146bfeb55773@gmx.com>
 <20260707231632.GA690447@zen.localdomain>
 <9a5f8318-fb44-4f0c-b8b0-5f8af1fbbfa3@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a5f8318-fb44-4f0c-b8b0-5f8af1fbbfa3@suse.com>

On Wed, Jul 08, 2026 at 09:00:39AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/8 08:46, Boris Burkov 写道:
> > On Wed, Jul 08, 2026 at 08:06:26AM +0930, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/7/8 04:42, Boris Burkov 写道:
> > > > On Tue, Jul 07, 2026 at 03:10:20PM +0930, Qu Wenruo wrote:
> > > [...]
> > > > > 
> > > > > > 
> > > > > > Second, and worse, it results in a deadlock which should show on btrfs/062
> > > > > > and btrfs/070, I believe. The problem is that clearing dirty at this point
> > > > > > results in a truncate being allowed to clean pages past the end of the
> > > > > > new file size without calling btrfs_mark_ordered_io_finished() so we
> > > > > > leak that OE unfinished and get stuck.
> > > > > 
> > > > > Mind to explain exactly where the missing btrfs_mark_ordered_io_finished()
> > > > > is?
> > > > > 
> > > > > The point here is, we always have the folio locked already, the difference
> > > > > is just in the timing where the folio dirty flag is cleared.
> > > > > 
> > > > > I didn't see a problem that the changed timing can cause problem related to
> > > > > btrfs_mark_ordered_io_finished().
> > > > 
> > > > Sorry, my explanation last night was rushed and clumsy, let me try to be
> > > > much more clear and specific!
> > > > 
> > > > The key change is your recent one, that went together with the removal
> > > > of folio_clear_dirty_for_io():
> > > > 
> > > > 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
> > > > 
> > > > and specifically the lines:
> > > > 
> > > >     /*
> > > >     * If the range is not dirty, the range has been submitted and
> > > >     * since we have waited for the writeback, endio has been
> > > >     * executed, thus we must skip the range to avoid double
> > > >     * accounting for the ordered extent.
> > > >     */
> > > >     if (!btrfs_folio_test_dirty(fs_info, folio, cur, range_len))
> > > >       goto next;
> > > > 
> > > > 
> > > > and quoting from the changelog:
> > > > 
> > > >     If the OE range is dirty, it means we have allocated an ordered extent but
> > > >     have not yet submitted the range. And that's exactly the case where we need
> > > >     to truncate the ordered extent.
> > > > 
> > > > But with this new fix, which returns folio_clear_dirty_for_io before
> > > > submission, the comment, skip, and changelog argument are no longer
> > > > true.
> > > > 
> > > > Suppose we dirty folios [F,F+K] at the end of a file and start writeback
> > > > on them, creating a single OE for [F, F+K]. extent_writepage will keep
> > > > looping through the folios submitting them.
> > > > 
> > > > Now suppose a truncate races in and shrinks i_size (taking i_rwsem but
> > > > no folio locks or blocking on OEs) via:
> > > > btrfs_setsize
> > > >     truncate_setsize
> > > >       i_size_write // shrinks i_size to M <= F
> > > >         truncate_pagecache
> > > >           folio_wait_writeback (not yet marked writeback)
> > > >           folio_invalidate
> > > >             btrfs_invalidate_folio (folio clean, skipped, this is the bug)
> > > 
> > > Just a small nitpick, the problem is not from the truncate_setsize() call
> > > site, as truncate_pagecache() is grabbing the folio with FGP_LOCK, so it can
> > > not grab the folio locked by writeback.
> > > 
> > 
> > Good point, but I think the issue is as soon as you do i_size_write(),
> > so the rest is just my explanation being a little misleading, I think.
> > 
> > > > 
> > > > extent_writepage hits the code
> > > > 
> > > >     if (folio->index > end_index ||
> > > >       (folio->index == end_index && !pg_offset)) {
> > > >         folio_invalidate(folio, 0, folio_size(folio));
> > > >         folio_unlock(folio);
> > > >         return 0;
> > > >     }
> > > > 
> > > > which calls btrfs_folio_invalidate() which needs to mark the OE past
> > > > isize finished but skips it because the folio is clean (same issue as in
> > > > truncate above)
> > > 
> > > Thanks a lot! Now I understand how things are going wrong now.
> > > 
> > > But I still have a question, I thought we should have some kind of inode
> > > lock or something else to prevent i_size_read() from getting stale results.
> > > 
> > > And digging deeper, for the btrfs_setsize(), the inode is already locked.
> > > E.g. inside notify_change() there is a WARN_ON_ONCE() if the inode is not
> > > locked.
> > > 
> > > Would the root cause of the problem is that we did not lock the inode for
> > > writeback?
> > 
> > yes, I think this path to the hang definitely requires the fact that
> > writeback does not hold i_rwsem while reading i_size.
> > 
> > > 
> > > And if we do not have proper inode lock for writeback, then I think write
> > > back should never bother the isize check, and always do the writeback no
> > > matter isize.
> > > 
> > 
> > Don't we risk weird truncate vs writeback races where they undo each
> > other, then?
> 
> Writeback still has the folio locked, so truncation should wait for the
> writeback first then invalidate it.
> 
> The other direction would also be true, if the invalidation invalidated the
> page first, then writeback should not got a dirty folio anymore.
> 
> But I can be totally wrong considering how complex things are.
> 
> I can explore if this idea won't break the existing runs first.
> > > 
> > > Mind to explain why folio_mkclean() is required? Is it for the same OE hang
> > > or something else?
> > > 
> > 
> > No it's a csum corruption with mmap being allowed to write to folios
> > that are under writeback (and thus computing csums)
> > 
> > Since we got rid of folio_clear_dirty_for_io() (and thus
> > folio_mkclean()), then if we mmap a large folio, then start writeback on
> > it, we never write protect the folios while they are under writeback so
> > the mmap user can trigger write faults and mess up the csums. We have
> > observed this in practice in our early testing of btrfs large folios in
> > production and we also have a racy reproducer that enables large folios,
> > mmaps a file and has a bunch of threads racing between touching each
> > sector with some new random data and fsyncing the file. We do that a bunch
> > of times, then drop caches and read everything. Do that whole thing in a
> > loop a few times and eventually you hit it. I can share the exact LLM
> > reproducer slop code if you would like, but that is the rough shape, to
> > explain the point.
> > 
> > I can send my holistic fix proposal with your v2 included in a series?
> 
> Sounds great. Feel free to include the v2 fix:
> https://lore.kernel.org/linux-btrfs/d47af8cae38e32462d61cb62139c2732e4e8fdbe.1783407237.git.wqu@suse.com/T/
> 
> Although considering this is already breaking cachestat() and will cause
> extra overhead for writeback, I'd prefer the v2 as a hot fix first.

I gave your v2 my r-b, and will send the patch to fix the corruption
next, separately. It shouldn't affect your patch, as it only conflicted
if we went back to folio_clear_dirty_for_io().

> 
> Thanks,
> Qu
> 
> 
> > 
> > > Thanks,
> > > Qu
> > > 
> > > > 
> > > > Thanks,
> > > > Boris
> > > > 
> > > > > 
> > > > > Thanks,
> > > > > Qu
> > > > > 
> 
