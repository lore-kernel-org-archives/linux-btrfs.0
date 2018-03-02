Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422876AbeCBIdc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 03:33:32 -0500
Subject: Re: [PATCH 5/5] btrfs: Show more accurate max_inline
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-6-wqu@suse.com>
 <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4c45603e-6747-a30c-3ed9-1fecb48fc358@suse.com>
Date: Fri, 2 Mar 2018 10:33:29 +0200
MIME-Version: 1.0
In-Reply-To: <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.03.2018 10:21, Misono, Tomohiro wrote:
> On 2018/03/02 14:22, Qu Wenruo wrote:
>> Btrfs shows max_inline option into kernel message, but for
>> max_inline=4096, btrfs won't really inline 4096 bytes inline data if
>> it's not compressed.
> 
> Hello,
> I have a question.
> 
> man mount(8) says: 
>    max_inline=bytes
>           Specify  the  maximum  amount  of space, in bytes, that can be
>           inlined in a metadata B-tree leaf.  The value is specified  in
>           bytes,  optionally with a K, M, or G suffix, case insensitive.
>           In practice, this value is limited by the  root  sector  size,
>           with  some  space  unavailable  due to leaf headers.  For a 4k
>           sectorsize, max inline data is ~3900 bytes.
> 
> So, is the size of 4k-(size of leaf header) actually the maximum value
> of max_inline instead of 4095 for 4k sectorsize?

I think the documentation is wrong. Without patch 3/5 we have the max
inline data size as:

BTRFS_MAX_ITEM_SIZE(info) - BTRFS_FILE_EXTENT_INLINE_DATA_START

so MAX_ITEM_SIZE  = nodesize - sizeof(btrfs_header) -
sizeof(btrfs_item).  So this gives us the data portion in the leaf.

So if we substitute the raw number we get:

16k - 101 - 25 = 16258 bytes.

>From this number we also subtract the offset of disk_bytenr in
btrfs_file_extent_item (which is 21). So we end up with
MAX_INLINE_DATA_SIZE of 16258 - 21 = 16237

With Qu's patch the min_t will always be taking 4095 as the
MAX_INLINE_DATA_SIZE.

> 
> Thanks,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
