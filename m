Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C929C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41F2620818
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfDLNGa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:06:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:40918 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726755AbfDLNGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 09:06:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EBCA6AD43;
        Fri, 12 Apr 2019 13:06:27 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: reserve delalloc metadata differently
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20190410195610.84110-1-josef@toxicpanda.com>
 <20190410195610.84110-3-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 mQINBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABtCNOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuY29tPokCOAQTAQIAIgUCWIo48QIbAwYLCQgHAwIGFQgC
 CQoLBBYCAwECHgECF4AACgkQcb6CRuU/KFc0eg/9GLD3wTQz9iZHMFbjiqTCitD7B6dTLV1C
 ddZVlC8Hm/TophPts1bWZORAmYIihHHI1EIF19+bfIr46pvfTu0yFrJDLOADMDH+Ufzsfy2v
 HSqqWV/nOSWGXzh8bgg/ncLwrIdEwBQBN9SDS6aqsglagvwFD91UCg/TshLlRxD5BOnuzfzI
 Leyx2c6YmH7Oa1R4MX9Jo79SaKwdHt2yRN3SochVtxCyafDlZsE/efp21pMiaK1HoCOZTBp5
 VzrIP85GATh18pN7YR9CuPxxN0V6IzT7IlhS4Jgj0NXh6vi1DlmKspr+FOevu4RVXqqcNTSS
 E2rycB2v6cttH21UUdu/0FtMBKh+rv8+yD49FxMYnTi1jwVzr208vDdRU2v7Ij/TxYt/v4O8
 V+jNRKy5Fevca/1xroQBICXsNoFLr10X5IjmhAhqIH8Atpz/89ItS3+HWuE4BHB6RRLM0gy8
 T7rN6ja+KegOGikp/VTwBlszhvfLhyoyjXI44Tf3oLSFM+8+qG3B7MNBHOt60CQlMkq0fGXd
 mm4xENl/SSeHsiomdveeq7cNGpHi6i6ntZK33XJLwvyf00PD7tip/GUj0Dic/ZUsoPSTF/mG
 EpuQiUZs8X2xjK/AS/l3wa4Kz2tlcOKSKpIpna7V1+CMNkNzaCOlbv7QwprAerKYywPCoOSC
 7P25Ag0EWIoHPgEQAMiUqvRBZNvPvki34O/dcTodvLSyOmK/MMBDrzN8Cnk302XfnGlW/YAQ
 csMWISKKSpStc6tmD+2Y0z9WjyRqFr3EGfH1RXSv9Z1vmfPzU42jsdZn667UxrRcVQXUgoKg
 QYx055Q2FdUeaZSaivoIBD9WtJq/66UPXRRr4H/+Y5FaUZx+gWNGmBT6a0S/GQnHb9g3nonD
 jmDKGw+YO4P6aEMxyy3k9PstaoiyBXnzQASzdOi39BgWQuZfIQjN0aW+Dm8kOAfT5i/yk59h
 VV6v3NLHBjHVw9kHli3jwvsizIX9X2W8tb1SefaVxqvqO1132AO8V9CbE1DcVT8fzICvGi42
 FoV/k0QOGwq+LmLf0t04Q0csEl+h69ZcqeBSQcIMm/Ir+NorfCr6HjrB6lW7giBkQl6hhomn
 l1mtDP6MTdbyYzEiBFcwQD4terc7S/8ELRRybWQHQp7sxQM/Lnuhs77MgY/e6c5AVWnMKd/z
 MKm4ru7A8+8gdHeydrRQSWDaVbfy3Hup0Ia76J9FaolnjB8YLUOJPdhI2vbvNCQ2ipxw3Y3c
 KhVIpGYqwdvFIiz0Fej7wnJICIrpJs/+XLQHyqcmERn3s/iWwBpeogrx2Lf8AGezqnv9woq7
 OSoWlwXDJiUdaqPEB/HmGfqoRRN20jx+OOvuaBMPAPb+aKJyle8zABEBAAGJAh8EGAECAAkF
 AliKBz4CGwwACgkQcb6CRuU/KFdacg/+M3V3Ti9JYZEiIyVhqs+yHb6NMI1R0kkAmzsGQ1jU
 zSQUz9AVMR6T7v2fIETTT/f5Oout0+Hi9cY8uLpk8CWno9V9eR/B7Ifs2pAA8lh2nW43FFwp
 IDiSuDbH6oTLmiGCB206IvSuaQCp1fed8U6yuqGFcnf0ZpJm/sILG2ECdFK9RYnMIaeqlNQm
 iZicBY2lmlYFBEaMXHoy+K7nbOuizPWdUKoKHq+tmZ3iA+qL5s6Qlm4trH28/fPpFuOmgP8P
 K+7LpYLNSl1oQUr+WlqilPAuLcCo5Vdl7M7VFLMq4xxY/dY99aZx0ZJQYFx0w/6UkbDdFLzN
 upT7NIN68lZRucImffiWyN7CjH23X3Tni8bS9ubo7OON68NbPz1YIaYaHmnVQCjDyDXkQoKC
 R82Vf9mf5slj0Vlpf+/Wpsv/TH8X32ajva37oEQTkWNMsDxyw3aPSps6MaMafcN7k60y2Wk/
 TCiLsRHFfMHFY6/lq/c0ZdOsGjgpIK0G0z6et9YU6MaPuKwNY4kBdjPNBwHreucrQVUdqRRm
 RcxmGC6ohvpqVGfhT48ZPZKZEWM+tZky0mO7bhZYxMXyVjBn4EoNTsXy1et9Y1dU3HVJ8fod
 5UqrNrzIQFbdeM0/JqSLrtlTcXKJ7cYFa9ZM2AP7UIN9n1UWxq+OPY9YMOewVfYtL8M=
