Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14521 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965178Ab3HHLNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 07:13:40 -0400
Message-ID: <52037A76.3000707@cn.fujitsu.com>
Date: Thu, 08 Aug 2013 19:01:10 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: catch error return value from find_extent_in_eb()
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1375938259-5015-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <CAL3q7H77CCD9saViLZukwHtmi3=PHkxiOy4rc+z1ftvHfOuK=w@mail.gmail.com>
In-Reply-To: <CAL3q7H77CCD9saViLZukwHtmi3=PHkxiOy4rc+z1ftvHfOuK=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/2013 06:24 PM, Filipe David Manana wrote:
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

Yeah, just ignore my patch.

Thanks,
Wang
> 
> thanks
> 

