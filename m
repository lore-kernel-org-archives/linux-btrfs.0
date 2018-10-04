Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71B8C00449
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 01:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76256213A2
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 01:24:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76256213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbeJDIPl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 04:15:41 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17956 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726270AbeJDIPk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 04:15:40 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45652142"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 04 Oct 2018 09:24:45 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 104C74B6ED9D;
        Thu,  4 Oct 2018 09:24:42 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 4 Oct 2018 09:24:48 +0800
Subject: Re: [PATCH 02/10] btrfs-progs: Add extent buffer bitmap manipulation
 infrastructure
To:     Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-3-git-send-email-nborisov@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <1ca5d354-d284-4095-86d0-c60065930cad@cn.fujitsu.com>
Date:   Thu, 4 Oct 2018 09:31:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1538405181-25231-3-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 104C74B6ED9D.AEE9B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/1/18 10:46 PM, Nikolay Borisov wrote:
> Those functions are in preparation for adding the freespace tree
> repair code since it needs to be able to deal with bitmap based fsts.
> This patch adds extent_buffer_bitmap_set and extent_buffer_bitmap_clear
> functions. Since in userspace we don't have to deal with page mappings
> their implementation is vastly simplified by simply setting each bit in
> the passed range.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   extent_io.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   extent_io.h |  4 ++++
>   2 files changed, 60 insertions(+)
> 
> diff --git a/extent_io.c b/extent_io.c
> index 198492699438..de47c2c59ae9 100644
> --- a/extent_io.c
> +++ b/extent_io.c
> @@ -204,6 +204,62 @@ static int clear_state_bit(struct extent_io_tree *tree,
>   	return ret;
>   }
>   
> +/**
> + * extent_buffer_bitmap_set - set an area of a bitmap
> + * @eb: the extent buffer
> + * @start: offset of the bitmap item in the extent buffer
> + * @pos: bit number of the first bit
> + * @len: number of bits to set
> + */
> +void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
> +                              unsigned long pos, unsigned long len)
> +{
> +	u8 *p = (u8 *)eb->data + start + BIT_BYTE(pos);
> +	const unsigned int size = pos + len;
> +	int bits_to_set = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
> +	u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
> +
> +	while (len >= bits_to_set) {
> +		*p |= mask_to_set;
> +		len -= bits_to_set;
> +		bits_to_set = BITS_PER_BYTE;
> +		mask_to_set = ~0;
> +		p++;
> +	}
> +	if (len) {
> +		mask_to_set &= BITMAP_LAST_BYTE_MASK(size);
> +		*p |= mask_to_set;
> +	}
> +}
> +
> +
> +/**
> + * extent_buffer_bitmap_clear - clear an area of a bitmap
> + * @eb: the extent buffer
> + * @start: offset of the bitmap item in the extent buffer
> + * @pos: bit number of the first bit
> + * @len: number of bits to clear
> + */
> +void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
> +                                unsigned long pos, unsigned long len)
> +{
> +	u8 *p = (u8 *)eb->data + start + BIT_BYTE(pos);
> +	const unsigned int size = pos + len;
> +	int bits_to_clear = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
> +	u8 mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
> +
> +	while (len >= bits_to_clear) {
> +		*p &= ~mask_to_clear;
> +		len -= bits_to_clear;
> +		bits_to_clear = BITS_PER_BYTE;
> +		mask_to_clear = ~0;
> +		p++;
> +	}
> +	if (len) {
> +		mask_to_clear &= BITMAP_LAST_BYTE_MASK(size);
> +		*p &= ~mask_to_clear;
> +	}
> +}
>   /*
>    * clear some bits on a range in the tree.
>    */
> diff --git a/extent_io.h b/extent_io.h
> index d407d93d617e..b67c6fc40e89 100644
> --- a/extent_io.h
> +++ b/extent_io.h
> @@ -175,4 +175,8 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
>   			u64 bytes, int mirror);
>   int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
>   		       u64 bytes, int mirror);
> +void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
> +                                unsigned long pos, unsigned long len);
> +void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
> +                              unsigned long pos, unsigned long len);
>   #endif
> 


