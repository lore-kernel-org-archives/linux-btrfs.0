Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbeDEREu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 13:04:50 -0400
Date: Thu, 5 Apr 2018 19:02:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix NULL pointer dereference in log_dir_items
Message-ID: <20180405170221.GK2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522691988-127156-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522691988-127156-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2018 at 01:59:47AM +0800, Liu Bo wrote:
> 0, 1 and <0 can be returned by btrfs_next_leaf(), and when <0 is
> returned, path->nodes[0] could be NULL, log_dir_items lacks such a
> check for <0 and we may run into a null pointer dereference panic.
> 
> Fixes: e02119d5a7b4 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---

Added to next, thanks.

> v2: Add Fixes tag and reviewed-by.
> 
>  fs/btrfs/tree-log.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 4344577..4ee9431 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3518,8 +3518,11 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
>  		 * from this directory and from this transaction
>  		 */
>  		ret = btrfs_next_leaf(root, path);
> -		if (ret == 1) {
> -			last_offset = (u64)-1;
> +		if (ret) {
> +			if (ret == 1)
> +				last_offset = (u64)-1;
> +			else
> +				err = ret;

I wonder if we could find some more consistent if/else pattern of the
error handling for this function. Each caller cares about something else
so it's hard to tell from a quick look which part is the expected one.

Something like:

if (ret < 0) {
	unexpected error
} else if (ret > 0 ) {
	no more leaves, probably a terminating condition
} else {
	more leaves to scan, possibly this can be ommitted in most cases
}
