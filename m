Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:58784 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3LJNG6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 08:06:58 -0500
Received: by mail-qa0-f51.google.com with SMTP id o15so3649340qap.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 05:06:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A67179.7040609@cn.fujitsu.com>
References: <1386605674-3320-1-git-send-email-wangshilong1991@gmail.com>
	<52A67179.7040609@cn.fujitsu.com>
Date: Tue, 10 Dec 2013 21:06:57 +0800
Message-ID: <CAP9B-QkJLPY8ENxbVPOP4dWtXgAY6cu6eNYq=EVXNx=RXBaTaw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: fix an oops when doing balance relocation
From: Shilong Wang <wangshilong1991@gmail.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2013/12/10 Wang Shilong <wangsl.fnst@cn.fujitsu.com>:
> On 12/10/2013 12:14 AM, Wang Shilong wrote:
>>
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> I hit a BUG_ON() when inserting reloc root into
>> rc->reloc_root_tree.rb_root,
>> the fact is block bytenr has been inserted before, this is really a
>> redicious
>> bug, the reason is that we freed root node after we have allocated root
>> node block,and this block bytenr will be reused and then oops happens.
>

By hacking the code (force cow for relocation tree),  BUG_ON() can be triggered
easily.

The problem is that reloc root bytenr inserted into @reloc_root_tree
is not within
one transaction. root block node can be cowed while it is still in
@reloc_root_tree
and  previous relocation root block can be reused and this oops happen.

We can fix it by updating relocation root node in @reloc_root_tree
when cowing block,
Patch has been make and hopely it can fix this problem, will send v2 later. ^_^

> oops, this is wrong, sorry for noise.

Previously, i really made mistakes, free_extent_buffer() even won't
free tree block,
it just dec refs and free memory if possible.

Thanks,
Wang
>
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/relocation.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index ce459a7..4dc7f26 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -1361,7 +1361,6 @@ static struct btrfs_root *create_reloc_root(struct
>> btrfs_trans_handle *trans,
>>         }
>>         btrfs_tree_unlock(eb);
>> -       free_extent_buffer(eb);
>>         ret = btrfs_insert_root(trans, root->fs_info->tree_root,
>>                                 &root_key, root_item);
>
>
