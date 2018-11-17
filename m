Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45679C43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 01:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3A72087C
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 01:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AKeG4pgt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF3A72087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731432AbeKQLoM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 17 Nov 2018 06:44:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42286 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbeKQLoM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Nov 2018 06:44:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAH1TNtd136486;
        Sat, 17 Nov 2018 01:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=gMtV8JxUMnLSj9+23vodk9GJp7IzB4ZjOXkuOLNAdVc=;
 b=AKeG4pgtkovpEPTq+lOL3JfCh3qRFIjqWz5L1mr78hRqNcdsWCyvHao28VnBiPlH6Ra0
 sKCLHUh+/FD6QQXlvmQT4128DnYoFm0jCSP7VehF5oYTx9Numy3Le0u1Nk3h5J4luSRB
 RU2U1YmTNnogtEyNd6yCz0dXc4VjhL5xynxA0uoa9rTKE9jjYD+GKhPvvq5/jpr4u3iI
 g2/p+4G31HFW7PZx0kovTifzoyeVJCIJoQ8r+fuBMM7oYPxvFxdtOELCbgiHRtc+Ppfl
 msY/QWbhv9idQreDlkT6FydM8MMJInLkw/qoXrHGnuh1YdP5GzH0JT6+kX23RH76ZtwH 3Q== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nr7cshubb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Nov 2018 01:29:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAH1THci028090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Nov 2018 01:29:17 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAH1TGo0025109;
        Sat, 17 Nov 2018 01:29:17 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Nov 2018 17:29:16 -0800
Subject: Re: [PATCH 2/5] btrfs: Refactor btrfs_can_relocate
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-3-git-send-email-nborisov@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <eb2690a3-7a47-af8f-a7cc-3d0cee98a1da@oracle.com>
Date:   Sat, 17 Nov 2018 09:29:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-3-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9079 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811170011
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/26/2018 07:43 PM, Nikolay Borisov wrote:
> btrfs_can_relocate returns 0 when it concludes the given chunk can be
> relocated and -1 otherwise. Since this function is used as a predicated
> and it return a binary value it makes no sense to have it's return
> value as an int so change it to bool. Furthermore, remove a stale
> leftover comment from e6ec716f0ddb ("Btrfs: make raid attr array more
> readable").
> 
> Finally make the logic in the list_for_each_entry loop a bit more obvious. Up
> until now the fact that we are returning success (0) was a bit masked by the
> fact that the 0 is re-used from the return value of find_free_dev_extent.
> Instead, now just increment dev_nr if we find a suitable extent and explicitly
> set can_reloc to true if enough devices with unallocated space are present.
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>   fs/btrfs/ctree.h       |  2 +-
>   fs/btrfs/extent-tree.c | 39 ++++++++++++++-------------------------
>   fs/btrfs/volumes.c     |  3 +--
>   3 files changed, 16 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 68ca41dbbef3..06edc4f9ceb2 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2680,7 +2680,7 @@ int btrfs_setup_space_cache(struct btrfs_trans_handle *trans,
>   int btrfs_extent_readonly(struct btrfs_fs_info *fs_info, u64 bytenr);
>   int btrfs_free_block_groups(struct btrfs_fs_info *info);
>   int btrfs_read_block_groups(struct btrfs_fs_info *info);
> -int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
> +bool btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
>   int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>   			   u64 bytes_used, u64 type, u64 chunk_offset,
>   			   u64 size);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a1febf155747..816bca482358 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9423,10 +9423,10 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache)
>   /*
>    * checks to see if its even possible to relocate this block group.
>    *
> - * @return - -1 if it's not a good idea to relocate this block group, 0 if its
> - * ok to go ahead and try.
> + * @return - false if not enough space can be found for relocation, true
> + * otherwise
>    */
> -int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
> +bool btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>   {
>   	struct btrfs_root *root = fs_info->extent_root;
>   	struct btrfs_block_group_cache *block_group;
> @@ -9441,7 +9441,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>   	int debug;
>   	int index;
>   	int full = 0;
> -	int ret = 0;
> +	bool can_reloc = true;
>   
>   	debug = btrfs_test_opt(fs_info, ENOSPC_DEBUG);
>   
> @@ -9453,7 +9453,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>   			btrfs_warn(fs_info,
>   				   "can't find block group for bytenr %llu",
>   				   bytenr);
> -		return -1;
> +		return false;
>   	}
>   
>   	min_free = btrfs_block_group_used(&block_group->item);
> @@ -9489,16 +9489,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>   	 * group is going to be restriped, run checks against the target
>   	 * profile instead of the current one.
>   	 */
> -	ret = -1;
> +	can_reloc = false;
>   
> -	/*
> -	 * index:
> -	 *      0: raid10
> -	 *      1: raid1
> -	 *      2: dup
> -	 *      3: raid0
> -	 *      4: single
> -	 */
>   	target = get_restripe_target(fs_info, block_group->flags);
>   	if (target) {
>   		index = btrfs_bg_flags_to_raid_index(extended_to_chunk(target));
> @@ -9534,10 +9526,8 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>   
>   	/* We need to do this so that we can look at pending chunks */
>   	trans = btrfs_join_transaction(root);
> -	if (IS_ERR(trans)) {
> -		ret = PTR_ERR(trans);
> +	if (IS_ERR(trans))
>   		goto out;
> -	}
>   
>   	mutex_lock(&fs_info->chunk_mutex);
>   	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
> @@ -9549,18 +9539,17 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>   		 */
>   		if (device->total_bytes > device->bytes_used + min_free &&
>   		    !test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
> -			ret = find_free_dev_extent(trans, device, min_free,
> -						   &dev_offset, NULL);
> -			if (!ret)
> +			if (!find_free_dev_extent(trans, device, min_free,
> +						   &dev_offset, NULL))

  This can return -ENOMEM;

>   				dev_nr++;
>   
> -			if (dev_nr >= dev_min)
> +			if (dev_nr >= dev_min) {
> +				can_reloc = true;
>   				break;
> -
> -			ret = -1;
> +			}
>   		}
>   	}
> -	if (debug && ret == -1)
> +	if (debug && !can_reloc)
>   		btrfs_warn(fs_info,
>   			   "no space to allocate a new chunk for block group %llu",
>   			   block_group->key.objectid);
> @@ -9568,7 +9557,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>   	btrfs_end_transaction(trans);
>   out:
>   	btrfs_put_block_group(block_group);
> -	return ret;
> +	return can_reloc;
>   }
>   
>   static int find_first_block_group(struct btrfs_fs_info *fs_info,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8b0fd7bf3447..dc53d94a62aa 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2856,8 +2856,7 @@ static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
>   	 */
>   	lockdep_assert_held(&fs_info->delete_unused_bgs_mutex);
>   
> -	ret = btrfs_can_relocate(fs_info, chunk_offset);
> -	if (ret)
> +	if (!btrfs_can_relocate(fs_info, chunk_offset))
>   		return -ENOSPC;

  And ends up converting -ENOMEM to -ENOSPC.

  Its better to propagate the accurate error.

Thanks, Anand


>   
>   	/* step one, relocate all the extents inside this chunk */
> 
