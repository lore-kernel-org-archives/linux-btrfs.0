Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:42558 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdIWVGo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Sep 2017 17:06:44 -0400
Subject: Re: [PATCH 3/3] btrfs: increase output size for LOGICAL_INO_V2 ioctl
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
 <20170922175847.6071-4-ce3g8jdj@umail.furryterror.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <c2778a9a-3d94-7888-657c-317c5bbf1ed7@mendix.com>
Date: Sat, 23 Sep 2017 23:06:42 +0200
MIME-Version: 1.0
In-Reply-To: <20170922175847.6071-4-ce3g8jdj@umail.furryterror.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/2017 07:58 PM, Zygo Blaxell wrote:
> Build-server workloads have hundreds of references per file after dedup.
> Multiply by a few snapshots and we quickly exhaust the limit of 2730
> references per extent that can fit into a 64K buffer.

Simulating this scenario:

/btrfs 2-# btrfs sub create 0
Create subvolume './0'
/btrfs 2-# cp /boot/vmlinuz-4.14.0-rc1-zygo1 0/0
/btrfs 2-# for i in $(seq 1 499); do cp --reflink 0/0 0/$i; done
/btrfs 2-# for i in $(seq 1 5); do btrfs sub snap 0 $i; done
Create a snapshot of '0' in './1'
Create a snapshot of '0' in './2'
Create a snapshot of '0' in './3'
Create a snapshot of '0' in './4'
Create a snapshot of '0' in './5'

-# ./show_block_groups.py /btrfs
block group vaddr 0 length 4194304 flags SYSTEM used 16384 used_pct 0
block group vaddr 4194304 length 8388608 flags METADATA used 507904
used_pct 6
block group vaddr 12582912 length 8388608 flags DATA used 4198400
used_pct 50
block group vaddr 20971520 length 268435456 flags METADATA used 0 used_pct 0

-# ./show_block_group_contents.py 12582912 /btrfs
block group vaddr 12582912 length 8388608 flags DATA used 4198400
used_pct 50
extent vaddr 12582912 length 4198400 refs 500 gen 25 flags DATA
    inline extent data backref root 257 objectid 262 offset 0 count 1
    inline extent data backref root 257 objectid 277 offset 0 count 1
    inline extent data backref root 257 objectid 288 offset 0 count 1
    [...]
    extent data backref root 257 objectid 663 offset 0 count 1
    extent data backref root 257 objectid 366 offset 0 count 1
    extent data backref root 257 objectid 715 offset 0 count 1
    extent data backref root 257 objectid 306 offset 0 count 1
    extent data backref root 257 objectid 470 offset 0 count 1
    [...]

Total 500 lines, the extra 2500 files in the snapshots are hidden behind
the shared metadata refs now...

> 
> Raise the limit to 16M to be consistent with other btrfs ioctls
> (e.g. TREE_SEARCH_V2, FILE_EXTENT_SAME).
> 
> To minimize surprising userspace behavior, apply this change only to
> the LOGICAL_INO_V2 ioctl.
> 
> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> ---
>  fs/btrfs/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index f4281ffd1833..1940678fc440 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4554,6 +4554,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>  
>  	if (version == 1) {
>  		ignore_offset = false;
> +		size = min_t(u32, loi->size, SZ_64K);
>  	} else {
>  		/* All reserved bits must be 0 for now */
>  		if (memchr_inv(loi->reserved, 0, sizeof(loi->reserved))) {
> @@ -4566,6 +4567,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>  			goto out_loi;
>  		}
>  		ignore_offset = loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
> +		size = min_t(u32, loi->size, SZ_16M);
>  	}
>  
>  	path = btrfs_alloc_path();
> @@ -4574,7 +4576,6 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>  		goto out;
>  	}
>  
> -	size = min_t(u32, loi->size, SZ_64K);
>  	inodes = init_data_container(size);
>  	if (IS_ERR(inodes)) {
>  		ret = PTR_ERR(inodes);
> 

>>> import btrfs
>>> fs = btrfs.FileSystem('/btrfs')

Checking that 'v1' still works:

>>> inodes, bytes_missed = btrfs.ioctl.logical_to_ino(fs.fd, 12582912,
65536)
>>> len(inodes)
2730
>>> bytes_missed
6480

Yes, we only get 2730, as expected with a 64k buffer.

v2 can do the same:

>>> inodes, bytes_missed = btrfs.ioctl.logical_to_ino_v2(fs.fd,
12582912, 65536)
>>> len(inodes)
2730
>>> bytes_missed
6480

The bytes_missed is really useful, because it tells us the exact size of
the buf we need instead :)

>>> inodes, bytes_missed = btrfs.ioctl.logical_to_ino_v2(fs.fd,
12582912, 65536 + 6480)
>>> len(inodes)
3000
>>> bytes_missed
0

Yay!

If I remove the buffer size sanity check inside the python-btrfs ioctl code:

>>> import btrfs
>>> fs = btrfs.FileSystem('/btrfs')
>>> inodes, bytes_missed = btrfs.ioctl.logical_to_ino(fs.fd, 12582912,
65536 + 6480)
>>> len(inodes)
2730
>>> bytes_missed
6480

Yes, buffer still gets truncated to 64k in the v1 code.

Reviewed-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Tested-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

-- 
Hans van Kranenburg