Message-ID: <0098847c-71fb-b305-3f2a-392ce2737ed4@suse.com>
Date:   Fri, 12 Apr 2019 16:06:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190410195610.84110-3-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10.04.19 г. 22:56 ч., Josef Bacik wrote:
> With the per-inode block rsvs we started refilling the reserve based on
> the calculated size of the outstanding csum bytes and extents for the
> inode, including the amount we were adding with the new operation.
> 
> However generic/224 exposed a problem with this approach.  With 1000
> files all writing at the same time we ended up with a bunch of bytes
> being reserved but unusable.
> 
> When you write to a file we reserve space for the csum leaves for those
> bytes, the number of extent items required to cover those bytes, and a
> single credit for updating the inode at ordered extent finish for that
> range of bytes.  This is held until the ordered extent finishes and we
> release all of the reserved space.
> 
> If a second write comes in at this point we would add a single
> reservation for the new outstanding extent and however many reservations
> for the csum leaves.  

If a second write comes we won't do anything different than the first
i.e calculate the number of extent items + csums bytes required, add
them to the block reservation and call btrfs_inode_rsv_refill which
should refill the delta necessary for the 2nd write.


At this point we find the delta of how much we
> have reserved and how much outstanding size this is and attempt to
> reserve this delta.  If the first write finishes it will not release any
> space, because the space it had reserved for the initial write is still
> needed for the second write.  However some space would have been used,

Each and every reservation is responsible for itself how come the first
one will know some of its space is required for the second, hence it
won't be released?


