Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1FB7083C
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 03:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=174.142.148.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786245443; cv=none; b=YYseAwL7nLwGsUOgojhRXr3gceTRumnsW/oovBieHrndT2atLXOD5y2g1iEfYPjKYzOTee804lLTh2SKJPClzRw5KvVFYx2mAvqDobGqslB1QF/qSwbX6497+w77qvjQ3UBJ0a0zAUYYke3FAWi9HhNyR17f2cqKGLgAaYXvXks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786245443; c=relaxed/simple;
	bh=szXPfEKH5BBA8R7a+37AtkNPToITiLpMX1HaSCojRxU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=VZEEjmKdrvdtjg3NKv7XSHEPrxKRmIyBuqG/2nJa7+ns0fEqSUeY2r0eOwp9+GBJ84lYEafd0wUOJ6ughVqm/A+8RAvqajFvlQdO3mrH8fY6Gf8M3ovYaNTw2nWmUIg11KVpKQ/oGcbSriDvoNnUuo4JcxosexMgXp5nkcDMfkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org; spf=pass smtp.mailfrom=drax.hungrycats.org; arc=none smtp.client-ip=174.142.148.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id D6E501B1CF1F; Sat, 08 Aug 2026 23:17:20 -0400 (EDT)
Date: Sat, 8 Aug 2026 23:17:20 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Martin Leitner-Ankerl <martin.ankerl@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [ANNOUNCE] oans: duperemove fork; FIDEDUPERANGE cost under
 memory pressure
Message-ID: <anfwWZH1TrBoFzQ4@hungrycats.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFOosY-roFVTBfviuFoL=1ahOKOerWbEidZW5Z66u2+XP5ZJg@mail.gmail.com>

On Fri, Aug 07, 2026 at 02:59:44PM +0200, Martin Leitner-Ankerl wrote:
> Hi,
> 
> I've been running offline dedup on a large btrfs tree on a schedule, and
> while profiling duperemove there I found something I didn't expect: once
> the working set exceeds RAM, hashing is no longer the bottleneck. The
> dedupe phase is, and by a wide margin.
> 
> FIDEDUPERANGE byte-compares every candidate range before sharing it, so
> the data is read twice: once by userspace to hash it, once by the kernel
> to verify it. When the tree fits in the page cache the second read is
> free. When it doesn't, the compare falls back to cold reads and ends up
> dominating the run.
> 
> Measured on two non-reflinked copies of a Linux kernel tree (189546
> files, ~10.5 GiB), deduped inside a hard 4 GiB cgroup limit so eviction
> actually happens, 10 interleaved rounds, median wall time:
> 
>   hash + dedupe   13.8 s     vs   179.7 s
>   peak RSS         121 MiB   vs    243 MiB
> 
> The second column is duperemove v0.15.2, the first is my fork. Both read
> the same 16.7 GiB, and "btrfs filesystem du -s" reports an identical
> on-disk layout afterwards, so the work is the same and only the read
> pattern differs.
> 
> What the fork does is read each dedupe round's source and destination
> ranges (at most 32 MiB each) sequentially in userspace immediately
> before issuing the ioctl, so the kernel's compare hits warm page cache.
> It also stops calling POSIX_FADV_DONTNEED on data it just hashed when a
> dedupe is going to follow.
> 
> My hypothesis for why this helps at all, given the kernel would read the
> same pages anyway, is that one sequential userspace read of a 32 MiB
> range is much friendlier to the device than the compare loop faulting
> pages in as it walks two files in lockstep. I have not verified that
> against the kernel side, and I would welcome a correction if the real
> mechanism is something else.

Before the 5.x kernels, when btrfs had its own private dedupe ioctl,
btrfs would read pages 16 MiB at a time before comparing them.  The two
loops are "for each 16 MiB of pages, fetch all pages," then "now that
all the pages are in memory, for each page, compare the page contents."

When this was replaced with the generic VFS dedupe implementation in
v5.0, this 16 MiB batching was lost.  The loop is now "for each page,
fetch page, compare."

bees does a userspace read of the dedupe src and dst extents just before
issuing the dedupe ioctl in order to work around this.  It's a significant
speedup for modern kernels, but it would be nice if the kernel simply
did this in the ioctl itself.

madvise/readahead/fadvise in theory avoids the extra data copy to
userspace, but it doesn't help in practice because they all go to the same
kernel function which issues the IOs at idle priority--which means that
if you have multiple worker threads, the kernel never actually executes
the readahead before some thread calls the dedupe ioctl (running in a
thread with non-idle ioprio), then the ioctl preempts the readahead and
demand-reads the pages.  So the prefetch has to be done by an actual
pread(), not readahead().

> Two questions I would genuinely like input on:
> 
> 1. Is the cold read path in the in-kernel compare something that could
>    reasonably be improved in btrfs, e.g. with readahead over the two
>    ranges before comparing? Doing it in userspace works but feels like
>    the wrong layer.
> 
> 2. Are there workloads where prefetching like this would hurt, for
>    instance on a system already under memory pressure from something
>    else, where pulling 64 MiB into the page cache per round evicts
>    something more useful?

That happens either way.  The dedupe ioctl doesn't allocate a buffer
for reading the pages--it reads all the pages into the page cache,
compares them while they are there, and leaves them in the cache.

If you're concerned about polluting the page cache, you can use madvise
DONTNEED to evict them; however, this evicts pages that might be in
use by other processes, which can be a different kind of problem for
some workloads.  It only works for dedupers that follow the two-phase
plan-execute model (as duperemove does); otherwise, they evict pages
that may then be immediately required to complete future dedupes.

> The fork is at https://github.com/martinus/oans (GPL, same as
> duperemove). It carries the benchmark methodology, the raw rounds and a
> script to reproduce the numbers above. Full credit to Mark Fasheh and
> the duperemove contributors; it is still their engine underneath, and
> the fixes I found along the way have been sent upstream as PRs.
> 
> For completeness: much of the fork was written with AI assistance
> reviewed and benchmarked on real data before landing. Dedup
> still goes through FIDEDUPERANGE, so a userspace bug there can waste
> work or miss a dedup but cannot make the kernel share data that is not
> identical.
> 
> Thanks,
> Martin
> 

