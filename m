Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33815 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbbDXPFM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 11:05:12 -0400
Received: by iget9 with SMTP id t9so30415955ige.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 08:05:11 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <553A4B36.2050901@fb.com>
References: <1428954759-1304912-1-git-send-email-clm@fb.com>
	<mh8h3f$l3u$1@ger.gmane.org>
	<pan.2015.04.22.16.37.38@googlemail.com>
	<5537D27E.3080609@fb.com>
	<CAL3q7H4ccdcJYKZaH_fYW9EUPCSTa3gDz_fiUjP8TvCUvQtxTQ@mail.gmail.com>
	<5538EB05.7050200@fb.com>
	<CAL3q7H6wUMruqTvKwMqcTXcgJv2fFw1GFN9QxyfE5GKqR-GNew@mail.gmail.com>
	<20150423151704.GA25585@ret.masoncoding.com>
	<CAL3q7H7oOcTZyCkP0NVWzQ3cKdJD=GDnM6+wM83D9_szHCX95g@mail.gmail.com>
	<CAL3q7H6+x7y64rZfRniJVDP8OwbNWCLuAC7M9D9OWY2urTsnWg@mail.gmail.com>
	<55394CEE.5030205@fb.com>
	<CAL3q7H7sM9Z4AbyuJUy5A9PkhrfOB=eQq_2ZRu9nRgjOwkVA6w@mail.gmail.com>
	<553A3E82.5020806@fb.com>
	<CAL3q7H4pEOCoZH5=LVDVr_ENdZZkrgX=rynk7uonZVQzoezYBw@mail.gmail.com>
	<553A4B36.2050901@fb.com>
Date: Fri, 24 Apr 2015 16:05:11 +0100
Message-ID: <CAL3q7H69RGET3=WD6s6OqVMtWui+Wetqjd7wrpNX0NhmJcjNkQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during commit
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 24, 2015 at 2:55 PM, Chris Mason <clm@fb.com> wrote:
> On 04/24/2015 09:43 AM, Filipe David Manana wrote:
>> On Fri, Apr 24, 2015 at 2:00 PM, Chris Mason <clm@fb.com> wrote:
>
>>> Can you please bang on this and get a more reliable reproduction? I'll
>>> take a look.
>>
>> Not really that easy to get a more reliable reproducer - just run
>> fsstress with multiple processes - it already happened twice again
>> after I sent the previous mail.
>> From the quick look I had at this, this seems to be the change causing
>> the problem:
>>
>> http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus-4.1&id=1bbc621ef28462456131c035eaeb5567a1a2a2fe
>>
>> Early in btrfs_commit_transaction(), btrfs_start_dirty_block_groups()
>> is called which ends up calling __btrfs_write_out_cache() for each
>> dirty block group, which collects all the bitmap entries from the bg's
>> space cache into a local list while holding the cache's ctl->tree_lock
>> (to serialize with concurrent allocation requests).
>>
>> Then we unlock ctl->tree_lock, do other stuff and later acquire
>> ctl->tree_lock again and call write_bitmap_entries() to write the
>> bitmap entries we previously collected. However, while we were doing
>> the other stuff without holding that lock, allocation requests might
>> have happened right? - since when we call
>> btrfs_start_dirty_block_groups() in btrfs_commit_transaction() the
>> transaction state wasn't yet changed, allowing other tasks to join the
>> current transaction. If such other task allocates all the remaining
>> space from a bitmap entry we collected before (because it's still in
>> the space cache's rbtree), it ends up deleting it and freeing its
>> ->bitmap member, which results in an invalid memory access (and the
>> warning on the list corruption) when we later call
>> write_bitmap_entries() in __btrfs_write_out_cache() - which is what
>> the second part of the trace I sent says:
>
> It's easy to hold the ctl->tree_lock from collection write out, but
> everyone deleting items is using list_del_init, so it should be fine to
> take the lock again and run through any items that are left.

Right, but free_bitmap() / unlink_free_space() free the bitmap entry
without deleting it from the list (nor its callers do it), which
should be enough to cause such list corruption report.

I'll try the patch and see if I can get at least one successful entire
run of xfstests.
Thanks Chris.

>
> Here's a replacement incremental that'll cover both cases:
>
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index d773f22..657a8ec 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1119,18 +1119,21 @@ static int flush_dirty_cache(struct inode *inode)
>  }
>
>  static void noinline_for_stack
> -cleanup_write_cache_enospc(struct inode *inode,
> +cleanup_write_cache_enospc(struct btrfs_free_space_ctl *ctl,
> +                          struct inode *inode,
>                            struct btrfs_io_ctl *io_ctl,
>                            struct extent_state **cached_state,
>                            struct list_head *bitmap_list)
>  {
>         struct list_head *pos, *n;
>
> +       spin_lock(&ctl->tree_lock);
>         list_for_each_safe(pos, n, bitmap_list) {
>                 struct btrfs_free_space *entry =
>                         list_entry(pos, struct btrfs_free_space, list);
>                 list_del_init(&entry->list);
>         }
> +       spin_unlock(&ctl->tree_lock);
>         io_ctl_drop_pages(io_ctl);
>         unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
>                              i_size_read(inode) - 1, cached_state,
> @@ -1266,8 +1269,8 @@ static int __btrfs_write_out_cache(struct
> btrfs_root *root, struct inode *inode,
>         ret = write_cache_extent_entries(io_ctl, ctl,
>                                          block_group, &entries, &bitmaps,
>                                          &bitmap_list);
> -       spin_unlock(&ctl->tree_lock);
>         if (ret) {
> +               spin_unlock(&ctl->tree_lock);
>                 mutex_unlock(&ctl->cache_writeout_mutex);
>                 goto out_nospc;
>         }
> @@ -1282,6 +1285,7 @@ static int __btrfs_write_out_cache(struct
> btrfs_root *root, struct inode *inode,
>          */
>         ret = write_pinned_extent_entries(root, block_group, io_ctl, &entries);
>         if (ret) {
> +               spin_unlock(&ctl->tree_lock);
>                 mutex_unlock(&ctl->cache_writeout_mutex);
>                 goto out_nospc;
>         }
> @@ -1291,7 +1295,6 @@ static int __btrfs_write_out_cache(struct
> btrfs_root *root, struct inode *inode,
>          * locked while doing it because a concurrent trim can be manipulating
>          * or freeing the bitmap.
>          */
> -       spin_lock(&ctl->tree_lock);
>         ret = write_bitmap_entries(io_ctl, &bitmap_list);
>         spin_unlock(&ctl->tree_lock);
>         mutex_unlock(&ctl->cache_writeout_mutex);
> @@ -1345,7 +1348,8 @@ out:
>         return ret;
>
>  out_nospc:
> -       cleanup_write_cache_enospc(inode, io_ctl, &cached_state, &bitmap_list);
> +       cleanup_write_cache_enospc(ctl, inode, io_ctl,
> +                                  &cached_state, &bitmap_list);
>
>         if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA))
>                 up_write(&block_group->data_rwsem);



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
