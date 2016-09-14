Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46858 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753297AbcINREd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 13:04:33 -0400
Subject: Re: [PATCH] Btrfs: return gracefully from balance if fs tree is
 corrupted
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1473868306-30578-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <0508f261-c838-8328-b796-8f76d75ebcfd@fb.com>
Date: Wed, 14 Sep 2016 13:04:21 -0400
MIME-Version: 1.0
In-Reply-To: <1473868306-30578-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2016 11:51 AM, Liu Bo wrote:
> When relocating tree blocks, we firstly get block information from
> back references in the extent tree, we then search fs tree to try to
> find all parents of a block.
>
> However, if fs tree is corrupted, eg. if there're some missing
> items, we could come across these WARN_ONs and BUG_ONs.
>
> This makes us print some error messages and return gracefully
> from balance.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/relocation.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index c0c13dc..680e234 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -923,9 +923,16 @@ again:
>  			path2->slots[level]--;
>
>  		eb = path2->nodes[level];
> -		WARN_ON(btrfs_node_blockptr(eb, path2->slots[level]) !=
> -			cur->bytenr);
> -
> +		if (btrfs_node_blockptr(eb, path2->slots[level]) !=
> +		    cur->bytenr) {
> +			btrfs_err(root->fs_info,
> +	"couldn't find block (%llu) (level %d) in tree (%llu) with key (%llu %u %llu)",
> +				  cur->bytenr, level - 1, root->objectid,
> +				  node_key->objectid, node_key->type,
> +				  node_key->offset);
> +			err = -ENOENT;
> +			goto out;
> +		}
>  		lower = cur;
>  		need_check = true;
>  		for (; level < BTRFS_MAX_LEVEL; level++) {
> @@ -2686,11 +2693,15 @@ static int do_relocation(struct btrfs_trans_handle *trans,
>
>  		if (!upper->eb) {
>  			ret = btrfs_search_slot(trans, root, key, path, 0, 1);
> -			if (ret < 0) {
> -				err = ret;
> +			if (ret) {
> +				if (ret < 0)
> +					err = ret;
> +				else
> +					err = -ENOENT;
> +
> +				btrfs_release_path(path);
>  				break;
>  			}
> -			BUG_ON(ret > 0);
>
>  			if (!upper->eb) {
>  				upper->eb = path->nodes[upper->level];
>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
