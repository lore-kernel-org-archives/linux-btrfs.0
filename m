Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA26C00449
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 00:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C6FE20856
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 00:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C6FE20856
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbeJDHt3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 03:49:29 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:40482 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726270AbeJDHt3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 03:49:29 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45651415"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 04 Oct 2018 08:58:39 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A8C004B6ED5B;
        Thu,  4 Oct 2018 08:58:36 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 4 Oct 2018 08:58:43 +0800
Subject: Re: [PATCH 01/10] btrfs-progs: Add support for freespace tree in
 btrfs_read_fs_root
To:     Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-2-git-send-email-nborisov@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <46749eea-092f-db69-a38f-65836adc1ead@cn.fujitsu.com>
Date:   Thu, 4 Oct 2018 09:05:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1538405181-25231-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: A8C004B6ED5B.AB14A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/1/18 10:46 PM, Nikolay Borisov wrote:
> For completeness sake add code to btrfs_read_fs_root so that it can
> handle the freespace tree.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   disk-io.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 2e6d56a36af9..14f0fd5c2f0c 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -668,6 +668,9 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
>   	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
>   		return fs_info->quota_enabled ? fs_info->quota_root :
>   				ERR_PTR(-ENOENT);
> +	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
> +        return fs_info->free_space_root ? fs_info->free_space_root :
> +                                                  ERR_PTR(-ENOENT);
>   
>   	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
>   	       location->offset != (u64)-1);
> 


