Return-Path: <SRS0=UsBE=QC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEE4C282C0
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 01:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 692B0218FF
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 01:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfAZBiA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 20:38:00 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:35770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725975AbfAZBiA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 20:38:00 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2CB48550CD59987EE818;
        Sat, 26 Jan 2019 09:37:57 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Sat, 26 Jan 2019
 09:37:53 +0800
Subject: Re: [PATCH -next] btrfs: qgroup: Fix inconsistent IS_ERR and PTR_ERR
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
References: <1548381009-80383-1-git-send-email-yuehaibing@huawei.com>
 <87ac97b6-2b14-9b48-ed28-4d0cbce7322f@gmx.com>
CC:     <linux-btrfs@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <904a130c-1f9b-2d67-1096-258d3c8bd52e@huawei.com>
Date:   Sat, 26 Jan 2019 09:37:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <87ac97b6-2b14-9b48-ed28-4d0cbce7322f@gmx.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/25 9:59, Qu Wenruo wrote:
> 
> 
> On 2019/1/25 上午9:50, YueHaibing wrote:
>> Change the call to PTR_ERR to access the value just tested by IS_ERR.
>>
>> Fixes: 2b35a512e9cf ("btrfs: qgroup: Use delayed subtree rescan for balance")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  fs/btrfs/qgroup.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 8559ed9..16d7ec8 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -3931,7 +3931,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
>>  				   block->reloc_generation, block->level,
>>  				   &block->first_key);
>>  	if (IS_ERR(reloc_eb)) {
>> -		ret = PTR_ERR(subv_eb);
>> +		ret = PTR_ERR(reloc_eb);
> 
> Nice catch.
> 
> I'll fold the this fix in my original patch if it's OK for you.

Ok, sure.

> 
> Thanks,
> Qu
> 
>>  		reloc_eb = NULL;
>>  		goto free_out;
>>  	}
>>
>>
>>
> 

