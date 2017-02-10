Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38899 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752336AbdBJQEK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 11:04:10 -0500
Date: Fri, 10 Feb 2017 17:02:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-kernel@vger.kernel.org, bo.li.liu@oracle.com, naota@elisp.net,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: add another missing end_page_writeback on
 submit_extent_page failure
Message-ID: <20170210160208.GI16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1486628673-30631-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1486628673-30631-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 09, 2017 at 05:24:33PM +0900, Takafumi Kubota wrote:
> If btrfs_bio_alloc fails in submit_extent_page, submit_extent_page returns
> without clearing the writeback bit of the failed page.
> 
> __extent_writepage_io, that is a caller of submit_extent_page,
> does not clear the remaining writeback bit anywhere.
> As a result, this will cause the hang at filemap_fdatawait_range,
> because it waits the writeback bit to be cleared from the failed page.
> So, we have to call end_page_writeback to clear the writeback bit.
> 
> For reproducing the hang, we inject a fault like
> 
>    if (should_failtest()) { // I define should_failtest()
>         bio = NULL;
>    }
>    else {
>         bio = btrfs_bio_alloc(...);
>    }
> 
> in submit_extent_page.
> 
> We should also check whether page has the bit before end_page_writeback,
> to avoid the conflict against the other end_page_writeback in bio_endio.
> Thus, we add PageWriteback checks not only in __extent_writepage_io,
> but also in write_one_eb too, because it misses the check.
> 
> Signed-off-by: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> Cc: David Sterba <dsterba@suse.cz>

Added to 4.11 queue, thanks.
