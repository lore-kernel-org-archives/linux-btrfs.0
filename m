Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48332 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161980AbaDCFeg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Apr 2014 01:34:36 -0400
Date: Thu, 3 Apr 2014 13:34:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix reversed warning condition in
 btrfs_delayed_inode_reserve_metadata
Message-ID: <20140403053421.GB11484@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1396458780-10923-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396458780-10923-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 02, 2014 at 07:13:00PM +0200, David Sterba wrote:
> Commit fae7f21cece9a4c181 ("btrfs: Use WARN_ON()'s return value in place of
> WARN_ON(1)") cleaned up WARN_ON usage and in one place reversed the condition
> that led to loads of warnings that were not supposed to occur.
> 
> WARN_ON will trigger because it sees 'ret' though in the previous code
> did not reach the WARN_ON below. The correct pattern is
> 
> -       if (condition)
> +       if (WARN_ON(condition))
> 
> CC: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
> CC: <stable@vger.kernel.org> # 3.13
> Reported-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/delayed-inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 451b00c86f6c..098af20abd88 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -649,7 +649,7 @@ static int btrfs_delayed_inode_reserve_metadata(
>  			goto out;
>  
>  		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
> -		if (!WARN_ON(ret))
> +		if (WARN_ON(!ret))
>  			goto out;

Oh sorry, I'd have to get my Reviewed-by back and give a NACK instead.

With this patch, (ret = 0) triggers the WARNING, which is not right.

-liubo
