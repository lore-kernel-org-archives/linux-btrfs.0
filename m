Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35186 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbbCZKXa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 06:23:30 -0400
Received: by ieclw3 with SMTP id lw3so42701700iec.2
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2015 03:23:30 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <55137BE2.80603@redhat.com>
References: <55137BE2.80603@redhat.com>
Date: Thu, 26 Mar 2015 10:23:30 +0000
Message-ID: <CAL3q7H4fYq4K2rAT401QKSYKjRyaZwHDVSg6YZ0P=XU_31fLFQ@mail.gmail.com>
Subject: Re: I think "btrfs: fix leak of path in btrfs_find_item" broke stable
 trees ...
From: Filipe David Manana <fdmanana@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 26, 2015 at 3:24 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> Looks like "btrfs: fix leak of path in btrfs_find_item" got sent
> to stable trees, but in my testing, it causes deadlocks on mount:
>
> [23379.359246] mount           D 0000000000000000     0 22541  22274 0x00000080
> [23379.366326]  ffff8803ebadf6c8 0000000000000086 ffff88027ff10230 0000000000013680
> [23379.373770]  0000000000013680 ffff8803ebadffd8 ffff8803ebadc010 0000000000013680
> [23379.381208]  ffff8803ebadffd8 0000000000013680 ffff880261c78b60 ffff8802140a0b60
> [23379.388648] Call Trace:
> [23379.391106]  [<ffffffff816182b9>] schedule+0x29/0x70
> [23379.396091]  [<ffffffffa06b82f5>] btrfs_tree_lock+0xb5/0x290 [btrfs]
> [23379.402444]  [<ffffffff8109b470>] ? wake_up_bit+0x40/0x40
> [23379.407855]  [<ffffffffa064f7a5>] ? generic_bin_search+0xf5/0x180 [btrfs]
> [23379.414643]  [<ffffffffa065041b>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
> [23379.421345]  [<ffffffffa065936b>] btrfs_search_slot+0x63b/0x800 [btrfs]
> [23379.427956]  [<ffffffffa064fa49>] ? btrfs_set_path_blocking+0x39/0x80 [btrfs]
> [23379.435088]  [<ffffffffa0659ede>] btrfs_insert_empty_items+0x7e/0xe0 [btrfs]
> [23379.442125]  [<ffffffffa065051a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [23379.448655]  [<ffffffffa06b8989>] btrfs_insert_orphan_item+0x69/0x90 [btrfs]
> [23379.455696]  [<ffffffffa06ba938>] insert_orphan_item+0x68/0x90 [btrfs]
> [23379.462251]  [<ffffffffa06bf772>] replay_one_buffer+0x372/0x380 [btrfs]
> [23379.468878]  [<ffffffffa069a4c1>] ? mark_extent_buffer_accessed+0x51/0x70 [btrfs]
> [23379.476372]  [<ffffffffa06ba54b>] walk_up_log_tree+0x1cb/0x250 [btrfs]
> [23379.482910]  [<ffffffffa06ba68f>] walk_log_tree+0xbf/0x1b0 [btrfs]
> [23379.489098]  [<ffffffffa06bd51c>] btrfs_recover_log_trees+0x1ec/0x4c0 [btrfs]
> ...
>
> I could hit this by running ./check generic/015  generic/039 in fstests,
> with a SCRATCH_DEV_POOL defined (not sure it matters, it's just what I
> have...)
>
> This fixes it, though I'm not totally sure why.  Refcounts?

Hi Eric,

Your patch seems correct to me.
The problem is that btrfs_insert_orphan_item tries to get a write lock
on the same node/leaf for which its caller (insert_orphan_item) is
already holding a read lock.

If you plan to submit a proper patch, feel free to add my Reviewed-by:
Filipe Manana <fdmanana@suse.com>

thanks

>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 906934e..d37e6d1 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -1265,11 +1265,11 @@ static int insert_orphan_item(struct btrfs_trans_handle *trans,
>
>         ret = btrfs_find_item(root, path, BTRFS_ORPHAN_OBJECTID,
>                         offset, BTRFS_ORPHAN_ITEM_KEY, NULL);
> +       btrfs_free_path(path);
> +
>         if (ret > 0)
>                 ret = btrfs_insert_orphan_item(trans, root, offset);
>
> -       btrfs_free_path(path);
> -
>         return ret;
>  }
>
>
> but it never likely showed up upstream, because
>
> 9c4f61f btrfs: simplify insert_orphan_item
>
> made the whole path alloc/free go away.
>
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
