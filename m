Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422939AbeCBIhU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 03:37:20 -0500
Subject: Re: [PATCH 5/5] btrfs: Show more accurate max_inline
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-6-wqu@suse.com>
 <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
 <b9f5f159-156d-1346-a4fa-d1eadf3223f4@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b87b3090-0edd-1120-19c0-2adcacee6097@suse.com>
Date: Fri, 2 Mar 2018 10:37:17 +0200
MIME-Version: 1.0
In-Reply-To: <b9f5f159-156d-1346-a4fa-d1eadf3223f4@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.03.2018 10:34, Qu Wenruo wrote:
> 
> 
> On 2018年03月02日 16:21, Misono, Tomohiro wrote:
>> On 2018/03/02 14:22, Qu Wenruo wrote:
>>> Btrfs shows max_inline option into kernel message, but for
>>> max_inline=4096, btrfs won't really inline 4096 bytes inline data if
>>> it's not compressed.
>>
>> Hello,
>> I have a question.
>>
>> man mount(8) says: 
>>    max_inline=bytes
>>           Specify  the  maximum  amount  of space, in bytes, that can be
>>           inlined in a metadata B-tree leaf.  The value is specified  in
>>           bytes,  optionally with a K, M, or G suffix, case insensitive.
>>           In practice, this value is limited by the  root  sector  size,
>>           with  some  space  unavailable  due to leaf headers.  For a 4k
>>           sectorsize, max inline data is ~3900 bytes.
>>
>> So, is the size of 4k-(size of leaf header) actually the maximum value
>> of max_inline instead of 4095 for 4k sectorsize?
> 
> Not exactly.
> 
> For 4K nodesize, max_inline would be 3960 bytes.
> As leaf header and EXTENT_ITEM header takes extra bytes.
> 
> For 16K nodesize (default), we can go up to 4095 bytes then.
> 
> And that man page needs updated, as it should be 4K *nodesize*.

Actually Qu what is preventing the btrfs_drop_extents of dropping inline
extents larger than pagesize? This why you are doing this patchset, right ?

> 
> Thanks,
> Qu
> 
>>
>> Thanks,
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
