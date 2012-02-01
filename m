From: Thomas Weber <thomas.weber.linux@googlemail.com>
Subject: Re: btrfs bug
Date: Wed, 01 Feb 2012 06:20:20 +0100
Message-ID: <4F28CB94.1040803@gmail.com>
References: <4F282D3B.8050609@gmail.com> <CAKcLGm-z3pJZgr30WYs8D8_VnVFMcjErKtvG5_ys-FOo=dRPEw@mail.gmail.com> <4F286263.7010502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Thomas Weber <thomas.weber.linux@googlemail.com>,
	linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F286263.7010502@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Mitch,

I have good news for you. I looked through all log files and found in 
the everything.log the following:

Regards,
Thomas


Jan 31 05:12:24 localhost kernel: [87276.968049] btrfs memmove bogus 
src_offset 1870 move len 687876531 len 4096
Jan 31 05:12:24 localhost kernel: [87276.968136] ------------[ cut here 
]------------
Jan 31 05:12:24 localhost kernel: [87276.968222] kernel BUG at 
fs/btrfs/extent_io.c:4357!
Jan 31 05:12:24 localhost kernel: [87276.968296] invalid opcode: 0000 
[#1] PREEMPT SMP
Jan 31 05:12:24 localhost kernel: [87276.968388] CPU 1
Jan 31 05:12:24 localhost kernel: [87276.968423] Modules linked in: nfs 
nfs_acl lockd auth_rpcgss sunrpc des_generic ecb md4 md5 hmac nls_utf8 
cifs fscache aes_generic ipv6 ext2 mbcache joydev arc4 dell_wmi 
sparse_keymap i915 snd_hda_codec_idt iwl3945 iwl_legacy psmouse 
snd_hda_intel serio_raw evdev pcspkr snd_hda_codec drm_kms_helper 
snd_hwdep mac80211 snd_pcm snd_page_alloc snd_timer drm cfg80211 
i2c_algo_bit i2c_i801 tg3 snd iTCO_wdt iTCO_vendor_support soundcore 
rfkill i2c_core libphy wmi intel_agp intel_gtt thermal button battery 
video processor ac btrfs crc32c libcrc32c zlib_deflate sd_mod pata_acpi 
uhci_hcd ata_piix libata scsi_mod ehci_hcd usbcore usb_common
Jan 31 05:12:24 localhost kernel: [87276.969644]
Jan 31 05:12:24 localhost kernel: [87276.969674] Pid: 15299, comm: 
btrfs-endio-wri Not tainted 3.2.2-1-ARCH #1 Dell Inc. Latitude 
D530                   /0HP728
Jan 31 05:12:24 localhost kernel: [87276.969831] RIP: 
0010:[<ffffffffa01d535a>]  [<ffffffffa01d535a>] 
memmove_extent_buffer+0x30a/0x310 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.969995] RSP: 
0018:ffff880057ceba90  EFLAGS: 00010282
Jan 31 05:12:24 localhost kernel: [87276.970065] RAX: 0000000000000055 
RBX: 00000000290029b3 RCX: 00000000000000f6
Jan 31 05:12:24 localhost kernel: [87276.970153] RDX: 0000000000000000 
RSI: 0000000000000046 RDI: 0000000000000202
Jan 31 05:12:24 localhost kernel: [87276.970240] RBP: ffff880057cebb00 
R08: 000000000000000a R09: 0000000000000000
Jan 31 05:12:24 localhost kernel: [87276.970330] R10: 0000000000000000 
R11: 0000000000000001 R12: ffff88010e9d9b40
Jan 31 05:12:24 localhost kernel: [87276.970419] R13: 00000000000006e9 
R14: 0000000029003101 R15: 000000000000002a
Jan 31 05:12:24 localhost kernel: [87276.970507] FS:  
0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
Jan 31 05:12:24 localhost kernel: [87276.970610] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Jan 31 05:12:24 localhost kernel: [87276.970681] CR2: 0000000001c63018 
CR3: 000000005ad52000 CR4: 00000000000006e0
Jan 31 05:12:24 localhost kernel: [87276.970769] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Jan 31 05:12:24 localhost kernel: [87276.970856] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 31 05:12:24 localhost kernel: [87276.970945] Process btrfs-endio-wri 
(pid: 15299, threadinfo ffff880057cea000, task ffff880103cb1c80)
Jan 31 05:12:24 localhost kernel: [87276.971056] Stack:
Jan 31 05:12:24 localhost kernel: [87276.971087]  0000000000000466 
00000000000006b4 0000000000000477 ffff88010e9d9b40
Jan 31 05:12:24 localhost kernel: [87276.971206]  ffff88010e9d9b40 
0000000000000000 0000160000000000 0000000000000000
Jan 31 05:12:24 localhost kernel: [87276.971286]  0000000000001000 
ffff880057cebc7c ffff88010e9d9b40 00000000000006e9
Jan 31 05:12:24 localhost kernel: [87276.971286] Call Trace:
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa0198251>] 
setup_items_for_insert+0x181/0x350 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa01985e5>] 
btrfs_insert_empty_items+0xb5/0xe0 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa01b8940>] 
insert_reserved_file_extent.constprop.52+0xc0/0x270 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa01b98fa>] 
btrfs_finish_ordered_io+0x2ca/0x320 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa01b999d>] 
btrfs_writepage_end_io_hook+0x4d/0xf0 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa01cf03f>] 
end_bio_extent_writepage+0x12f/0x170 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffff8119ba0d>] 
bio_endio+0x1d/0x40
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa01ac736>] 
end_workqueue_fn+0x56/0x140 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa01dc920>] 
worker_loop+0x150/0x520 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffffa01dc7d0>] ? 
btrfs_queue_worker+0x300/0x300 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffff810883fc>] 
kthread+0x8c/0xa0
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffff8142b874>] 
kernel_thread_helper+0x4/0x10
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffff81088370>] ? 
kthread_worker_fn+0x190/0x190
Jan 31 05:12:24 localhost kernel: [87276.971286]  [<ffffffff8142b870>] ? 
gs_change+0x13/0x13
Jan 31 05:12:24 localhost kernel: [87276.971286] Code: 41 5f 5d c3 48 89 
da 48 c7 c7 c0 91 20 a0 31 c0 e8 94 9b 24 e1 0f 0b 48 89 c6 48 89 da 48 
c7 c7 80 91 20 a0 31 c0 e8 7e 9b 24 e1 <0f> 0b 0f 1f 40 00 55 48 89 e5 
48 83 ec 30 48 89 5d d8 4c 89 65
Jan 31 05:12:24 localhost kernel: [87276.971286] RIP  
[<ffffffffa01d535a>] memmove_extent_buffer+0x30a/0x310 [btrfs]
Jan 31 05:12:24 localhost kernel: [87276.971286]  RSP <ffff880057ceba90>
Jan 31 05:12:24 localhost kernel: [87276.993478] ---[ end trace 
174f2acd3ea6a532 ]---
Jan 31 05:12:24 localhost kernel: [87276.993491] note: 
btrfs-endio-wri[15299] exited with preempt_count 1

