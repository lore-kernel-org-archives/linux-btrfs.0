Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbcGLR3x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 13:29:53 -0400
Date: Tue, 12 Jul 2016 19:30:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3] Btrfs: fix eb memory leak due to readpage failure
Message-ID: <20160712173002.GI10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464980918-8365-1-git-send-email-bo.li.liu@oracle.com>
 <1468258747-19617-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468258747-19617-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 10:39:07AM -0700, Liu Bo wrote:
> eb->io_pages is set in read_extent_buffer_pages().
> 
> In case of readpage failure, for pages that have been added to bio,
> it calls bio_endio and later readpage_io_failed_hook() does the work.
> 
> When this eb's page (couldn't be the 1st page) fails to add itself to bio
> due to failure in merge_bio(), it cannot decrease eb->io_pages via bio_endio,
>  and ends up with a memory leak eventually.
> 
> This lets __do_readpage propagate errors to callers and adds the
>  'atomic_dec(&eb->io_pages)'.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

>  		if (!PageUptodate(page)) {
> +			if (ret) {
> +				atomic_dec(&eb->io_pages);
> +				unlock_page(page);
> +				continue;
> +			}

This changes the behaviour to "fail early", which could be positive as a
sequence of unreadable blocks will not try to reread all of them with
the timeouts and retries.
