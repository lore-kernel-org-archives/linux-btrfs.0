Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:10829 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3EFGIl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 02:08:41 -0400
Message-ID: <518748E1.4030209@jan-o-sch.net>
Date: Mon, 06 May 2013 08:08:33 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>,
        Wang Shilong <wangsl-fnst@fujitsu.com>
Subject: Re: [PATCH] Btrfs: use arg gfp_mask to decide how to allocate tree
 mod
References: <1367730320-7660-1-git-send-email-wangshilong1991@gmail.com> <5F1F1D90-E9EC-41AC-9DDB-6A91C5292C83@gmail.com>
In-Reply-To: <5F1F1D90-E9EC-41AC-9DDB-6A91C5292C83@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 05, 2013 at 15:58 (+0200), Wang Shilong wrote:
> It seems the original code doesn't pass the right arg gfp_t to decide how to allocate.
> Just applying this patch, fsstress will fail. So please ignore this patch, will resend later..

That's in fact what the comment above the line you changed implies :-)

-Jan

> Thanks,
> Wang
> 
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>
>> We have passed arg gfp_mask to tree_mod_alloc(), so
>> just use it rather than always use GFP_ATOMIC.
>>
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> ---
>> fs/btrfs/ctree.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index de6de8e..0e3514f 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -553,7 +553,7 @@ static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
>> 	 * once we switch from spin locks to something different, we should
>> 	 * honor the flags parameter here.
>> 	 */
>> -	tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);
>> +	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
>> 	if (!tm)
>> 		return -ENOMEM;
>>
>> -- 
>> 1.7.11.7
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
