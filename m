From: Martin Mailand <martin@tuxadero.com>
Subject: kernel BUG at fs/btrfs/inode.c:1163
Date: Tue, 18 Oct 2011 22:04:01 +0200
Message-ID: <4E9DDBB1.2050007@tuxadero.com>
Reply-To: martin@tuxadero.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: ceph-devel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi
today I hit this Bug, kernel is v3.1-rc10 + josef from today, workload 
is a ceph osd.

Best Regards,
  Martin

[28997.273289] ------------[ cut here ]------------
[28997.282916] kernel BUG at fs/btrfs/inode.c:1163!
[28997.290863] invalid opcode: 0000 [#1] SMP
[28997.290863] CPU 0
[28997.290863] Modules linked in: radeon ttm drm_kms_helper drm psmouse 
sp5100_tco i2c_piix4 i2c_algo_bit serio_raw edac_core k8temp 
edac_mce_amd shpchp lp parport pata_atiixp btrfs zlib_deflate e1000e 
libcrc32c ahci libahci
[28997.290863]
[28997.290863] Pid: 1220, comm: ceph-osd Tainted: G        W 
3.1.0-rc10+ #2 MICRO-STAR INTERNATIONAL CO., LTD MS-96B3/MS-96B3
[28997.290863] RIP: 0010:[<ffffffffa0094f17>]  [<ffffffffa0094f17>] 
run_delalloc_nocow+0x7a7/0x7c0 [btrfs]
[28997.290863] RSP: 0018:ffff880117357a78  EFLAGS: 00010206
[28997.290863] RAX: 000000000000002f RBX: ffff880116b12a20 RCX: 
ffff880117357a38
[28997.290863] RDX: ffff880000000000 RSI: 0000000000000496 RDI: 
ffff8801003851e0
[28997.290863] RBP: ffff880117357b78 R08: 0000000000000497 R09: 
ffff880117357a28
[28997.290863] R10: 0000000000000030 R11: 0000000000000000 R12: 
0000000000011d3b
[28997.290863] R13: 0000000000011d3b R14: ffff8801003851e0 R15: 
0000000000300000
[28997.290863] FS:  00007ff45ae7b700(0000) GS:ffff88011fc00000(0000) 
knlGS:0000000000000000
[28997.507960] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[28997.507960] CR2: 00007ff450a20000 CR3: 0000000114b75000 CR4: 
00000000000006f0
[28997.507960] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[28997.507960] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[28997.507960] Process ceph-osd (pid: 1220, threadinfo ffff880117356000, 
task ffff880115260000)
[28997.507960] Stack:
[28997.507960]  ffff880117357aa8 ffffffff81156e90 ffff880104413af0 
ffff880104413af0
[28997.507960]  ffff880117550030 ffff880117357bf0 ffff880117550028 
ffff880117550020
[28997.507960]  0000000000400000 0000000100400000 ffff880117357d14 
00ffffffa00a973e
[28997.507960] Call Trace:
[28997.507960]  [<ffffffff81156e90>] ? kmem_cache_free+0x20/0x100
[28997.507960]  [<ffffffffa0095264>] run_delalloc_range+0x334/0x380 [btrfs]
[28997.507960]  [<ffffffffa00abc85>] __extent_writepage+0x5b5/0x6f0 [btrfs]
[28997.507960]  [<ffffffff812e526d>] ? 
radix_tree_gang_lookup_tag_slot+0x8d/0xd0
[28997.507960]  [<ffffffffa00abfea>] 
extent_write_cache_pages.clone.19.clone.26+0x22a/0x3a0 [btrfs]
[28997.507960]  [<ffffffffa00ac3a5>] extent_writepages+0x45/0x60 [btrfs]
[28997.507960]  [<ffffffffa00903e0>] ? acls_after_inode_item+0xc0/0xc0 
[btrfs]
[28997.507960]  [<ffffffff81182ade>] ? vfsmount_lock_local_unlock+0x1e/0x30
[28997.507960]  [<ffffffffa008fa27>] btrfs_writepages+0x27/0x30 [btrfs]
[28997.507960]  [<ffffffff81118161>] do_writepages+0x21/0x40
[28997.507960]  [<ffffffff8110e2cb>] __filemap_fdatawrite_range+0x5b/0x60
[28997.507960]  [<ffffffff8110f1d3>] filemap_fdatawrite_range+0x13/0x20
[28997.507960]  [<ffffffff81192c99>] sys_sync_file_range+0x149/0x180
[28997.835220]  [<ffffffff815f05c2>] system_call_fastpath+0x16/0x1b
[28997.835220] Code: 8b 7d 80 e8 dc 9e 00 00 41 b9 04 00 00 00 e9 3d fe 
ff ff 4d 89 ef 41 bc 01 00 00 00 48 c7 45 a8 ff ff ff ff e9 5c fb ff ff 
0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 84 00
[28997.835220] RIP  [<ffffffffa0094f17>] run_delalloc_nocow+0x7a7/0x7c0 
[btrfs]
[28997.835220]  RSP <ffff880117357a78>
[28997.927402] ---[ end trace a0a1c4a13d975229 ]---

