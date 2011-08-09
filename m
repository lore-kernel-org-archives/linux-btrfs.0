From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Kernel bug at fs/bio.c:1499 during heavy I/O - mdadm linear used
Date: Tue, 9 Aug 2011 15:57:01 +0200
Message-ID: <CAOjO-iVjhYb_d2ad=OpBpvHgVtx=rmVLfh3rZZHd6Unz+5fu4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am having issues with my server, as I am getting kernel bugs about a
few minutes after starting rtorrent, while it's verifying hashes on
the fiels.

Unfortunately I can't figure out if this is a mdadm issue, a btrfs
issue or a hardware issue, but it seems to be fairly consistent. The
process is on btrfs-submit, so I figure it's a btrfs problem. Here's
the stacktrace in question:

[ 2109.468208] ------------[ cut here ]------------
[ 2109.468241] kernel BUG at fs/bio.c:1499!
[ 2109.468263] invalid opcode: 0000 [#1] PREEMPT SMP
[ 2109.468300] CPU 3
[ 2109.468312] Modules linked in: iptable_filter iptable_mangle
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables x_tables appletalk ipx p8022 psnap llc p8023 ipv6 ext2
mbcache loop usbhid hid usb_storage uas lm63 radeon ttm i2c_i801
drm_kms_helper uhci_hcd r8169 evdev drm mii i7core_edac serio_raw
pcspkr edac_core ehci_hcd i2c_algo_bit mxm_wmi i2c_core thermal
processor wmi iTCO_wdt usbcore fan button iTCO_vendor_support btrfs
zlib_deflate crc32c libcrc32c linear md_mod sg sd_mod ahci libahci
libata scsi_mod
[ 2109.468711]
[ 2109.468722] Pid: 265, comm: btrfs-submit-0 Not tainted 3.0-ARCH #1
OEM OEM/121-BL-E756
[ 2109.468773] RIP: 0010:[<ffffffff811896ab>]  [<ffffffff811896ab>]
bio_split+0x2eb/0x2f0
[ 2109.468823] RSP: 0018:ffff880156587ae0  EFLAGS: 00010206
[ 2109.468852] RAX: ffff8801565e0000 RBX: ffff88005795e240 RCX: 00000000025072c3
[ 2109.468891] RDX: ffff880015ae0000 RSI: 00000000000153a0 RDI: ffffffff810fa155
[ 2109.468930] RBP: ffff880156587b30 R08: 00000000e8dd8300 R09: 0000000000000000
[ 2109.468969] R10: 00000000000000f8 R11: 0000000000000000 R12: ffff880015ae0000
[ 2109.469008] R13: 00000000e8dd8300 R14: 0000000000000001 R15: 00000000e8dd8300
[ 2109.469047] FS:  0000000000000000(0000) GS:ffff88015fcc0000(0000)
knlGS:0000000000000000
[ 2109.469091] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2109.469122] CR2: 00007ff2784994aa CR3: 0000000001693000 CR4: 00000000000006e0
[ 2109.469161] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2109.469200] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2109.469239] Process btrfs-submit-0 (pid: 265, threadinfo
ffff880156586000, task ffff8801573ea3f0)
[ 2109.469286] Stack:
[ 2109.469298]  0000000000000001 0000000000000000 ffff8801565e0000
000000e000000000
[ 2109.469344]  0000000000000000 ffff88005795e240 ffff880158360800
00000000e8dd8300
[ 2109.469389]  0000000000000001 00000000e8dd8220 ffff880156587ba0
ffffffffa00a2687
[ 2109.469435] Call Trace:
[ 2109.469453]  [<ffffffffa00a2687>] linear_make_request+0x117/0x1c0 [linear]
[ 2109.469493]  [<ffffffff812118d6>] ? throtl_find_tg+0x46/0x60
[ 2109.469525]  [<ffffffff812121bb>] ? blk_throtl_bio+0x1fb/0x620
[ 2109.469560]  [<ffffffffa0085c52>] md_make_request+0x102/0x250 [md_mod]
[ 2109.469597]  [<ffffffff81201c6e>] generic_make_request+0x30e/0x5c0
[ 2109.469633]  [<ffffffff813efe9e>] ? schedule+0x34e/0x9f0
[ 2109.469663]  [<ffffffff81201fa7>] submit_bio+0x87/0x110
[ 2109.469693]  [<ffffffff8106cc18>] ? lock_timer_base.isra.30+0x38/0x70
[ 2109.469739]  [<ffffffffa0108d53>] run_scheduled_bios+0x253/0x510 [btrfs]
[ 2109.469782]  [<ffffffffa0109025>] pending_bios_fn+0x15/0x20 [btrfs]
[ 2109.469822]  [<ffffffffa010fb45>] worker_loop+0x165/0x520 [btrfs]
[ 2109.469862]  [<ffffffffa010f9e0>] ? btrfs_queue_worker+0x2f0/0x2f0 [btrfs]
[ 2109.469901]  [<ffffffff8107ed2c>] kthread+0x8c/0xa0
[ 2109.469930]  [<ffffffff813f4ea4>] kernel_thread_helper+0x4/0x10
[ 2109.469964]  [<ffffffff8107eca0>] ? kthread_worker_fn+0x190/0x190
[ 2109.469998]  [<ffffffff813f4ea0>] ? gs_change+0x13/0x13
[ 2109.470026] Code: 65 48 8b 04 25 48 cd 00 00 83 a8 44 e0 ff ff 01
48 8b 80 38 e0 ff ff a8 08 0f 84 7c fd ff ff e8 2c 71 26 00 e9 72 fd
ff ff 0f 0b <0f> 0b 0f 1f 00 55 48 89 e5 41 54 53 66 66 66 66 90 8b 56
3c 48
[ 2109.470323] RIP  [<ffffffff811896ab>] bio_split+0x2eb/0x2f0
[ 2109.470356]  RSP <ffff880156587ae0>
[ 2109.486493] ---[ end trace 2077ba124373992b ]---

If this isn't a btrfs problem please forgive me and let me know :)

Also, PLEASE CC me if you're responding to this! I am not subscribed
to the mailing list.

Regards,
-- 
Sebastian J.
