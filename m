Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71245C10F0B
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 07:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 419022083D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 07:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388000AbfDRHeY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 03:34:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54616 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729446AbfDRHeY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 03:34:24 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 98EBEC5D5E067E109CB5;
        Thu, 18 Apr 2019 15:34:18 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.408.0; Thu, 18 Apr 2019
 15:34:15 +0800
Subject: Re: [PATCH -next] btrfs: Remove set but not used variable 'fs_info'
To:     Nikolay Borisov <nborisov@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <20190418064356.10418-1-yuehaibing@huawei.com>
 <0d280de4-9ef4-1531-5bad-22ea15cc150c@suse.com>
CC:     <linux-btrfs@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <b2b59b30-e1de-bea3-d25b-ff3a10796f7d@huawei.com>
Date:   Thu, 18 Apr 2019 15:34:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <0d280de4-9ef4-1531-5bad-22ea15cc150c@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


On 2019/4/18 14:37, Nikolay Borisov wrote:
> 
> 
> On 18.04.19 г. 9:43 ч., YueHaibing wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> fs/btrfs/free-space-tree.c: In function 'load_free_space_tree':
>> fs/btrfs/free-space-tree.c:1535:24: warning:
>>  variable 'fs_info' set but not used [-Wunused-but-set-variable]
>>
>> It's not used since commit 05e9d3137d47 ("btrfs: get fs_info from block group
>> in search_free_space_info"),  so can be removed.
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  fs/btrfs/free-space-tree.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
>> index cfe9dfb0ff05..f5dc115ebba0 100644
>> --- a/fs/btrfs/free-space-tree.c
>> +++ b/fs/btrfs/free-space-tree.c
>> @@ -1532,14 +1532,12 @@ static int load_free_space_extents(struct btrfs_caching_control *caching_ctl,
>>  int load_free_space_tree(struct btrfs_caching_control *caching_ctl)
>>  {
>>  	struct btrfs_block_group_cache *block_group;
>> -	struct btrfs_fs_info *fs_info;
>>  	struct btrfs_free_space_info *info;
>>  	struct btrfs_path *path;
>>  	u32 extent_count, flags;
>>  	int ret;
>>  
>>  	block_group = caching_ctl->block_group;
>> -	fs_info = block_group->fs_info;
> 
> What version is this patch based on? In current misc-next ( on which new
> patches ought to be based  and can be found at: currently has:

This patch based on linux-next tree:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=05e9d3137d47

> 
> fs_info = block_group->fs_info;
> root = fs_info->free_space_root;
> 
> ......
> 
> if (extent_count != expected_extent_count) {
>                   btrfs_err(fs_info,
> 
>                             "incorrect extent count for %llu; counted
> %u, expected %u",
>                             block_group->key.objectid, extent_count,
> 
>                             expected_extent_count);
> 
> In short: nack
> 
>>  
>>  	path = btrfs_alloc_path();
>>  	if (!path)
>>
>>
>>
>>
> 
> 

