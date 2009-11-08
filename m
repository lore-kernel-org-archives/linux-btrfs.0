From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: 2.6.32-rc6: kernel BUG at fs/btrfs/volumes.c:1746
Date: Mon, 9 Nov 2009 00:56:29 +0800
Message-ID: <3d0408630911080856g3f4e65b2k11daaccdd4e53424@mail.gmail.com>
References: <a4423d670911080631k3a5d26b5n852885f02c4d81ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a4423d670911080631k3a5d26b5n852885f02c4d81ba@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 8, 2009 at 10:31 PM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
> Hi
>
> Filesystem was created by 'mkfs.btrfs -d raid0 /dev/sd[ef]".
> Kernel is 2.6.32-rc6.
>
> # btrfs-show
> Label: none =A0uuid: be452097-a24c-420e-b47d-c8eb68fe8bce
> =A0 =A0 =A0 =A0Total devices 2 FS bytes used 105.88GB
> =A0 =A0 =A0 =A0devid =A0 =A02 size 74.54GB used 70.01GB path /dev/sdf
> =A0 =A0 =A0 =A0devid =A0 =A01 size 74.54GB used 70.03GB path /dev/sde
>
> Btrfs Btrfs v0.19
>
> # btrfs-vol -b /mnt/e
> Segmentation fault
>
>
> WARNING: at fs/btrfs/relocation.c:3588
> btrfs_relocate_block_group+0x236/0x340 [btrfs]()
> Hardware name:
> Modules linked in: btrfs zlib_deflate zlib_inflate hwmon_vid sata_sil
> i2c_nforce2
> Pid: 32148, comm: btrfs-vol Not tainted 2.6.32-rc6 #4
> Call Trace:
> =A0[<c1345267>] ? printk+0x18/0x21
> =A0[<c1029ced>] warn_slowpath_common+0x6d/0xa0
> =A0[<f9b2fc26>] ? btrfs_relocate_block_group+0x236/0x340 [btrfs]
> =A0[<f9b2fc26>] ? btrfs_relocate_block_group+0x236/0x340 [btrfs]
> =A0[<c1029d35>] warn_slowpath_null+0x15/0x20
> =A0[<f9b2fc26>] btrfs_relocate_block_group+0x236/0x340 [btrfs]
> =A0[<f9b189f6>] btrfs_relocate_chunk+0x66/0x540 [btrfs]
> =A0[<f9b0d3dc>] ? unmap_extent_buffer+0xc/0x10 [btrfs]
> =A0[<f9b01ebf>] ? btrfs_item_offset+0xdf/0xf0 [btrfs]
> =A0[<f9b19604>] btrfs_balance+0x294/0x320 [btrfs]
> =A0[<f9b1e081>] btrfs_ioctl+0x361/0xa60 [btrfs]
> =A0[<c106d48b>] ? __alloc_pages_nodemask+0xeb/0x570
> =A0[<c104f89a>] ? print_lock_contention_bug+0x1a/0xe0
> =A0[<c107c14c>] ? handle_mm_fault+0x4fc/0x5b0
> =A0[<f9b1dd20>] ? btrfs_ioctl+0x0/0xa60 [btrfs]
> =A0[<c109d68c>] vfs_ioctl+0x1c/0x70
> =A0[<c109d93a>] do_vfs_ioctl+0x6a/0x5a0
> =A0[<c1347c5d>] ? _spin_unlock+0x1d/0x20
> =A0[<c107be08>] ? handle_mm_fault+0x1b8/0x5b0
> =A0[<c134a0cb>] ? do_page_fault+0x9b/0x370
> =A0[<c134a185>] ? do_page_fault+0x155/0x370
> =A0[<c1040a56>] ? up_read+0x16/0x30
> =A0[<c134a185>] ? do_page_fault+0x155/0x370
> =A0[<c109dea9>] sys_ioctl+0x39/0x60
> =A0[<c1002c58>] sysenter_do_call+0x12/0x36

Please send full kernel log.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
