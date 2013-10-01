Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33503 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3JAMic (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 08:38:32 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 770249A069F
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Oct 2013 06:38:32 -0600 (MDT)
Date: Tue, 1 Oct 2013 08:38:30 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix crash of compressed writes
Message-ID: <20131001123830.GE27490@localhost.localdomain>
References: <1380544797-29798-1-git-send-email-bo.li.liu@oracle.com>
 <20130930170249.GO18681@localhost.localdomain>
 <20131001033721.GA32575@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131001033721.GA32575@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 01, 2013 at 11:37:22AM +0800, Liu Bo wrote:
> On Mon, Sep 30, 2013 at 01:02:49PM -0400, Josef Bacik wrote:
> > On Mon, Sep 30, 2013 at 08:39:57PM +0800, Liu Bo wrote:
> > > The crash[1] is found by xfstests/generic/208 with "-o compress",
> > > it's not reproduced everytime, but it does panic.
> > > 
> > > The bug is quite interesting, it's actually introduced by a recent commit
> > > (573aecafca1cf7a974231b759197a1aebcf39c2a,
> > > Btrfs: actually limit the size of delalloc range).
> > > 
> > > Btrfs implements delay allocation, so during writeback, we
> > > (1) get a page A and lock it
> > > (2) search the state tree for delalloc bytes and lock all pages within the range
> > > (3) process the delalloc range, including find disk space and create
> > >     ordered extent and so on.
> > > (4) submit the page A.
> > > 
> > > It runs well in normal cases, but if we're in a racy case, eg.
> > > buffered compressed writes and aio-dio writes,
> > > sometimes we may fail to lock all pages in the 'delalloc' range,
> > > in which case, we need to fall back to search the state tree again with
> > > a smaller range limit(max_bytes = PAGE_CACHE_SIZE - offset).
> > > 
> > > The mentioned commit has a side effect, that is, in the fallback case,
> > > we can find delalloc bytes before the index of the page we already have locked,
> > > so we're in the case of (delalloc_end <= *start) and return with (found > 0).
> > > 
> > > This ends with not locking delalloc pages but making ->writepage still
> > > process them, and the crash happens.
> > > 
> > > This fixes it by not enforcing the 'max_bytes' limit in the special fallback
> > > case.
> > > 
> > 
> > Great analysis, thank you for that, however I don't like the fix ;).  Instead We
> > need to change the
> > 
> > if (!found || delalloc_end <= *start)
> > 
> > to always return 0 since we should not call fill delalloc if the delalloc range
> > doesn't start at our current offset.  Secondly the
> 
> Setting 'found = 0' is also the first idea into my mind :), but I'm not sure if
> it's right.
> 
> I've check it out, commit 70b99e6959a4c28ae1b314985eca731f3db72f1d
> (Btrfs: Compression corner fixes,
> Signed-off-by: Chris Mason <chris.mason@oracle.com>)
> introduced the (delalloc_end <= *start).
> 
> The commit log says, 
> "Make sure we lock pages in the correct order during delalloc.  The
>  search into the state tree for delalloc bytes can return bytes
>  before the page we already have locked."
> 
> But I think if we find bytes before the page we locked, then we
> should get (found = 0).
> 
> So I don't know why we need the check (delalloc_end <= *start),
> maybe some corner cases need that? Chris can explain a bit?
> 

No we needed his other addition below which is important, for when the delalloc
range starts before but still encompasses our page.  The other part is not
needed, we should be returning 0 if delalloc_end lands before or on our start,
which should fix your bug and make it a bit more sane.

> > 
> > max_bytes = PAGE_CACHE_SIZE - offset;
> > 
> > is completely crap since we are talking about the entire page/sector.  We should
> > simply set max_bytes to sectorszie or PAGE_CACHE_SIZE that way we avoid this
> > issue.  Thanks,
> 
> This might be due to historical reasons, but for now, it doesn't cause
> problems as the passed @start is page aligned and @offset is always 0.
> 

Yeah you are right, still I'd kill it anyway since it doesn't make sense.
Thanks,

Josef
