Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB8737AA99
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 19:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783451618; cv=none; b=pvkmPz1oQl+A2kqheqxWyTM0rE8RqPh4IjVzlU1EGshcbTOmMP4f1hpj7gQQVLJI1WBDt6EvKW0EgfYT1MqJx6UtUZJuyYo1/MKnR/6xcEjgo6VDdepsRtQMH9uFl4Rca0IlfsMs+CaC4d53Z+KotIVCRwnWJxiB5rTe8JGJ1Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783451618; c=relaxed/simple;
	bh=Giu0/uBhfuVa38vs2pkl3lJZ5OihL0Vo/1GUWTrwxpg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=bbwOM5wBU2SQiWMzJzCXh1+VpIq5oGWHa+uQ97UBBNcgx30fhS8V5IezCrMQOfmbN3KfZOBxQ7ydMn3wHbZVipsXxJ2VpXtfWblr+chMyJ3r/oMigaqpni+K9t9cR5lsIT1uRQ1LqrwNMSbHJCGTAI0xyCjiDi8aWrj7GyvgfnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=YmLML3z+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jY5vJMiS; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="YmLML3z+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jY5vJMiS"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 361681D0008B;
	Tue,  7 Jul 2026 15:13:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 07 Jul 2026 15:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:reply-to:subject:subject:to:to; s=fm3; t=1783451615; x=
	1783538015; bh=34paa7LWp4wrY6eDFNXUFGM3NLQg9bVMGsgqWmIzkOM=; b=Y
	mLML3z+mWaTx0+G4EeAzXeQc4cpDfTkj9G8fKjzRIhGZvKK+w8jDAeeSxKvr6R6D
	igOCf410CBFMO5um6I7vpS705ZjbLgYiNKqkjkyTa6pEfTfrC4pMnqKHvWgLxB6M
	7OH5jlnm9ormhMtePahAaTUofeqpSXfTlRReI5BV8UBMT/9E0dq0DOKkTlZ/oyGr
	RSjtzPDoQ4bB/jygqeDBUxXgeuJCMsYagkOCBQrGuTDAMXpQr2e4QZwQMAcrTW1Z
	XsU2YuwAsa7oYOwptyAnIOuAZZhhd0gCoGQywLf+KH4/Vg4Fa+VExdo7nVsz4rEL
	2EL+mWTBTnl5NSFo02NsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783451615; x=1783538015; bh=3
	4paa7LWp4wrY6eDFNXUFGM3NLQg9bVMGsgqWmIzkOM=; b=jY5vJMiSExEFydeCz
	2lSep10SN7NEDrulei/0wvGoR763KFDUIpa1Ela8WAkB7YPHwKPJzlWJKF9d0++3
	TprJ98ar4hYau3XqabvG3F+eOAem0f57C5u1TGybZwkBn8Oh0vUEtWd6Gaveidq9
	rgQ7EO0RvnUlXtBZf6Ao7kod+P3UYju6HKVtPPsrOa07JhswPYMySsNShj6XeJHN
	FFnzIsh8pRasChXEX7isC1ghBmEE51splB0h+e0QHCHaiQNdSkr+PseHQcLeMPSI
	HC7oqfAvAHQOwrXhuxPZvPglxKsnZ+/ro8qMkigq59BYDUIWLhwxm2lRmNhcp7GX
	eRQWA==
X-ME-Sender: <xms:3k9Naoo2oirmTgO5EFHid0Id7_bvwTfVebgGPWOhhhpoKeCp2Z-hUQ>
    <xme:3k9NamEsG4kYSYAjEuGZ6phExrsDzvcVPME6-WMcE9yCVRbfhSrBYW695kUUzqvUV
    eUhloka9L43ZIKXPJmkwOqzY1fXc9J7xUOabLRwt17c0r9u9Asn5lrR>
