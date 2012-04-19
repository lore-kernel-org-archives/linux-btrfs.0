From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Thu, 19 Apr 2012 17:42:05 +0200
Message-ID: <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
 <20120416134643.GA20982@twin.jikos.cz> <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
 <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: dave@jikos.cz, "Marco L. Crociani" <marco.crociani@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Today I tried scrub...

Apr 19 17:36:01 evo kernel: [  187.932297] device label RootFS devid 1
transid 47046 /dev/sda3
Apr 19 17:36:02 evo kernel: [  188.145858] device label RootFS devid 3
transid 47046 /dev/sdb3
Apr 19 17:36:19 evo kernel: [  205.483044] device label RootFS devid 1
transid 47046 /dev/sda3
Apr 19 17:36:19 evo kernel: [  205.483730] btrfs: allowing degraded mounts
Apr 19 17:36:19 evo kernel: [  205.483737] btrfs: disk space caching is enabled
Apr 19 17:38:41 evo kernel: [  347.661603] BUG: unable to handle
kernel NULL pointer dereference at           (null)
Apr 19 17:38:41 evo kernel: [  347.661617] IP: [<ffffffff8131ff94>]
strncpy+0x14/0x30
Apr 19 17:38:41 evo kernel: [  347.661633] PGD 17b672067 PUD 17b5ed067 PMD 0
Apr 19 17:38:41 evo kernel: [  347.661643] Oops: 0000 [#1] SMP
Apr 19 17:38:41 evo kernel: [  347.661650] CPU 3
Apr 19 17:38:41 evo kernel: [  347.661654] Modules linked in:
ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables
bridge stp kvm_amd kvm rfcomm bnep bluetooth parport_pc ppdev dm_crypt
snd_hda_codec_realtek snd_hda_codec_hdmi snd_usb_audio snd_usbmidi_lib
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event uvcvideo snd_seq snd_timer snd_seq_device snd
videobuf2_core videodev v4l2_compat_ioctl32 videobuf2_vmalloc
soundcore videobuf2_memops dm_multipath eeepc_wmi mac_hid asus_wmi
binfmt_misc snd_page_alloc fglrx(PO) i2c_piix4 k10temp sparse_keymap
lp parport raid10 raid456 async_pq async_xor xor async_memcpy
async_raid6_recov raid6_pq async_tx raid0 multipath linear btrfs
zlib_deflate libcrc32c raid1 usbhid hid wmi r8169
Apr 19 17:38:41 evo kernel: [  347.661780]
Apr 19 17:38:41 evo kernel: [  347.661787] Pid: 3218, comm: btrfs
Tainted: P           O 3.3.2-030302-generic #201204131335 System
manufacturer System Product Name/F1A75-V EVO
Apr 19 17:38:41 evo kernel: [  347.661799] RIP:
0010:[<ffffffff8131ff94>]  [<ffffffff8131ff94>] strncpy+0x14/0x30
Apr 19 17:38:41 evo kernel: [  347.661810] RSP: 0018:ffff880182559e08
EFLAGS: 00010206
Apr 19 17:38:41 evo kernel: [  347.661816] RAX: ffff8801b14eac00 RBX:
ffff8801b14ea000 RCX: 0000000000000000
Apr 19 17:38:41 evo kernel: [  347.661822] RDX: 0000000000000400 RSI:
0000000000000000 RDI: ffff8801b14eac00
Apr 19 17:38:41 evo kernel: [  347.661827] RBP: ffff880182559e08 R08:
ffff8801b048b8b8 R09: 0000000000000002
Apr 19 17:38:41 evo kernel: [  347.661833] R10: 0000000000000010 R11:
0000000000000206 R12: ffff8801b1741800
Apr 19 17:38:41 evo kernel: [  347.661839] R13: 0000000000d55040 R14:
ffff8801b14ea008 R15: ffff8801b048b898
Apr 19 17:38:41 evo kernel: [  347.661846] FS:  00007f73c9f34760(0000)
GS:ffff8801bed80000(0000) knlGS:0000000000000000
Apr 19 17:38:41 evo kernel: [  347.661852] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Apr 19 17:38:41 evo kernel: [  347.661857] CR2: 0000000000000000 CR3:
00000001827db000 CR4: 00000000000006e0
Apr 19 17:38:41 evo kernel: [  347.661863] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 19 17:38:41 evo kernel: [  347.661869] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 19 17:38:41 evo kernel: [  347.661875] Process btrfs (pid: 3218,
threadinfo ffff880182558000, task ffff88017b5e44d0)
Apr 19 17:38:41 evo kernel: [  347.661880] Stack:
Apr 19 17:38:41 evo kernel: [  347.661884]  ffff880182559e78
ffffffffa00b76ac ffff8801b1504e00 0000000000000000
Apr 19 17:38:41 evo kernel: [  347.661895]  0000000000000000
0000000000000000 ffff880182559f48 000000005bfc4f67
Apr 19 17:38:41 evo kernel: [  347.661905]  0000000100002c2c
ffff8801824a2600 0000000000d55040 ffff88018c7df800
Apr 19 17:38:41 evo kernel: [  347.661915] Call Trace:
Apr 19 17:38:41 evo kernel: [  347.661964]  [<ffffffffa00b76ac>]
btrfs_ioctl_dev_info+0x15c/0x1a0 [btrfs]
Apr 19 17:38:41 evo kernel: [  347.662013]  [<ffffffffa00ba9b1>]
btrfs_ioctl+0x571/0x6c0 [btrfs]
Apr 19 17:38:41 evo kernel: [  347.662024]  [<ffffffff81193839>]
do_vfs_ioctl+0x99/0x330
Apr 19 17:38:41 evo kernel: [  347.662032]  [<ffffffff8118d345>] ?
putname+0x35/0x50
Apr 19 17:38:41 evo kernel: [  347.662040]  [<ffffffff81193b71>]
sys_ioctl+0xa1/0xb0
Apr 19 17:38:41 evo kernel: [  347.662049]  [<ffffffff816691a9>]
system_call_fastpath+0x16/0x1b
Apr 19 17:38:41 evo kernel: [  347.662054] Code: 48 83 c2 01 84 c9 75
ef c9 c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 d2 48 89 f8
48 89 e5 75 08 eb 18 66 90 48 83 c7 01 <0f> b6 0e 80 f9 01 88 0f 48 83
de ff 48 83 ea 01 75 ea c9 c3 0f
Apr 19 17:38:41 evo kernel: [  347.662128] RIP  [<ffffffff8131ff94>]
strncpy+0x14/0x30
Apr 19 17:38:41 evo kernel: [  347.662137]  RSP <ffff880182559e08>
Apr 19 17:38:41 evo kernel: [  347.662141] CR2: 0000000000000000
Apr 19 17:38:41 evo kernel: [  347.662147] ---[ end trace 9a8c295d04917ed2 ]---


-- 
Marco Lorenzo Crociani,
marco.crociani@gmail.com
