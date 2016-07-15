Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33172 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbcGOCXH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 22:23:07 -0400
Subject: Re: [PATCH] Btrfs-progs: fix btrfs-map-logical to only print extent
 mapping info
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1468546827-28501-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f12ae244-0b15-fb93-eda1-8f758694afde@cn.fujitsu.com>
Date: Fri, 15 Jul 2016 10:22:52 +0800
MIME-Version: 1.0
In-Reply-To: <1468546827-28501-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/15/2016 09:40 AM, Liu Bo wrote:
> I have a valid btrfs image which contains,
> ...
>         item 10 key (1103101952 BLOCK_GROUP_ITEM 1288372224) itemoff 15947 itemsize 24
>                 block group used 655360 chunk_objectid 256 flags DATA|RAID5
>         item 11 key (1103364096 EXTENT_ITEM 131072) itemoff 15894 itemsize 53
>                 extent refs 1 gen 11 flags DATA
>                 extent data backref root 5 objectid 258 offset 0 count 1
>         item 12 key (1103888384 EXTENT_ITEM 262144) itemoff 15841 itemsize 53
>                 extent refs 1 gen 15 flags DATA
>                 extent data backref root 1 objectid 256 offset 0 count 1
>         item 13 key (1104281600 EXTENT_ITEM 262144) itemoff 15788 itemsize 53
>                 extent refs 1 gen 15 flags DATA
>                 extent data backref root 1 objectid 257 offset 0 count 1
> ...
>
> The extent [1103364096, 131072) has length 131072, but if we run
>
> "btrfs-map-logical -l 1103364096 -b $((65536 * 3)) /dev/sda"
>
> it will return mapping info 's of  non-existing extents.
>
> It's because it assumes that extents's are contiguous on logical address,
> when it's not true, after one loop (cur_logical += cur_len) and mapping
> the next extent, we can get an extent that is out of our search range and
> we end up with a negative @real_len and printing all mapping infos till
> the disk end.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Yes, the assumption of all extents are contiguous is quite wrong.
So your check is needed.

Thanks,
Qu
> ---
>  btrfs-map-logical.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
> index fd0286d..f421a50 100644
> --- a/btrfs-map-logical.c
> +++ b/btrfs-map-logical.c
> @@ -329,6 +329,11 @@ int main(int argc, char **argv)
>  			goto out_close_fd;
>  		if (ret > 0)
>  			break;
> +		/* check again if there is overlap. */
> +		if (cur_logical + cur_len < logical ||
> +		    cur_logical >= logical + bytes)
> +			break;
> +
>  		real_logical = max(logical, cur_logical);
>  		real_len = min(logical + bytes, cur_logical + cur_len) -
>  			   real_logical;
>


