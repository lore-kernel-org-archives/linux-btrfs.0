Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35481 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbJMSuI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 14:50:08 -0400
Received: by iofl186 with SMTP id l186so31380809iof.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 11:50:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20151013180648.GC4890@ret.masoncoding.com>
References: <20151013180648.GC4890@ret.masoncoding.com>
Date: Tue, 13 Oct 2015 19:50:08 +0100
Message-ID: <CAL3q7H5joPMAkybrXy=VATCoeCjSMcjxmL-6gGzUcJk_0-y2VA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix use after free iterating extrefs
From: Filipe Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>, Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2015 at 7:06 PM, Chris Mason <clm@fb.com> wrote:
> The code for btrfs inode-resolve has never worked properly for
> files with enough hard links to trigger extrefs.  It was trying to
> get the leaf out of a path after freeing the path:
>
>         btrfs_release_path(path);
>         leaf = path->nodes[0];
>         item_size = btrfs_item_size_nr(leaf, slot);
>
> The fix here is to use the extent buffer we cloned just a little higher
> up to avoid deadlocks caused by using the leaf in the path.
>
> Signed-off-by: Chris Mason <clm@fb.com>
> cc: stable@vger.kernel.org # v3.7+
> cc: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good to me.
I failed to notice that problem at commit [1]

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3fe81ce206f3805e0eb5d886aabbf91064655144

> ---
>  fs/btrfs/backref.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index ecbc63d..9a2ec79 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1828,7 +1828,6 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
>         int found = 0;
>         struct extent_buffer *eb;
>         struct btrfs_inode_extref *extref;
> -       struct extent_buffer *leaf;
>         u32 item_size;
>         u32 cur_offset;
>         unsigned long ptr;
> @@ -1856,9 +1855,8 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
>                 btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>                 btrfs_release_path(path);
>
> -               leaf = path->nodes[0];
> -               item_size = btrfs_item_size_nr(leaf, slot);
> -               ptr = btrfs_item_ptr_offset(leaf, slot);
> +               item_size = btrfs_item_size_nr(eb, slot);
> +               ptr = btrfs_item_ptr_offset(eb, slot);
>                 cur_offset = 0;
>
>                 while (cur_offset < item_size) {
> @@ -1872,7 +1870,7 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
>                         if (ret)
>                                 break;
>
> -                       cur_offset += btrfs_inode_extref_name_len(leaf, extref);
> +                       cur_offset += btrfs_inode_extref_name_len(eb, extref);
>                         cur_offset += sizeof(*extref);
>                 }
>                 btrfs_tree_read_unlock_blocking(eb);
> --
> 2.4.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
