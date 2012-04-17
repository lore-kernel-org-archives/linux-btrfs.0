From: Olivier Doucet <webmaster@ajeux.com>
Subject: Kernel bug in BTRFS (kernel 3.3.0)
Date: Tue, 17 Apr 2012 11:23:27 +0200
Message-ID: <CAPPqfY0T7KmTx=5tcwbUs-zZcB+-yxf01-CWFWY7LUqxepAuNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Doing some extensive benchmarks on BTRFS, I encountered a kernel bug
in BTRFS (as reported in dmesg)

Maybe the information below can help you making btrfs better.

Situation
Doing an intensive sequential write on a SAS 3TB disk drive (SEAGATE
ST33000652SS) with 128 threads with Sysbench.
Device is connected through an HBA. Blocksize was 256k ; Kernel is
3.3.0 (x86_64) ; Btrfs is version v0.19

Write is done through an LVS volume formated with BTRFS of course;
Mount options are : rw,noatime,nodiratime,compress=3Dlzo,nospace_cache

Dmesg gives me following error :

[370517.203926] sd 0:0:15:0: [sdo] Device not ready
[370517.203930] sd 0:0:15:0: [sdo] =A0Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[370517.203935] sd 0:0:15:0: [sdo] =A0Sense Key : Not Ready [current]
[370517.203940] sd 0:0:15:0: [sdo] =A0ASC=3D0x4 <<vendor>> ASCQ=3D0xf2
[370517.203946] sd 0:0:15:0: [sdo] CDB: Write(10): 2a 00 00 00 6a 00 00=
 00 80 00
[370517.203955] end_request: I/O error, dev sdo, sector 27136
[370517.204236] sd 0:0:15:0: [sdo] Device not ready
[370517.204240] sd 0:0:15:0: [sdo] =A0Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[370517.204244] sd 0:0:15:0: [sdo] =A0Sense Key : Not Ready [current]
[370517.204249] sd 0:0:15:0: [sdo] =A0ASC=3D0x4 <<vendor>> ASCQ=3D0xf2
[370517.204255] sd 0:0:15:0: [sdo] CDB: Write(10): 2a 00 00 00 08 80 00=
 00 08 00
[370517.204265] end_request: I/O error, dev sdo, sector 2176
[370517.204283] lost page write due to I/O error on dm-5
[370517.204350] btrfs: 1 errors while writing supers
[370517.204376] ------------[ cut here ]------------
[370517.204391] kernel BUG at fs/btrfs/disk-io.c:2880!
[370517.204406] invalid opcode: 0000 [#1] SMP
[370517.204423] CPU 2
[370517.204436] Pid: 8790, comm: sysbench Not tainted 3.3.0-oxeva #2
Supermicro X8DTT-H/X8DTT-H
[370517.204482] RIP: 0010:[<ffffffff81389e63>] =A0[<ffffffff81389e63>]
write_all_supers+0x833/0x840
[370517.204508] RSP: 0018:ffff880e52f63b68 =A0EFLAGS: 00010292
[370517.204522] RAX: 000000000000003b RBX: ffff88100ef81f38 RCX:
0000000000000068
[370517.204539] RDX: 0000000000000000 RSI: 0000000000000046 RDI:
ffffffff81f9c6b0
[370517.204556] RBP: ffff880e52f63bd8 R08: 0000000000000000 R09:
ffffffff81bba980
[370517.204573] R10: 0000000000000001 R11: 0000000000000000 R12:
ffff880e52f63ba0
[370517.204592] R13: ffff88100ef81f38 R14: ffff881010902000 R15:
0000000000000001
[370517.204829] FS: =A000007f3a2300c700(0000) GS:ffff88081fc40000(0000)
knlGS:0000000000000000
[370517.204954] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
[370517.205024] CR2: 00007f3a24b9e998 CR3: 0000000ce9963000 CR4:
00000000000006e0
[370517.205147] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[370517.205269] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[370517.205393] Process sysbench (pid: 8790, threadinfo
ffff880e52f62000, task ffff881008902880)
[370517.205519] Stack:
[370517.205580] =A0ffff88101090210b ffff88100ef81ec0 0000000052f63ba8
0000000100000001
[370517.205716] =A0ffff881010d59000 ffff881000000001 ffff880811d87400
ffff88100ef81f38
[370517.205849] =A000000013c4a03fff ffff880ff058d000 ffff880811d87400
ffff881002a915a0
[370517.205984] Call Trace:
[370517.206049] =A0[<ffffffff81389e7e>] write_ctree_super+0xe/0x10
[370517.206119] =A0[<ffffffff813c24b4>] btrfs_sync_log+0x424/0x5c0
[370517.206190] =A0[<ffffffff8139e9cb>] btrfs_sync_file+0x17b/0x1e0
[370517.206260] =A0[<ffffffff81160703>] vfs_fsync_range+0x23/0x30
[370517.206329] =A0[<ffffffff8116076c>] generic_write_sync+0x3c/0x40
[370517.206399] =A0[<ffffffff8139f4a7>] btrfs_file_aio_write+0x317/0x53=
0
[370517.206472] =A0[<ffffffff8113556a>] do_sync_write+0xda/0x120
[370517.206544] =A0[<ffffffff8110037f>] ? handle_mm_fault+0x1af/0x320
[370517.206614] =A0[<ffffffff81135ab8>] vfs_write+0xc8/0x190
[370517.206682] =A0[<ffffffff81135c12>] sys_pwrite64+0x92/0xa0
[370517.206753] =A0[<ffffffff81aa82e2>] system_call_fastpath+0x16/0x1b
[370517.206820] Code: e9 72 fe ff ff 44 89 d6 48 c7 c7 b8 68 d2 81 31
c0 e8 43 b1 71 00 0f 0b eb fe 8b 75 b8 48 c7 c7 b8 68 d2 81 31 c0 e8
2e b1 71 00 <0f> 0b eb fe 66 0f 1f 84 00 00 00 00 00 55 48 89 f7 48 89
e5 89
[370517.207167] RIP =A0[<ffffffff81389e63>] write_all_supers+0x833/0x84=
0
[370517.207239] =A0RSP <ffff880e52f63b68>
[370517.207673] ---[ end trace f208fa157676276c ]---


I don't know if the device failed because BTRFS did something wrong,
or if BTRFS failed because of the device.

After this error, device cannot be accessed anymore (stuck and fdisk
returned no info, neither do smartctl - just 'device busy').

By the way, I'm actually doing some extensive benchmarks, comparing
BTRFS with XFS or EXT4. I'll post results on this mailing list in a
few days, I'm sure it can be interested for you.

Olivier
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
