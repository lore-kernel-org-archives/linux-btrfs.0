Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46959 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab3JCEu1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Oct 2013 00:50:27 -0400
Received: by mail-ie0-f169.google.com with SMTP id tp5so4382051ieb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Oct 2013 21:50:26 -0700 (PDT)
MIME-Version: 1.0
From: Slava Barinov <rayslava@gmail.com>
Date: Thu, 3 Oct 2013 08:50:06 +0400
Message-ID: <CADef55pBMJ-oeOLy9Z3AeP7iRyFqm6fNfuS8BNm0qbDk876SwQ@mail.gmail.com>
Subject: Btrfs balance bug
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good day.

  I've got a failure with btrfs balance. In fact I started btrfs balance /btr
  and got a total filesystem freeze. After I tried applying balance pause
  or balance cancel the following crashdump appeared and btrfs tool
  freezed.
  Reboot changed nothing: I've got totally the same crashdump.
  So I mounted filesystem with skip_balance option and tried to cancel
  balance. It worked. Then I performed a btrfsck on my fs and it found
  nothing suspicious. So I believe it is just a balance bug. I suppose
  that could be because of lack of free space on device but should not
  filesystem reject balancing instead of crashing?

Best Regards,
Slava Barinov.

Crashdump:

[  114.475635] btrfs: enabling inode map caching
[  114.475640] btrfs: disk space caching is enabled
[  117.069811] BTRFS debug (device sdb2): unlinked 1 orphans
[  117.078876] btrfs: continuing balance
[  117.269167] mount (4055) used greatest stack depth: 3144 bytes left
[  133.779670] btrfs: relocating block group 447242829824 flags 1
[  143.195258] btrfs: found 1532 extents
[  152.192595] ------------[ cut here ]------------
[  152.195487] kernel BUG at fs/btrfs/relocation.c:1055!
[  152.198432] invalid opcode: 0000 [#1] SMP
[  152.201335] Modules linked in: nfsd vmnet(O) vmblock(O) vsock(O)
vmci(O) vmmon(O) bridge stp ipv6 llc vboxnetflt(O) vboxnetadp(O)
vboxdrv(O) pl2303 usbserial x86_pkg_temp_thermal coretemp kvm_intel
kvm psmouse i2c_i801
[  152.207676] CPU: 1 PID: 4078 Comm: btrfs-balance Tainted: G
  O 3.11.3-gentoo-ray #1
[  152.210862] Hardware name: System manufacturer System Product
Name/P8H77-V LE, BIOS 0608 07/27/2012
[  152.214112] task: ffff8803b7417000 ti: ffff8803a0ae4000 task.ti:
ffff8803a0ae4000
[  152.217395] RIP: 0010:[<ffffffff8130e27c>]  [<ffffffff8130e27c>]
build_backref_tree+0x112c/0x11e0
[  152.220751] RSP: 0018:ffff8803a0ae5ab8  EFLAGS: 00010246
[  152.224119] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8803f1287910
[  152.227481] RDX: ffff8803a0ae5b28 RSI: ffff8803b740e020 RDI: ffff8803f1287900
[  152.230828] RBP: ffff8803a0ae5b98 R08: ffff88039ad40380 R09: ffff88040f403900
[  152.234140] R10: ffffffff8130b5ee R11: 0000000000000000 R12: ffff8803f1287910
[  152.237428] R13: ffff8803aa11b1b0 R14: ffff8803b740e000 R15: ffff88039ad40480
[  152.240718] FS:  0000000000000000(0000) GS:ffff88041fa40000(0000)
knlGS:0000000000000000
[  152.244082] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  152.247434] CR2: 00007f5660bd5600 CR3: 0000000001c1a000 CR4: 00000000001407e0
[  152.250787] Stack:
[  152.254068]  ffff8803b740e580 ffff88039ad40580 ffff8803f1287960
ffff88039ad40380
[  152.257432]  ffff88039ad40380 ffff8803f13be000 ffff8803aa11b1b0
ffff88039ad403c0
[  152.260753]  ffff8803aa11b090 ffff8803b740e120 ffff88039ad40580
ffff8803b740e020
[  152.264097] Call Trace:
[  152.267377]  [<ffffffff8130e6e8>] relocate_tree_blocks+0x1d8/0x640
[  152.270682]  [<ffffffff8130f378>] ? add_data_references+0x238/0x270
[  152.273970]  [<ffffffff8130ff78>] relocate_block_group+0x278/0x680
[  152.277268]  [<ffffffff8131051f>] btrfs_relocate_block_group+0x19f/0x2e0
[  152.280604]  [<ffffffff812e8bfa>] btrfs_relocate_chunk.isra.32+0x6a/0x740
[  152.283913]  [<ffffffff812a0d81>] ? btrfs_set_path_blocking+0x31/0x70
[  152.287194]  [<ffffffff812a5b32>] ? btrfs_search_slot+0x372/0x930
[  152.290448]  [<ffffffff812e5217>] ? free_extent_buffer+0x47/0xa0
[  152.293687]  [<ffffffff812ed4f7>] btrfs_balance+0x8d7/0xe00
[  152.296906]  [<ffffffff812eda8b>] balance_kthread+0x6b/0x70
[  152.300100]  [<ffffffff812eda20>] ? btrfs_balance+0xe00/0xe00
[  152.303275]  [<ffffffff810646eb>] kthread+0xbb/0xc0
[  152.306369]  [<ffffffff81064630>] ? kthread_create_on_node+0x110/0x110
[  152.309440]  [<ffffffff8177683c>] ret_from_fork+0x7c/0xb0
[  152.312481]  [<ffffffff81064630>] ? kthread_create_on_node+0x110/0x110
[  152.315517] Code: 4c 89 ef e8 87 2c f9 ff 48 8b bd 60 ff ff ff e8
7b 2c f9 ff 48 83 bd 38 ff ff ff 00 0f 85 e0 fc ff ff 31 c0 e9 ac ef
ff ff 0f 0b <0f> 0b 48 8b 85 38 ff ff ff 49 8d 7e 20 48 8b 70 18 48 89
c2 e8
[  152.322548] RIP  [<ffffffff8130e27c>] build_backref_tree+0x112c/0x11e0
[  152.325862]  RSP <ffff8803a0ae5ab8>
[  152.329188] ---[ end trace f6907cd56547f763 ]---
[  152.332881] btrfs-balance (4078) used greatest stack depth: 2976 bytes left


# btrfs fi show /btr
Btrfs v0.20-rc1-358-g194aa4a

# btrfs fi df /btr
Data: total=405.01GB, used=377.99GB
System, DUP: total=8.00MB, used=52.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=12.50GB, used=8.55GB
Metadata: total=8.00MB, used=0.00

# btrfs --version
Btrfs v0.20-rc1-358-g194aa4a

Kernel is just 3.11.3-gentoo. -ray is my machine config and several
custom modules which are not loaded now.
