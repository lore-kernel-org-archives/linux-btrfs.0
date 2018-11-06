Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D872C0044C
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 01:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DD5420827
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 01:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DD5420827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbeKFKbt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 05:31:49 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:14172 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbeKFKbt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 05:31:49 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6369ECBF7BECD;
        Tue,  6 Nov 2018 09:09:13 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Tue, 6 Nov 2018
 09:09:11 +0800
Subject: Re: [PATCH] btrfs: tree-checker: Fix misleading group system
 information
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <1541414949-16300-1-git-send-email-zhangshaokun@hisilicon.com>
 <425b8a43-ec24-82f7-0627-82edc81e329d@gmx.com>
 <044651c8-b5b7-2ec2-bf22-bdd967e24eb6@hisilicon.com>
 <5477c8b2-8b0f-58ff-d4c6-ea95521049f4@gmx.com>
CC:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
From:   Zhangshaokun <zhangshaokun@hisilicon.com>
Message-ID: <b835cc55-6a84-6c8b-f293-41899630b3b6@hisilicon.com>
Date:   Tue, 6 Nov 2018 09:09:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <5477c8b2-8b0f-58ff-d4c6-ea95521049f4@gmx.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

On 2018/11/5 22:42, Qu Wenruo wrote:
> 
> 
> On 2018/11/5 下午7:33, Zhangshaokun wrote:
>> Hi Qu,
>>
>> On 2018/11/5 19:03, Qu Wenruo wrote:
>>>
>>>
>>> On 2018/11/5 下午6:49, Shaokun Zhang wrote:
>>>> block_group_err shows the group system as a decimal value with a '0x'
>>>> prefix, which is somewhat misleading.
>>>>
>>>> Fix it to print hexadecimal, as was intended.
>>>>
>>>> Cc: David Sterba <dsterba@suse.com> 
>>>> Cc: Chris Mason <clm@fb.com>
>>>> Cc: Josef Bacik <josef@toxicpanda.com> 
>>>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>>>
>>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>>
>>> BTW, did you catch it with some real world case or just by looking into
>>> the code?
>>
>> I made a mistake (0x%d) when debugged my code, so I grep the similar format
>> for the kernel code and came across this typo, a trivial patch.
> 
> Ok, that's fine.
> 
> Just a small tip for your further involvement in kernel, for such small
> fix, there is really no need to bother all the maintainers.
> 

My apologies for the noise to all the maintainers. I shall pay more attention
on it.

> You could just use "git blame" to find who is causing the problem, in
> this case it's me unfortunately :( , and Cc that guy.
> 

In fact, I really used the "git blame" and saw it from your patch. While I
use the get_maintainer.pl and Cc them directly, forgot to Cc you. I will
do what you said for the further work.

> Furthermore, you could add a "fixes:" tag.
> About these common tags, you could refer to 'Describe your changes'
> section of 'Documentation/process/submitting-patches.rst'.
> 

Sure, thanks for your nice guidance.

Shaokun

> Thanks,
> Qu
> 
>>
>> Thanks,
>> Shaokun
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>> ---
>>>>  fs/btrfs/tree-checker.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>>>> index cab0b1f..efcf89a 100644
>>>> --- a/fs/btrfs/tree-checker.c
>>>> +++ b/fs/btrfs/tree-checker.c
>>>> @@ -440,7 +440,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
>>>>  	    type != (BTRFS_BLOCK_GROUP_METADATA |
>>>>  			   BTRFS_BLOCK_GROUP_DATA)) {
>>>>  		block_group_err(fs_info, leaf, slot,
>>>> -"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x%llu or 0x%llx",
>>>> +"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x%llx or 0x%llx",
>>>>  			type, hweight64(type),
>>>>  			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
>>>>  			BTRFS_BLOCK_GROUP_SYSTEM,
>>>>
>>>
>>
> 

