From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: kernel BUG at /usr/src/linux-head/fs/btrfs/inode.c:2951!
Date: Thu, 15 Mar 2012 00:02:37 -0400
Message-ID: <20120315000237.7a079149@Bidule>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

So, it happened when doing "btrfs subvolume delete $path".

I was filling in my report and decided to check the volume with the latest btrfsck
(the distro-provided one found nothing, but it is quite old) and dangerdonteveruse
from today gave zillions of errors, so this bug report concerns more FS robustness
than a bug that needs to be fixed at this stage.

Though, since I need to reboot the computer now, I kind of wish the excessive
BUG_ON were replaced by graceful error handling...

$ git grep BUG_ON -- fs/ext4 | wc -l
169
$ git grep BUG_ON -- fs/btrfs | wc -l
733

Regards,

-- 
cJ


[ 7648.180068] ------------[ cut here ]------------
[ 7648.180077] kernel BUG at /usr/src/linux-head/fs/btrfs/inode.c:2951!
[ 7648.180084] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 7648.180093] CPU 0 
[ 7648.180096] Modules linked in: dm_crypt dm_mod nfsd lockd nfs_acl auth_rpcgss sunrpc usbhid usb_storage vfat fat usb_libusual snd_hda_codec_hdmi snd_hda_codec_realtek ohci_hcd snd_hda_intel snd_hda_codec xhci_hcd snd_hwdep snd_pcm ehci_hcd firewire_ohci snd_timer r8169 edac_core usbcore snd firewire_core k10temp i2c_piix4 edac_mce_amd mii fam15h_power pcspkr crc_itu_t soundcore snd_page_alloc usb_common wmi powernow_k8 processor mperf it87 hwmon_vid hwmon it87_wdt tun msr fuse autofs4
[ 7648.180182] 
[ 7648.180188] Pid: 23764, comm: btrfs Tainted: G        W    3.3.0-rc7-Bidule-00048-g762ad8a #3 To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX
[ 7648.180201] RIP: 0010:[<ffffffff8127d612>]  [<ffffffff8127d612>] btrfs_unlink_subvol+0x262/0x270
[ 7648.180215] RSP: 0018:ffff880323a69d08  EFLAGS: 00010286
[ 7648.180220] RAX: 00000000ffffffe4 RBX: ffff8802a6194800 RCX: ffff88035882b198
[ 7648.180225] RDX: ffff88035882b198 RSI: 0000000000000000 RDI: ffff88029b9736c8
[ 7648.180230] RBP: ffff880323a69d88 R08: ffffffff812bc360 R09: 0000000000000000
[ 7648.180235] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880337001000
[ 7648.180241] R13: ffff88042dc0f510 R14: ffff88042a3e35e8 R15: 00000000002bc010
[ 7648.180247] FS:  00007f7448e2d740(0000) GS:ffff88043ec00000(0000) knlGS:00000000f41beb70
[ 7648.180253] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7648.180257] CR2: 00000030005181d0 CR3: 00000003d2851000 CR4: 00000000000406f0
[ 7648.180263] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7648.180268] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7648.180274] Process btrfs (pid: 23764, threadinfo ffff880323a68000, task ffff88004ac14470)
[ 7648.180278] Stack:
[ 7648.180282]  ffff8802b1e0b7b8 ffff880300000016 0000000000000f93 0000000000000184
[ 7648.180293]  ffff8802b1e0b7b8 00000016815ac6dd 84ff880323a69d58 8400000000000001
[ 7648.180303]  ffffffffffffffff 0000000000000002 ffff880359031b00 ffff8804222bd000
[ 7648.180313] Call Trace:
[ 7648.180326]  [<ffffffff812a1945>] btrfs_ioctl_snap_destroy+0x275/0x4b0
[ 7648.180334]  [<ffffffff812a44ab>] btrfs_ioctl+0x49b/0x1260
[ 7648.180344]  [<ffffffff815b6b3c>] ? do_page_fault+0x1dc/0x520
[ 7648.180353]  [<ffffffff8116216f>] do_vfs_ioctl+0x8f/0x4f0
[ 7648.180361]  [<ffffffff81150150>] ? vfs_write+0x110/0x180
[ 7648.180368]  [<ffffffff81162661>] sys_ioctl+0x91/0xa0
[ 7648.180377]  [<ffffffff815baad2>] system_call_fastpath+0x16/0x1b
[ 7648.180382] Code: 90 48 39 55 98 0f 85 77 fe ff ff e9 8b fe ff ff 90 0f 0b 66 0f 1f 44 00 00 0f 0b 66 0f 1f 44 00 00 b8 f4 ff ff ff e9 43 ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec 
[ 7648.180487] RIP  [<ffffffff8127d612>] btrfs_unlink_subvol+0x262/0x270
[ 7648.180495]  RSP <ffff880323a69d08>
[ 7648.180501] ---[ end trace 618c04afd5d82b28 ]---

Side note: when trying to unmount the volume, you will get a kernel BUG at /usr/src/linux-head/fs/dcache.c:908!

