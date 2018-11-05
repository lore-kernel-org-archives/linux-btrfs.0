Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20A6C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 11:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ED952085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 11:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ED952085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbeKEUwr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:52:47 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:14592 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726319AbeKEUwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 15:52:46 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5F5D08C541A60;
        Mon,  5 Nov 2018 19:33:27 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.408.0; Mon, 5 Nov 2018
 19:33:27 +0800
Subject: Re: [PATCH] btrfs: tree-checker: Fix misleading group system
 information
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <1541414949-16300-1-git-send-email-zhangshaokun@hisilicon.com>
 <425b8a43-ec24-82f7-0627-82edc81e329d@gmx.com>
CC:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
From:   Zhangshaokun <zhangshaokun@hisilicon.com>
Message-ID: <044651c8-b5b7-2ec2-bf22-bdd967e24eb6@hisilicon.com>
Date:   Mon, 5 Nov 2018 19:33:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <425b8a43-ec24-82f7-0627-82edc81e329d@gmx.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

On 2018/11/5 19:03, Qu Wenruo wrote:
> 
> 
> On 2018/11/5 下午6:49, Shaokun Zhang wrote:
>> block_group_err shows the group system as a decimal value with a '0x'
>> prefix, which is somewhat misleading.
>>
>> Fix it to print hexadecimal, as was intended.
>>
>> Cc: David Sterba <dsterba@suse.com> 
>> Cc: Chris Mason <clm@fb.com>
>> Cc: Josef Bacik <josef@toxicpanda.com> 
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> BTW, did you catch it with some real world case or just by looking into
> the code?

I made a mistake (0x%d) when debugged my code, so I grep the similar format
for the kernel code and came across this typo, a trivial patch.

Thanks,
Shaokun

> 
> Thanks,
> Qu
> 
>> ---
>>  fs/btrfs/tree-checker.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index cab0b1f..efcf89a 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -440,7 +440,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
>>  	    type != (BTRFS_BLOCK_GROUP_METADATA |
>>  			   BTRFS_BLOCK_GROUP_DATA)) {
>>  		block_group_err(fs_info, leaf, slot,
>> -"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x%llu or 0x%llx",
>> +"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x%llx or 0x%llx",
>>  			type, hweight64(type),
>>  			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
>>  			BTRFS_BLOCK_GROUP_SYSTEM,
>>
> 

