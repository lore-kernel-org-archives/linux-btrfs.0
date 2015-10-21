Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61138 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbbJUO2Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 10:28:25 -0400
Subject: Re: [RFC PATCH 2/3] btrfs-progs: kernel based default features for
 mkfs
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
 <1445417149-804-2-git-send-email-anand.jain@oracle.com>
 <562756ED.1090302@cn.fujitsu.com> <56279E0E.4030407@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5627A05A.4080708@gmx.com>
Date: Wed, 21 Oct 2015 22:25:30 +0800
MIME-Version: 1.0
In-Reply-To: <56279E0E.4030407@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年10月21日 22:15, Anand Jain 写道:
>
> Thanks for the comments.. more below.
>
> On 10/21/2015 05:12 PM, Qu Wenruo wrote:
>>
>>
>> Anand Jain wrote on 2015/10/21 16:45 +0800:
>>> mkfs from latest btrfs-progs will enable latest default features,
>>> and if the kernel is down-rev and does not support a latest default
>>> feature then mount fails, as expected.
>>>
>>> This patch disables default features based on the running kernel.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   mkfs.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mkfs.c b/mkfs.c
>>> index a5802f7..2b9d734 100644
>>> --- a/mkfs.c
>>> +++ b/mkfs.c
>>> @@ -1357,10 +1357,13 @@ int main(int ac, char **av)
>>>       int dev_cnt = 0;
>>>       int saved_optind;
>>>       char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
>>> -    u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
>>> +    u64 features;
>>>       struct mkfs_allocation allocation = { 0 };
>>>       struct btrfs_mkfs_config mkfs_cfg;
>>>
>>> +    features = btrfs_features_allowed_by_kernel();
>>> +    features &= BTRFS_MKFS_DEFAULT_FEATURES;
>>> +
>>
>> Despite the problem of btrfs_features_allowed_by_kernel() I mentioned in
>> previous mail,
>> the behavior is a little aggressive for me.
>>
>> So a user with old kernel won't be able to create a filesystem with
>> newer feature forever.
>> Maybe the user are just making btrfs for his or her newer kernel?
>
>    I am not understanding the complete picture here, is there any
> example that you can quote. ?
>
> Thanks, Anand
>

Sorry my fault.
Your features are set before parse_fs_features()

So it's just my misunderstanding.

However, I still prefer warning other than just changing default features.

Thanks,
Qu

>> IMHO, it's better to output a warning other than just change features
>> without any information.
>>
>> Thanks,
>> Qu
>>
>>>       while(1) {
>>>           int c;
>>>           static const struct option long_options[] = {
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