X-ME-Received: <xmr:3k9NaqkTWwawKcIU1gBKhGmsHmyoACZAgbjmnCFiyzkqrkFW3gGRpDNv51ATNAqBOXUchcXkGoZWSzTg5ZE7Tedq9Ko>
X-ME-Proxy-Cause: dmFkZTEdNt9T/maXaPEo3vjUkqeExus3P/4y7hwrlo5uO5ZE+TXdWSDhz47QSPoymZYosv
    MMX1jNMO6HPk+MdAp7kQo3SKPRWOTeoDdl3H3WCWl99SWwgcHdOh4R0G5I/bynQXgiT9HW
    yC9MoBQA3v797S7MUrCCZf/M0K2YOQ0guhFTdTQHsu8niRLsroLHNsJPwt0BYU5sn4MYrD
    bYLOF9k97j4V9Lp3UHBTT1j0pN40AKRwGvhAoZdBzfvCHWYq20ldZTiW06yQcv+L0BNVW+
    M0+OJlhtNtnff97cbAH7N7wfhm0NOl8rFb7gdbXHwno6LddKloBSevLjHSssbEqEyuZne4
    RPDW4aMVYxXMWfOmkSzYj4luRrm1SLI2xWrrDEG/g/VAGuXKpqb40BmusOlXR9wVgCl1M9
    Woke16rii4rb0qZ5irSn75u75Rq9XbveYrJe1NmddYO7EJ5yaO2UttWzFiCa0s3oe5cd5l
    rgQiWzXwSn8kd6HU1GG7x4jQ2i7UPcF5BdWZua/XjWHrud2u5FY0aOSQapwAivktWsIWtS
    tP/UjdQ8zp+CKGoo2rMiGUjNz0XxDp4z2vPAGKCI/RKlxyPUoBlXVMBHtLGOZkcf2+HLiK
    FsoYSchC9r4quL9o7OTi+K8UIqVTJnahEyMTENqdUP0PrNXTzwWZzbWfDAfQ
X-ME-Proxy: <xmx:3k9Napm4Bx_6-oF3VPgLGp5cyzVsyTWmBEnbPlPRJL-21TjX-DnUPw>
    <xmx:3k9NaruKkGu34Vymrvhqnb_8NHaVP3qORZebiKHNGZ2g2MdSs4LeIQ>
    <xmx:3k9NasmUJMIlrOa2x1Pb9rs8CExndZjyTNfYZ7aMOmXAtenqfYppQw>
    <xmx:3k9Namv5Xmzxmc98O5rvLg5z8IMrt8gVwhn0ql3u3umTe3dvRE-rCg>
    <xmx:309NatazL77SeWoQeynHojgj0GaCg5QoZ5orW2kLO4Y9ejWdAnSw6Mri>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jul 2026 15:13:34 -0400 (EDT)
Date: Tue, 7 Jul 2026 12:12:08 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
Message-ID: <20260707191208.GA516053@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5a0dbb8-27f5-4b7d-8923-54373622729d@gmx.com>

On Tue, Jul 07, 2026 at 03:10:20PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/7 13:44, Boris Burkov 写道:
> > On Tue, Jul 07, 2026 at 12:10:25PM +0930, Qu Wenruo wrote:
> > > [BUG]
> > > The following script (already submitted as generic/798) will report
> > > incorrect dirty page numbers, with 64K page size systems and 4K fs block
> > > size:
> > > 
> > >   # mkfs.btrfs -s 4k -f $dev
> > >   # mount $dev $mnt
> > >   # xfs_io -f -c "pwrite 0 64K" -c fsync -c "cachestat 0 64K" $mnt/foobar
> > >   Cached: 1, Dirty: 1, Writeback: 0, Evicted: 0, Recently Evicted: 0
> > > 
> > > Note that the dirtied page number is still 1.
> > > 
> > > [CAUSE]
> > > The cachestat() go through the XArray of the page cache, but
> > > instead of checking each folio's flag, it uses the
> > > PAGECACHE_TAG_DIRTY tag to report dirty pages
> > > 
> > > Since commit 095be159f3eb ("btrfs: unify folio dirty flag clearing"),
> > > btrfs replaced a folio_clear_dirty_for_io() call inside
> > > extent_write_cache_pages() with folio_test_dirty().
> > 
> > This is an interesting coincidence. I have been debugging this exact
> > change from a different, scarier perspective as well. Because we stopped
> > calling folio_clear_dirty_for_io() we stopped calling folio_mkclean()
> > which meant the folio remained writeable via mmap during writeback. We
> > observed a significant uptick of csum errors with large folios, as a
> > result. However, just this fix I think is not sufficient, and has two
> > serious bugs of its own.
> > 
> > First of all, now that your patch does clear dirty here, the keep_write
> > check in btrfs_subpage_start_writeback() is not correct anymore, which will
> > result in clearing TOWRITE on a non-sync writeback and losing it for
> > other pages in the folio on a sync writeback. So if we do clear dirty,
> > we need to also add a check for the subpage dirty bits for keep_write
> > like we did for extent_buffers before moving to the eb xarray.
> > Incidentally since that means not using __folio_start_writeback, it does
> > fix this exact bug too.
> 
> You're right on this changed btrfs_subpage_start_writeback() change.
> 
> But there is a deeper problem, the timing of folio dirty and writeback flags
> change is not synced anyway.
> 
> If we do not clear the folio dirty early, then the timing of folio dirty
> clearing is always on the last dirty block clearing.
> But at that time, we may have already called folio_start_writeback(), thus
> for the last block we do not clear the TOWRITE tag.
> 
> If we do clear the folio dirty early, then it's exactly the problem you're
> describing.
> 
> So I believe we should not rely on btrfs_start/end_writeback() to handle the
> pagecache tags at all.
> 
> > 
> > Second, and worse, it results in a deadlock which should show on btrfs/062
> > and btrfs/070, I believe. The problem is that clearing dirty at this point
> > results in a truncate being allowed to clean pages past the end of the
> > new file size without calling btrfs_mark_ordered_io_finished() so we
> > leak that OE unfinished and get stuck.
> 
> Mind to explain exactly where the missing btrfs_mark_ordered_io_finished()
> is?
> 
> The point here is, we always have the folio locked already, the difference
> is just in the timing where the folio dirty flag is cleared.
> 
> I didn't see a problem that the changed timing can cause problem related to
> btrfs_mark_ordered_io_finished().