> as we have added csums, extent items, and dirtied the inode.  Our
> reserved space would be > 0 but < the total needed reserved space.
> 
> This is just for a single inode, now consider generic/224.  This has
> 1000 inodes writing in parallel to a very small file system, 1gib.  In
> my testing this usually means we get about a 120mib metadata area to
> work with, more than enough to allow the writes to continue, but not
> enough if all of the inodes are stuck trying to reserve the slack space
> while continuing to hold their leftovers from their initial writes.
> 
> Fix this by pre-reserved _only_ for the space we are currently trying to
> add.  Then once that is successful modify our inodes csum count and
> outstanding extents, and then add the newly reserved space to the inodes
> block_rsv.  This allows us to actually pass generic/224 without running
> out of metadata space.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 145 ++++++++++++++++++-------------------------------
>  1 file changed, 53 insertions(+), 92 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0982456ebabb..9aff7a8817d9 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5811,85 +5811,6 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
>  	return ret;
>  }
>  
> -static void calc_refill_bytes(struct btrfs_block_rsv *block_rsv,
> -				u64 *metadata_bytes, u64 *qgroup_bytes)
> -{
> -	*metadata_bytes = 0;
> -	*qgroup_bytes = 0;
> -
> -	spin_lock(&block_rsv->lock);
> -	if (block_rsv->reserved < block_rsv->size)
> -		*metadata_bytes = block_rsv->size - block_rsv->reserved;
> -	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
> -		*qgroup_bytes = block_rsv->qgroup_rsv_size -
> -			block_rsv->qgroup_rsv_reserved;
> -	spin_unlock(&block_rsv->lock);
> -}
> -
> -/**
> - * btrfs_inode_rsv_refill - refill the inode block rsv.
> - * @inode - the inode we are refilling.
> - * @flush - the flushing restriction.
> - *
> - * Essentially the same as btrfs_block_rsv_refill, except it uses the
> - * block_rsv->size as the minimum size.  We'll either refill the missing amount
> - * or return if we already have enough space.  This will also handle the reserve
> - * tracepoint for the reserved amount.
> - */
> -static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
> -				  enum btrfs_reserve_flush_enum flush)
> -{
> -	struct btrfs_root *root = inode->root;
> -	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
> -	u64 num_bytes, last = 0;
> -	u64 qgroup_num_bytes;
> -	int ret = -ENOSPC;
> -
> -	calc_refill_bytes(block_rsv, &num_bytes, &qgroup_num_bytes);
> -	if (num_bytes == 0)
> -		return 0;
> -
> -	do {
> -		ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes,
> -							 true);
> -		if (ret)
> -			return ret;
> -		ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
> -		if (ret) {
> -			btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
> -			last = num_bytes;
> -			/*
> -			 * If we are fragmented we can end up with a lot of
> -			 * outstanding extents which will make our size be much
> -			 * larger than our reserved amount.
> -			 *
> -			 * If the reservation happens here, it might be very
> -			 * big though not needed in the end, if the delalloc
> -			 * flushing happens.
> -			 *
> -			 * If this is the case try and do the reserve again.
> -			 */
> -			if (flush == BTRFS_RESERVE_FLUSH_ALL)
> -				calc_refill_bytes(block_rsv, &num_bytes,
> -						   &qgroup_num_bytes);
> -			if (num_bytes == 0)
> -				return 0;
> -		}
> -	} while (ret && last != num_bytes);
> -
> -	if (!ret) {
> -		block_rsv_add_bytes(block_rsv, num_bytes, false);
> -		trace_btrfs_space_reservation(root->fs_info, "delalloc",
> -					      btrfs_ino(inode), num_bytes, 1);
> -
> -		/* Don't forget to increase qgroup_rsv_reserved */
> -		spin_lock(&block_rsv->lock);
> -		block_rsv->qgroup_rsv_reserved += qgroup_num_bytes;
> -		spin_unlock(&block_rsv->lock);
> -	}
> -	return ret;
> -}
> -
>  static u64 __btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
>  				     struct btrfs_block_rsv *block_rsv,
>  				     u64 num_bytes, u64 *qgroup_to_release)
> @@ -6190,9 +6111,26 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
>  	spin_unlock(&block_rsv->lock);
>  }
>  
> +static inline void calc_inode_reservations(struct btrfs_fs_info *fs_info,
> +					   struct btrfs_inode *inode,
> +					   u64 num_bytes, u64 *meta_reserve,
> +					   u64 *qgroup_reserve)
> +{
> +	u64 nr_extents = count_max_extents(num_bytes);
> +	u64 csum_leaves = btrfs_csum_bytes_to_leaves(fs_info, num_bytes);
> +
> +	/* We add one for the inode update at finish ordered time. */
> +	*meta_reserve = btrfs_calc_trans_metadata_size(fs_info,
> +						nr_extents + csum_leaves + 1);
> +	*qgroup_reserve = nr_extents * fs_info->nodesize;
> +}
> +
>  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  {
> -	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct btrfs_root *root = inode->root;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
> +	u64 meta_reserve, qgroup_reserve;
>  	unsigned nr_extents;
>  	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
>  	int ret = 0;
> @@ -6222,7 +6160,31 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  
>  	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
>  
> -	/* Add our new extents and calculate the new rsv size. */
> +	/*
> +	 * Josef, we always want to do it this way, every other way is wrong and
> +	 * ends in tears.  Pre-reserving the amount we are going to add will
> +	 * always be the right way, because otherwise if we have enough
> +	 * parallelism we could end up with thousands of inodes all holding
> +	 * little bits of reservations they were able to make previously and the
> +	 * only way to reclaim that space is to ENOSPC out the operations and
> +	 * clear everything out and try again, which is shitty.  This way we
> +	 * just over-reserve slightly, and clean up the mess when we are done.
> +	 */
> +	calc_inode_reservations(fs_info, inode, num_bytes, &meta_reserve,
> +				&qgroup_reserve);
> +	ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_reserve, true);
> +	if (ret)
> +		goto out_fail;
> +	ret = reserve_metadata_bytes(root, block_rsv, meta_reserve, flush);
> +	if (ret)
> +		goto out_qgroup;
> +
> +	/*
> +	 * Now we need to update our outstanding extents and csum bytes _first_
> +	 * and then add the reservation to the block_rsv.  This keeps us from
> +	 * racing with an ordered completion or some such that would think it
> +	 * needs to free the reservation we just made.
> +	 */
>  	spin_lock(&inode->lock);
>  	nr_extents = count_max_extents(num_bytes);
>  	btrfs_mod_outstanding_extents(inode, nr_extents);
> @@ -6230,22 +6192,21 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>  	spin_unlock(&inode->lock);
>  
> -	ret = btrfs_inode_rsv_refill(inode, flush);
> -	if (unlikely(ret))
> -		goto out_fail;
> +	/* Now we can safely add our space to our block rsv. */
> +	block_rsv_add_bytes(block_rsv, meta_reserve, false);
> +	trace_btrfs_space_reservation(root->fs_info, "delalloc",
> +				      btrfs_ino(inode), meta_reserve, 1);
> +
> +	spin_lock(&block_rsv->lock);
> +	block_rsv->qgroup_rsv_reserved += qgroup_reserve;
> +	spin_unlock(&block_rsv->lock);
>  
>  	if (delalloc_lock)
>  		mutex_unlock(&inode->delalloc_mutex);
>  	return 0;
> -
> +out_qgroup:
> +	btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
>  out_fail:
> -	spin_lock(&inode->lock);
> -	nr_extents = count_max_extents(num_bytes);
> -	btrfs_mod_outstanding_extents(inode, -nr_extents);
> -	inode->csum_bytes -= num_bytes;
> -	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
> -	spin_unlock(&inode->lock);
> -
>  	btrfs_inode_rsv_release(inode, true);
>  	if (delalloc_lock)
>  		mutex_unlock(&inode->delalloc_mutex);
> 
