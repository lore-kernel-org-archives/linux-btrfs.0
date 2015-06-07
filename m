Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47368 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbFGKE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jun 2015 06:04:57 -0400
Message-ID: <55741732.7000403@oracle.com>
Date: Sun, 07 Jun 2015 18:04:34 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: fdmanana@gmail.com
Subject: Re: replace seed/sprout hangs (regression ?)
References: <54C0CAFB.4020708@oracle.com> <CAL3q7H59s0d9EwMzSRUc59r6W3zOJNm=wUzYxNcaL3ZCi4kUyA@mail.gmail.com>
In-Reply-To: <CAL3q7H59s0d9EwMzSRUc59r6W3zOJNm=wUzYxNcaL3ZCi4kUyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



    I can't reproduce this bug with 4.x any thing that fixed this ?

Thanks, Anand


On 01/22/2015 06:12 PM, Filipe David Manana wrote:
> On Thu, Jan 22, 2015 at 10:03 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>>
>>   The following test case hangs as of now, but as I remember Fujitsu
>>   had sent a patch to fix this, a long time back. Can't find now,
>>   any idea. ?
>>
>>   Test case:
>>     add a spout device
>>     replace seed / sprout device
>>
>>   hangs at:
>>    (btrfs_reada_wait+0x4d/0xb0)
>
> No idea when it happened.
> But perhaps, it's a good time to start having an xfstest for it? :)
>
> thanks
>
>>
>> Thanks, Anand
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