Sorry, my explanation last night was rushed and clumsy, let me try to be
much more clear and specific!

The key change is your recent one, that went together with the removal
of folio_clear_dirty_for_io():

334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")

and specifically the lines:

  /*
  * If the range is not dirty, the range has been submitted and
  * since we have waited for the writeback, endio has been
  * executed, thus we must skip the range to avoid double
  * accounting for the ordered extent.
  */
  if (!btrfs_folio_test_dirty(fs_info, folio, cur, range_len))
    goto next;


and quoting from the changelog:

  If the OE range is dirty, it means we have allocated an ordered extent but
  have not yet submitted the range. And that's exactly the case where we need
  to truncate the ordered extent.

But with this new fix, which returns folio_clear_dirty_for_io before
submission, the comment, skip, and changelog argument are no longer
true.

Suppose we dirty folios [F,F+K] at the end of a file and start writeback
on them, creating a single OE for [F, F+K]. extent_writepage will keep
looping through the folios submitting them.

Now suppose a truncate races in and shrinks i_size (taking i_rwsem but
no folio locks or blocking on OEs) via:
btrfs_setsize
  truncate_setsize
    i_size_write // shrinks i_size to M <= F
      truncate_pagecache
        folio_wait_writeback (not yet marked writeback)
        folio_invalidate
          btrfs_invalidate_folio (folio clean, skipped, this is the bug)

extent_writepage hits the code

  if (folio->index > end_index ||
    (folio->index == end_index && !pg_offset)) {
      folio_invalidate(folio, 0, folio_size(folio));
      folio_unlock(folio);
      return 0;
  }

which calls btrfs_folio_invalidate() which needs to mark the OE past
isize finished but skips it because the folio is clean (same issue as in
truncate above)

Now a bunch of processes, including a later call in the truncate itself,
will hang waiting on the OE which never finishes because these latter
folios never get submitted, nor does an invalidate truncate and finish
the lost OE.

Here are some trace printks showing the buggy sequence:
# btrfs_alloc_ordered_extent
91.901347  OE-CREATE      ino=306 oe_off=3637248 num_bytes=73728 isize=4587672
# btrfs_setsize the file, changing memory isize to newsize < oe_off
91.901392  TRUNCATE       ino=306 oldsize=4587672 newsize=2573711
# extent_writepage calls folio_invalidate for being past i_size (905 * 4096 = 3706880 > 2473711)
91.901528  WB-INVALIDATE  ino=306 folio_idx=905 isize=2573711 dirty=0 writeback=0
# btrfs_invalidate_folio does goto next and skips calling btrfs_mark_ordered_extent_truncated()
91.901531  SKIP-OE-FINISH ino=306 oe_off=3637248 bytes_left=73728 isize=2573711 writeback=0

I hope this is enough to figure out which one of us is missing
something! Sorry again for being so unclear earlier.

