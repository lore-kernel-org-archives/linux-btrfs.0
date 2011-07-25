From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: btrfs invalid opcode
Date: Mon, 25 Jul 2011 17:38:10 +0100
Message-ID: <j0k65i$29a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm afraid this is a rather old kernel, 2.6.35.13-92.fc14.x86_64, but this 
error looks rather similiar to 
http://www.spinics.net/lists/linux-btrfs/msg11053.html

Has this been fixed? I was simultaneously doing rsyncs into different 
subvolumes (one reading and one writing).

Jeremy

[454244.123352] ------------[ cut here ]------------
[454244.123523] kernel BUG at fs/btrfs/inode.c:1528!
[454244.123687] invalid opcode: 0000 [#1] SMP 
[454244.123851] last sysfs file: 
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
[454244.124175] CPU 1 
[454244.124179] Modules linked in: btrfs nfs fscache nfsd lockd nfs_acl 
auth_rpcgss hwmon_vid sunrpc ipv6 zlib_deflate libcrc32c xfs exportfs uinput 
ppdev microcode k8temp edac_core edac_mce_amd forcedeth snd_intel8x0 
snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm snd_timer snd 
soundcore snd_page_alloc i2c_nforce2 i2c_core raid456 async_raid6_recov 
async_pq raid6_pq async_xor xor async_memcpy async_tx linear parport_pc 
parport firewire_ohci firewire_core crc_itu_t sata_nv pata_acpi ata_generic 
pata_amd 3w_9xxx [last unloaded: btrfs]
[454244.124338] 
[454244.124338] Pid: 3158, comm: btrfs-fixup-0 Not tainted 
2.6.35.13-92.fc14.x86_64 #1 C51MCP51/C51GM03
[454244.124338] RIP: 0010:[<ffffffffa048ed89>]  [<ffffffffa048ed89>] 
btrfs_writepage_fixup_worker+0xde/0x118 [btrfs]
[454244.124338] RSP: 0018:ffff88001b6edde0  EFLAGS: 00010246
[454244.124338] RAX: 0000000000000000 RBX: ffffea0000224488 RCX: 
ffff880059ff2ce8
[454244.124338] RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 
ffff880059ff2af8
[454244.124338] RBP: ffff88001b6ede30 R08: ffffea00001302b0 R09: 
ffff88001b6edce0
[454244.124338] R10: ffff88004ea8e8b8 R11: 0000000000000001 R12: 
0000000000f83000
[454244.124338] R13: ffff880059ff2bd0 R14: 0000000000000000 R15: 
ffff88001b6eddf8
[454244.124338] FS:  00007f3ca3e1e720(0000) GS:ffff880002100000(0000) 
knlGS:00000000f77af6c0
[454244.124338] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[454244.124338] CR2: 00000000020c66f8 CR3: 00000000423be000 CR4: 
00000000000006e0
[454244.124338] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[454244.124338] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[454244.124338] Process btrfs-fixup-0 (pid: 3158, threadinfo 
ffff88001b6ec000, task ffff88004da045c0)
[454244.124338] Stack:
[454244.124338]  ffff880059ff2a78 0000000000f83fff ffff8800ffffffff 
ffff8800056e7d00
[454244.124338] <0> 0000000000000000 ffff88004ea8e8a0 ffff880014ad5b70 
ffff88004ea8e8f0
[454244.124338] <0> ffff88004ea8e8b8 ffff88004ea8e8a8 ffff88001b6edee0 
ffffffffa04b0d1e
[454244.124338] Call Trace:
[454244.124338]  [<ffffffffa04b0d1e>] worker_loop+0x17b/0x4cd [btrfs]
[454244.124338]  [<ffffffffa04b0ba3>] ? worker_loop+0x0/0x4cd [btrfs]
[454244.124338]  [<ffffffff810665b1>] kthread+0x7f/0x87
[454244.124338]  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
[454244.124338]  [<ffffffff81066532>] ? kthread+0x0/0x87
[454244.124338]  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
[454244.124338] Code: 41 b8 50 00 00 00 4c 89 f9 e8 06 8c 01 00 48 89 df e8 
9c 51 c4 e0 ba 01 00 00 00 4c 89 f6 4c 89 ef e8 05 66 01 00 e9 48 ff ff ff 
<0f> 0b 48 8b 55 b8 48 8b 7d b0 41 b8 50 00 00 00 4c 89 f9 4c 89 
[454244.124338] RIP  [<ffffffffa048ed89>] 
btrfs_writepage_fixup_worker+0xde/0x118 [btrfs]
[454244.124338]  RSP <ffff88001b6edde0>
[454244.133555] ---[ end trace a6f7bb6b08ba9fb4 ]---



