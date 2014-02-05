Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16675 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbaBEQU4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 11:20:56 -0500
Message-ID: <52F264E2.3050507@fb.com>
Date: Wed, 5 Feb 2014 11:20:50 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: switch to btrfs_previous_extent_item()
References: <1391186525-2965-1-git-send-email-wangshilong1991@gmail.com> <CAL3q7H7n+L2CqT9whDDT1ZjUzgU378HUhOuQHhjKUp7eiKD=aw@mail.gmail.com> <337FC422-D102-4310-A714-FA35538DD402@gmail.com> <23FBD0CF-ABE2-4135-8522-7B24E90911B9@gmail.com>
In-Reply-To: <23FBD0CF-ABE2-4135-8522-7B24E90911B9@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/05/2014 11:14 AM, Wang Shilong wrote:
> Hi Filipe,
>
>> So i knew what was wrong here, we need found_key while btrfs_previous_extent_item() did set
>> it properly..^_^
>>
>> I will send a v2 to fix this, thanks!
>>
>>
>>> On Fri, Jan 31, 2014 at 4:42 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:
>>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>>
>>>> Since we have introduced btrfs_previous_extent_item() to search previous
>>>> extent item, just switch into it.
>>>>
>>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> Hi Shilong,
>>>
>>> This patch is making btrfs/004 fail for me, consistently:
> I was trying to reproduce this xfstest failure(though we have known what's wrong with my previous patch).
> I did not really hit 004 failure, but i can reproduce btrfs/030 fail consistently, i think you might be interested in this:
>
Do you guys have some CONFIG_ONLY_BREAK_FOR_ME=y set or something? I 
can't reproduce this failure either.  Will you send the updated 
btrfs_previous_extent_item patch and then see if you can bisect down why 
030 is failing for you?  Thanks,

Josef