[ 8127.479885] ------------[ cut here ]------------
[ 8127.479898] WARNING: at /usr/src/linux-head/fs/namespace.c:795 mntput_no_expire+0xfc/0x130()
[ 8127.479904] Hardware name: To be filled by O.E.M.
[ 8127.479908] Modules linked in: dm_crypt dm_mod nfsd lockd nfs_acl auth_rpcgss sunrpc usbhid usb_storage vfat fat usb_libusual snd_hda_codec_hdmi snd_hda_codec_realtek ohci_hcd snd_hda_intel snd_hda_codec xhci_hcd snd_hwdep snd_pcm ehci_hcd firewire_ohci snd_timer r8169 edac_core usbcore snd firewire_core k10temp i2c_piix4 edac_mce_amd mii fam15h_power pcspkr crc_itu_t soundcore snd_page_alloc usb_common wmi powernow_k8 processor mperf it87 hwmon_vid hwmon it87_wdt tun msr fuse autofs4
[ 8127.480025] Pid: 24579, comm: umount Tainted: G      D W    3.3.0-rc7-Bidule-00048-g762ad8a #3
[ 8127.480031] Call Trace:
[ 8127.480041]  [<ffffffff81043c1f>] warn_slowpath_common+0x7f/0xc0
[ 8127.480049]  [<ffffffff81043c7a>] warn_slowpath_null+0x1a/0x20
[ 8127.480056]  [<ffffffff8116e86c>] mntput_no_expire+0xfc/0x130
[ 8127.480065]  [<ffffffff8116f5ce>] sys_umount+0x6e/0x380
[ 8127.480076]  [<ffffffff815baad2>] system_call_fastpath+0x16/0x1b
[ 8127.480083] ---[ end trace 618c04afd5d82b29 ]---
[ 8127.480105] BUG: Dentry ffff8802b1e0b780{i=100,n=sync-potiok-2012-01-16} still in use (1) [unmount of btrfs dm-2]
[ 8127.480124] ------------[ cut here ]------------
[ 8127.480133] kernel BUG at /usr/src/linux-head/fs/dcache.c:908!
[ 8127.480144] invalid opcode: 0000 [#2] PREEMPT SMP 
[ 8127.480174] CPU 4 
[ 8127.480183] Modules linked in: dm_crypt dm_mod nfsd lockd nfs_acl auth_rpcgss sunrpc usbhid usb_storage vfat fat usb_libusual snd_hda_codec_hdmi snd_hda_codec_realtek ohci_hcd snd_hda_intel snd_hda_codec xhci_hcd snd_hwdep snd_pcm ehci_hcd firewire_ohci snd_timer r8169 edac_core usbcore snd firewire_core k10temp i2c_piix4 edac_mce_amd mii fam15h_power pcspkr crc_itu_t soundcore snd_page_alloc usb_common wmi powernow_k8 processor mperf it87 hwmon_vid hwmon it87_wdt tun msr fuse autofs4
[ 8127.480486] 
[ 8127.480496] Pid: 24579, comm: umount Tainted: G      D W    3.3.0-rc7-Bidule-00048-g762ad8a #3 To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX
[ 8127.480528] RIP: 0010:[<ffffffff811669d6>]  [<ffffffff811669d6>] shrink_dcache_for_umount_subtree+0x1d6/0x1e0
[ 8127.480551] RSP: 0018:ffff88004a4d1dc8  EFLAGS: 00010296
[ 8127.480560] RAX: 000000000000007b RBX: ffff8802b1e0b780 RCX: 0000000000000000
[ 8127.480570] RDX: 000000000000006c RSI: 0000000000000046 RDI: ffffffff810443cd
[ 8127.480580] RBP: ffff88004a4d1de8 R08: 0000000000000000 R09: 0000000000000000
[ 8127.480589] R10: 0000000000000000 R11: 000000000000000d R12: ffff8802db9d1a80
[ 8127.480599] R13: ffff880049cbf720 R14: ffff880049cbf720 R15: ffff88032762fc00
[ 8127.480609] FS:  00007f30e56ca740(0000) GS:ffff88043ed00000(0000) knlGS:00000000f76f4aa0
[ 8127.480619] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8127.480628] CR2: 0000003000435520 CR3: 0000000318aa3000 CR4: 00000000000406e0
[ 8127.480638] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8127.480647] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8127.480657] Process umount (pid: 24579, threadinfo ffff88004a4d0000, task ffff880345f8ada0)
[ 8127.480671] Stack:
[ 8127.480680]  ffff88032762fec0 0000000000000009 ffff88032762fc00 ffffffff8162fe20
[ 8127.480713]  ffff88004a4d1e08 ffffffff81167b22 ffff88004a4d1e58 ffff88032762fc00
[ 8127.480750]  ffff88004a4d1e38 ffffffff8115210c ffff88004a4d1e38 0000000000000036
[ 8127.480781] Call Trace:
[ 8127.480798]  [<ffffffff81167b22>] shrink_dcache_for_umount+0x32/0x60
[ 8127.480815]  [<ffffffff8115210c>] generic_shutdown_super+0x2c/0xf0
[ 8127.480832]  [<ffffffff81152266>] kill_anon_super+0x16/0x30
[ 8127.480848]  [<ffffffff8125005a>] btrfs_kill_super+0x1a/0x90
[ 8127.480862]  [<ffffffff811524ac>] deactivate_locked_super+0x3c/0x90
[ 8127.480878]  [<ffffffff81152fce>] deactivate_super+0x4e/0x70
[ 8127.480893]  [<ffffffff8116e84c>] mntput_no_expire+0xdc/0x130
[ 8127.480912]  [<ffffffff8116f5ce>] sys_umount+0x6e/0x380
[ 8127.480931]  [<ffffffff815baad2>] system_call_fastpath+0x16/0x1b
[ 8127.480943] Code: 00 00 48 8b 40 28 4c 8b 08 48 8b 43 30 48 85 c0 74 04 48 8b 50 40 48 89 34 24 48 c7 c7 58 45 7b 81 48 89 de 31 c0 e8 77 19 44 00 <0f> 0b 0f 0b 66 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 
[ 8127.481017] RIP  [<ffffffff811669d6>] shrink_dcache_for_umount_subtree+0x1d6/0x1e0
[ 8127.481017]  RSP <ffff88004a4d1dc8>
[ 8127.481411] ---[ end trace 618c04afd5d82b2a ]---
