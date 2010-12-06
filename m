From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC PATCH 4/4] btrfs: implement delayed dir index insertion
 and deletion
Date: Mon, 06 Dec 2010 15:25:03 +0800
Message-ID: <4CFC8FCF.5090807@cn.fujitsu.com>
References: <4CF602BF.7010805@cn.fujitsu.com> <1291307496-sup-6170@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291307496-sup-6170@think>
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 02 Dec 2010 11:33:40 -0500, Chris Mason wrote:
> Excerpts from Miao Xie's message of 2010-12-01 03:09:35 -0500:
>> Compare with Ext3/4, the performance of file creation and deletion on btrfs
>> is very poor. the reason is that btrfs must do a lot of b+ tree insertions,
>> such as inode item, directory name item, directory name index and so on.
>>
>> If we can do some delayed b+ tree insertion or deletion, we can improve the
>> performance, so we made this patch which implemented delayed directory name
>> index insertion and deletion.
>
> Many thanks for working on this.  It's a difficult problem and these
> patches look very clean.
>
> I think you can get more improvement if you also do this delayed scheme
> for the inode items themselves.

I think I can try to do it later.

> The hard part of these delayed implementations is always the throttling,
>
> +    if (delayed_root->count>= root->leafsize / sizeof(*dir_item))
> +        btrfs_run_delayed_dir_index(trans, root, NULL,
> +                        BTRFS_DELAYED_INSERT_ITEM, 0);
> +
>
> Have you experimented with other values here?

Yes, I have tried to set it to other values(such as 40, 100), or remove this check.
Though the performance becomes better as the number increases, the reserved space
that fs needs become larger, if the fs space is not enough, btrfs will call
shrink_delalloc(), the performance drops rapidly.

Maybe we can use a background work thread to do b+ tree insertion and deletion,
and implement it just like dirty page write back mechanism.

> I need to take a hard look at the locking and do some benchmarking on
> larger machines.  I'm a little worried about increased lock contention,
> but I think we can get around it by breaking up the rbtrees a little
> later on if we need to.

Yes, we can create rb-tree for every directory.

Thanks
Miao
