Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50006C67879
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 01:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1282A20858
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 01:54:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1282A20858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbeJIJJD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 05:09:03 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4783 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726846AbeJIJJC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 05:09:02 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45804317"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 09 Oct 2018 09:54:29 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 690664B6ED4F;
        Tue,  9 Oct 2018 09:54:30 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 9 Oct 2018 09:54:35 +0800
Subject: Re: [PATCH v3 3/6] btrfs-progs: original check: Add ability to detect
 bad dev extents
To:     Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20181008123044.13413-1-wqu@suse.com>
 <20181008123044.13413-4-wqu@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <6ad49df8-0e82-50ec-9819-905b5ced133a@cn.fujitsu.com>
Date:   Tue, 9 Oct 2018 10:01:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181008123044.13413-4-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 690664B6ED4F.AAF99
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/8/18 8:30 PM, Qu Wenruo wrote:
> Unlike lowmem mode check, we don't have good place for original mode to
> check overlap dev extents.
> 
> So this patch introduces a new function, btrfs_check_dev_extents(), to
> handle possible bad dev extents.
> 
> Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   check/main.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 99 insertions(+)
> 
> diff --git a/check/main.c b/check/main.c
> index bc2ee22f7943..ff9a785ce555 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -8224,6 +8224,99 @@ out:
>   	return ret;
>   }
>   
> +/*
> + * Check if all dev extents are valid (not overlap nor beyond device
> + * boundary).
> + *
> + * Dev extents <-> chunk cross checking is already done in check_chunks().
> + */
> +static int check_dev_extents(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	struct btrfs_root *dev_root = fs_info->dev_root;
> +	int ret;
> +	u64 prev_devid = 0;
> +	u64 prev_dev_ext_end = 0;
> +
> +	btrfs_init_path(&path);
> +
> +	key.objectid = 1;
> +	key.type = BTRFS_DEV_EXTENT_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
> +	if (ret < 0) {
> +		error("failed to search device tree: %s", strerror(-ret));
> +		goto out;
> +	}
> +	if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
> +		ret = btrfs_next_leaf(dev_root, &path);
> +		if (ret < 0) {
> +			error("failed to find next leaf: %s", strerror(-ret));
> +			goto out;
> +		}
> +		if (ret > 0) {
> +			ret = 0;
> +			goto out;
> +		}
> +	}
> +
> +	while (1) {
> +		struct btrfs_dev_extent *dev_ext;
> +		struct btrfs_device *dev;
> +		u64 devid;
> +		u64 physical_offset;
> +		u64 physical_len;
> +
> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +		if (key.type != BTRFS_DEV_EXTENT_KEY)
> +			break;
> +		dev_ext = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +					 struct btrfs_dev_extent);
> +		devid = key.objectid;
> +		physical_offset = key.offset;
> +		physical_len = btrfs_dev_extent_length(path.nodes[0], dev_ext);
> +
> +		dev = btrfs_find_device(fs_info, devid, NULL, NULL);
> +		if (!dev) {
> +			error("failed to find device with devid %llu", devid);
> +			ret = -EUCLEAN;
> +			goto out;
> +		}
> +		if (prev_devid == devid && prev_dev_ext_end > physical_offset) {
> +			error(
> +"dev extent devid %llu physical offset %llu overlap with previous dev extent end %llu",
> +			      devid, physical_offset, prev_dev_ext_end);
> +			ret = -EUCLEAN;
> +			goto out;
> +		}
> +		if (physical_offset + physical_len > dev->total_bytes) {
> +			error(
> +"dev extent devid %llu physical offset %llu len %llu is beyond device boudnary %llu",
> +			      devid, physical_offset, physical_len,
> +			      dev->total_bytes);
> +			ret = -EUCLEAN;
> +			goto out;
> +		}
> +		prev_devid = devid;
> +		prev_dev_ext_end = physical_offset + physical_len;
> +
> +		ret = btrfs_next_item(dev_root, &path);
> +		if (ret < 0) {
> +			error("failed to find next leaf: %s", strerror(-ret));
> +			goto out;
> +		}
> +		if (ret > 0) {
> +			ret = 0;
> +			break;
> +		}
> +	}
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
>   static int check_chunks_and_extents(struct btrfs_fs_info *fs_info)
>   {
>   	struct rb_root dev_cache;
> @@ -8318,6 +8411,12 @@ again:
>   		goto out;
>   	}
>   
> +	ret = check_dev_extents(fs_info);
> +	if (ret < 0) {
> +		err = ret;
> +		goto out;
> +	}
> +
>   	ret = check_chunks(&chunk_cache, &block_group_cache,
>   			   &dev_extent_cache, NULL, NULL, NULL, 0);
>   	if (ret) {
> 


