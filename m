Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41326 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3HJVal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 17:30:41 -0400
Received: by mail-ob0-f177.google.com with SMTP id f8so7081841obp.8
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 14:30:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130809144626.GL5284@twin.jikos.cz>
References: <1375998348-20639-1-git-send-email-fdmanana@gmail.com>
	<5204826C.3060902@cn.fujitsu.com>
	<20130809144626.GL5284@twin.jikos.cz>
Date: Sat, 10 Aug 2013 16:30:40 -0500
Message-ID: <CAKcLGm-rwRPGja3N+52+pKvAoMzfDX3TxhFNSw+u2iMx9C-5oA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: set default max_inline to 8KiB instead of 8MiB
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: David Sterba <dsterba@suse.cz>, Miao Xie <miaox@cn.fujitsu.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 9, 2013 at 9:46 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Aug 09, 2013 at 01:47:24PM +0800, Miao Xie wrote:
>> On thu, 8 Aug 2013 22:45:48 +0100, Filipe David Borba Manana wrote:
>> > 8MiB is way too large and likely set by mistake. This is not
>> > a significant issue as in practice the max amount of data
>> > added to an inline extent is also limited by the page cache
>> > and btree leaf sizes.
>>
>> I don't think 8KB is a reasonable value of the default max inline size
>> because it makes no sense on the machine whose page size is 4KB.
>
> Page size limit is artificial implied by the implementation and on a 4k
> page machine max_inline does not take place. Even if it's 4k, it does
> not apply because the leaf space is smaller.
>
>> I think 4KB is a reasonable value, because we may mount the fs on
>> the machines with the different page size in the future, in order to
>> avoid the compatible problem, we should use the min page size as
>> the max inline size.
>
> If there's support for mounting a fs with sectorsize != pagesize, this
> will work automatically. Currently such filesystem fails to mount, as we
> know.
>
> Whether it's 4k or 8k could be decided by the performance impact, but I
> have no numbers to vote for either.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I did some research on max_inline when I was playing with an
experimental patch to allow inline extents to be greater than
sectorsize (but still < leafsize and inodesize).

I concluded that that max_inline doesn't matter as long as it is >
PAGE_CACHE_SIZE.

My guess is that at some point early in BTRFS history, they wanted to
allow for inlining of really large extents (essentially inlining
almost the entire filesystem except for really large files).

When Chris incorporated compression (Btrfs: Add zlib compression
support, 2008-10-29, commit c8b978188c9a0fd3d535c13debd19d522b726f1f,
and a follow-up patch: Btrfs: Compression corner fixes, 2008-10-31,
70b99e6959a4c28ae1b314985eca731f3db72f1d), the new
cow_file_range_inline() function limited inline extent size to
PAGE_CACHE_SIZE.

if (start > 0 ||
   actual_end >= PAGE_CACHE_SIZE ||
   data_len >= BTRFS_MAX_INLINE_DATA_SIZE(root) ||
   (!compressed_size &&
   (actual_end & (root->sectorsize - 1)) == 0) ||
   end + 1 < isize ||
   data_len > root->fs_info->max_inline) {
return 1;
}

So, this is why we could have a really large max_inline setting for
all these years that didn't make anything go BOOM.

As Miao Xie suggested, if you use fs_info->max_inline =
PAGE_CACHE_SIZE, the code will be ready if the issue with 64k page
size is ever addressed.

You could probably also refactor fs_info->max_inline out completely
with some additional work.
