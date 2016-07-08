Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25587 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbcGHVX3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 17:23:29 -0400
Date: Fri, 8 Jul 2016 14:23:18 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix eb memory leak due to readpage failure
Message-ID: <20160708212318.GA26260@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1464980918-8365-1-git-send-email-bo.li.liu@oracle.com>
 <20160708160149.GP13336@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160708160149.GP13336@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 08, 2016 at 06:01:49PM +0200, David Sterba wrote:
> On Fri, Jun 03, 2016 at 12:08:38PM -0700, Liu Bo wrote:
> > eb->io_pages is set in read_extent_buffer_pages().
> > 
> > In case of readpage failure, for pages that have been added to bio,
> > it calls bio_endio and later readpage_io_failed_hook() does the work.
> > 
> > When this eb's page (couldn't be the 1st page) fails to add itself to bio
> > due to failure in merge_bio(), it cannot decrease eb->io_pages via bio_endio,
> >  and ends up with a memory leak eventually.
> > 
> > This lets __do_readpage propagate errors to callers and adds the
> >  'atomic_dec(&eb->io_pages)'.
> 
> I'm not sure, but could we lose some error values from __do_readpage?
> Ie. return 0 even if there was an error in a page that's in the middle
> (not the first, not the last).
> 
> The loop in __do_readpage iterates while (cur <= end), and ret is only
> set by submit_extent_page, but the loop does not exit immediatelly. So
> we can detect error, set page error state bit, but next loop will
> overwrite ret with 0 (if the page submission was ok).
> 
> Then we still don't decrement the io_pages as needed.

Right, it still has that problem, then the possible way I can see is to break
the while (cur <= end) loop when we fail on submit_extent_page() and
pass an error up to its caller and we can do the rest eb->io_pages cleanup work in
read_extent_buffer_pages(), just like how we did in write_one_eb()
(this was already suggested by Josef, but seems I was off the right track).

This also assumes that if one page fails on submit_extent_page(), it's
likely for the rest pages to fail as well.

What do you think?

Thanks,

-liubo
