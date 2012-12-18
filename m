Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19062 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2LRCri (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 21:47:38 -0500
Message-ID: <50CFD93F.3030106@oracle.com>
Date: Tue, 18 Dec 2012 10:47:27 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: kreijack@inwind.it, Goffredo Baroncelli <kreijack@gmail.com>,
        linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [RFC PATCH V5 2/2] Btrfs: Add a new ioctl to change the label
 of a mounted file system
In-Reply-To: <50CFD601.3000107@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50CF0063.3060503@oracle.com>
 <50CF08A8.9010504@cn.fujitsu.com>
 <50CF1E5A.8030407@oracle.com>
 <50CF57B1.1000106@gmail.com>
 <50CFD32A.6070501@cn.fujitsu.com>
 <50CFD601.3000107@oracle.com>

On 12/18/2012 10:33 AM, Jeff Liu wrote:
> On 12/18/2012 10:21 AM, Miao Xie wrote:
>> On 	mon, 17 Dec 2012 18:34:41 +0100, Goffredo Baroncelli wrote:
>>> On 12/17/2012 02:30 PM, Jeff Liu wrote:
>>>> On 12/17/2012 07:57 PM, Miao Xie wrote:
>>>>> On 	mon, 17 Dec 2012 19:22:11 +0800, Jeff Liu wrote:
>>>>>> Introduce a new ioctl BTRFS_IOC_SET_FSLABEL to change the label of a mounted file system.
>>>>>>
>>>>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>>>> Cc: Miao Xie <miaox@cn.fujitsu.com>
>>> [...]
>>>>>> +
>>>>>> +	if (strlen(label) > BTRFS_LABEL_SIZE - 1)
>>>>>> +		return -EINVAL;
>>>>>
>>>>> I think we should use strnlen()
>>>> AFAICS, strnlen() is better only if the caller need to get the length of
>>>> a length-limited string and make use of it proceeding, which means that
>>>> the procedure would not return an error even if the length is beyond the
>>>> limit.  Or if the caller need to examine if a length-limited string is
>>>> nul-terminated or not in a manner below,
>>>> if (strnlen(buf, MAX_BUF_SIZE) == MAX_BUF_SIZE) {
>>>> 	....
>>>> }
>>>>
>>>> I don't think it really needed here since the logic is clear with
>>>> strlen(), or Am I miss anything?
>>>
>>> I think that Miao fears strlen() searching a zero could go beyond the
>>> page limit touching an un-mapped page and raising an segmentation fault....
>>
>> Yes, so I think the following check is better.
>>
>> if (strnlen(buf, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE)
>> 	return -EINVAL;
> Generally speaking, the user would not input a large string for normal
> purpose, so strnlen() will always have a bit waste(can be ignore here)
> with the counter self-check. i.e. for (; count--, ;).
>> Thanks
>> Miao
>>
>>> I think that we should change the code as
>>>
>>> +	label[BTRFS_LABEL_SIZE - 1] = 0;
>>> +
>>> +	if (strlen(label) > BTRFS_LABEL_SIZE - 1)
>>> +		return -EINVAL;
> Both suggestion are fine to me, but I prefer to above approach.
Oh No, Miao is right.  We can not perform the check as above because we
have already made the last character of label to NUL, hence
"strlen(label) > BTRFS_LABEL_SIZE -1" will be an invalid checking even
if the input string is longer than BTRFS_LABEL_SIZE -1.

Thanks,
-Jeff
> 
> Thanks,
> -Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

