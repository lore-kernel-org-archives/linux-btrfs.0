Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54311 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3A2NMe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 08:12:34 -0500
Received: by mail-wi0-f178.google.com with SMTP id hn3so376189wib.17
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 05:12:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5102AB54.3050704@redhat.com>
References: <5102AB54.3050704@redhat.com>
Date: Tue, 29 Jan 2013 15:12:22 +0200
Message-ID: <CAOcd+r0=7gQ8npy6_Fd61k9VogdMO2iPNey2xigTafYSt5CiKA@mail.gmail.com>
Subject: Re: [PATCH, RFC] mkfs: collapse redundant logic in custom_alloc_extent()
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

On Fri, Jan 25, 2013 at 5:57 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> It looks to me like the logic in these two if statements are
> overlapping.
>
> The test for flags & BTRFS_BLOCK_GROUP_SYSTEM in the 2nd case
> should never get triggered, because it would have triggered
> on the first case, right?
>
> And since the actions are identical in both cases, this can be
> collapsed into one.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> p.s.
>
> Having done that, I now look at the nearly identical
> custom_alloc_extent() copy in convert.c, and wonder if it's
> intentional that the convert copy does not care about
> BTRFS_BLOCK_GROUP_METADATA, but mkfs does?  I'm not quite
> sure what's going on there.

When I was digging in the conversion code, I saw that
btrfs_make_block_groups() uses some heuristics to define some block
groups as DATA and some as METADATA. But later, the conversion code,
as you noticed, doesn't care about this, and there are data
EXTENT_ITEMs that land in METADATA block groups. I am not sure if this
is a problem or not, I asked here:
http://www.spinics.net/lists/linux-btrfs/msg19894.html, but got no
answers:(
Since then I tried to develop my own version of convert that lays out
block groups more properly, but it makes some assumptions on the free
space on the block device being converted.

Alex.



>
> Thanks,
> -Eric
>
> diff --git a/mkfs.c b/mkfs.c
> index ca850d9..5d77428 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -635,14 +635,10 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
>
>                 cache = btrfs_lookup_block_group(root->fs_info, start);
>                 BUG_ON(!cache);
> -               if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM ||
> -                   last > cache->key.objectid + cache->key.offset) {
> -                       last = cache->key.objectid + cache->key.offset;
> -                       continue;
> -               }
>
>                 if (cache->flags & (BTRFS_BLOCK_GROUP_SYSTEM |
> -                           BTRFS_BLOCK_GROUP_METADATA)) {
> +                           BTRFS_BLOCK_GROUP_METADATA) ||
> +                   last > cache->key.objectid + cache->key.offset) {
>                         last = cache->key.objectid + cache->key.offset;
>                         continue;
>                 }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
