Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26476 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030461Ab2ERCDN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 22:03:13 -0400
Message-ID: <4FB5AD85.2020308@cn.fujitsu.com>
Date: Fri, 18 May 2012 10:01:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] Btrfs: count the chunks which will be relocated at
 first
References: <4FB4E785.4050902@cn.fujitsu.com> <20120517145856.GA1934@zambezi.lan>
In-Reply-To: <20120517145856.GA1934@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 17 May 2012 17:58:56 +0300, Ilya Dryomov wrote:
> On Thu, May 17, 2012 at 07:56:53PM +0800, Miao Xie wrote:
>> the balance function should count the chunks which will be relocated at first,
>> and then relocate those chunks one by one.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/volumes.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 759d024..91da8a2 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2580,7 +2580,7 @@ again:
>>  
>>  		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
>>  
>> -		if (!counting) {
>> +		if (counting) {
>>  			spin_lock(&fs_info->balance_lock);
>>  			bctl->stat.considered++;
>>  			spin_unlock(&fs_info->balance_lock);
> 
> __btrfs_balance() already calculates the approximate number of chunks
> that will be relocated and stores that value in bctl->stat.expected.
> The stat.considered counter OTOH is supposed to reflect the number of
> chunks processed through balance filters and it is meant to be updated
> at relocation pass, so AFAICS if (!counting) is the right test.
> 
> What exactly are you trying to fix here ?

In fact this number reflect the number of all the chunks that may be relocated.
So since we can know the approximate number of chunks that will be relocated
before the relocation start, why can not we know it at the beginning?

And beside that, as a user, I am very strange that this counter is changed
every time I get the status of the balance, it should be the fixed number
since it reflect the number of all the chunks that may be relocated.

Thanks
Miao
