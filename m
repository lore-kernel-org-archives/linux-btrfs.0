Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52049 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751462AbdGRPCm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 11:02:42 -0400
Date: Tue, 18 Jul 2017 17:01:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: make use of inode_need_compress()
Message-ID: <20170718150125.GT2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170718093747.19046-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170718093747.19046-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 18, 2017 at 05:37:47PM +0800, Anand Jain wrote:
> Its better to have the policy enforcement going through a function,
> so that we have better control and visibility of the decision logic.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/inode.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 06dea7c89bbd..d0cc3de120b7 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1189,11 +1189,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>  		async_cow->locked_page = locked_page;
>  		async_cow->start = start;
>  
> -		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
> -		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
> -			cur_end = end;
> -		else
> +		if (inode_need_compress(inode))
>  			cur_end = min(end, start + SZ_512K - 1);
> +		else
> +			cur_end = end;

The opencoded test should be cleaned up, however cow_file_range_async is
called from run_delalloc_range if the inode_need_compress passes the
'inode_need_compress' condition. So at minimum, checking again here is
redundant, but we still might need to know if the compression is
desired.

The check does no depend on anything inside the loop, so it should be
moved out of it.  If I understand the logic correctly, we get to
cow_file_range_async and always want to compress, so the test should be
dropped entirely.
