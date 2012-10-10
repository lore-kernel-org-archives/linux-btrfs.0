Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58366 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2JJUV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Oct 2012 16:21:56 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so959988obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2012 13:21:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121001122832.53c25596@natsu>
References: <20121001122832.53c25596@natsu>
Date: Wed, 10 Oct 2012 15:21:55 -0500
Message-ID: <CAKcLGm8_ACVv0_+38aMJJFq0QSY01qoEVhWaPYfcHuLFUdRQAQ@mail.gmail.com>
Subject: Re: block rsv returned -28 during balance
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 1, 2012 at 1:28 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> Hello,
>
> On a 3.6.0-rc7 kernel, I launched:
>
>   # btrfs fi balance start -f -mconvert=single /mnt/tmp/
>
> Current situation:
>
> # df -h /mnt/tmp/
> Filesystem             Size  Used Avail Use% Mounted on
> /dev/mapper/alpha-lv1  3.6T  2.7T  801G  78% /mnt/tmp
>
> # btrfs fi df /mnt/tmp/
> Data: total=3.00TB, used=2.66TB
> System: total=4.00MB, used=364.00KB
> Metadata, DUP: total=11.00GB, used=5.72GB
> Metadata: total=63.00GB, used=0.00
>
> There seems to be plenty of free space, but the balance seems to have stalled
> and the dmesg is being filled with messages like this:
>
> [ 2926.465406] btrfs: block rsv returned -28
> [ 2926.465411] ------------[ cut here ]------------
> [ 2926.465446] WARNING: at /home/apw/COD/linux/fs/btrfs/extent-tree.c:6323 use_block_rsv+0x19f/0x1b0 [btrfs]()
> [ 2926.465450] Hardware name: VirtualBox
> [ 2926.465452] Modules linked in: joydev microcode parport_pc hid_generic parport psmouse serio_raw pcspkr i2c_piix4 mac_hid xfs btrfs libcrc32c zlib_deflate raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq usbhid hid e1000
> [ 2926.465517] Pid: 4682, comm: btrfs Tainted: G        W    3.6.0-030600rc7-generic #201209232235

I've just run into the same issue running a balance.  My kernel is a
3.6.1 kernel merged with the latest for-linus branch.  The dmesg log
is full of warnings, and the balance appears stuck.

Looking at the results of 'btrfs fi df ...", it almost seems like
btrfs is unable to allocate any more metadata space, even though there
is some space available.

# btrfs fi df /mnt/sabayon8/
Data: total=7.14GB, used=6.08GB
System: total=4.00MB, used=4.00KB
Metadata: total=1.00GB, used=973.32MB

# df -T /mnt/sabayon8/
Filesystem     Type  1K-blocks    Used Available Use% Mounted on
/dev/sdb5      btrfs  10008460 7373064   2537536  75% /mnt/sabayon8


For reference here's an example of the dmesg warning:

[ 4070.726429] btrfs: block rsv returned -28
[ 4070.726431] ------------[ cut here ]------------
[ 4070.726455] WARNING: at fs/btrfs/extent-tree.c:6359
btrfs_alloc_free_block+0x4ee/0x500 [btrfs]()
[ 4070.726531] Hardware name:
[ 4070.726533] Modules linked in: nvidia(PO) nvidia_agp xts gf128mul
ablk_helper cryptd sha256_generic btrfs libcrc32c xhci_hcd
[ 4070.726543] Pid: 8717, comm: btrfs Tainted: P        W  O 3.6.1-git-local+ #1
[ 4070.726545] Call Trace:
[ 4070.726552]  [<c1029952>] warn_slowpath_common+0x72/0xa0
[ 4070.726569]  [<f85d38de>] ? btrfs_alloc_free_block+0x4ee/0x500 [btrfs]
[ 4070.726585]  [<f85d38de>] ? btrfs_alloc_free_block+0x4ee/0x500 [btrfs]
[ 4070.726590]  [<c10299a2>] warn_slowpath_null+0x22/0x30
[ 4070.726606]  [<f85d38de>] btrfs_alloc_free_block+0x4ee/0x500 [btrfs]
[ 4070.726628]  [<f8603c0c>] ? read_extent_buffer+0x9c/0x100 [btrfs]
[ 4070.726643]  [<f85c0394>] __btrfs_cow_block+0x144/0x590 [btrfs]
[ 4070.726731]  [<f85ddb65>] ? verify_parent_transid+0x55/0x1c0 [btrfs]
[ 4070.726746]  [<f85c08b9>] ? btrfs_cow_block+0xd9/0x230 [btrfs]
[ 4070.726765]  [<f85fc799>] ? mark_extent_buffer_accessed+0x59/0x70 [btrfs]
[ 4070.726780]  [<f85c08b9>] btrfs_cow_block+0xd9/0x230 [btrfs]
[ 4070.726801]  [<f862815a>] do_relocation+0x42a/0x4d0 [btrfs]
[ 4070.726818]  [<f85d00fb>] ? btrfs_block_rsv_add+0x6b/0x80 [btrfs]
[ 4070.726838]  [<f862bb9a>] relocate_tree_blocks+0x3fa/0x5a0 [btrfs]
[ 4070.726929]  [<f862ca42>] relocate_block_group+0x212/0x670 [btrfs]
[ 4070.726950]  [<f862d030>] btrfs_relocate_block_group+0x190/0x2e0 [btrfs]
[ 4070.726969]  [<f8605a57>] btrfs_relocate_chunk.isra.54+0x57/0x690 [btrfs]
[ 4070.726989]  [<f85fa351>] ? btrfs_get_token_64+0x61/0x100 [btrfs]
[ 4070.727008]  [<f8602bf6>] ? free_extent_buffer+0x26/0x70 [btrfs]
[ 4070.727045]  [<f860ad41>] btrfs_balance+0x9b1/0xf40 [btrfs]
[ 4070.727051]  [<c12f14ae>] ? cred_has_capability+0x7e/0xf0
[ 4070.727071]  [<f861254b>] btrfs_ioctl_balance+0xcb/0x330 [btrfs]
[ 4070.727163]  [<f8614777>] btrfs_ioctl+0x907/0x1840 [btrfs]
[ 4070.727168]  [<c10bcd22>] ? lru_cache_add_lru+0x22/0x40
[ 4070.727172]  [<c10cf00f>] ? handle_pte_fault+0x42f/0x5c0
[ 4070.727192]  [<f8613e70>] ? update_ioctl_balance_args+0x240/0x240 [btrfs]
[ 4070.727197]  [<c10f5cf2>] do_vfs_ioctl+0x82/0x570
[ 4070.727202]  [<c12f1dba>] ? inode_has_perm.isra.42.constprop.68+0x3a/0x50
[ 4070.727206]  [<c12f43c6>] ? selinux_file_ioctl+0x46/0xe0
[ 4070.727209]  [<c10f624f>] sys_ioctl+0x6f/0x80
[ 4070.727214]  [<c176e693>] sysenter_do_call+0x12/0x22
[ 4070.727217] ---[ end trace b39bb21a5ae11cb1 ]---