> > This is caused by the other
> > patches which removed the Ordered bitmap tracking to reduce the bitmap
> > size, I believe, as we now use dirty to track the existence of OEs.
> > 
> > Can you confirm whether btrfs/062 and btrfs/070 finish for you every
> > time under this patch? If not, something about my test setup and yours
> > is different, or something is different on the branch I was working on.
> > I will try to re-test with your patches and my patches on for-next as
> > well.
> 
> I have not yet experienced btrfs/062 nor btrfs/070 hang.
> 

I have reproduced it on two systems with your patch (x86 4k pages for both)
and also while working on my own version which was basically your patch with
a hack to clean up the TOWRITE bit only in btrfs_subpage_set_writeback().

While working on the details of my explanation for this email, I was
adding lots of printks and it did go away in one build, so I guess the
race between truncate and writeback is finicky enough that you are
getting unlucky? I played with some delays but haven't yet found a
perfect place to make it 100% reliable.

> [...]
> > >   			if (folio_test_writeback(folio) ||
> > > -			    !folio_test_dirty(folio)) {
> > > +			    !folio_clear_dirty_for_io(folio)) {
> > 
> > 
> > So far, the best solution I have come up with is to call a raw
> > "folio_mkclean" here, as opposed to folio_clear_dirty_for_io().
> 
> I believe the root cause is that we can not rely on folio_*_writeback()
> calls to do the sub-folio level handling correctly.
> 
> I think the long term solution would be the iomap solution by tracking how
> many write bytes are still pending, and only call folio_end_writeback()
> once.

I was not aware of this design, I'll look into it, thanks for the tip.

> 
> But for now, I think a quicker fix is, to de-couple the
> PAGECACHE_TAG_DIRTY/TOWRITE from folio_*_writeback().
> 
> The idea is, we clear PAGECACHE_TAG_DIRTY when the last subblock dirty flag
> is cleared.
> 
> Then do the same for PAGECACHE_TAG_TOWRITE, this time do not rely on
> __folio_end_writeback(), but manually do it inside
> btrfs_subpage_set_writeback().

I have been testing something hacky like this in
btrfs_subpage_set_writeback(), and I believe it is correct for TOWRITE
but still convincing myself about DIRTY. Just putting code out to be
more concrete. I think it's clearly hacky, but it's something we have
thrown around before so it was easy to start with:

 	keep_write = folio_test_dirty(folio);
 	if (!folio_test_writeback(folio))
 		__folio_start_writeback(folio, keep_write);
+	if (!keep_write) {
+		struct address_space *mapping = folio_mapping(folio);
+		unsigned long xas_flags;
+		XA_STATE(xas, &mapping->i_pages, folio->index);
+
+		xas_lock_irqsave(&xas, xas_flags);
+		xas_load(&xas);
+		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
+		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
+		xas_unlock_irqrestore(&xas, xas_flags);
+	}
 	spin_unlock_irqrestore(&bfs->lock, flags);

> 
> 
> I think this would be much smaller, and completely free us from the special
> handling of folio_*_writeback().

Under your proposal would we still be calling folio_clear_dirty_for_io()
as in this current incomplete fix? You haven't commented yet either way
on your view of the importance of getting to a folio_mkclean() *somehow*
to write protect the folio, so I just wanted to make sure we were synced
on that, as that is what got me debugging this in the first place, not
the messed up PAGECACHE_TAG_DIRTY, which we obviously need to fix as
well!

Thanks,
Boris

> 
> Thanks,
> Qu
> > 
> > a second place it is needed is in extent_range_clear_dirty_for_io()
> > which also used to call folio_clear_dirty_for_io() and needs stable
> > pages during the compression, for which we need to call folio_mkclean().
> > 
> > Sorry to derail your fix with a whole different problem.. But unless I
> > am missing something I think we will have to fix all of it to fix any of
> > it.
> > Either by fixing forward with folio_mkclean() or by reverting and/or
> > rethinking all of the patches in the series:
> > https://lore.kernel.org/linux-btrfs/cover.1778131118.git.wqu@suse.com/
> > 
> > specifically:
> > 095be159f3eb ("btrfs: unify folio dirty flag clearing")
> > and
> > 7d97bdca4bcb ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
> > 
> > Thanks,
> > Boris
> > 
> > >   				folio_unlock(folio);
> > >   				continue;
> > >   			}
> > > -- 
> > > 2.54.0
> > > 
> > 
> 
