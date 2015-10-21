Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31513 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbbJUOQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 10:16:15 -0400
Message-ID: <56279E0E.4030407@oracle.com>
Date: Wed, 21 Oct 2015 22:15:42 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] btrfs-progs: kernel based default features for
 mkfs
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com> <1445417149-804-2-git-send-email-anand.jain@oracle.com> <562756ED.1090302@cn.fujitsu.com>
In-Reply-To: <562756ED.1090302@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for the comments.. more below.

On 10/21/2015 05:12 PM, Qu Wenruo wrote:
>
>
> Anand Jain wrote on 2015/10/21 16:45 +0800:
>> mkfs from latest btrfs-progs will enable latest default features,
>> and if the kernel is down-rev and does not support a latest default
>> feature then mount fails, as expected.
>>
>> This patch disables default features based on the running kernel.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   mkfs.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/mkfs.c b/mkfs.c
>> index a5802f7..2b9d734 100644
>> --- a/mkfs.c
>> +++ b/mkfs.c
>> @@ -1357,10 +1357,13 @@ int main(int ac, char **av)
>>       int dev_cnt = 0;
>>       int saved_optind;
>>       char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
>> -    u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
>> +    u64 features;
>>       struct mkfs_allocation allocation = { 0 };
>>       struct btrfs_mkfs_config mkfs_cfg;
>>
>> +    features = btrfs_features_allowed_by_kernel();
>> +    features &= BTRFS_MKFS_DEFAULT_FEATURES;
>> +
>
> Despite the problem of btrfs_features_allowed_by_kernel() I mentioned in
> previous mail,
> the behavior is a little aggressive for me.
>
> So a user with old kernel won't be able to create a filesystem with
> newer feature forever.
> Maybe the user are just making btrfs for his or her newer kernel?

   I am not understanding the complete picture here, is there any 
example that you can quote. ?

Thanks, Anand

> IMHO, it's better to output a warning other than just change features
> without any information.
>
> Thanks,
> Qu
>
>>       while(1) {
>>           int c;
>>           static const struct option long_options[] = {
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
