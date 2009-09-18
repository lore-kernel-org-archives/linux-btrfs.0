From: Elladan <elladan@eskimo.com>
Subject: Kernel oops with 2.6.31 in btrfs_set_acl
Date: Fri, 18 Sep 2009 07:43:53 -0700
Message-ID: <20090918144353.GA9761@eskimo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I got an oops this morning with btrfs on the Ubuntu 2.6.31 kernel.  I mounted
with compress and thread_pool=4.  This is on a 64 bit quad AMD machine.

Sep 18 04:00:07 caper kernel: [614439.131866] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
Sep 18 04:00:07 caper kernel: [614439.131882] IP: [<ffffffff81161de1>] posix_acl_equiv_mode+0x1/0xa0
Sep 18 04:00:07 caper kernel: [614439.131900] PGD 126d98067 PUD 11e572067 PMD 0 
Sep 18 04:00:07 caper kernel: [614439.131911] Oops: 0000 [#4] SMP 
Sep 18 04:00:07 caper kernel: [614439.131918] last sysfs file: /sys/devices/virtual/net/pan0/statistics/collisions
Sep 18 04:00:07 caper kernel: [614439.131925] CPU 1 
Sep 18 04:00:07 caper kernel: [614439.131928] Modules linked in: joydev hid_gaff ff_memless btrfs zlib_deflate crc32c libcrc32c isofs udf crc_itu_t nls_iso8859_1 nls_cp437 vfat fat usb_storage binfmt_misc ppdev bnep ipt_MASQUERADE iptabl
e_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_amd kvm tun video output nfsd nfs lockd nfs_acl auth_rpcgss sunrpc it87 hwmon_vid lp parport snd_hd
a_codec_realtek snd_hda_intel snd_hda_codec snd_usb_audio snd_usb_lib snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device uvcvideo usblp pcspk
r amd64_edac_mod edac_core i2c_piix4 snd soundcore snd_page_alloc videodev v4l1_compat v4l2_compat_ioctl32 nvidia(P) xfs exportfs ohci1394 ieee1394 r8169 mii usbhid
Sep 18 04:00:07 caper kernel: [614439.132057] Pid: 23795, comm: rdiff-backup Tainted: P      D W  2.6.31-020631-generic #020631 GA-MA790GP-UD4H
Sep 18 04:00:07 caper kernel: [614439.132064] RIP: 0010:[<ffffffff81161de1>]  [<ffffffff81161de1>] posix_acl_equiv_mode+0x1/0xa0
Sep 18 04:00:07 caper kernel: [614439.132077] RSP: 0018:ffff88007cc61c58  EFLAGS: 00010246
Sep 18 04:00:07 caper kernel: [614439.132082] RAX: 0000000000008180 RBX: 00000000ffffffea RCX: 0000000000000004
Sep 18 04:00:07 caper kernel: [614439.132088] RDX: 0000000000008000 RSI: ffff88007cc61c8c RDI: 0000000000000000
Sep 18 04:00:07 caper kernel: [614439.132094] RBP: ffff88007cc61cb8 R08: 0000000000000000 R09: ffffffffa0f5e9a0
Sep 18 04:00:07 caper kernel: [614439.132099] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
Sep 18 04:00:07 caper kernel: [614439.132104] R13: 0000000000008000 R14: ffff88005aa4b9b0 R15: 0000000000008000
Sep 18 04:00:07 caper kernel: [614439.132112] FS:  00007fc423a2e6f0(0000) GS:ffff88002803f000(0000) knlGS:00000000f72c1750
Sep 18 04:00:07 caper kernel: [614439.132117] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep 18 04:00:07 caper kernel: [614439.132123] CR2: 0000000000000004 CR3: 000000011b806000 CR4: 00000000000006a0
Sep 18 04:00:07 caper kernel: [614439.132129] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Sep 18 04:00:07 caper kernel: [614439.132134] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep 18 04:00:07 caper kernel: [614439.132141] Process rdiff-backup (pid: 23795, threadinfo ffff88007cc60000, task ffff88007f432d60)
Sep 18 04:00:07 caper kernel: [614439.132146] Stack:
Sep 18 04:00:07 caper kernel: [614439.132149]  ffff88007cc61cb8 ffffffffa0f3c157 ffff88007cc61ce8 0000000000000008
Sep 18 04:00:07 caper kernel: [614439.132158] <0> 0000000000000eb6 ffff88003e0af110 000081807cc61c98 0000000000000000
Sep 18 04:00:07 caper kernel: [614439.132168] <0> 0000000000000004 0000000000008000 ffff88005aa4b9b0 ffff880079484240
Sep 18 04:00:07 caper kernel: [614439.132178] Call Trace:
Sep 18 04:00:07 caper kernel: [614439.132228]  [<ffffffffa0f3c157>] ? btrfs_set_acl+0x87/0x230 [btrfs]
Sep 18 04:00:07 caper kernel: [614439.132266]  [<ffffffffa0f3c384>] btrfs_xattr_set_acl+0x84/0xa0 [btrfs]
Sep 18 04:00:07 caper kernel: [614439.132300]  [<ffffffffa0f3c3be>] btrfs_xattr_acl_access_set+0xe/0x10 [btrfs]
Sep 18 04:00:07 caper kernel: [614439.132311]  [<ffffffff81133d5f>] generic_setxattr+0x6f/0x90
Sep 18 04:00:07 caper kernel: [614439.132349]  [<ffffffffa0f25d3a>] btrfs_setxattr+0x4a/0xa0 [btrfs]
Sep 18 04:00:07 caper kernel: [614439.132359]  [<ffffffff8113470e>] vfs_setxattr+0xbe/0x210
Sep 18 04:00:07 caper kernel: [614439.132368]  [<ffffffff81134915>] setxattr+0xb5/0x110
Sep 18 04:00:07 caper kernel: [614439.132375]  [<ffffffff811202ac>] ? path_put+0x2c/0x40
Sep 18 04:00:07 caper kernel: [614439.132383]  [<ffffffff81120931>] ? putname+0x31/0x50
Sep 18 04:00:07 caper kernel: [614439.132390]  [<ffffffff81122419>] ? user_path_at+0x59/0x90
Sep 18 04:00:07 caper kernel: [614439.132400]  [<ffffffff81265a7d>] ? _atomic_dec_and_lock+0x4d/0x70
Sep 18 04:00:07 caper kernel: [614439.132407]  [<ffffffff811202ac>] ? path_put+0x2c/0x40
Sep 18 04:00:07 caper kernel: [614439.132415]  [<ffffffff81115881>] ? sys_fchmodat+0x71/0xe0
Sep 18 04:00:07 caper kernel: [614439.132423]  [<ffffffff81265a7d>] ? _atomic_dec_and_lock+0x4d/0x70
Sep 18 04:00:07 caper kernel: [614439.132432]  [<ffffffff81134b72>] sys_setxattr+0x92/0xa0
Sep 18 04:00:07 caper kernel: [614439.132442]  [<ffffffff81011f82>] system_call_fastpath+0x16/0x1b
Sep 18 04:00:07 caper kernel: [614439.132447] Code: 08 0f 85 6a ff ff ff 85 ff 90 0f 85 61 ff ff ff e9 77 ff ff ff 31 c0 85 c9 90 0f 85 51 ff ff ff c9 c3 0f 1f 84 00 00 00 00 00 55 <8b> 47 04 48 8d 57 08 31 c9 45 31 c0 48 89 e5 48 8d 7c 
c7 08 48 
Sep 18 04:00:07 caper kernel: [614439.132515] RIP  [<ffffffff81161de1>] posix_acl_equiv_mode+0x1/0xa0
Sep 18 04:00:07 caper kernel: [614439.132524]  RSP <ffff88007cc61c58>
Sep 18 04:00:07 caper kernel: [614439.132527] CR2: 0000000000000004
Sep 18 04:00:07 caper kernel: [614439.132566] ---[ end trace c082b72bca0dff79 ]---


-J

