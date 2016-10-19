Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41313 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942255AbcJSObo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:31:44 -0400
Date: Wed, 19 Oct 2016 16:31:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, rgoldwyn@suse.de, rgoldwyn@suse.com
Subject: Re: [PATCH 1/2] btrfs: Add WARN_ON for qgroup reserved underflow
Message-ID: <20161019143142.GS11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160930011537.4857-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160930011537.4857-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 30, 2016 at 09:15:36AM +0800, Qu Wenruo wrote:
> While the reason why qgroup reserved space may underflow is still under
> investigation, such WARN_ON will help us to expose the bug more easily,
> and for end-user we can detect and avoid underflow.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/qgroup.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8db2e29..8532587 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1061,8 +1061,12 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>  	WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>  	qgroup->excl += sign * num_bytes;
>  	qgroup->excl_cmpr += sign * num_bytes;
> -	if (sign > 0)
> -		qgroup->reserved -= num_bytes;
> +	if (sign > 0) {
> +		if (WARN_ON(qgroup->reserved < num_bytes))

That's only partially helpful, you should also print the numbers,
ref_root and/or qgroup id.
