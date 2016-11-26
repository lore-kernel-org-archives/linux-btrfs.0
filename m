Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38766 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751774AbcKZRTF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Nov 2016 12:19:05 -0500
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <fd6f5be1-9f18-2311-403b-06bfd7abd28d@fb.com>
 <f182add7-4a1c-b882-4732-338f32debf87@cn.fujitsu.com>
CC: <kreijack@inwind.it>, <ce3g8jdj@umail.furryterror.org>
From: Chris Mason <clm@fb.com>
Message-ID: <c1fd7ac1-f2b3-b9d6-c4c7-6f8d57087902@fb.com>
Date: Sat, 26 Nov 2016 12:18:44 -0500
MIME-Version: 1.0
In-Reply-To: <f182add7-4a1c-b882-4732-338f32debf87@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/22/2016 07:26 PM, Qu Wenruo wrote:
>
>>
>> We're changing which pages we kmap() but not which ones we kunmap(). Can
>> you please update the kunmap loop to use this pointers array?  Also it
>> looks like this kmap is never unmapped.
>
> Oh I forget that.
> I'll update it soon.

Thanks!

>
> This reminds me, is there any kernel debug option to trace such unmapped
> pages?
>

I don't think so, which is surprising.  It explodes so quickly on 32 bit 
machines, its easiest to boot it on a 32 bit qemu.

-chris

