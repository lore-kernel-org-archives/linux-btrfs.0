From: Chris Mason <chris.mason@oracle.com>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:3546 write_extent_buffer()
Date: Thu, 20 Nov 2008 16:58:11 -0500
Message-ID: <1227218291.9895.0.camel@think.oraclecorp.com>
References: <a4423d670811201350le43f908m6fd59b72efa9ecf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670811201350le43f908m6fd59b72efa9ecf4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-11-21 at 00:50 +0300, Alexander Beregalov wrote:
> Hi
> 
> I try to run btrfs (Linus's-git + btrfs-unstable) on sparc64:
> 

On sparc64, you'll have to set the sectorsize to your page size.  What
is the output from mkfs.btrfs?

-chris

> device fsid 1f5369b18fa4bb4-8268533a4c733861 devid 1 transid 9 /dev/sdb1
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent_io.c:3546 write_extent_buffer+0x134/0x144()
> Modules linked in:
> Call Trace:
>  [000000000045067c] warn_on_slowpath+0x4c/0x6c
>  [00000000005e39d0] write_extent_buffer+0x134/0x144
>  [00000000005e7ff4] btrfs_read_sys_array+0x4c/0x330
>  [00000000005b76a0] open_ctree+0xb3c/0x1250
>  [000000000058ce1c] btrfs_get_sb+0x254/0x498
>  [00000000004b3a64] vfs_kern_mount+0x44/0xa4
>  [00000000004b3b20] do_kern_mount+0x30/0xcc
>  [00000000004c8cd8] do_mount+0x78c/0x7d8
>  [00000000004e56ec] compat_sys_mount+0x21c/0x26c
>  [0000000000406154] linux_sparc_syscall32+0x34/0x40
> ---[ end trace 5e8d2fdd33a1d24e ]---
> 
> 
> Then
> I see many indentical messages while running dbench:
> 
> Kernel unaligned access at TPC[5b2a98] btrfs_csum_final+0x44/0x50
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

