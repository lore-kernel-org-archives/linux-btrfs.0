Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60510 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbcCUT1d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 15:27:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 01DDC2034C
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 18:51:24 +0000 (UTC)
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com [209.85.213.172])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 3D24B20320
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 18:51:23 +0000 (UTC)
Received: by mail-ig0-f172.google.com with SMTP id kc10so74575719igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 11:51:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1457608215-18089-1-git-send-email-alex@zadarastorage.com>
References: <1457608215-18089-1-git-send-email-alex@zadarastorage.com>
Date: Mon, 21 Mar 2016 18:51:22 +0000
Message-ID: <CAL3q7H62a=Y8MhPUHJis0SSFNks6wpMO+nWhjmom3WMO6M5pww@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: do not write corrupted metadata blocks to disk
From: Filipe Manana <fdmanana@kernel.org>
To: Alex Lyakas <alex.bolshoy@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Alex Lyakas <alex@zadarastorage.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 11:10 AM, Alex Lyakas <alex.bolshoy@gmail.com> wrote:
> csum_dirty_buffer was issuing a warning in case the extent buffer
> did not look alright, but was still returning success.
> Let's return error in this case, and also add an additional sanity
> check on the extent buffer header.
> The caller up the chain may BUG_ON on this, for example flush_epd_write_bio will,
> but it is better than to have a silent metadata corruption on disk.
>
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/disk-io.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 4420ab2..cf85714 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -506,23 +506,34 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>
>  static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  {
>         u64 start = page_offset(page);
>         u64 found_start;
>         struct extent_buffer *eb;
>
>         eb = (struct extent_buffer *)page->private;
>         if (page != eb->pages[0])
>                 return 0;
> +
>         found_start = btrfs_header_bytenr(eb);
> -       if (WARN_ON(found_start != start || !PageUptodate(page)))
> -               return 0;
> +       /*
> +        * Please do not consolidate these warnings into a single if.
> +        * It is useful to know what went wrong.
> +        */
> +       if (WARN_ON(found_start != start))
> +               return -EUCLEAN;
> +       if (WARN_ON(!PageUptodate(page)))
> +               return -EUCLEAN;
> +
> +       ASSERT(memcmp_extent_buffer(eb, fs_info->fsid,
> +                       btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
> +
>         return csum_tree_block(fs_info, eb, 0);
>  }
>
>  static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
>                                  struct extent_buffer *eb)
>  {
>         struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>         u8 fsid[BTRFS_UUID_SIZE];
>         int ret = 1;
>
> --
> 1.9.1
>
