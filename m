Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11313 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755483AbcLOIVf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 03:21:35 -0500
Subject: Re: [PATCH] btrfs-progs: Fix NULL pointer when receive clone
 operation
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
References: <20161215072802.21452-1-quwenruo@cn.fujitsu.com>
 <fb824e22-658e-80f5-bb77-041ce0b6088e@jp.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b0d38b0a-587f-ba4a-b043-41c7feccf404@cn.fujitsu.com>
Date: Thu, 15 Dec 2016 16:20:42 +0800
MIME-Version: 1.0
In-Reply-To: <fb824e22-658e-80f5-bb77-041ce0b6088e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/15/2016 04:07 PM, Tsutomu Itoh wrote:
> On 2016/12/15 16:28, Qu Wenruo wrote:
>> The subvol_info returned from subvol_uuid_search() can be NULL.
>> So the branch checking IS_ERR(si) should also check if it's NULL.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  cmds-receive.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/cmds-receive.c b/cmds-receive.c
>> index cb42aa2..c8f2fff 100644
>> --- a/cmds-receive.c
>> +++ b/cmds-receive.c
>> @@ -750,7 +750,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
>>  	si = subvol_uuid_search(&rctx->sus, 0, clone_uuid, clone_ctransid,
>>  				NULL,
>>  				subvol_search_by_received_uuid);
>> -	if (IS_ERR(si)) {
>> +	if (IS_ERR(si) || !si) {
>
> Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>
> But I like  if (!si || IS_ERR(si)) {
>
> Thanks,
> Tsutomu
>

Thanks　for the test.
But it seems that there are more such problems.

I'd better introduce a new macro, IS_ERR_OR_NULL() to handle it.
Since all the modification commit a2f7af94 introduced can return NULL.

I'll update the patchset soon.

Thanks,
Qu

>>  		if (memcmp(clone_uuid, rctx->cur_subvol.received_uuid,
>>  				BTRFS_UUID_SIZE) == 0) {
>>  			/* TODO check generation of extent */
>>
>
>
>


