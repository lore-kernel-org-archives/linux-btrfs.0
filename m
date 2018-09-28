Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26775C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 01:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 944D42170E
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 01:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 944D42170E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbeI1HXR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 03:23:17 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20578 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726083AbeI1HXR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 03:23:17 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45456774"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Sep 2018 09:02:11 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id DF07C4B6EC9F;
        Fri, 28 Sep 2018 09:02:09 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 28 Sep 2018 09:02:08 +0800
Subject: Re: [PATCH] btrfs: tree-checker: Check level for leaves and nodes
To:     Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180927235934.5215-1-wqu@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <63dbf4f5-f576-c37e-a3a6-ba513d9c015b@cn.fujitsu.com>
Date:   Fri, 28 Sep 2018 09:08:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180927235934.5215-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: DF07C4B6EC9F.ADD5B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 9/28/18 7:59 AM, Qu Wenruo wrote:
> Although we have tree level check at tree read runtime, it's completely
> based on its parent level.
> We still need to do accurate level check to avoid invalid tree blocks
> sneak into kernel space.
> 
> The check itself is simple, for leaf its level should always be 0.
> For nodes its level should be in range [1, BTRFS_MAX_LEVEL - 1].
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/tree-checker.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index db835635372f..cab0b1f1f741 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -487,6 +487,13 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>   	u32 nritems = btrfs_header_nritems(leaf);
>   	int slot;
>   
> +	if (btrfs_header_level(leaf) != 0) {
> +		generic_err(fs_info, leaf, 0,
> +			"invalid level for leaf, have %d expect 0",
> +			btrfs_header_level(leaf));
> +		return -EUCLEAN;
> +	}
> +
BTW, output more info(bytenr, root) of the corrupted node/leaf may be 
better?

>   	/*
>   	 * Extent buffers from a relocation tree have a owner field that
>   	 * corresponds to the subvolume tree they are based on. So just from an
> @@ -645,9 +652,16 @@ int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
>   	unsigned long nr = btrfs_header_nritems(node);
>   	struct btrfs_key key, next_key;
>   	int slot;
> +	int level = btrfs_header_level(node);
>   	u64 bytenr;
>   	int ret = 0;
>   
> +	if (level <= 0 || level >= BTRFS_MAX_LEVEL) {
> +		generic_err(fs_info, node, 0,
> +			"invalid level for node, have %d expect [1, %d]",
> +			level, BTRFS_MAX_LEVEL - 1);
> +		return -EUCLEAN;
> +	}
>   	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(fs_info)) {
>   		btrfs_crit(fs_info,
>   "corrupt node: root=%llu block=%llu, nritems too %s, have %lu expect range [1,%u]",
> 


