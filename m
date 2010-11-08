From: Albert Strasheim <fullung@gmail.com>
Subject: mkfs.btrfs on 24 disks in parallel crashes kernel
Date: Mon, 8 Nov 2010 09:22:09 +0200
Message-ID: <AANLkTi=zjPYJ1rbb0GbYVEFQsL+cEb4NZufmL4tTxBet@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all

I did some experiments on Fedora 14 with 2.6.35.6, running mkfs.btrfs
followed by a mount in parallel on 24 disks.

This seems to crash reliably.

I reported the bug to Fedora here:

https://bugzilla.redhat.com/show_bug.cgi?id=650261

The bug report has some stacktraces and stuff attached.

I saw stuff like this:

[  203.861368] Btrfs loaded
[  203.871418] device label myvol-12b0f8ba-e1ef-4d00-aae4-578d59d955e4
devid 1 transid 7 /dev/sdv
[  203.981371] device label myvol-fe7fdbcd-8f2f-4b34-aa6b-0d3bb7582ebc
devid 1 transid 7 /dev/sdl
[  203.990234] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000128
[  204.001153] IP: [<ffffffffa019a010>] btrfs_test_super+0x10/0x26 [btrfs]
[  204.016840] PGD 0
[  204.018696] Oops: 0000 [#1] SMP
[  204.021264] last sysfs file:
/sys/devices/pci0000:00/0000:00:05.0/0000:0d:00.0/host7/port-7:0/expander-7:0/port-7:0:9/end_device-7:0:9/target7:0:9/7:0:9:0/uevent
[  204.045966] CPU 0
[  204.055933] Modules linked in: btrfs zlib_deflate libcrc32c ipv6
mlx4_ib ib_mad ib_core mlx4_en igb mlx4_core ses iTCO_wdt ioatdma dca
iTCO_vendor_support i7core_edac edac_core enclosure i2c_i801 i2c_core
microcode joydev serio_raw mptsas mptscsih mptbase scsi_transport_sas
[last unloaded: scsi_wait_scan]
[  204.100672]
[  204.103025] Pid: 2166, comm: mount Not tainted
2.6.35.6-48.fc14.x86_64 #1 ASSY,BLADE,X6270      /SUN BLADE X6270
SERVER MODULE
[  204.121895] RIP: 0010:[<ffffffffa019a010>]  [<ffffffffa019a010>]
btrfs_test_super+0x10/0x26 [btrfs]
[  204.139279] RSP: 0018:ffff8803768ddcd8  EFLAGS: 00010287
[  204.144675] RAX: 0000000000000000 RBX: ffff8803772df800 RCX: ffff8801f7d34480
[  204.160885] RDX: 0000000000000120 RSI: ffff8801f7d34480 RDI: ffff8803772df800
[  204.179473] RBP: ffff8803768ddcd8 R08: ffff8801f7d344f8 R09: ffff880375c78760
[  204.185673] R10: ffff8803768ddb68 R11: ffff8801f7d34480 R12: ffffffffa01f13d0
[  204.200174] R13: ffffffffa019a000 R14: ffff8801f7d34480 R15: ffffffffa01f1400
[  204.221347] FS:  00007f766050d800(0000) GS:ffff880022200000(0000)
knlGS:0000000000000000
[  204.226597] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  204.238144] CR2: 0000000000000128 CR3: 00000001f7504000 CR4: 00000000000006f0
[  204.256446] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  204.263975] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  204.280097] Process mount (pid: 2166, threadinfo ffff8803768dc000,
task ffff880376ab8000)
[  204.296529] Stack:
[  204.298975]  ffff8803768ddd38 ffffffff81118df6 ffffffffa01f13d0
0000000000000000
[  204.305955] <0> ffffffff811184a7 0000000000000000 ffff8803768ddd38
0000000000000003
[  204.320999] <0> ffffffffa01f13d0 0000000000000000 ffff880375c78680
ffff8801f4f59d00
[  204.338658] Call Trace:
[  204.341138]  [<ffffffff81118df6>] sget+0x54/0x367
[  204.355474]  [<ffffffff811184a7>] ? set_anon_super+0x0/0xe7
[  204.360487]  [<ffffffffa019a821>] btrfs_get_sb+0x108/0x3eb [btrfs]
[  204.375799]  [<ffffffff81118b99>] vfs_kern_mount+0xad/0x1ac
[  204.379952]  [<ffffffff81118d00>] do_kern_mount+0x4d/0xef
[  204.395757]  [<ffffffff8112e45a>] do_mount+0x700/0x75d
[  204.400676]  [<ffffffff810e5aec>] ? strndup_user+0x54/0x85
[  204.417219]  [<ffffffff8112e6e7>] sys_mount+0x88/0xc2
[  204.420399]  [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
[  204.435716] Code: <48> 8b 80 28 01 00 00 48 39 b0 28 22 00 00 c9 0f
94 c0 0f b6 c0 c3
[  204.447369] RIP  [<ffffffffa019a010>] btrfs_test_super+0x10/0x26 [btrfs]
[  204.458280]  RSP <ffff8803768ddcd8>
[  204.462330] CR2: 0000000000000128
[  204.466479] ---[ end trace c8bb842fa664d021 ]---
[  204.498273] device label myvol-11d50321-7482-4ee2-8da5-5ee5f623ae17
devid 1 transid 7 /dev/sdk

Regards,

Albert
