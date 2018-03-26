Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:47551 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbeCZAyS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Mar 2018 20:54:18 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id CB818AC007A
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 09:54:11 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: remove BTRFS_CRC32_SIZE definition
To: <linux-btrfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>
References: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>
 <a41c7961-fd69-ddbf-e831-769446868a5c@gmx.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <e3a82fc6-2649-4d47-1893-9277130e6a1c@jp.fujitsu.com>
Date: Mon, 26 Mar 2018 09:54:04 +0900
MIME-Version: 1.0
In-Reply-To: <a41c7961-fd69-ddbf-e831-769446868a5c@gmx.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/23 18:14, Qu Wenruo wrote:
> 
> 
> On 2018年03月23日 16:20, Misono Tomohiro wrote:
>> The kernel code no longer has BTRFS_CRC32_SIZE and only uses
>> btrfs_csum_sizes[]. So, update the progs code as well.
>>
>> Suggested-by: Qu Wenruo <wqu@suse.com>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>> ---
>>  convert/common.c |  2 +-
>>  convert/main.c   |  2 +-
>>  ctree.h          |  3 +--
>>  image/main.c     |  4 ++--
>>  mkfs/common.c    | 14 +++++++-------
>>  5 files changed, 12 insertions(+), 13 deletions(-)
>>
>> diff --git a/convert/common.c b/convert/common.c
>> index 3860f3b9..2b944fd8 100644
>> --- a/convert/common.c
>> +++ b/convert/common.c
>> @@ -219,7 +219,7 @@ static inline int write_temp_extent_buffer(int fd, struct extent_buffer *buf,
>>  {
>>  	int ret;
>>  
>> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
>> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
> 
> I'd say the normal kernel way to do this is like this, other than using
> BTRFS_CSUM_TYPE_CRC32:
> 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
> 
> Thanks,
> Qu


Thanks, but we cannot access fs_info or struct btrfs_super_block here (and others in this diff).
Should we pass the csum type parameter as an argument? Since currently the only
supported type is crc32, I'm not sure if we should write the code so generic at this time.

