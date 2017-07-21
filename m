Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750849AbdGUSM1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 14:12:27 -0400
Date: Fri, 21 Jul 2017 20:11:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make use of inode_need_compress()
Message-ID: <20170721181111.GO2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170718093747.19046-1-anand.jain@oracle.com>
 <20170718150125.GT2866@twin.jikos.cz>
 <e48652eb-78bb-d6b7-4bbf-3722f0af2fb7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e48652eb-78bb-d6b7-4bbf-3722f0af2fb7@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 10:22:13AM +0800, Anand Jain wrote:
> >> @@ -1189,11 +1189,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
> >>   		async_cow->locked_page = locked_page;
> >>   		async_cow->start = start;
> >>   
> >> -		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
> >> -		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
> >> -			cur_end = end;
> >> -		else
> >> +		if (inode_need_compress(inode))
> >>   			cur_end = min(end, start + SZ_512K - 1);
> >> +		else
> >> +			cur_end = end;
> > 
> > The opencoded test should be cleaned up, however cow_file_range_async is
> > called from run_delalloc_range if the inode_need_compress passes the
> > 'inode_need_compress' condition. So at minimum, checking again here is
> > redundant,
> 
>   David, no its not redundant. If the preceding SZ_512K block is not
>   compressible, then we would have already set the BTRFS_INODE_NOCOMPRESS
>   flag, which then we would straightaway go up to the end.

Right, I missed that it's using 'start', that changes in the loop and
that NOCOMPRESS can get set indirectly through the async write between
the iterations.

I'm still counting too many times where the expensive "should we
compress" check can get triggerd. It's at least once before we go to
cow_file_range_async and then again for each compressed range in
compress_file_range. I think we can fix that by two modes of
inode_need_compres or separate the lightweight and expensive checks.
