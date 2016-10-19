Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49643 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750775AbcJSFDT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 01:03:19 -0400
Subject: Re: [PATCH] btrfs: pass correct args to
 btrfs_async_run_delayed_refs()
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        <linux-btrfs@vger.kernel.org>
References: <20161018075613.10757-1-wangxg.fnst@cn.fujitsu.com>
 <pan$9e691$50b48431$37da74db$d7e3b0a2@applied-asynchrony.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <5806FD2F.1000609@cn.fujitsu.com>
Date: Wed, 19 Oct 2016 12:57:19 +0800
MIME-Version: 1.0
In-Reply-To: <pan$9e691$50b48431$37da74db$d7e3b0a2@applied-asynchrony.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On 10/18/2016 06:32 PM, Holger Hoffstätte wrote:
> On Tue, 18 Oct 2016 15:56:13 +0800, Wang Xiaoguang wrote:
>
>> In btrfs_truncate_inode_items()->btrfs_async_run_delayed_refs(), we
>> swap the arg2 and arg3 wrongly, fix this.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/inode.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 2b790bd..2f1372b 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4605,8 +4605,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>>   			BUG_ON(ret);
>>   			if (btrfs_should_throttle_delayed_refs(trans, root))
>>   				btrfs_async_run_delayed_refs(root,
>> -							     trans->transid,
>> -					trans->delayed_ref_updates * 2, 0);
>> +					trans->delayed_ref_updates * 2,
>> +					trans->transid, 0);
>>   			if (be_nice) {
>>   				if (truncate_space_check(trans, root,
>>   							 extent_num_bytes)) {
> Reviewed-by: Holger Hoffstätte <holger@applied-asynchrony.com>
>
> Passing the wrong transid..why did this ever work?
Indeed this bug just impacts asynchronous delayed refs handle when we 
truncate
inodes.  In delayed_ref_async_start(), there is such codes:

     trans = btrfs_join_transaction(async->root);
     if (trans->transid > async->transid)
         goto end;
     ret = btrfs_run_delayed_refs(trans, async->root, async->count);

 From this codes, we can see that this just influence whether can we handle
delayed refs or the number of delayed refs to handle, this may impact
performance, but will not result in missing delayed refs, all delayed 
refs will
be handled in btrfs_commit_transaction().

Regards,
Xiaoguang Wang

>
> -h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



