Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6CEC6787A
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 01:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EEDF2075E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 01:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EEDF2075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbeJIIxw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 04:53:52 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39356 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726160AbeJIIxw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 04:53:52 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45803679"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 09 Oct 2018 09:39:22 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D6D6E4B6EC90;
        Tue,  9 Oct 2018 09:39:20 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 9 Oct 2018 09:39:24 +0800
Subject: Re: [PATCH v3 2/6] btrfs-progs: lowmem check: Add check for
 overlapping dev extents
To:     Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20181008123044.13413-1-wqu@suse.com>
 <20181008123044.13413-3-wqu@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <12b7c374-cd71-b882-6e6e-b28235b9c750@cn.fujitsu.com>
Date:   Tue, 9 Oct 2018 09:46:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181008123044.13413-3-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: D6D6E4B6EC90.AE314
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/8/18 8:30 PM, Qu Wenruo wrote:
> Add such check at check_dev_item(), since at that timing we're also
> iterating dev extents for dev item accounting.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM.
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   check/mode-lowmem.c | 34 ++++++++++++++++++++++++++++++++--
>   1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 1bce44f5658a..07c03cad77af 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -4065,6 +4065,8 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
>   	u64 dev_id;
>   	u64 used;
>   	u64 total = 0;
> +	u64 prev_devid = 0;
> +	u64 prev_dev_ext_end = 0;
>   	int ret;
>   
>   	dev_item = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
> @@ -4086,8 +4088,16 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
>   		return REFERENCER_MISSING;
>   	}
>   
> -	/* Iterate dev_extents to calculate the used space of a device */
> +	/*
> +	 * Iterate dev_extents to calculate the used space of a device
> +	 *
> +	 * Also make sure no dev extents overlap and end beyond device boundary
> +	 */
>   	while (1) {
> +		u64 devid;
> +		u64 physical_offset;
> +		u64 physical_len;
> +
>   		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0]))
>   			goto next;
>   
> @@ -4099,7 +4109,27 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
>   
>   		ptr = btrfs_item_ptr(path.nodes[0], path.slots[0],
>   				     struct btrfs_dev_extent);
> -		total += btrfs_dev_extent_length(path.nodes[0], ptr);
> +		devid = key.objectid;
> +		physical_offset = key.offset;
> +		physical_len = btrfs_dev_extent_length(path.nodes[0], ptr);
> +
> +		if (prev_devid == devid && physical_offset < prev_dev_ext_end) {
> +			error(
> +"dev extent devid %llu offset %llu len %llu overlap with previous dev extent end %llu",
> +			      devid, physical_offset, physical_len,
> +			      prev_dev_ext_end);
> +			return ACCOUNTING_MISMATCH;
> +		}
> +		if (physical_offset + physical_len > total_bytes) {
> +			error(
> +"dev extent devid %llu offset %llu len %llu is beyond device boundary %llu",
> +			      devid, physical_offset, physical_len,
> +			      total_bytes);
> +			return ACCOUNTING_MISMATCH;
> +		}
> +		prev_devid = devid;
> +		prev_dev_ext_end = physical_offset + physical_len;
> +		total += physical_len;
>   next:
>   		ret = btrfs_next_item(dev_root, &path);
>   		if (ret)
> 


