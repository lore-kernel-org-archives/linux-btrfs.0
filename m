Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:43195 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755933AbdKCK72 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 06:59:28 -0400
Received: by mail-io0-f171.google.com with SMTP id 134so5407574ioo.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Nov 2017 03:59:28 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20171102070406.21138-1-wqu@suse.com>
References: <20171102070406.21138-1-wqu@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 3 Nov 2017 10:59:27 +0000
Message-ID: <CAL3q7H7kHbDyW7Uuq5wn3um6X9FOCmvQT7gwZ8teO0NaL3K1Jg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Move leaf verification to correct timing to avoid
 false panic for sanity test
To: Qu Wenruo <wqu@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, lakshmipathi.g@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 2, 2017 at 7:04 AM, Qu Wenruo <wqu@suse.com> wrote:
> [BUG]
> If we run btrfs with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y, it will
> instantly cause kernel panic like:
>
> ------
> ...
> assertion failed: 0, file: fs/btrfs/disk-io.c, line: 3853
> ...
> Call Trace:
>  btrfs_mark_buffer_dirty+0x187/0x1f0 [btrfs]
>  setup_items_for_insert+0x385/0x650 [btrfs]
>  __btrfs_drop_extents+0x129a/0x1870 [btrfs]
> ...
> ------
>
> [Cause]
> Btrfs will call btrfs_check_leaf() in btrfs_mark_buffer_dirty() to check
> if the leaf is valid with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y.
>
> However some btrfs_mark_buffer_dirty() caller, like
> setup_items_for_insert(), doesn't really initialize its item data but
> only initialize its item pointers, leaving item data uninitialized.

So instead of doing this juggling, the best would be to have it not call
mark_buffer_dirty(), and leave that responsibility for the caller after
it initializes the item data. I give you a very good reason for that below.

>
> This makes tree-checker catch uninitialized data as error, causing
> such panic.
>
> [Fix]
> The correct timing to check leaf validation should be before write IO or
> after read IO.
>
> Just like ee have already done the tree validation check at btree
> readpage end io hook, this patch will move the write time tree checker to
> csum_dirty_buffer().
>
> As csum_dirty_buffer() is called just before submitting btree write bio, as
> the call path shows:
>
> btree_submit_bio_hook()
> |- __btree_submit_bio_start()
>    |- btree_csum_one_bio()
>       |- csum_dirty_buffer()
>          |- btrfs_check_leaf()
>
> By this we can ensure the leaf passed in is in consistent status, and
> can check them without causing tons of false alert.
>
> Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index efce9a2fa9be..6c17bce2a05e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -506,6 +506,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>         u64 start = page_offset(page);
>         u64 found_start;
>         struct extent_buffer *eb;
> +       int ret;
>
>         eb = (struct extent_buffer *)page->private;
>         if (page != eb->pages[0])
> @@ -524,7 +525,24 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>         ASSERT(memcmp_extent_buffer(eb, fs_info->fsid,
>                         btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
>
> -       return csum_tree_block(fs_info, eb, 0);
> +       ret = csum_tree_block(fs_info, eb, 0);
> +       if (ret)
> +               return ret;
> +
> +#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
> +       /*
> +        * Do extra check before we write the tree block into disk.
> +        */
> +       if (btrfs_header_level(eb) == 0) {
> +           ret = btrfs_check_leaf(fs_info->tree_root, eb);
> +           if (ret) {
> +               btrfs_print_leaf(eb);
> +               ASSERT(0);
> +               return ret;
> +           }
> +       }
> +#endif
> +       return 0;
>  }
>
>  static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
> @@ -3847,12 +3865,6 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
>                 percpu_counter_add_batch(&fs_info->dirty_metadata_bytes,
>                                          buf->len,
>                                          fs_info->dirty_metadata_batch);
> -#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
> -       if (btrfs_header_level(buf) == 0 && btrfs_check_leaf(root, buf)) {
> -               btrfs_print_leaf(buf);
> -               ASSERT(0);
> -       }
> -#endif

So there's a reason why btrfs_check_leaf() was called here, at
mark_buffer_dirty(),
instead of somewhere else like csum_dirty_buffer().

The reason is that once some bad code inserts a key out of order for
example (or did any
other bad stuff that check_leaf() catched before you added the
tree-checker thing), we
would get a trace that pinpoints exactly where the bad code is. With
this change, we will
only know some is bad when writeback of the leaf starts, and before
that happens, the leaf might
have been changed dozens of times by many different functions (and
this happens very
often, it's far from being a unusual case), in which case the given
trace won't tell you which code
misbehaved. This makes it harder to find out bugs, and as it used to
be it certainly helped me in
the past several times. IOW, I would prefer what I mentioned earlier
or, at very least, do those new
checks that validate data only at writeback start time.

>  }
>
>  static void __btrfs_btree_balance_dirty(struct btrfs_fs_info *fs_info,
> --
> 2.14.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
