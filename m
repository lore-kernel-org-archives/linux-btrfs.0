Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:59526 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965139Ab3HHLGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 07:06:43 -0400
Message-ID: <52037BC2.8050902@jan-o-sch.net>
Date: Thu, 08 Aug 2013 13:06:42 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: catch error return value from find_extent_in_eb()
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1375938259-5015-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <CAL3q7H77CCD9saViLZukwHtmi3=PHkxiOy4rc+z1ftvHfOuK=w@mail.gmail.com>
In-Reply-To: <CAL3q7H77CCD9saViLZukwHtmi3=PHkxiOy4rc+z1ftvHfOuK=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
On Thu, August 08, 2013 at 12:24 (+0200), Filipe David Manana wrote:
> On Thu, Aug 8, 2013 at 6:04 AM, Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
>> find_extent_in_eb() may return ENOMEM, catch this error return value.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/backref.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 54e7610..f7781e6 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -934,6 +934,10 @@ again:
>>                                 }
>>                                 ret = find_extent_in_eb(eb, bytenr,
>>                                                         *extent_item_pos, &eie);
>> +                               if (ret) {
>> +                                       free_extent_buffer(eb);
>> +                                       goto out;
>> +                               }
>>                                 ref->inode_list = eie;
>>                                 free_extent_buffer(eb);
>>                         }
> 
> Hello, this is a duplicate of:  https://patchwork.kernel.org/patch/2835989/

Your linked patch checks for ret < 0, which is a safer option since there are
functions down the stack returning > 0 or 0 for success and < 0 for errors.
Currently, find_extent_in_eb doesn't return their return values, but I'd rather
be a bit more on the safe side and use your patch.

Thanks,
-Jan
