Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37222 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753522AbdCQAfM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 20:35:12 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: convert: Make btrfs_reserved_ranges
 const
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170316031831.28006-1-quwenruo@cn.fujitsu.com>
 <20170316031831.28006-2-quwenruo@cn.fujitsu.com>
 <20170316163325.GL14605@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5c30fbd8-d9e5-b03f-4d0c-6ad7a7dd33cd@cn.fujitsu.com>
Date: Fri, 17 Mar 2017 08:35:01 +0800
MIME-Version: 1.0
In-Reply-To: <20170316163325.GL14605@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/17/2017 12:33 AM, David Sterba wrote:
> On Thu, Mar 16, 2017 at 11:18:31AM +0800, Qu Wenruo wrote:
>> Since btrfs_reserved_ranges array is just used to store btrfs reserved
>> ranges, no one will nor should modify them at run time, make them static
>> and const will be better.
>>
>> This also eliminates the use of immediate number 3.
>
> Adding const is fine, but you shouldn't define the structure inside
> header, even as static.

Any reason why we shouldn't define const static array in header?

Is extra .text segments usage the problem?

Thanks,
Qu

> The number 3 needs to stay so we can use
> ARRAY_SIZE.
>
>


