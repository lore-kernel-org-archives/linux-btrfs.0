Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55593 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbeFTNpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 09:45:54 -0400
Date: Wed, 20 Jun 2018 15:43:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/4] btrfs: remove the wait ordered logic in the
 log_one_extent path
Message-ID: <20180620134303.GY24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523155836.4622-1-josef@toxicpanda.com>
 <20180523155836.4622-2-josef@toxicpanda.com>
 <da2605c7-a453-4e93-9793-258326002176@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <da2605c7-a453-4e93-9793-258326002176@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 26, 2018 at 03:48:31PM +0300, Nikolay Borisov wrote:
> > +	ret = log_extent_csums(trans, inode, root, em);
> 
> With the following minor diff: 
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index daf32dc94dc3..34d5b0630824 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> 
> @@ -4064,11 +4064,9 @@ static int extent_cmp(void *priv, struct list_head *a, struct list_head *b)
>  
>  static int log_extent_csums(struct btrfs_trans_handle *trans,
>                             struct btrfs_inode *inode,
> -                           struct btrfs_root *root,
> +                           struct btrfs_root *log,
>                             const struct extent_map *em)
>  {
> -       struct btrfs_fs_info *fs_info = root->fs_info;
> -       struct btrfs_root *log = root->log_root;
>         u64 csum_offset;
>         u64 csum_len;
>         LIST_HEAD(ordered_sums);
> @@ -4089,7 +4087,7 @@ static int log_extent_csums(struct btrfs_trans_handle *trans,
>         }
>  
>         /* block start is already adjusted for the file extent offset. */
> -       ret = btrfs_lookup_csums_range(fs_info->csum_root,
> +       ret = btrfs_lookup_csums_range(trans->fs_info->csum_root,
>                                        em->block_start + csum_offset,
>                                        em->block_start + csum_offset +
>                                        csum_len - 1, &ordered_sums, 0);
> @@ -4125,7 +4123,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>         int ret;
>         int extent_inserted = 0;
>  
> -       ret = log_extent_csums(trans, inode, root, em);
> +       ret = log_extent_csums(trans, inode, log, em);
>         if (ret)
>                 return ret;
> 
> Bloat-o-meter reports: 
> 
> add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-55 (-55)
> Function                                     old     new   delta
> btrfs_log_changed_extents.isra              4298    4243     -55
> Total: Before=64999, After=64944, chg -0.08%
> 
> I suggest you incorporate it in the patch

The patches are in misc-next now, please send that as a separate patch.
