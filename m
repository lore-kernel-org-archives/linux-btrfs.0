Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:55631 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LNOuW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 09:50:22 -0500
Received: by mail-qe0-f43.google.com with SMTP id 2so2576224qeb.2
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 06:50:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP9B-QnExXqCPxXZxK2ghjfHvfi-pmy-CtKirJLu-vnGzY=+gg@mail.gmail.com>
References: <1387006051-17067-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<20131214134935.GA23060@localhost.localdomain>
	<CAP9B-QnExXqCPxXZxK2ghjfHvfi-pmy-CtKirJLu-vnGzY=+gg@mail.gmail.com>
Date: Sat, 14 Dec 2013 22:50:19 +0800
Message-ID: <CAP9B-Qk2owJCO4a628SE4_ST50B5Nnm585eehUPb8UV_oAS0-A@mail.gmail.com>
Subject: Fwd: [PATCH] Btrfs: fix a warning when iput a file
From: Shilong Wang <wangshilong1991@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CC:linux-btrfs

---------- Forwarded message ----------
From: Shilong Wang <wangshilong1991@gmail.com>
Date: 2013/12/14
Subject: Re: [PATCH] Btrfs: fix a warning when iput a file
To: bo.li.liu@oracle.com


Hello Liu

2013/12/14 Liu Bo <bo.li.liu@oracle.com>:
> On Sat, Dec 14, 2013 at 03:27:31PM +0800, Wang Shilong wrote:
>> See the warning below:
>>
>> [ 1209.102076]  [<ffffffffa04721b9>] remove_extent_mapping+0x69/0x70 [btrfs]
>> [ 1209.102084]  [<ffffffffa0466b06>] btrfs_evict_inode+0x96/0x4d0 [btrfs]
>> [ 1209.102089]  [<ffffffff81073010>] ? wake_atomic_t_function+0x40/0x40
>> [ 1209.102092]  [<ffffffff8118ab2e>] evict+0x9e/0x190
>> [ 1209.102094]  [<ffffffff8118b313>] iput+0xf3/0x180
>> [ 1209.102101]  [<ffffffffa0461fd1>] btrfs_run_delayed_iputs+0xb1/0xd0 [btrfs]
>> [ 1209.102107]  [<ffffffffa045d358>] __btrfs_end_transaction+0x268/0x350 [btrfs]
>>
>> clear extent bit here to avoid triggering WARN_ON() in remove_extent_mapping()
>
> Why PINNED and LOGGING isn't unset as usual?
>

Flippe sent an improved patch regarding evict inode:
https://patchwork.kernel.org/patch/3204281/

In btrfs_invalidatepages(), if we are evicting an inode, we will skip
usual operation that is operated page by page.

Rather than we do it more effectively, that we operate extent_map and
extent_state structure, this will be faster!

So for now code , after calling truncate_inode_pages(), PINNED and
LOGGED won't be unset
as usual(Maybe a better solution is to move remove_extent_mappin after
we clear extent state).

Correct me if i am wrong here.

Thanks,
Wang

> -liubo
>
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/inode.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index e889779..c0f0f9d 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4515,6 +4515,8 @@ static void evict_inode_truncate_pages(struct inode *inode)
>>
>>               node = rb_first(&map_tree->map);
>>               em = rb_entry(node, struct extent_map, rb_node);
>> +             clear_bit(EXTENT_FLAG_PINNED, &em->flags);
>> +             clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
>>               remove_extent_mapping(map_tree, em);
>>               free_extent_map(em);
>>       }
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
