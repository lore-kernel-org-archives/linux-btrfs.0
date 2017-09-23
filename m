Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41654 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdIWUif (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Sep 2017 16:38:35 -0400
Subject: Re: [PATCH 2/3] btrfs: add a flags argument to LOGICAL_INO and call
 it LOGICAL_INO_V2
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
 <20170922175847.6071-3-ce3g8jdj@umail.furryterror.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <837ce8ff-bf06-5e0b-6dd2-3ced42cf45aa@mendix.com>
Date: Sat, 23 Sep 2017 22:38:33 +0200
MIME-Version: 1.0
In-Reply-To: <20170922175847.6071-3-ce3g8jdj@umail.furryterror.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/2017 07:58 PM, Zygo Blaxell wrote:
> Now that check_extent_in_eb()'s extent offset filter can be turned off,
> we need a way to do it from userspace.
> 
> Add a 'flags' field to the btrfs_logical_ino_args structure to disable
> extent offset filtering, taking the place of one of the existing
> reserved[] fields.
> 
> Previous versions of LOGICAL_INO neglected to check whether any of the
> reserved fields have non-zero values.  Assigning meaning to those fields
> now may change the behavior of existing programs that left these fields
> uninitialized.  The lack of a zero check also means that new programs
> have no way to know whether the kernel is honoring the flags field.
> 
> To avoid these problems, define a new ioctl LOGICAL_INO_V2.  We can
> use the same argument layout as LOGICAL_INO, but shorten the reserved[]
> array by one element and turn it into the 'flags' field.  The V2 ioctl
> explicitly checks that reserved fields and unsupported flag bits are zero
> so that userspace can negotiate future feature bits as they are defined.
> 
> Since the memory layouts of the two ioctls' arguments are compatible,
> there is no need for a separate function for logical_to_ino_v2 (contrast
> with tree_search_v2 vs tree_search where the layout and code are quite
> different).  A version parameter and an 'if' statement will suffice.
> 
> Now that we have a flags field in logical_ino_args, add a flag
> BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET to get the behavior we want,
> and pass it down the stack to iterate_inodes_from_logical.

Nice! This is a very welcome addition for userspace. I have seen the
question: "ok, but which files are using any part of this extent"
regularly in the past, and it caused some disappointment when I was
first implementing that ioctl, since I was hoping I could do that easily. :)

Today I built a 4.14-rc1 with the 3 patches on top. I have been testing
with python-btrfs (of course :D) so I can quickly try out things.

https://github.com/knorrie/python-btrfs/commits/logical_ino_v2

> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> ---
>  fs/btrfs/ioctl.c           | 26 +++++++++++++++++++++++---
>  include/uapi/linux/btrfs.h |  8 +++++++-
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b7de32568082..f4281ffd1833 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4536,13 +4536,14 @@ static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
>  }
>  
>  static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
> -					void __user *arg)
> +					void __user *arg, int version)
>  {
>  	int ret = 0;
>  	int size;
>  	struct btrfs_ioctl_logical_ino_args *loi;
>  	struct btrfs_data_container *inodes = NULL;
>  	struct btrfs_path *path = NULL;
> +	bool ignore_offset;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -4551,6 +4552,22 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>  	if (IS_ERR(loi))
>  		return PTR_ERR(loi);
>  
> +	if (version == 1) {
> +		ignore_offset = false;
> +	} else {
> +		/* All reserved bits must be 0 for now */
> +		if (memchr_inv(loi->reserved, 0, sizeof(loi->reserved))) {
> +			ret = -EINVAL;
> +			goto out_loi;
> +		}

If I put a non-zero bit in the reserved field, it explodes with OSError:
[Errno 22] Invalid argument, check.

> +		/* Only accept flags we have defined so far */
> +		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET)) {
> +			ret = -EINVAL;
> +			goto out_loi;
> +		}

If I put any other flag in than nothing or only the first set, it
explodes with OSError: [Errno 22] Invalid argument, check.

> +		ignore_offset = loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
> +	}
> +
>  	path = btrfs_alloc_path();
>  	if (!path) {
> [...]

Testing:

-# cp /boot/vmlinuz-4.14.0-rc1-zygo1 /btrfs

-# ./show_block_groups.py /btrfs
block group vaddr 0 length 4194304 flags SYSTEM used 16384 used_pct 0
block group vaddr 4194304 length 8388608 flags METADATA used 131072
used_pct 2
block group vaddr 12582912 length 8388608 flags DATA used 0 used_pct 0
block group vaddr 20971520 length 268435456 flags METADATA used 0 used_pct 0

Using 'v1':

-# ./show_block_group_data_extent_filenames.py 12582912 /btrfs
block group vaddr 12582912 length 8388608 flags DATA used 4198400
used_pct 50
extent vaddr 12582912 length 4198400 refs 1 gen 17 flags DATA
    root 5 inode 258 offset 0 path utf-8 vmlinuz-4.14.0-rc1-zygo1

Let's overwrite the first few blocks:

-# dd if=/dev/urandom bs=16K conv=notrunc
of=/btrfs/vmlinuz-4.14.0-rc1-zygo1 count=1
1+0 records in
1+0 records out
16384 bytes (16 kB, 16 KiB) copied, 0.000191925 s, 85.4 MB/s

Here we see the limitation of the 'v1' ioctl. I get no name back for the
first extent any more:

-# ./show_block_group_data_extent_filenames.py 12582912 /btrfs
block group vaddr 12582912 length 8388608 flags DATA used 4214784
used_pct 50
extent vaddr 12582912 length 4198400 refs 1 gen 17 flags DATA
extent vaddr 16781312 length 16384 refs 1 gen 19 flags DATA
    root 5 inode 258 offset 0 path utf-8 vmlinuz-4.14.0-rc1-zygo1

(And to test that the 'v1' also still works...)
When I change it to use LOGICAL_INO_V2, it shows the same:

-# ./show_block_group_data_extent_filenames2.py 12582912 /btrfs
block group vaddr 12582912 length 8388608 flags DATA used 4214784
used_pct 50
extent vaddr 12582912 length 4198400 refs 1 gen 17 flags DATA
extent vaddr 16781312 length 16384 refs 1 gen 19 flags DATA
    root 5 inode 258 offset 0 path utf-8 vmlinuz-4.14.0-rc1-zygo1

When I also set the ignore_offset flag:

-# ./show_block_group_data_extent_filenames2.py 12582912 /btrfs
block group vaddr 12582912 length 8388608 flags DATA used 4214784
used_pct 50
extent vaddr 12582912 length 4198400 refs 1 gen 17 flags DATA
    root 5 inode 258 offset 16384 path utf-8 vmlinuz-4.14.0-rc1-zygo1
extent vaddr 16781312 length 16384 refs 1 gen 19 flags DATA
    root 5 inode 258 offset 0 path utf-8 vmlinuz-4.14.0-rc1-zygo1

Moo! No more brute forcing needed!

Reviewed-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Tested-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

-- 
Hans van Kranenburg
