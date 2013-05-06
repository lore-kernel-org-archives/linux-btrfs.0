Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39021 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3EFGPv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 02:15:51 -0400
Message-ID: <51874BCA.5070104@cn.fujitsu.com>
Date: Mon, 06 May 2013 14:20:58 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Wang Shilong <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>,
        Wang Shilong <wangsl-fnst@fujitsu.com>
Subject: Re: [PATCH] Btrfs: use arg gfp_mask to decide how to allocate tree
 mod
References: <1367730320-7660-1-git-send-email-wangshilong1991@gmail.com> <5F1F1D90-E9EC-41AC-9DDB-6A91C5292C83@gmail.com> <518748E1.4030209@jan-o-sch.net>
In-Reply-To: <518748E1.4030209@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

> On Sun, May 05, 2013 at 15:58 (+0200), Wang Shilong wrote:
>> It seems the original code doesn't pass the right arg gfp_t to decide how to allocate.
>> Just applying this patch, fsstress will fail. So please ignore this patch, will resend later..
> 
> That's in fact what the comment above the line you changed implies :-)


e.. It seems tree_mod_alloc() will always allocate with GFP_ATOMIC in your code.
However, i think we should try best not to allocate with GTP_ATOMIC.. otherwise,
at least.. the arg gfp_t you try to pass is useless and should be removed ^_^


Thanks,
Wang

> 
> -Jan
> 
>> Thanks,
>> Wang
>>
>>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>>
>>> We have passed arg gfp_mask to tree_mod_alloc(), so
>>> just use it rather than always use GFP_ATOMIC.
>>>
>>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>> ---
>>> fs/btrfs/ctree.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>>> index de6de8e..0e3514f 100644
>>> --- a/fs/btrfs/ctree.c
>>> +++ b/fs/btrfs/ctree.c
>>> @@ -553,7 +553,7 @@ static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
>>> 	 * once we switch from spin locks to something different, we should
>>> 	 * honor the flags parameter here.
>>> 	 */
>>> -	tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);
>>> +	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
>>> 	if (!tm)
>>> 		return -ENOMEM;
>>>
>>> -- 
>>> 1.7.11.7
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



