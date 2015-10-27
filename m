Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34496 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbJ0JeO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 05:34:14 -0400
Received: by igpw7 with SMTP id w7so1890931igp.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 02:34:13 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
Date: Tue, 27 Oct 2015 09:34:13 +0000
Message-ID: <CAL3q7H7Fz80P9DMG5B5oZFprMdPcdC44YCZpgECZjaLt4=VY_g@mail.gmail.com>
Subject: ENOSPC regression in integration-4.4 branch
From: Filipe Manana <fdmanana@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Not sure if you are aware or got my report on IRC, but one of the
allocator fixes/improvements (Chris' integration-4.4 branch) is
causing new ENOSPC failures:

http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration-4.4&id=a5e681d9bd641c4f0677e87d3a0c92a8f4f16293

(couldn't find the patch in the mailing list, so starting this thread)

A few xfstests (generic ones) are now failing, like generic/077 which
constantly fails for me with:

244045.147965] run fstests generic/077 at 2015-10-27 00:24:27
[244045.945396] BTRFS: device fsid
cf433807-c8dd-4f89-96d1-73dcce55ee38 devid 1 transid 3 /dev/sdc
[244046.106326] BTRFS info (device sdc): disk space caching is enabled
[244046.107825] BTRFS: has skinny extents
[244046.113251] BTRFS: creating UUID tree
[244055.206756] BTRFS info (device sdc): disk space caching is enabled
[244055.208472] BTRFS: has skinny extents
[244055.240473] BTRFS: error (device sdc) in
btrfs_free_dev_extent:1454: errno=-28 No space left (Slot search
failed)
[244055.243138] BTRFS info (device sdc): forced readonly
[244055.244528] ------------[ cut here ]------------
[244055.245426] WARNING: CPU: 1 PID: 32239 at fs/btrfs/volumes.c:2771
btrfs_remove_chunk+0x2ff/0x795 [btrfs]()
[244055.247216] BTRFS: Transaction aborted (error -28)
[244055.248271] Modules linked in: btrfs dm_snapshot dm_bufio
dm_flakey dm_mod crc32c_generic xor raid6_pq nfsd auth_rpcgss
oid_registry nfs_acl nfs lockd grace fscache sunrpc loop fuse
parport_pc parport i2c_piix4 psmouse acpi_cpufreq microcode pcspkr
processor evdev i2c_core serio_raw button ext4 crc16 jbd2 mbcache
sd_mod sg sr_mod cdrom ata_generic virtio_scsi ata_piix libata floppy
virtio_pci virtio_ring scsi_mod e1000 virtio [last unloaded: btrfs]
[244055.258189] CPU: 1 PID: 32239 Comm: umount Tainted: G        W
  4.3.0-rc5-btrfs-next-17+ #1
[244055.259874] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org
04/01/2014
[244055.262228]  0000000000000000 ffff88011987fbd8 ffffffff812566f4
ffff88011987fc20
[244055.263688]  ffff88011987fc10 ffffffff8104d0a6 ffffffffa03e4fc7
00000000ffffffe4
[244055.265174]  ffff880045a9dc00 00000000ffffffe4 ffff8800acd6ad28
ffff88011987fc78
[244055.266541] Call Trace:
[244055.267023]  [<ffffffff812566f4>] dump_stack+0x4e/0x79
[244055.267889]  [<ffffffff8104d0a6>] warn_slowpath_common+0x9f/0xb8
[244055.268966]  [<ffffffffa03e4fc7>] ? btrfs_remove_chunk+0x2ff/0x795 [btrfs]
[244055.270326]  [<ffffffff8104d107>] warn_slowpath_fmt+0x48/0x50
[244055.271405]  [<ffffffffa03e4fc7>] btrfs_remove_chunk+0x2ff/0x795 [btrfs]
[244055.272563]  [<ffffffffa03b49b0>]
btrfs_delete_unused_bgs+0x29a/0x365 [btrfs]
[244055.273857]  [<ffffffffa03bebe2>] close_ctree+0xf3/0x33e [btrfs]
[244055.274837]  [<ffffffff811841ae>] ? evict_inodes+0x13b/0x14a
[244055.275780]  [<ffffffffa039a6d1>] btrfs_put_super+0x19/0x1b [btrfs]
[244055.276864]  [<ffffffff8116e9d9>] generic_shutdown_super+0x6a/0xea
[244055.277983]  [<ffffffff8116ee05>] kill_anon_super+0x12/0x1c
[244055.278948]  [<ffffffffa039a403>] btrfs_kill_super+0x16/0x21 [btrfs]
[244055.280042]  [<ffffffff8116e878>] deactivate_locked_super+0x3b/0x68
[244055.281165]  [<ffffffff8116e8db>] deactivate_super+0x36/0x39
[244055.282111]  [<ffffffff81186f7a>] cleanup_mnt+0x58/0x76
[244055.282995]  [<ffffffff81186fd6>] __cleanup_mnt+0x12/0x14
[244055.283899]  [<ffffffff8106798d>] task_work_run+0x6a/0x93
[244055.284848]  [<ffffffff81001948>] prepare_exit_to_usermode+0x91/0xac
[244055.287301]  [<ffffffff81001ab5>] syscall_return_slowpath+0x152/0x1ab
[244055.288506]  [<ffffffff8147cef1>] int_ret_from_sys_call+0x25/0x9f
[244055.289437] ---[ end trace 6ee4342a5722b12b ]---

Other tests like generic/103 also intermittently failed with ENOSPC here.
Without that patch, they all pass again.
There's plenty of unallocated space left (100G test devices) so these
tests shouldn't fail with ENOSPC.

Rings a bell?

thanks



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
