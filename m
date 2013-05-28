Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc2-s5.bay0.hotmail.com ([65.54.190.80]:52186 "EHLO
	bay0-omc2-s5.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934176Ab3E1OVp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 10:21:45 -0400
Message-ID: <BAY172-DS16C3FC74BB7793F893E2B0B0970@phx.gbl>
From: "Kyle Gates" <kylegates@hotmail.com>
To: <bo.li.liu@oracle.com>
Cc: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com> <h1rh5a-1lg.ln1@hurikhan.ath.cx> <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com> <BAY172-DS142AB5E40D200CC3946388B0A40@phx.gbl> <20130510051500.GB5615@liubo.jp.oracle.com> <BAY172-DS77BDBEADA4D3971B47F29B0A50@phx.gbl> <BAY172-DS3707AF83BC83C3B48502DB0A30@phx.gbl> <20130517070443.GN20202@liubo.jp.oracle.com>
In-Reply-To: <20130517070443.GN20202@liubo.jp.oracle.com>
Subject: Re: nocow 'C' flag ignored after balance
Date: Tue, 28 May 2013 09:22:11 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> From: Liu Bo <bo.li.liu@oracle.com>
>
> Subject: [PATCH] Btrfs: fix broken nocow after a normal balance
>
> Balance will create reloc_root for each fs root, and it's going to
> record last_snapshot to filter shared blocks.  The side effect of
> setting last_snapshot is to break nocow attributes of files.
>
> So here we update file extent's generation while walking relocated
> file extents in data reloc root, and use file extent's generation
> instead for checking if we have cross refs for the file extent.
>
> That way we can make nocow happy again and have no impact on others.
>
> Reported-by: Kyle Gates <kylegates@hotmail.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> fs/btrfs/ctree.h       |    2 +-
> fs/btrfs/extent-tree.c |   18 +++++++++++++-----
> fs/btrfs/inode.c       |   10 ++++++++--
> fs/btrfs/relocation.c  |    1 +
> 4 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4560052..eb2e782 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3090,7 +3090,7 @@ int btrfs_pin_extent_for_log_replay(struct 
> btrfs_root *root,
>      u64 bytenr, u64 num_bytes);
> int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
>    struct btrfs_root *root,
> -   u64 objectid, u64 offset, u64 bytenr);
> +   u64 objectid, u64 offset, u64 bytenr, u64 gen);
> struct btrfs_block_group_cache *btrfs_lookup_block_group(
>  struct btrfs_fs_info *info,
>  u64 bytenr);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 1e84c74..f3b3616 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2816,7 +2816,8 @@ out:
> static noinline int check_committed_ref(struct btrfs_trans_handle *trans,
>  struct btrfs_root *root,
>  struct btrfs_path *path,
> - u64 objectid, u64 offset, u64 bytenr)
> + u64 objectid, u64 offset, u64 bytenr,
> + u64 fi_gen)
> {
>  struct btrfs_root *extent_root = root->fs_info->extent_root;
>  struct extent_buffer *leaf;
> @@ -2861,8 +2862,15 @@ static noinline int check_committed_ref(struct 
> btrfs_trans_handle
> *trans,
>      btrfs_extent_inline_ref_size(BTRFS_EXTENT_DATA_REF_KEY))
>  goto out;
>
> - if (btrfs_extent_generation(leaf, ei) <=
> -     btrfs_root_last_snapshot(&root->root_item))
> + /*
> + * Usually generation in extent item is larger than that in file extent
> + * item because of delay refs.  But we don't want balance to break
> + * file's nocow behaviour, so use file_extent's generation which has
> + * been updates when we update fs root to point to relocated file
> + * extents in data reloc root.
> + */
> + fi_gen = max_t(u64, btrfs_extent_generation(leaf, ei), fi_gen);
> + if (fi_gen <= btrfs_root_last_snapshot(&root->root_item))
>  goto out;
>
>  iref = (struct btrfs_extent_inline_ref *)(ei + 1);
> @@ -2886,7 +2894,7 @@ out:
>
> int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
>    struct btrfs_root *root,
> -   u64 objectid, u64 offset, u64 bytenr)
> +   u64 objectid, u64 offset, u64 bytenr, u64 gen)
> {
>  struct btrfs_path *path;
>  int ret;
> @@ -2898,7 +2906,7 @@ int btrfs_cross_ref_exist(struct btrfs_trans_handle 
> *trans,
>
>  do {
>  ret = check_committed_ref(trans, root, path, objectid,
> -   offset, bytenr);
> +   offset, bytenr, gen);
>  if (ret && ret != -ENOENT)
>  goto out;
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2cfdd33..976b045 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1727,6 +1727,8 @@ next_slot:
>  ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
>  if (extent_type == BTRFS_FILE_EXTENT_REG ||
>      extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
> + u64 gen;
> + gen = btrfs_file_extent_generation(leaf, fi);
>  disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
>  extent_offset = btrfs_file_extent_offset(leaf, fi);
>  extent_end = found_key.offset +
> @@ -1749,7 +1751,8 @@ next_slot:
>  goto out_check;
>  if (btrfs_cross_ref_exist(trans, root, ino,
>    found_key.offset -
> -   extent_offset, disk_bytenr))
> +   extent_offset, disk_bytenr,
> +   gen))
>  goto out_check;
>  disk_bytenr += extent_offset;
>  disk_bytenr += cur_offset - found_key.offset;
> @@ -7002,6 +7005,7 @@ static noinline int can_nocow_odirect(struct 
> btrfs_trans_handle
> *trans,
>  struct btrfs_key key;
>  u64 disk_bytenr;
>  u64 backref_offset;
> + u64 fi_gen;
>  u64 extent_end;
>  u64 num_bytes;
>  int slot;
> @@ -7048,6 +7052,7 @@ static noinline int can_nocow_odirect(struct 
> btrfs_trans_handle
> *trans,
>  }
>  disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
>  backref_offset = btrfs_file_extent_offset(leaf, fi);
> + fi_gen = btrfs_file_extent_generation(leaf, fi);
>
>  *orig_start = key.offset - backref_offset;
>  *orig_block_len = btrfs_file_extent_disk_num_bytes(leaf, fi);
> @@ -7067,7 +7072,8 @@ static noinline int can_nocow_odirect(struct 
> btrfs_trans_handle
> *trans,
>  * find any we must cow
>  */
>  if (btrfs_cross_ref_exist(trans, root, btrfs_ino(inode),
> -   key.offset - backref_offset, disk_bytenr))
> +   key.offset - backref_offset, disk_bytenr,
> +   fi_gen))
>  goto out;
>
>  /*
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 704a1b8..07faabf 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1637,6 +1637,7 @@ int replace_file_extents(struct btrfs_trans_handle 
> *trans,
>  BUG_ON(ret < 0);
>
>  btrfs_set_file_extent_disk_bytenr(leaf, fi, new_bytenr);
> + btrfs_set_file_extent_generation(leaf, fi, trans->transid);
>  dirty = 1;
>
>  key.offset -= btrfs_file_extent_offset(leaf, fi);
> -- 
> 1.7.7
>

Sorry for the long wait in replying.
This patch was unsuccessful in fixing the problem (on my 3.8 Ubuntu Raring 
kernel). I can probably try again on a newer version if you think it will 
help.
This was my first kernel compile so I patched by hand and waited (10 hours 
on my old 32 bit single core machine).

I did move some of the files off and back on to the filesystem to start 
fresh and compare but all seem to exhibit the same behavior after a balance.

Thanks,
Kyle 

