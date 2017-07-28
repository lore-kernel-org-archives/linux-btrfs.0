Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52018 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbdG1BVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 21:21:00 -0400
Subject: Re: [PATCH 3/5] btrfs-progs: convert: use search_cache_extent in
 migrate_one_reserved_range
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20170727154723.2208-1-jeffm@suse.com>
 <20170727154723.2208-4-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3150ecb7-ca3a-0942-6647-c6f89f616241@gmx.com>
Date: Fri, 28 Jul 2017 09:20:18 +0800
MIME-Version: 1.0
In-Reply-To: <20170727154723.2208-4-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月27日 23:47, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> When we are looking for extents in migrate_one_reserved_range, it's likely
> that there will be multiple extents that fall into the 0-1MB range.
> 
> If lookup_cache_extent is called with a range that covers multiple cache
> entries, it will return the first entry it encounters while searching
> from the top of the tree that happens to fall in that range.  That
> means that we can end up skipping regions within that range, resulting
> in a file system image that can't be rolled back since it wasn't
> all migrated properly.

Thanks for catching this one.

> 
> This is reproducible using convert-tests/008-readonly-image.  There was
> a range from 0-160kB, but the only entry that was returned began at
> ~ 280kB.
> 
> The fix is to use search_cache_extent to iterate through multiple regions
> within that range >
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Thanks,
Qu

> ---
>   convert/main.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/convert/main.c b/convert/main.c
> index 01657a6..24ed1de 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -340,10 +340,12 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
>   	 * migrate ranges that covered by old fs data.
>   	 */
>   	while (cur_off < range_end(range)) {
> -		cache = lookup_cache_extent(used, cur_off, cur_len);
> +		cache = search_cache_extent(used, cur_off);
>   		if (!cache)
>   			break;
>   		cur_off = max(cache->start, cur_off);
> +		if (cur_off >= range_end(range))
> +			break;
>   		cur_len = min(cache->start + cache->size, range_end(range)) -
>   			  cur_off;
>   		BUG_ON(cur_len < root->sectorsize);
> 
