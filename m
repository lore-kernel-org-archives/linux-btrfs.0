Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423878AbcFMPfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jun 2016 11:35:46 -0400
Date: Mon, 13 Jun 2016 17:36:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix eb memory leak due to readpage failure
Message-ID: <20160613153624.GB6205@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464980918-8365-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464980918-8365-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 12:08:38PM -0700, Liu Bo wrote:
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

I'm adding this to for-next, but a review is needed if this is supposed
to go to 4.7.
