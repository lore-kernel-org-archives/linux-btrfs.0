Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54460 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2IMBIl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 21:08:41 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 1BC033EE0C7
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 10:08:37 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 03A7445DEBB
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 10:08:37 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id DDBD645DEB7
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 10:08:36 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id BF8A21DB8041
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 10:08:36 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 781431DB803E
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 10:08:36 +0900 (JST)
Message-ID: <50513208.3010202@jp.fujitsu.com>
Date: Thu, 13 Sep 2012 10:08:24 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup of error processing in btree_get_extent()
References: <201209120826.AA00007@FM-323941448.jp.fujitsu.com> <505065FB.4040200@giantdisaster.de>
In-Reply-To: <505065FB.4040200@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Stefan,

(2012/09/12 19:37), Stefan Behrens wrote:
> On Wed, 12 Sep 2012 17:26:43 +0900, Tsutomu Itoh wrote:
>> This patch simplifies a little complex error processing in
>> btree_get_extent().
>>
>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> ---
>>   fs/btrfs/disk-io.c |   14 +++++---------
>>   1 files changed, 5 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 29c69e6..27d0ebe 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -222,21 +222,17 @@ static struct extent_map *btree_get_extent(struct inode *inode,
>>
>>   		free_extent_map(em);
>>   		em = lookup_extent_mapping(em_tree, start, len);
>> -		if (em) {
>> -			ret = 0;
>> -		} else {
>> -			em = lookup_extent_mapping(em_tree, failed_start,
>> -						   failed_len);
>> -			ret = -EIO;
>> +		if (!em) {
>> +			lookup_extent_mapping(em_tree, failed_start,
>> +					      failed_len);
>> +			em = ERR_PTR(-EIO);
>
> The patch itself looks good and doesn't change the behavior while it
> simplifies the code. But I think that it identifies an old error in the
> code. It is eye-catching the the return value of lookup_extent_mapping()
> is not used. Therefore the call can either be removed or it has
> side-effects which are required. lookup_extent_mapping() has the
> side-effect to increment the extent map's ref count that it returns. I
> cannot believe that this incremented ref count is correct when the
> extent map itself is not used. IMO, either the EIO and ignoring the
> returned extent map is wrong, or the incremented ref count is wrong.

Thank you for your review.
I think lookup_extent_mapping() using failed_start is not needed.
So, I will remake my patch later.

Thanks,
Tsutomu

>
>>   		}
>>   	} else if (ret) {
>>   		free_extent_map(em);
>> -		em = NULL;
>> +		em = ERR_PTR(ret);
>>   	}
>>   	write_unlock(&em_tree->lock);
>>
>> -	if (ret)
>> -		em = ERR_PTR(ret);
>>   out:
>>   	return em;
>>   }
>
>
>


