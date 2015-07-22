Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14394 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933017AbbGVJ3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 05:29:09 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "=?utf-8?Q?'Sas=C3=A0_Vita'?=" <totore9876@gmail.com>,
        <linux-btrfs@vger.kernel.org>
References: <CAL_C0_VTsfp7BbsRionsJ2SNJNqdNQ0Dyd4xrfsTm3wKzvnB_w@mail.gmail.com>
In-Reply-To: <CAL_C0_VTsfp7BbsRionsJ2SNJNqdNQ0Dyd4xrfsTm3wKzvnB_w@mail.gmail.com>
Subject: RE: stack trace (free_fs_root) with either fallocate + mv-across-subvolumes, or mount-wth-compress + dd
Date: Wed, 22 Jul 2015 17:28:13 +0800
Message-ID: <047201d0c460$bc02f7c0$3408e740$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Sasà Vita 

Thanks for reporting!

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Sasà Vita
> Sent: Wednesday, July 22, 2015 1:52 PM
> To: linux-btrfs@vger.kernel.org
> Subject: stack trace (free_fs_root) with either fallocate +
> mv-across-subvolumes, or mount-wth-compress + dd
> 
> The script below generates a stack trace, and some of the "mv dir/f dir/a"
> commands that it spawns fail with the message: "Device or resource busy".
> 
> The stack trace is not generated on every iteration. The "for" loop ensures that
> it is generated at least once.
> 
> Reproduced on Arch Linux, with various kernels from 3.11.2-1-ARCH up to
> 4.0.4-2-ARCH.
> 
> 
> mkdir dir
> truncate -s 3G loop
> 
> fun1() {
>   mount loop dir
>   btrfs subvolume create dir/a
>   fallocate -l 46M dir/f
>   mv dir/f dir/a
> }
> 
> for i in {1..30} ; do
>   mkfs.btrfs loop
>   fun1
>   umount dir
> done
> 
> 

I tested this script in following platforms,
but can't reproduce this bug:

1: physical machine, RHEL7.1, linux 4.2-rc1
2: physical machine, RHEL7.1, linux 4.0
3: physical machine, RHEL7.1, linux 3.11
4: kvm, RHEL6, linux 4.2-rc2

on both physical and loop device,
and 3 times(90 loops) tests.

Who can test it in other platform?

Thanks
Zhaolei

> [  112.060072] BTRFS: device fsid 88f9e1b0-d018-4f21-9598-22987aa2b893
> devid 1 transid 4 /dev/loop3
> [  112.067593] BTRFS info (device loop3): disk space caching is enabled
> [  112.067597] BTRFS: has skinny extents [  112.067599] BTRFS: flagging fs
> with big metadata feature [  112.068900] BTRFS: creating UUID tree
> [  112.316740] ------------[ cut here ]------------ [  112.316740] WARNING: CPU: 0
> PID: 1094 at fs/btrfs/disk-io.c:3549
> free_fs_root+0xe1/0xf0 [btrfs]()
> [  112.316740] Modules linked in: crc32c_generic btrfs xor raid6_pq
> cfg80211 rfkill ppdev psmouse snd_intel8x0 iosf_mbi joydev mousedev pcspkr
> snd_ac97_codec ac97_bus snd_pcm serio_raw i2c_piix4 i2c_core snd_timer
> snd soundcore parport_pc parport battery ac evdev mac_hid acpi_cpufreq
> processor sch_fq_codel nfs lockd grace sunrpc fscache
> ext4 crc16 mbcache jbd2 dm_snapshot dm_bufio dm_mod squashfs loop isofs
> sr_mod cdrom hid_generic usbhid hid atkbd libps2 ahci libahci ohci_pci ohci_hcd
> ehci_pci ehci_hcd libata scsi_mod usbcore usb_common
> e1000 intel_agp intel_gtt i8042 serio video button [  112.316740] CPU: 0 PID:
> 1094 Comm: umount Not tainted 4.0.4-2-ARCH #1 [  112.316740] Hardware
> name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  112.316740]  0000000000000000 000000001675626b ffff88004925bc88
> ffffffff81574b23
> [  112.316740]  0000000000000000 0000000000000000 ffff88004925bcc8
> ffffffff81074dda [  112.316740]  ffff88004925bcd8 ffff880000082000
> ffff880053082000
> ffff880053082068
> [  112.316740] Call Trace:
> [  112.316740]  [<ffffffff81574b23>] dump_stack+0x4c/0x6e [  112.316740]
> [<ffffffff81074dda>] warn_slowpath_common+0x8a/0xc0 [  112.316740]
> [<ffffffff81074f0a>] warn_slowpath_null+0x1a/0x20 [  112.316740]
> [<ffffffffa04f2bc1>] free_fs_root+0xe1/0xf0 [btrfs] [  112.316740]
> [<ffffffffa04f55bd>]
> btrfs_drop_and_free_fs_root+0x7d/0xc0 [btrfs] [  112.316740]
> [<ffffffffa04f56df>] btrfs_free_fs_roots+0xdf/0x180 [btrfs] [  112.316740]
> [<ffffffffa04f7471>] close_ctree+0x151/0x360 [btrfs] [  112.316740]
> [<ffffffff811f535d>] ? evict_inodes+0x13d/0x160 [  112.316740]
> [<ffffffffa04ca739>] btrfs_put_super+0x19/0x20 [btrfs] [  112.316740]
> [<ffffffff811da836>] generic_shutdown_super+0x76/0x100 [  112.316740]
> [<ffffffff811dab76>] kill_anon_super+0x16/0x30 [  112.316740]
> [<ffffffffa04ca398>] btrfs_kill_super+0x18/0x120 [btrfs] [  112.316740]
> [<ffffffff811daf69>] deactivate_locked_super+0x49/0x80 [  112.316740]
> [<ffffffff811db3dc>] deactivate_super+0x6c/0x80 [  112.316740]
> [<ffffffff811f8df3>] cleanup_mnt+0x43/0xa0 [  112.316740]
> [<ffffffff811f8ea2>] __cleanup_mnt+0x12/0x20 [  112.316740]
> [<ffffffff810917b4>] task_work_run+0xd4/0xf0 [  112.316740]
> [<ffffffff81015d35>] do_notify_resume+0x75/0x80 [  112.316740]
> [<ffffffff8157a6a3>] int_signal+0x12/0x17 [  112.316740] ---[ end trace
> 1cd8909b794df110 ]--- [  112.351293] VFS: Busy inodes after unmount of loop3.
> Self-destruct in 5 seconds.  Have a nice day...
> 
> 
> I tested a variant of the script, where only the fallocate line is changed, and
> replaced with:
> dd if=/dev/zero of=dir/f bs=512 count=1
> I was unable to reproduce the problem, in this case.
> 
> 
> A related issue: in the following script, some of the 'mv dir/a/f dir' commands
> enter the state D and hang, even if no external storage is involved and the
> loop-mounted file is on a tmpfs.
> 
> for i in {1..30} ; do
>   mkfs.btrfs loop
>   fun1
>   umount dir
>   mount loop dir
>   mv dir/a/f dir   # this may hang
>   umount dir
> done
> 
> 
> Furthermore, the following script also generates the same stack trace, as
> above.
> 
> mkdir dir
> truncate -s 3G loop
> 
> fun2() {
>   mount -ocompress=zlib loop dir   # or compress=lzo
>   dd if=/usr/bin/js of=dir/a bs=1024 count=2000 }
> 
> for i in {1..30} ; do
>   mkfs.btrfs loop
>   fun2
>   umount dir
> done
> 
> 
> Hope this helps.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

