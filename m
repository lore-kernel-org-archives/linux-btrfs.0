From: Hadmut Danisch <hadmut@danisch.de>
Subject: btrfs crashing 3.2.0-030200rc2-generic
Date: Mon, 19 Dec 2011 15:29:06 +0100
Message-ID: <4EEF4A32.10409@msgid.danisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

just in case anybody wants to know: btrfs just crashed my kernel.

regards



Dec 19 15:13:53 sodom kernel: [19781.993189] INFO: task
udisks-daemon:2987 blocked for more than 120 seconds.
Dec 19 15:13:53 sodom kernel: [19781.993192] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 19 15:13:53 sodom kernel: [19781.993194] udisks-daemon   D
ffff8803bfe51ab0     0  2987   2984 0x00000000
Dec 19 15:13:53 sodom kernel: [19781.993197]  ffff8803bfed7b28
0000000000000082 0000000000000000 000000003ee8e83f
Dec 19 15:13:53 sodom kernel: [19781.993200]  0000000000013640
ffff8803bfed7fd8 ffff8803bfed6010 0000000000013640
Dec 19 15:13:53 sodom kernel: [19781.993203]  ffff8803bfed7fd8
0000000000013640 ffffffff81c0d020 ffff8803bfe516f0
Dec 19 15:13:53 sodom kernel: [19781.993206] Call Trace:
Dec 19 15:13:53 sodom kernel: [19781.993211]  [<ffffffff81304486>] ?
get_disk+0x56/0xc0
Dec 19 15:13:53 sodom kernel: [19781.993214]  [<ffffffff8160c7af>]
schedule+0x3f/0x60
Dec 19 15:13:53 sodom kernel: [19781.993217]  [<ffffffff8160d3df>]
__mutex_lock_slowpath+0xdf/0x160
Dec 19 15:13:53 sodom kernel: [19781.993219]  [<ffffffff8160d2db>]
mutex_lock+0x2b/0x50
Dec 19 15:13:53 sodom kernel: [19781.993222]  [<ffffffff811aedb3>]
__blkdev_get+0x73/0x430
Dec 19 15:13:53 sodom kernel: [19781.993225]  [<ffffffff811af1cc>]
blkdev_get+0x5c/0x210
Dec 19 15:13:53 sodom kernel: [19781.993227]  [<ffffffff8160e7fe>] ?
_raw_spin_lock+0xe/0x20
Dec 19 15:13:53 sodom kernel: [19781.993229]  [<ffffffff811af3e2>]
blkdev_open+0x62/0x80
Dec 19 15:13:53 sodom kernel: [19781.993232]  [<ffffffff81176213>]
__dentry_open+0x243/0x350
Dec 19 15:13:53 sodom kernel: [19781.993235]  [<ffffffff81183bbb>] ?
do_lookup+0x4b/0x390
Dec 19 15:13:53 sodom kernel: [19781.993237]  [<ffffffff811af380>] ?
blkdev_get+0x210/0x210
Dec 19 15:13:53 sodom kernel: [19781.993239]  [<ffffffff81176421>]
nameidata_to_filp+0x71/0x80
Dec 19 15:13:53 sodom kernel: [19781.993241]  [<ffffffff81184e38>]
do_last+0x3d8/0x800
Dec 19 15:13:53 sodom kernel: [19781.993243]  [<ffffffff81185bd5>]
path_openat+0xd5/0x3f0
Dec 19 15:13:53 sodom kernel: [19781.993259]  [<ffffffff8141ed64>] ?
scsi_device_put+0x44/0x60
Dec 19 15:13:53 sodom kernel: [19781.993261]  [<ffffffff81186009>]
do_filp_open+0x49/0xa0
Dec 19 15:13:53 sodom kernel: [19781.993264]  [<ffffffff8132236a>] ?
strncpy_from_user+0x4a/0x90
Dec 19 15:13:53 sodom kernel: [19781.993266]  [<ffffffff8160e7fe>] ?
_raw_spin_lock+0xe/0x20
Dec 19 15:13:53 sodom kernel: [19781.993269]  [<ffffffff811938fa>] ?
alloc_fd+0x10a/0x150
Dec 19 15:13:53 sodom kernel: [19781.993271]  [<ffffffff81176607>]
do_sys_open+0x107/0x1e0
Dec 19 15:13:53 sodom kernel: [19781.993273]  [<ffffffff81176720>]
sys_open+0x20/0x30
Dec 19 15:13:53 sodom kernel: [19781.993276]  [<ffffffff81616c02>]
system_call_fastpath+0x16/0x1b
Dec 19 15:13:53 sodom kernel: [19781.993295] INFO: task blkid:12144
blocked for more than 120 seconds.
Dec 19 15:13:53 sodom kernel: [19781.993297] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 19 15:13:53 sodom kernel: [19781.993298] blkid           D
ffff88038b4fc890     0 12144  12075 0x00000004
Dec 19 15:13:53 sodom kernel: [19781.993301]  ffff8802ab9cbb28
0000000000000086 000000000000e400 0000000000000000
Dec 19 15:13:53 sodom kernel: [19781.993303]  0000000000013640
ffff8802ab9cbfd8 ffff8802ab9ca010 0000000000013640
Dec 19 15:13:53 sodom kernel: [19781.993306]  ffff8802ab9cbfd8
0000000000013640 ffff8804055a16f0 ffff88038b4fc4d0
Dec 19 15:13:53 sodom kernel: [19781.993308] Call Trace:
Dec 19 15:13:53 sodom kernel: [19781.993310]  [<ffffffff8160c7af>]
schedule+0x3f/0x60
Dec 19 15:13:53 sodom kernel: [19781.993312]  [<ffffffff8160d3df>]
__mutex_lock_slowpath+0xdf/0x160
Dec 19 15:13:53 sodom kernel: [19781.993315]  [<ffffffff8160d2db>]
mutex_lock+0x2b/0x50
Dec 19 15:13:53 sodom kernel: [19781.993317]  [<ffffffff811aedb3>]
__blkdev_get+0x73/0x430
Dec 19 15:13:53 sodom kernel: [19781.993319]  [<ffffffff811af1cc>]
blkdev_get+0x5c/0x210
Dec 19 15:13:53 sodom kernel: [19781.993322]  [<ffffffff8160e7fe>] ?
_raw_spin_lock+0xe/0x20
Dec 19 15:13:53 sodom kernel: [19781.993324]  [<ffffffff811af3e2>]
blkdev_open+0x62/0x80
Dec 19 15:13:53 sodom kernel: [19781.993326]  [<ffffffff81176213>]
__dentry_open+0x243/0x350
Dec 19 15:13:53 sodom kernel: [19781.993328]  [<ffffffff81183bbb>] ?
do_lookup+0x4b/0x390
Dec 19 15:13:53 sodom kernel: [19781.993330]  [<ffffffff811af380>] ?
blkdev_get+0x210/0x210
Dec 19 15:13:53 sodom kernel: [19781.993332]  [<ffffffff81176421>]
nameidata_to_filp+0x71/0x80
Dec 19 15:13:53 sodom kernel: [19781.993334]  [<ffffffff81184e38>]
do_last+0x3d8/0x800
Dec 19 15:13:53 sodom kernel: [19781.993336]  [<ffffffff81185bd5>]
path_openat+0xd5/0x3f0
Dec 19 15:13:53 sodom kernel: [19781.993338]  [<ffffffff81186009>]
do_filp_open+0x49/0xa0
Dec 19 15:13:53 sodom kernel: [19781.993340]  [<ffffffff8132236a>] ?
strncpy_from_user+0x4a/0x90
Dec 19 15:13:53 sodom kernel: [19781.993342]  [<ffffffff8160e7fe>] ?
_raw_spin_lock+0xe/0x20
Dec 19 15:13:53 sodom kernel: [19781.993344]  [<ffffffff811938fa>] ?
alloc_fd+0x10a/0x150
Dec 19 15:13:53 sodom kernel: [19781.993346]  [<ffffffff81176607>]
do_sys_open+0x107/0x1e0
Dec 19 15:13:53 sodom kernel: [19781.993348]  [<ffffffff81176720>]
sys_open+0x20/0x30
Dec 19 15:13:53 sodom kernel: [19781.993350]  [<ffffffff81616c02>]
system_call_fastpath+0x16/0x1b
Dec 19 15:14:15 sodom kernel: [19803.828253] ------------[ cut here
]------------
Dec 19 15:14:15 sodom kernel: [19803.830588] kernel BUG at
/home/apw/COD/linux/fs/btrfs/transaction.c:1329!
Dec 19 15:14:15 sodom kernel: [19803.831738] invalid opcode: 0000 [#1] SMP
Dec 19 15:14:15 sodom kernel: [19803.832877] CPU 0
Dec 19 15:14:15 sodom kernel: [19803.832882] Modules linked in:
nls_iso8859_1 nls_cp437 omfs jfs xfs reiserfs hfs hfsplus vfat fat isofs
nls_utf8 udf crc_itu_t bfs rfcomm bnep bluetooth vboxnetadp(O)
vboxnetflt(O) vboxdrv(O) kvm_intel kvm parport_pc ppdev binfmt_misc
dm_crypt ip6t_LOG nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
ip6_tables ipt_ULOG xt_multiport xt_state nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack xt_tcpudp iptable_filter
ip_tables x_tables snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer joydev snd_seq_device serio_raw snd
soundcore mei(C) snd_page_alloc uvcvideo videodev v4l2_compat_ioctl32 lp
parport raid10 raid456 async_pq async_xor xor async_memcpy
async_raid6_recov raid6_pq async_tx raid0 multipath linear btrfs
zlib_deflate libcrc32c usb_storage hid_microsoft usbhid raid1 hid uas
mxm_wmi i915 drm_kms_helper drm ahci r8169 libahci i2c_algo_bit xhci_hcd
video wmi
Dec 19 15:14:15 sodom kernel: [19803.839902]
Dec 19 15:14:15 sodom kernel: [19803.841101] Pid: 12192, comm: sync
Tainted: G         C O 3.2.0-030200rc2-generic #201111151435 Gigabyte
Technology Co., Ltd. Z68MX-UD2H-B3/Z68MX-UD2H-B3
Dec 19 15:14:15 sodom kernel: [19803.842329] RIP:
0010:[<ffffffffa01b8052>]  [<ffffffffa01b8052>]
btrfs_commit_transaction+0x8f2/0x900 [btrfs]
Dec 19 15:14:15 sodom kernel: [19803.843558] RSP: 0018:ffff880352329dd8 
EFLAGS: 00010282
Dec 19 15:14:15 sodom kernel: [19803.844765] RAX: 00000000fffffffb RBX:
ffff880316a16000 RCX: ffff880352329d48
Dec 19 15:14:15 sodom kernel: [19803.845963] RDX: 0000000000002000 RSI:
0000000001c0b000 RDI: ffff880316a16060
Dec 19 15:14:15 sodom kernel: [19803.847147] RBP: ffff880352329e98 R08:
0000000000002000 R09: 0000120760acac00
Dec 19 15:14:15 sodom kernel: [19803.848315] R10: 0000000000000001 R11:
0000000000000001 R12: ffff880316a16078
Dec 19 15:14:15 sodom kernel: [19803.849489] R13: ffff8803805b3400 R14:
ffff880316a16000 R15: ffff880332ac3000
Dec 19 15:14:15 sodom kernel: [19803.850655] FS:  00007fa835d71720(0000)
GS:ffff88041fa00000(0000) knlGS:0000000000000000
Dec 19 15:14:15 sodom kernel: [19803.851838] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Dec 19 15:14:15 sodom kernel: [19803.853004] CR2: 00007f2f8899c210 CR3:
00000002ac810000 CR4: 00000000000406f0
Dec 19 15:14:15 sodom kernel: [19803.854160] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Dec 19 15:14:15 sodom kernel: [19803.855301] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Dec 19 15:14:15 sodom kernel: [19803.856426] Process sync (pid: 12192,
threadinfo ffff880352328000, task ffff8802aaf744d0)
Dec 19 15:14:15 sodom kernel: [19803.857540] Stack:
Dec 19 15:14:15 sodom kernel: [19803.858630]  ffff880352329e38
ffff8803805b3400 0000000000000000 ffff880332ac3000
Dec 19 15:14:15 sodom kernel: [19803.859720]  0000000000000001
0000000000000000 ffff880352329e38 ffffffffa01b772d
Dec 19 15:14:15 sodom kernel: [19803.860796]  0000000000000000
ffff8803805b3400 ffff8803805b3400 0000000000000000
Dec 19 15:14:15 sodom kernel: [19803.861863] Call Trace:
Dec 19 15:14:15 sodom kernel: [19803.862914]  [<ffffffffa01b772d>] ?
join_transaction+0x24d/0x280 [btrfs]
Dec 19 15:14:15 sodom kernel: [19803.863956]  [<ffffffff81088a90>] ?
wake_up_bit+0x40/0x40
Dec 19 15:14:15 sodom kernel: [19803.864987]  [<ffffffff811a5420>] ?
__sync_filesystem+0x90/0x90
Dec 19 15:14:15 sodom kernel: [19803.866013]  [<ffffffffa0193e0e>]
btrfs_sync_fs+0x5e/0xd0 [btrfs]
Dec 19 15:14:15 sodom kernel: [19803.867026]  [<ffffffff811a53f3>]
__sync_filesystem+0x63/0x90
Dec 19 15:14:15 sodom kernel: [19803.868026]  [<ffffffff811a543f>]
sync_one_sb+0x1f/0x30
Dec 19 15:14:15 sodom kernel: [19803.869016]  [<ffffffff81179e01>]
iterate_supers+0x91/0xf0
Dec 19 15:14:15 sodom kernel: [19803.869990]  [<ffffffff811a549a>]
sys_sync+0x4a/0x70
Dec 19 15:14:15 sodom kernel: [19803.870956]  [<ffffffff81616c02>]
system_call_fastpath+0x16/0x1b
Dec 19 15:14:15 sodom kernel: [19803.871922] Code: 00 48 85 db 0f 84 5b
fe ff ff 48 8b 03 0f 1f 40 00 48 8b 7b 08 48 83 c3 10 4c 89 ee ff d0 48
8b 03 48 85 c0 75 eb e9 3a fe ff ff <0f> 0b eb fe 66 2e 0f 1f 84 00 00
00 00 00 55 48 89 e5 48 83 ec
Dec 19 15:14:15 sodom kernel: [19803.874032] RIP  [<ffffffffa01b8052>]
btrfs_commit_transaction+0x8f2/0x900 [btrfs]
Dec 19 15:14:15 sodom kernel: [19803.875107]  RSP <ffff880352329dd8>
Dec 19 15:14:15 sodom kernel: [19803.898433] ---[ end trace
e923de0b6397904f ]---
Dec 19 15:14:48 sodom kernel: Kernel logging (proc) stopped.

