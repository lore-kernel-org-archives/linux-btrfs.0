Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33377 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2JQCDF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 22:03:05 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so6946682oag.19
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2012 19:03:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121017020012.GA13769@localhost>
References: <08589dd39c78346ec2ed2fedfd6e3121ca38acda.1350413420.git.rprabhu@wnohang.net>
 <20121017020012.GA13769@localhost>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 16 Oct 2012 22:02:44 -0400
Message-ID: <CAHGf_=qxMv20bNg2FZLCO2Ra0S+zTicxQEXu=nOTc-f3kiWj-Q@mail.gmail.com>
Subject: Re: [PATCH] Change the check for PageReadahead into an else-if
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: raghu.prabhu13@gmail.com, zheng.yan@oracle.com, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 16, 2012 at 10:00 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Wed, Oct 17, 2012 at 12:28:05AM +0530, raghu.prabhu13@gmail.com wrote:
>> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>
>> >From 51daa88ebd8e0d437289f589af29d4b39379ea76, page_sync_readahead coalesces
>> async readahead into its readahead window, so another checking for that again is
>> not required.
>>
>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>> ---
>>  fs/btrfs/relocation.c | 10 ++++------
>>  mm/filemap.c          |  3 +--
>>  2 files changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 4da0865..6362003 100644
>
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -2996,12 +2996,10 @@ static int relocate_file_extent_cluster(struct inode *inode,
>>                               ret = -ENOMEM;
>>                               goto out;
>>                       }
>> -             }
>> -
>> -             if (PageReadahead(page)) {
>> -                     page_cache_async_readahead(inode->i_mapping,
>> -                                                ra, NULL, page, index,
>> -                                                last_index + 1 - index);
>> +             } else if (PageReadahead(page)) {
>> +                             page_cache_async_readahead(inode->i_mapping,
>> +                                                     ra, NULL, page, index,
>> +                                                     last_index + 1 - index);
>
> That extra indent is not necessary.
>
> Otherwise looks good to me. Thanks!
>
> Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Hi Raghavendra,

Indentation breakage is now welcome. Please respin it. Otherwise

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
