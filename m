Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48351 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751865AbdHCP24 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Aug 2017 11:28:56 -0400
Subject: Re: [PATCH] Btrfs: avoid unnecessarily locking inode when clearing a
 range
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <fdmanana@kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20170727185255.5122-1-fdmanana@kernel.org>
 <e19d649f-8ee6-fade-f4d9-c303a2e01fcc@fb.com>
 <CAP9B-QnAMtTHGxTe-A72uK_1m-vmAxSKj-No63R3NSXjwE=b1g@mail.gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <0fd7da41-9111-0ab6-0aa4-bf68bfa671be@fb.com>
Date: Thu, 3 Aug 2017 11:28:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAP9B-QnAMtTHGxTe-A72uK_1m-vmAxSKj-No63R3NSXjwE=b1g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/03/2017 11:25 AM, Wang Shilong wrote:
> On Thu, Aug 3, 2017 at 11:00 PM, Chris Mason <clm@fb.com> wrote:
>>
>>
>> On 07/27/2017 02:52 PM, fdmanana@kernel.org wrote:
>>>
>>> From: Filipe Manana <fdmanana@suse.com>
>>>
>>> If the range being cleared was not marked for defrag and we are not
>>> about to clear the range from the defrag status, we don't need to
>>> lock and unlock the inode.
>>>
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>
>>
>> Thanks Filipe, looks like it goes all the way back to:
>>
>> commit 47059d930f0e002ff851beea87d738146804726d
>> Author: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Date:   Thu Jul 3 18:22:07 2014 +0800
>>
>>      Btrfs: make defragment work with nodatacow option
>>
>> I can't see how the inode lock is required here.
> 
> This blames to me, thanks for fixing it.

No blame ;)  I'll take code that works any day.

-chris
