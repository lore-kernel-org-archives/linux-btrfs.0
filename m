Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46432 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3I3RCw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 13:02:52 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6420B7C0431
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 11:02:52 -0600 (MDT)
Date: Mon, 30 Sep 2013 13:02:49 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix crash of compressed writes
Message-ID: <20130930170249.GO18681@localhost.localdomain>
References: <1380544797-29798-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1380544797-29798-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 30, 2013 at 08:39:57PM +0800, Liu Bo wrote:
> The crash[1] is found by xfstests/generic/208 with "-o compress",
> it's not reproduced everytime, but it does panic.
> 
> The bug is quite interesting, it's actually introduced by a recent commit
> (573aecafca1cf7a974231b759197a1aebcf39c2a,
> Btrfs: actually limit the size of delalloc range).
> 
> Btrfs implements delay allocation, so during writeback, we
> (1) get a page A and lock it
> (2) search the state tree for delalloc bytes and lock all pages within the range
> (3) process the delalloc range, including find disk space and create
>     ordered extent and so on.
> (4) submit the page A.
> 
> It runs well in normal cases, but if we're in a racy case, eg.
> buffered compressed writes and aio-dio writes,
> sometimes we may fail to lock all pages in the 'delalloc' range,
> in which case, we need to fall back to search the state tree again with
> a smaller range limit(max_bytes = PAGE_CACHE_SIZE - offset).
> 
> The mentioned commit has a side effect, that is, in the fallback case,
> we can find delalloc bytes before the index of the page we already have locked,
> so we're in the case of (delalloc_end <= *start) and return with (found > 0).
> 
> This ends with not locking delalloc pages but making ->writepage still
> process them, and the crash happens.
> 
> This fixes it by not enforcing the 'max_bytes' limit in the special fallback
> case.
> 

Great analysis, thank you for that, however I don't like the fix ;).  Instead We
need to change the

if (!found || delalloc_end <= *start)

to always return 0 since we should not call fill delalloc if the delalloc range
doesn't start at our current offset.  Secondly the

max_bytes = PAGE_CACHE_SIZE - offset;

is completely crap since we are talking about the entire page/sector.  We should
simply set max_bytes to sectorszie or PAGE_CACHE_SIZE that way we avoid this
issue.  Thanks,

Josef
