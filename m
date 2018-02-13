Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41146 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965079AbeBMPRQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 10:17:16 -0500
Subject: Re: [PATCH] btrfs: manage thread_pool mount option as %u
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180213095048.9550-1-anand.jain@oracle.com>
 <12714050-aece-8bfd-2e83-ef5da4590c81@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b72463c0-6d27-5fe7-b790-4d6c3b5dfca0@oracle.com>
Date: Tue, 13 Feb 2018 23:18:41 +0800
MIME-Version: 1.0
In-Reply-To: <12714050-aece-8bfd-2e83-ef5da4590c81@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>







>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 02c7766e6849..8112619cac95 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -346,7 +346,7 @@ static const match_table_t tokens = {
>>   	{Opt_barrier, "barrier"},
>>   	{Opt_max_inline, "max_inline=%u"},
>>   	{Opt_alloc_start, "alloc_start=%s"},
>> -	{Opt_thread_pool, "thread_pool=%d"},
>> +	{Opt_thread_pool, "thread_pool=%u"},
>>   	{Opt_compress, "compress"},
>>   	{Opt_compress_type, "compress=%s"},
>>   	{Opt_compress_force, "compress-force"},
>> @@ -596,12 +596,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>>   			ret = match_int(&args[0], &intarg);
>>   			if (ret) {
>>   				goto out;
>> -			} else if (intarg > 0) {
>> -				info->thread_pool_size = intarg;
>> -			} else {
>> +			} else if (intarg == 0) {
> 
> One thing I'm worried about is the fact that match_int parses a signed
> int. So If someone pases -1 then it would be parsed to -1 but when you
> set it to thread_pool_size the actual value is going to be the 2's
> complement of the value i.e. a very large number. So a check for intarg
> < 0 is required to avoid that. Same applies to your other patches

  That's not true. When -o thread_pool=-1 is passed it would fail
  to match to any token. And same applies to other patches too.

Thanks, Anand
