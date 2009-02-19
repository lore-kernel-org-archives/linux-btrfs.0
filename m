From: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
Subject: Re: [PATCH] btrfs: add better -ENOSPC handling VERSION 3
Date: Thu, 19 Feb 2009 17:45:54 +0900
Message-ID: <20090219174554.490a9a0b.ytakahashi@miraclelinux.com>
References: <1234557604-28769-1-git-send-email-jbacik@redhat.com>
	<20090217182110.00bdb9e3.ytakahashi@miraclelinux.com>
	<20090217134219.GA2882@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__19_Feb_2009_17_45_54_+0900_T0q2AAeFF9ljf9TJ"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090217134219.GA2882@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Thu__19_Feb_2009_17_45_54_+0900_T0q2AAeFF9ljf9TJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Josef.

> Thank you, what tool are you using to create these files and such?

I use an original tool.
I do not make the document.

ex.
./mkfbmt -d /btrfs -f 10000000 -x 10000
This makes a file under 10,000 directories with 10,000,000 files in /btrfs.

make 10,000 files under 100 directories each.
100dir * 10000files = 10000000

/btrfs/0/0
/btrfs/0/1
 ...
/btrfs/0/9998
/btrfs/0/9999
/btrfs/1/0
 ...
/btrfs/99/9999

defaults file size is zero byte.
When make a file of 4,096 bytes, please appoint -w 4096.
defaults option is all test.
-m mkdir
-c open(O_CREAT | O_EXCL | O_WRONLY) test
-o open test
-p utime test
-s stat test
-u unlink test
-r rmdir

# ./mkfbmt -d /btrfs/ -f 1000000 -x 10000
## __linuxfs_init(91) [0x401fc8]
mkfbmt 100 directry 1000000 files , one directry 10000 files
make files for /btrfs

mkdir : 0.004923 sec , 1 file mkdir  for 0.000000 sec
creat : 179.155566 sec , 1 file creat  for 0.000179 sec
open  : 26.696062 sec , 1 file open   for 0.000027 sec
utime : 55.143818 sec , 1 file utime   for 0.000055 sec
stat  : 4.692097 sec , 1 file stat   for 0.000005 sec
unlink: 210.624820 sec , 1 file unlink for 0.000211 sec
rmdir : 0.806472 sec , 1 file rmdir  for 0.000001 sec
file        creat       open        utime       stat        unlink
     50000       4.08       1.18       2.17       0.13      14.18
    100000      10.70       1.86       4.78       0.25      22.57
    150000      55.87       2.42       7.57       0.37      30.99
    200000      63.74       3.23       9.81       0.49      42.35
    250000      69.72       4.93      12.16       0.60      55.71
    300000      76.37       7.16      14.56       0.72      64.03
    350000      83.60      10.34      17.01       0.83      91.18
    400000      90.23      15.36      19.60       0.94     103.36
    450000      97.47      20.07      22.17       1.06     111.07
    500000     103.99      22.14      24.56       1.38     118.84
    550000     110.85      22.36      26.93       1.88     126.66
    600000     118.49      22.58      29.70       2.30     136.47
    650000     125.26      23.08      32.05       2.50     148.96
    700000     132.34      23.65      34.28       3.01     156.62
    750000     138.89      24.22      36.80       3.54     164.49
    800000     146.38      24.78      44.05       4.05     172.23
    850000     155.14      25.34      46.81       4.28     180.48
    900000     163.21      26.25      49.85       4.41     195.99
    950000     171.81      26.47      52.22       4.55     203.47
   1000000     179.16      26.70      55.14       4.69     210.62

Best regards,

On Tue, 17 Feb 2009 08:42:19 -0500
Josef Bacik <josef@redhat.com> wrote:

> On Tue, Feb 17, 2009 at 06:21:10PM +0900, Yoshihiro Takahashi wrote:
> > Hi Josef.
> > 
> > I created file till return of ENOSPC.
> > I created 18874027 files of size zero on btrfs of 16Gbyte in 1609 seconds.
> > I test to cause ENOSPC-problem but there was not the problem.
> > ENOSPC-problem were fixed in linux-2.6.29-rc5 and this patch.
> > This is a good patch.
> > 
> > Next.
> > I created 2758939 files of size 4096 on btrfs of 16Gbyte in 431 seconds.
> > And I received the following messages when I unlink files.
> > 
> >  btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
> >  btrfs allocation failed flags 36, wanted 4096
> >  space_info has 65536 free, is full
> >  space_info total=1932853248, pinned=164216832, delalloc=0, may_use=0, used=1768570880
> >  block group 29360128 has 1073741824 bytes, 942583808 used 131092480 pinned 0 reserved
> >  0 blocks of free space at or bigger than bytes is
> >  block group 8619294720 has 859111424 bytes, 825987072 used 33124352 pinned 0 reserved
> >  0 blocks of free space at or bigger than bytes is
> >  ------------[ cut here ]------------
> >  kernel BUG at fs/btrfs/extent-tree.c:3360!
> >  invalid opcode: 0000 [#1] SMP
> >  last sysfs file: /sys/devices/pci0000:80/0000:80:0e.0/0000:84:00.0/local_cpus
> >  CPU 3
> >  Modules linked in: btrfs zlib_deflate nls_utf8 hfsplus autofs4 hidp rfcomm l2cap bluetooth sunrpc ib_iser libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib inet_lro rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ib_sa ib_mad ib_core dm_mirror dm_region_hash dm_log dm_multipath dm_mod sbs sbshc battery acpi_memhotplug ac ipv6 lp floppy snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss sg rtc_cmos snd_mixer_oss snd_pcm snd_timer rtc_core parport_pc tg3 libphy ide_cd_mod snd button parport cdrom serio_raw rtc_lib i2c_amd8111 i2c_amd756 k8temp soundcore hwmon snd_page_alloc shpchp amd_rng i2c_core pcspkr sata_sil libata aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci
 _hcd
> >  Pid: 20535, comm: rm Tainted: G   M       2.6.29-rc5 #1 -[62176J7]-
> >  RIP: 0010:[<ffffffffa041e529>]  [<ffffffffa041e529>] __btrfs_reserve_extent+0x25b/0x270 [btrfs]
> >  RSP: 0018:ffff8800acd6d3d8  EFLAGS: 00010246
> >  RAX: ffff88011996ca38 RBX: ffff88011996c960 RCX: 0000000000008610
> >  RDX: 000000000000e1e1 RSI: 0000000000000246 RDI: ffff88011996ca34
> >  RBP: ffff8800acd6d448 R08: 0000000000000000 R09: 00000000ffffff00
> >  R10: 000000000000000a R11: 0000000000000000 R12: ffff88011996c9c0
> >  R13: 0000000000001000 R14: ffff88011996ca30 R15: 0000000000001000
> >  FS:  00007fea3f7486e0(0000) GS:ffff88012ecffcc0(0000) knlGS:00000000f7fa38d0
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >  CR2: 00007f651b793000 CR3: 00000000c64be000 CR4: 00000000000006e0
> >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >  Process rm (pid: 20535, threadinfo ffff8800acd6c000, task ffff88012ed8c970)
> >  Stack:
> >   0000000000000000 ffff8800acd6d4f8 0000000000000000 0000000000000000
> >   ffffe20000000024 ffff880000000000 0000000000000000 0000000000000000
> >   ffff88010c0c4000 0000000000001000 ffff8800acd6d4f8 ffff88012a516000
> >  Call Trace:
> >   [<ffffffffa0421005>] btrfs_alloc_extent+0x48/0xa7 [btrfs]
> >   [<ffffffffa04210c0>] btrfs_alloc_free_block+0x5c/0x87 [btrfs]
> >   [<ffffffffa04155e1>] __btrfs_cow_block+0x1e7/0x82e [btrfs]
> >   [<ffffffffa04162d9>] btrfs_cow_block+0x1ed/0x1fc [btrfs]
> >   [<ffffffffa0419cb2>] btrfs_search_slot+0x31a/0x90f [btrfs]
> >   [<ffffffffa041add4>] btrfs_insert_some_items+0xb2/0x570 [btrfs]
> >   [<ffffffff80279fa3>] ? unlock_page+0x22/0x27
> >   [<ffffffffa04482df>] ? set_extent_buffer_dirty+0x102/0x131 [btrfs]
> >   [<ffffffffa041f50b>] insert_extents+0x162/0x36f [btrfs]
> >   [<ffffffffa0420105>] finish_current_insert+0x4de/0x553 [btrfs]
> >   [<ffffffffa04228dc>] __btrfs_inc_extent_ref+0x1b5/0x1e4 [btrfs]
> >   [<ffffffff8034a2fe>] ? generic_swap+0x0/0x1c
> >   [<ffffffffa04256fb>] btrfs_inc_ref+0x42d/0x4ce [btrfs]
> >   [<ffffffffa0422727>] ? __btrfs_inc_extent_ref+0x0/0x1e4 [btrfs]
> >   [<ffffffffa0445c95>] ? copy_extent_buffer+0x115/0x149 [btrfs]
> >   [<ffffffffa0415834>] __btrfs_cow_block+0x43a/0x82e [btrfs]
> >   [<ffffffffa04162d9>] btrfs_cow_block+0x1ed/0x1fc [btrfs]
> >   [<ffffffffa0419cb2>] btrfs_search_slot+0x31a/0x90f [btrfs]
> >   [<ffffffff8034d5e8>] ? crc32c+0x4c/0x60
> >   [<ffffffffa0427d8d>] btrfs_lookup_dir_item+0x71/0xe7 [btrfs]
> >   [<ffffffffa04337e4>] btrfs_unlink_inode+0x60/0x26f [btrfs]
> >   [<ffffffffa042f0e5>] ? start_transaction+0xf9/0x105 [btrfs]
> >   [<ffffffffa0433dbc>] btrfs_unlink+0x55/0x97 [btrfs]
> >   [<ffffffff802af53b>] vfs_unlink+0xb9/0x12c
> >   [<ffffffff802b197e>] do_unlinkat+0xc1/0x173
> >   [<ffffffff802b4063>] ? vfs_readdir+0x9a/0xaf
> >   [<ffffffff8026855b>] ? audit_syscall_entry+0x16b/0x19e
> >   [<ffffffff802b1a41>] sys_unlink+0x11/0x13
> >   [<ffffffff8020c05b>] system_call_fastpath+0x16/0x1b
> >  Code: 00 48 81 eb b8 00 00 00 48 8b 83 b8 00 00 00 48 8d 93 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 9f 4c 89 f7 e8 29 1e e3 df <0f> 0b eb fe 48 83 c4 48 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3
> >  RIP  [<ffffffffa041e529>] __btrfs_reserve_extent+0x25b/0x270 [btrfs]
> >   RSP <ffff8800acd6d3d8>
> >  ---[ end trace b5c34207a1ecc394 ]---
> > 
> > And, I received the following messages when I utime(2) files.
> > 
> >  btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
> >  btrfs allocation failed flags 36, wanted 4096
> >  space_info has 65536 free, is full
> >  space_info total=1932853248, pinned=54943744, delalloc=0, may_use=0, used=1877843968
> >  block group 29360128 has 1073741824 bytes, 1041494016 used 32182272 pinned 0 reserved
> >  0 blocks of free space at or bigger than bytes is
> >  block group 8619294720 has 859111424 bytes, 836349952 used 22761472 pinned 0 reserved
> >  0 blocks of free space at or bigger than bytes is
> >  ------------[ cut here ]------------
> >  kernel BUG at fs/btrfs/extent-tree.c:3360!
> >  invalid opcode: 0000 [#1] SMP
> >  last sysfs file: /sys/devices/pci0000:80/0000:80:0e.0/0000:84:00.0/local_cpus
> >  CPU 3
> >  Modules linked in: btrfs zlib_deflate autofs4 hidp rfcomm l2cap bluetooth sunrpc ib_iser libiscsi scsi_transport_iscsi ib_srp scsi_transport_srp ib_ipoib inet_lro rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ib_sa ib_mad ib_core dm_mirror dm_region_hash dm_log dm_multipath dm_mod sbs sbshc battery acpi_memhotplug ac ipv6 lp floppy snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss k8temp button sg snd_pcm i2c_amd8111 snd_timer snd serio_raw parport_pc rtc_cmos tg3 i2c_amd756 soundcore rtc_core parport hwmon libphy i2c_core ide_cd_mod cdrom rtc_lib amd_rng pcspkr snd_page_alloc shpchp sata_sil libata aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
> >  Pid: 14421, comm: mkfbmt Tainted: G   M       2.6.29-rc5 #1 -[62176J7]-
> >  RIP: 0010:[<ffffffffa0407529>]  [<ffffffffa0407529>] __btrfs_reserve_extent+0x25b/0x270 [btrfs]
> >  RSP: 0018:ffff88010010d968  EFLAGS: 00010246
> >  RAX: ffff880026bed8f8 RBX: ffff880026bed820 RCX: 0000000000008689
> >  RDX: 0000000000005959 RSI: 0000000000000246 RDI: ffff880026bed8f4
> >  RBP: ffff88010010d9d8 R08: 0000000000000000 R09: 00000000ffffff00
> >  R10: 000000000000000a R11: 0000000000000000 R12: ffff880026bed880
> >  R13: 0000000000001000 R14: ffff880026bed8f0 R15: 0000000000001000
> >  FS:  00007fb97df446e0(0000) GS:ffff88012ecffcc0(0000) knlGS:00000000f7f4f8d0
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >  CR2: 000000342e614ce5 CR3: 000000011557b000 CR4: 00000000000006e0
> >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >  Process mkfbmt (pid: 14421, threadinfo ffff88010010c000, task ffff88011f9738d0)
> >  Stack:
> >   0000000000000000 ffff88010010da88 0000000000000000 0000000000000000
> >   ffff880100000024 ffff88010010dad4 0000000000000000 0000000000000000
> >   ffff8801145c0000 0000000000001000 ffff88010010da88 ffff8801149cd000
> >  Call Trace:
> >   [<ffffffffa040a005>] btrfs_alloc_extent+0x48/0xa7 [btrfs]
> >   [<ffffffffa040a0c0>] btrfs_alloc_free_block+0x5c/0x87 [btrfs]
> >   [<ffffffffa03fe5e1>] __btrfs_cow_block+0x1e7/0x82e [btrfs]
> >   [<ffffffffa03ff2d9>] btrfs_cow_block+0x1ed/0x1fc [btrfs]
> >   [<ffffffffa0402cb2>] btrfs_search_slot+0x31a/0x90f [btrfs]
> >   [<ffffffffa0419b89>] ? btrfs_lookup_dentry+0x159/0x16f [btrfs]
> >   [<ffffffff802cd6a1>] ? inotify_d_instantiate+0x1a/0x43
> >   [<ffffffff802b6984>] ? d_splice_alias+0xc4/0xd0
> >   [<ffffffffa0412a8c>] btrfs_lookup_inode+0x2c/0x90 [btrfs]
> >   [<ffffffffa041bb13>] btrfs_update_inode+0x46/0xbd [btrfs]
> >   [<ffffffffa041c770>] btrfs_dirty_inode+0x3e/0x52 [btrfs]
> >   [<ffffffff802c0f3c>] __mark_inode_dirty+0x33/0x178
> >   [<ffffffff802b998c>] inode_setattr+0x11b/0x125
> >   [<ffffffffa041ace0>] btrfs_setattr+0x56/0x6e [btrfs]
> >   [<ffffffff802b9b2a>] notify_change+0x194/0x2d6
> >   [<ffffffff802c3969>] utimes_common+0x121/0x163
> >   [<ffffffff802c3a64>] do_utimes+0xb9/0xda
> >   [<ffffffff802c3c0f>] sys_utime+0x66/0x7b
> >   [<ffffffff8020c05b>] system_call_fastpath+0x16/0x1b
> >  Code: 00 48 81 eb b8 00 00 00 48 8b 83 b8 00 00 00 48 8d 93 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 9f 4c 89 f7 e8 29 8e e4 df <0f> 0b eb fe 48 83 c4 48 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3
> >  RIP  [<ffffffffa0407529>] __btrfs_reserve_extent+0x25b/0x270 [btrfs]
> >   RSP <ffff88010010d968>
> >  ---[ end trace 16075f4743156c16 ]---
> > 
> > Thanks, regards,
> > 
> 
> Thank you, what tool are you using to create these files and such?
> 
> Josef

--Multipart=_Thu__19_Feb_2009_17_45_54_+0900_T0q2AAeFF9ljf9TJ
Content-Type: text/plain;
 name="mkfbmt.c"
Content-Disposition: attachment;
 filename="mkfbmt.c"
Content-Transfer-Encoding: base64

LyoNCiAqICAgICAgbWtmYm10LmMNCiAqICAgICAgaHR0cDovL3dpa2kubGl2ZWRvb3IuanAvbGlu
dXhmcy8NCiAqICAgICAgeW9zLnRha2FoYXNoaUBnbWFpbC5jb20NCiAqDQogKiAgICAgIDIwMDUu
MDkuMTQgIHVwZGF0ZWQgYnkgeXRha2FoYXNoaQ0KICogICAgICAyMDA3LjAxLjA1ICB1cGRhdGVk
IGJ5IHl0YWthaGFzaGkNCiAqICAgICAgICAgICAgICAgICAgY3JlYXQgLT4gb3BlbihPX0NSRUFU
IHwgT19FWENMIHwgT19XUk9OTFkpDQogKi8NCg0KI2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVk
ZSA8dW5pc3RkLmg+DQojaW5jbHVkZSA8c3lzL21tYW4uaD4NCiNpbmNsdWRlIDxzdHJpbmcuaD4N
CiNpbmNsdWRlIDx1bmlzdGQuaD4NCiNpbmNsdWRlIDxzdGRsaWIuaD4NCiNpbmNsdWRlIDxzaWdu
YWwuaD4NCiNpbmNsdWRlIDxpbnR0eXBlcy5oPg0KDQojaW5jbHVkZSA8bGltaXRzLmg+DQojaW5j
bHVkZSA8c3lzL3R5cGVzLmg+DQojaW5jbHVkZSA8c3lzL3N0YXQuaD4NCiNpbmNsdWRlIDxmY250
bC5oPg0KI2luY2x1ZGUgPGVycm5vLmg+DQojaW5jbHVkZSA8c3lzL3RpbWUuaD4NCiNpbmNsdWRl
IDx1dGltZS5oPg0KDQojZGVmaW5lIEtFRVBfRklMRSAyMA0KI2RlZmluZSBDSEVDS19FTlRSWSA2
DQoNCiNkZWZpbmUgTUtfQUxMCQkgIDANCiNkZWZpbmUgTUtfTUtESVIJICAxDQojZGVmaW5lIE1L
X0NSRUFURQkgIDINCiNkZWZpbmUgTUtfT1BFTgkJICA0DQojZGVmaW5lIE1LX1VUSU1FCSAxNg0K
I2RlZmluZSBNS19TVEFUCQkgMzINCiNkZWZpbmUgTUtfVU5MSU5LCSA2NA0KI2RlZmluZSBNS19S
TURJUgkxMjgNCg0KLyogZ3JvYmFsIGNvbmZpZyAqLw0KdHlwZWRlZiBzdHJ1Y3QgbWtmYm10X2Nv
bmYgew0KCWludCBmaWxlczsNCgl1aW50NjRfdCBtYXhfZmlsZXM7DQoJaW50IGRpcmVjdHJ5Ow0K
CWludCB0aW1lX291dDsNCglpbnQgdG90YWw7DQoJaW50IG1rX2ZpbGVzOw0KCWludCBlbnRyeTsN
CglpbnQgbG9vcHM7DQoJaW50IG1vZGlzOw0KCXNpemVfdCB3X3NpemU7DQp9IG1rZmJtdF9jb25m
X3Q7DQoNCmRvdWJsZSB0YWJsZVtLRUVQX0ZJTEVdW0NIRUNLX0VOVFJZXTsNCnN0cnVjdCB0aW1l
dmFsIGdfcnRpbWU7DQpzdHJ1Y3QgdGltZXZhbCBnX2V0aW1lOw0KDQpzdHJ1Y3QgbWtmYm10X2Nv
bmYgY29uZiA9IHsNCgkuZmlsZXMgPSAxMDAwMCwNCgkubWF4X2ZpbGVzID0gMHhmZmZmZmZmZmZm
ZmZmZmZmVUxMLA0KCS5kaXJlY3RyeSA9IDAsDQoJLnRpbWVfb3V0ID0gMCwNCgkudG90YWwgPSAw
LA0KCS5ta19maWxlcyA9IDAsDQoJLmVudHJ5ID0gMCwNCgkubG9vcHMgPSAxLA0KCS5tb2RpcyA9
IDEwMDAsDQoJLndfc2l6ZSA9IDAsDQp9Ow0KDQpjaGFyICp3X2J1ZiA9IE5VTEw7DQoNCnZvaWQg
aGFuZGxlcihpbnQgc2lnKTsNCg0KLyogdXNhZ2UgKi8NCnZvaWQgQmZvcm0oKQ0Kew0KCWZwcmlu
dGYoc3RkZXJyLCAiVXNhZ2U6Wy1kIGRpcmVjdHJ5XVstZiB0YXJnZXRmaWxlIGNvdW50XVstdCBz
aWduYWxdWy14IGZpbGUgY291bnRdWy1sIGNvdW50XVstbWNvc3VyXVstdyBzaXplXVxuIg0KCQkJ
IiAgICAgICAtZCB0ZXN0IGRpcmVjdHJ5XG4iDQoJCQkiICAgICAgIC1mIHRhcmdldGZpbGUgY291
bnRcbiINCgkJCSIgICAgICAgLXQgdGltZV9vdXQgcHJpbnQgdGltZVxuIg0KCQkJIiAgICAgICAt
eCBtYXggZmlsZSBmb3IgZGlyZWN0cnlcbiINCgkJCSIgICAgICAgLWwgdGVzdCBsb29wIGNvdW50
XG4iDQoJCQkiICAgICAgIC1tIG1rZGlyICB0ZXN0XG4iDQoJCQkiICAgICAgIC1jIGNyZWF0ICB0
ZXN0XG4iDQoJCQkiICAgICAgIC1vIG9wZW4gICB0ZXN0XG4iDQoJCQkiICAgICAgIC1wIHV0aW1l
ICB0ZXN0XG4iDQoJCQkiICAgICAgIC1zIHN0YXQgICB0ZXN0XG4iDQoJCQkiICAgICAgIC11IHVu
bGluayB0ZXN0XG4iDQoJCQkiICAgICAgIC1yIHJtZGlyICB0ZXN0XG4iDQoJCQkiICAgICAgIC13
IHdyaXRlICB0ZXN0XG4iKTsNCglleGl0KDEpOw0KfQ0KDQp2b2lkIF9fbGludXhmc19pbml0KHZv
aWQpDQp7DQoJZnByaW50ZihzdGRlcnIsICIjIyAlcyglZCkgWyVwXSBcbiIsIF9fRlVOQ1RJT05f
XywgX19MSU5FX18sIF9fYnVpbHRpbl9yZXR1cm5fYWRkcmVzcygwKSk7DQp9DQoNCi8qIGVycm9y
ICovDQp2b2lkIEJlcnJvcihpbnQgZXJycykNCnsNCglmcHJpbnRmKHN0ZGVyciwgIkVSUk9SIDog
JXMgXG4iLCBzdHJlcnJvcihlcnJzKSk7DQoJZXhpdCgxKTsNCn0NCg0Kdm9pZCBCZXJyb3IyKGlu
dCBlcnJzKQ0Kew0KCWZwcmludGYoc3RkZXJyLCAiRVJST1IgOiAlcyBcbiIsIHN0cmVycm9yKGVy
cnMpKTsNCn0NCg0KLyogZV90aW1lICovDQpkb3VibGUgZV90aW1lKHN0cnVjdCB0aW1ldmFsIGZp
cnN0LCBzdHJ1Y3QgdGltZXZhbCBzZWNvbmQpDQp7DQoJaWYgKGZpcnN0LnR2X3VzZWMgPiBzZWNv
bmQudHZfdXNlYykgew0KCQlzZWNvbmQudHZfdXNlYyArPSAxMDAwMDAwOw0KCQlzZWNvbmQudHZf
c2VjLS07DQoJfQ0KCXJldHVybigoZG91YmxlKShzZWNvbmQudHZfc2VjIC0gZmlyc3QudHZfc2Vj
KSAqIDEwMDAwMDAuMA0KCQkrIChkb3VibGUpKHNlY29uZC50dl91c2VjIC0gZmlyc3QudHZfdXNl
YykpOw0KfQ0KDQovKiBmb3IgdGltZW91dCBzZXR0aW5nICovDQp2b2lkIHNldF9zaWdhbHJtKHZv
aWQpDQp7DQoJc3RydWN0IHNpZ2FjdGlvbiBhY3Q7DQoJc2lnc2V0X3QgZnVsbF9tYXNrOw0KCWNv
bmYubWtfZmlsZXMgPSAwOw0KDQoNCglpZiAoc2lnZmlsbHNldCgmZnVsbF9tYXNrKSkgew0KCQlm
cHJpbnRmKHN0ZGVyciwgIkNhbm5vdCBmaWxsIHNpZ25hbCBtYXNrXG4iKTsNCgkJZXhpdCgxKTsN
Cgl9DQoNCglpZiAoc2lnZGVsc2V0KCZmdWxsX21hc2ssIFNJR0FMUk0pKSB7DQoJCWZwcmludGYo
c3RkZXJyLCAiQ2Fubm90IHJlc2V0IHNpZ25hbCBtYXNrXG4iKTsNCgkJZXhpdCgxKTsNCgl9DQoN
CglpZiAoc2lncHJvY21hc2soU0lHX0JMT0NLLCAmZnVsbF9tYXNrLCBOVUxMKSkgew0KCQlmcHJp
bnRmKHN0ZGVyciwgIkNhbm5vdCBzZXQgc2lnbmFsIHByb2MgbWFza1xuIik7DQoJCWV4aXQoMSk7
DQoJfQ0KDQoJYWN0LnNhX2hhbmRsZXIgPSBoYW5kbGVyOw0KCWFjdC5zYV9mbGFncyA9IFNBX1JF
U1RBUlQ7DQoJYWN0LnNhX21hc2sgPSBmdWxsX21hc2s7DQoNCglpZiAoc2lnYWN0aW9uKFNJR0FM
Uk0sICAmYWN0LCBOVUxMKSkgew0KCQlmcHJpbnRmKHN0ZGVyciwgIkNhbm5vdCBzZXQgc2lnbmFs
IGFjdGlvblxuIik7DQoJCWV4aXQoMSk7DQoJfQ0KCWFsYXJtKGNvbmYudGltZV9vdXQpOw0KfQ0K
DQovKiB1bnNldCB0aW1lb3V0ICovDQp2b2lkIHVuc2V0X3NpZ2Fscm0odm9pZCkNCnsNCglhbGFy
bSgwKTsNCn0NCg0KLyogc2lnbmFsIGhhbmRsZXIgKi8NCnZvaWQgaGFuZGxlcihpbnQgc2lnKQ0K
ew0KCWlmIChzaWcgPT0gU0lHQUxSTSkgew0KCQl1bnNldF9zaWdhbHJtKCk7DQoJCWNvbmYudG90
YWwgKz0gY29uZi5ta19maWxlczsNCgkJcHJpbnRmKCJtYWtlICU4ZCgrJThkKSAvICU4ZCAgXG4i
LCBjb25mLnRvdGFsLCBjb25mLm1rX2ZpbGVzLCBjb25mLmZpbGVzKTsNCgkJY29uZi5ta19maWxl
cyA9IDA7DQoJCXNldF9zaWdhbHJtKCk7DQoJfQ0KfQ0KDQovKiBtYWtlIGRpciAqLw0Kdm9pZCBs
bF9ta2Rpcih2b2lkKQ0Kew0KCWludCBpOw0KCWNoYXIgZmlsZV9uYW1lW1BBVEhfTUFYICsgMV07
DQoNCglmb3IgKGkgPSAwOyBpIDwgY29uZi5kaXJlY3RyeTsgaSsrKSB7DQoJCXNucHJpbnRmKGZp
bGVfbmFtZSwgUEFUSF9NQVgsICIlZCIsIGkpOw0KCQlpZiAobWtkaXIoZmlsZV9uYW1lLCAwNzc3
KSkgew0KCQkJQmVycm9yKGVycm5vKTsNCgkJfQ0KCQljb25mLmVudHJ5Kys7DQoJCWNvbmYubWtf
ZmlsZXMrKzsNCgl9DQp9DQoNCi8qIHJtZGlyICovDQp2b2lkIGxsX3JtZGlyKHZvaWQpDQp7DQoJ
aW50IGk7DQoJY2hhciBmaWxlX25hbWVbUEFUSF9NQVggKyAxXTsNCg0KCWZvciAoaSA9IDA7IGkg
PCBjb25mLmRpcmVjdHJ5OyBpKyspIHsNCgkJc25wcmludGYoZmlsZV9uYW1lLCBQQVRIX01BWCwg
IiVkIiwgaSk7DQoJCWlmIChybWRpcihmaWxlX25hbWUpKSB7DQoJCQlCZXJyb3IoZXJybm8pOw0K
CQl9DQoJCWNvbmYuZW50cnkrKzsNCgkJY29uZi5ta19maWxlcysrOw0KCX0NCn0NCg0KLyogY3Jl
YXRlICovDQp2b2lkIGxsX2NyZWF0KGludCBmaWxlcykNCnsNCglpbnQgZmQsIGksIHg7DQoJY2hh
ciBmaWxlX25hbWVbUEFUSF9NQVggKyAxXTsNCg0KCWZvciAoaSA9IDA7IGkgPCBmaWxlczsgaSsr
KSB7DQoJCXNucHJpbnRmKGZpbGVfbmFtZSwgUEFUSF9NQVgsICIlZCIsIGkpOw0KCQlmZCA9IG9w
ZW4oZmlsZV9uYW1lLCBPX0NSRUFUIHwgT19FWENMIHwgT19XUk9OTFksIDA2NjYpOw0KCQlpZiAo
ZmQgPCAwKSB7DQoJCQlCZXJyb3IyKGVycm5vKTsNCgkJCXJldHVybjsNCgkJfQ0KCQlpZiAoY29u
Zi53X3NpemUpIHsNCgkJCXdyaXRlKGZkLCB3X2J1ZiwgY29uZi53X3NpemUpOw0KCQl9DQoJCWNs
b3NlKGZkKTsNCgkJY29uZi5lbnRyeSsrOw0KCQljb25mLm1rX2ZpbGVzKys7DQoJCWlmICghKGNv
bmYuZW50cnkgJSBjb25mLm1vZGlzKSkgew0KCQkJZ2V0dGltZW9mZGF5ICgmZ19ldGltZSwgTlVM
TCk7DQoJCQl4ID0gKChjb25mLmVudHJ5IC8gY29uZi5tb2RpcykgPiAwKSA/ICgoY29uZi5lbnRy
eSAvIGNvbmYubW9kaXMpIC0gMSkgOiAwOw0KCQkJdGFibGVbeF1bMV0gPSAoZG91YmxlKShlX3Rp
bWUoZ19ydGltZSwgZ19ldGltZSkpIC8gMTAwMDAwMC4wOw0KCQl9DQoJfQ0KfQ0KDQovKiBvcGVu
ICovDQp2b2lkIGxsX29wZW4oaW50IGZpbGVzKQ0Kew0KCWludCBpLCBmZCwgeDsNCgljaGFyIGZp
bGVfbmFtZVtQQVRIX01BWCArIDFdOw0KDQoJZm9yIChpID0gMDsgaSA8IGZpbGVzOyBpKyspIHsN
CgkJc25wcmludGYoZmlsZV9uYW1lLCBQQVRIX01BWCwgIiVkIiwgaSk7DQoJCWZkID0gb3Blbihm
aWxlX25hbWUsIE9fUkRPTkxZKTsNCgkJaWYgKGZkIDwgMCkgew0KCQkJQmVycm9yMihlcnJubyk7
DQoJCQlyZXR1cm47DQoJCX0NCgkJY2xvc2UoZmQpOw0KCQljb25mLmVudHJ5Kys7DQoJCWNvbmYu
bWtfZmlsZXMrKzsNCgkJaWYgKCEoY29uZi5lbnRyeSAlIGNvbmYubW9kaXMpKSB7DQoJCQlnZXR0
aW1lb2ZkYXkgKCZnX2V0aW1lLCBOVUxMKTsNCgkJCXggPSAoKGNvbmYuZW50cnkgLyBjb25mLm1v
ZGlzKSA+IDApID8gKChjb25mLmVudHJ5IC8gY29uZi5tb2RpcykgLSAxKSA6IDA7DQoJCQl0YWJs
ZVt4XVsyXSA9IChkb3VibGUpKGVfdGltZShnX3J0aW1lLCBnX2V0aW1lKSkgLyAxMDAwMDAwLjA7
DQoJCX0NCgl9DQp9DQoNCnZvaWQgbGxfdXRpbWUoaW50IGZpbGVzKQ0Kew0KCWludCBpLCB4Ow0K
CXN0cnVjdCB1dGltYnVmIHV0Ow0KCWNoYXIgZmlsZV9uYW1lW1BBVEhfTUFYICsgMV07DQoJdXQu
YWN0aW1lID0gMDsNCgl1dC5tb2R0aW1lID0gMDsNCg0KCWZvciAoaSA9IDA7IGkgPCBmaWxlczsg
aSsrKSB7DQoJCXNucHJpbnRmKGZpbGVfbmFtZSwgUEFUSF9NQVgsICIlZCIsIGkpOw0KCQlpZiAo
dXRpbWUoZmlsZV9uYW1lLCAmdXQpIDwgMCkgew0KCQkJQmVycm9yMihlcnJubyk7DQoJCQlyZXR1
cm47DQoJCX0NCg0KCQljb25mLmVudHJ5Kys7DQoJCWNvbmYubWtfZmlsZXMrKzsNCgkJaWYgKCEo
Y29uZi5lbnRyeSAlIGNvbmYubW9kaXMpKSB7DQoJCQlnZXR0aW1lb2ZkYXkgKCZnX2V0aW1lLCBO
VUxMKTsNCgkJCXggPSAoKGNvbmYuZW50cnkgLyBjb25mLm1vZGlzKSA+IDApID8gKChjb25mLmVu
dHJ5IC8gY29uZi5tb2RpcykgLSAxKSA6IDA7DQoJCQl0YWJsZVt4XVszXSA9IChkb3VibGUpKGVf
dGltZShnX3J0aW1lLCBnX2V0aW1lKSkgLyAxMDAwMDAwLjA7DQoJCX0NCgl9DQp9DQoNCi8qIHN0
YXQgKi8NCnZvaWQgbGxfc3RhdChpbnQgZmlsZXMpDQp7DQoJaW50IGksIHg7DQoJY2hhciBmaWxl
X25hbWVbUEFUSF9NQVggKyAxXTsNCglzdHJ1Y3Qgc3RhdCBzYjsNCg0KCWZvciAoaSA9IDA7IGkg
PCBmaWxlczsgaSsrKSB7DQoJCXNucHJpbnRmKGZpbGVfbmFtZSwgUEFUSF9NQVgsICIlZCIsIGkp
Ow0KCQlpZiAoc3RhdChmaWxlX25hbWUsICZzYikpIHsNCgkJCUJlcnJvcjIoZXJybm8pOw0KCQkJ
cmV0dXJuOw0KCQl9DQoJCWNvbmYuZW50cnkrKzsNCgkJY29uZi5ta19maWxlcysrOw0KCQlpZiAo
IShjb25mLmVudHJ5ICUgY29uZi5tb2RpcykpIHsNCgkJCWdldHRpbWVvZmRheSAoJmdfZXRpbWUs
IE5VTEwpOw0KCQkJeCA9ICgoY29uZi5lbnRyeSAvIGNvbmYubW9kaXMpID4gMCkgPyAoKGNvbmYu
ZW50cnkgLyBjb25mLm1vZGlzKSAtIDEpIDogMDsNCgkJCXRhYmxlW3hdWzRdID0gKGRvdWJsZSko
ZV90aW1lKGdfcnRpbWUsIGdfZXRpbWUpKSAvIDEwMDAwMDAuMDsNCgkJfQ0KCX0NCn0NCg0KLyog
dW5saW5rICovDQp2b2lkIGxsX3VubGluayhpbnQgZmlsZXMpDQp7DQoJaW50IGksIHg7DQoJY2hh
ciBmaWxlX25hbWVbUEFUSF9NQVggKyAxXTsNCg0KCWZvciAoaSA9IDA7IGkgPCBmaWxlczsgaSsr
KSB7DQoJCXNucHJpbnRmKGZpbGVfbmFtZSwgUEFUSF9NQVgsICIlZCIsIGkpOw0KCQl1bmxpbmso
ZmlsZV9uYW1lKTsNCgkJY29uZi5lbnRyeSsrOw0KCQljb25mLm1rX2ZpbGVzKys7DQoJCWlmICgh
KGNvbmYuZW50cnkgJSBjb25mLm1vZGlzKSkgew0KCQkJZ2V0dGltZW9mZGF5ICgmZ19ldGltZSwg
TlVMTCk7DQoJCQl4ID0gKChjb25mLmVudHJ5IC8gY29uZi5tb2RpcykgPiAwKSA/ICgoY29uZi5l
bnRyeSAvIGNvbmYubW9kaXMpIC0gMSkgOiAwOw0KCQkJdGFibGVbeF1bNV0gPSAoZG91YmxlKShl
X3RpbWUoZ19ydGltZSwgZ19ldGltZSkpIC8gMTAwMDAwMC4wOw0KCQl9DQoJfQ0KfQ0KDQp2b2lk
IGNyZWF0X29wKGNvbnN0IGNoYXIgKmRpcmVjdHJ5KQ0Kew0KCWludCBpLCBmaWxlcywgc3ZfZmls
ZXM7DQoJY2hhciBwYXRoW1BBVEhfTUFYICsgMV07DQoJZG91YmxlIHNlYzsNCglzdHJ1Y3QgdGlt
ZXZhbCBzdGFydCwgc3RvcDsNCg0KCWNvbmYuZW50cnkgPSAwOw0KCWNvbmYudG90YWwgPSAwOw0K
CXN2X2ZpbGVzID0gY29uZi5maWxlczsNCglzZXRfc2lnYWxybSgpOw0KCWdldHRpbWVvZmRheSAo
JnN0YXJ0LCBOVUxMKTsNCglnZXR0aW1lb2ZkYXkgKCZnX3J0aW1lLCBOVUxMKTsNCg0KCWlmIChj
b25mLmRpcmVjdHJ5ID09IDApIHsNCgkJc25wcmludGYocGF0aCwgUEFUSF9NQVgsICIlcyIsIGRp
cmVjdHJ5KTsNCgkJY2hkaXIocGF0aCk7DQoJCWxsX2NyZWF0KHN2X2ZpbGVzKTsNCgl9IGVsc2Ug
ew0KCQlmb3IgKGkgPSAwOyBpIDwgY29uZi5kaXJlY3RyeTsgaSsrKSB7DQoJCQlzdl9maWxlcyA+
IGNvbmYubWF4X2ZpbGVzID8gKGZpbGVzID0gY29uZi5tYXhfZmlsZXMpIDogKGZpbGVzID0gc3Zf
ZmlsZXMpOw0KCQkJc3ZfZmlsZXMgLT0gY29uZi5tYXhfZmlsZXM7DQoJCQlzbnByaW50ZihwYXRo
LCBQQVRIX01BWCwgIiVzLyVkIiwgZGlyZWN0cnksIGkpOw0KCQkJY2hkaXIocGF0aCk7DQoJCQls
bF9jcmVhdChmaWxlcyk7DQoJCX0NCgl9DQoJZ2V0dGltZW9mZGF5ICgmc3RvcCwgTlVMTCk7DQoJ
dW5zZXRfc2lnYWxybSgpOw0KCXNlYyA9IChkb3VibGUpKGVfdGltZShzdGFydCwgc3RvcCkpIC8g
MTAwMDAwMC4wIC8gY29uZi5maWxlczsNCglwcmludGYoImNyZWF0IDogJWxmIHNlYyAsIDEgZmls
ZSBjcmVhdCAgZm9yICVsZiBzZWNcbiIsIChkb3VibGUpKGVfdGltZShzdGFydCwgc3RvcCkpIC8g
MTAwMDAwMC4wLCBzZWMpOw0KfQ0KDQp2b2lkIG9wZW5fb3AoY29uc3QgY2hhciAqZGlyZWN0cnkp
DQp7DQoJaW50IGksIGZpbGVzLCBzdl9maWxlczsNCgljaGFyIHBhdGhbUEFUSF9NQVggKyAxXTsN
Cglkb3VibGUgc2VjOw0KCXN0cnVjdCB0aW1ldmFsIHN0YXJ0LCBzdG9wOw0KDQoJY29uZi5lbnRy
eSA9IDA7DQoJY29uZi50b3RhbCA9IDA7DQoJc3ZfZmlsZXMgPSBjb25mLmZpbGVzOw0KCXNldF9z
aWdhbHJtKCk7DQoJZ2V0dGltZW9mZGF5ICgmc3RhcnQsIE5VTEwpOw0KCWdldHRpbWVvZmRheSAo
JmdfcnRpbWUsIE5VTEwpOw0KDQoJaWYgKGNvbmYuZGlyZWN0cnkgPT0gMCkgew0KCQlzbnByaW50
ZihwYXRoLCBQQVRIX01BWCwgIiVzIiwgZGlyZWN0cnkpOw0KCQljaGRpcihwYXRoKTsNCgkJbGxf
b3Blbihzdl9maWxlcyk7DQoJfSBlbHNlIHsNCgkJZm9yIChpID0gMDsgaSA8IGNvbmYuZGlyZWN0
cnk7IGkrKykgew0KCQkJc3ZfZmlsZXMgPiBjb25mLm1heF9maWxlcyA/IChmaWxlcyA9IGNvbmYu
bWF4X2ZpbGVzKSA6IChmaWxlcyA9IHN2X2ZpbGVzKTsNCgkJCXN2X2ZpbGVzIC09IGNvbmYubWF4
X2ZpbGVzOw0KCQkJc25wcmludGYocGF0aCwgUEFUSF9NQVgsICIlcy8lZCIsIGRpcmVjdHJ5LCBp
KTsNCgkJCWNoZGlyKHBhdGgpOw0KCQkJbGxfb3BlbihmaWxlcyk7DQoJCX0NCgl9DQoJZ2V0dGlt
ZW9mZGF5ICgmc3RvcCwgTlVMTCk7DQoJdW5zZXRfc2lnYWxybSgpOw0KDQoJc2VjID0gKGRvdWJs
ZSkoZV90aW1lKHN0YXJ0LCBzdG9wKSkgLyAxMDAwMDAwLjAgLyBjb25mLmZpbGVzOw0KCXByaW50
Zigib3BlbiAgOiAlbGYgc2VjICwgMSBmaWxlIG9wZW4gICBmb3IgJWxmIHNlY1xuIiwgKGRvdWJs
ZSkoZV90aW1lKHN0YXJ0LCBzdG9wKSkgLyAxMDAwMDAwLjAsIHNlYyk7DQp9DQoNCnZvaWQgc3Rh
dF9vcChjb25zdCBjaGFyICpkaXJlY3RyeSkNCnsNCglpbnQgaSwgZmlsZXMsIHN2X2ZpbGVzOw0K
CWNoYXIgcGF0aFtQQVRIX01BWCArIDFdOw0KCWRvdWJsZSBzZWM7DQoJc3RydWN0IHRpbWV2YWwg
c3RhcnQsIHN0b3A7DQoNCgljb25mLmVudHJ5ID0gMDsNCgljb25mLnRvdGFsID0gMDsNCglzdl9m
aWxlcyA9IGNvbmYuZmlsZXM7DQoJc2V0X3NpZ2Fscm0oKTsNCglnZXR0aW1lb2ZkYXkgKCZzdGFy
dCwgTlVMTCk7DQoJZ2V0dGltZW9mZGF5ICgmZ19ydGltZSwgTlVMTCk7DQoNCglpZiAoY29uZi5k
aXJlY3RyeSA9PSAwKSB7DQoJCXNucHJpbnRmKHBhdGgsIFBBVEhfTUFYLCAiJXMiLCBkaXJlY3Ry
eSk7DQoJCWNoZGlyKHBhdGgpOw0KCQlsbF9zdGF0KHN2X2ZpbGVzKTsNCgl9IGVsc2Ugew0KCQlm
b3IgKGkgPSAwOyBpIDwgY29uZi5kaXJlY3RyeTsgaSsrKSB7DQoJCQlzdl9maWxlcyA+IGNvbmYu
bWF4X2ZpbGVzID8gKGZpbGVzID0gY29uZi5tYXhfZmlsZXMpIDogKGZpbGVzID0gc3ZfZmlsZXMp
Ow0KCQkJc3ZfZmlsZXMgLT0gY29uZi5tYXhfZmlsZXM7DQoJCQlzbnByaW50ZihwYXRoLCBQQVRI
X01BWCwgIiVzLyVkIiwgZGlyZWN0cnksIGkpOw0KCQkJY2hkaXIocGF0aCk7DQoJCQlsbF9zdGF0
KGZpbGVzKTsNCgkJfQ0KCX0NCglnZXR0aW1lb2ZkYXkgKCZzdG9wLCBOVUxMKTsNCgl1bnNldF9z
aWdhbHJtKCk7DQoNCglzZWMgPSAoZG91YmxlKShlX3RpbWUoc3RhcnQsIHN0b3ApKSAvIDEwMDAw
MDAuMCAvIGNvbmYuZmlsZXM7DQoJcHJpbnRmKCJzdGF0ICA6ICVsZiBzZWMgLCAxIGZpbGUgc3Rh
dCAgIGZvciAlbGYgc2VjXG4iLCAoZG91YmxlKShlX3RpbWUoc3RhcnQsIHN0b3ApKSAvIDEwMDAw
MDAuMCwgc2VjKTsNCn0NCg0Kdm9pZCB1dGltZV9vcChjb25zdCBjaGFyICpkaXJlY3RyeSkNCnsN
CglpbnQgaSwgZmlsZXMsIHN2X2ZpbGVzOw0KCWNoYXIgcGF0aFtQQVRIX01BWCArIDFdOw0KCWRv
dWJsZSBzZWM7DQoJc3RydWN0IHRpbWV2YWwgc3RhcnQsIHN0b3A7DQoNCgljb25mLmVudHJ5ID0g
MDsNCgljb25mLnRvdGFsID0gMDsNCglzdl9maWxlcyA9IGNvbmYuZmlsZXM7DQoJc2V0X3NpZ2Fs
cm0oKTsNCglnZXR0aW1lb2ZkYXkgKCZzdGFydCwgTlVMTCk7DQoJZ2V0dGltZW9mZGF5ICgmZ19y
dGltZSwgTlVMTCk7DQoNCglpZiAoY29uZi5kaXJlY3RyeSA9PSAwKSB7DQoJCXNucHJpbnRmKHBh
dGgsIFBBVEhfTUFYLCAiJXMiLCBkaXJlY3RyeSk7DQoJCWNoZGlyKHBhdGgpOw0KCQlsbF91dGlt
ZShzdl9maWxlcyk7DQoJfSBlbHNlIHsNCgkJZm9yIChpID0gMDsgaSA8IGNvbmYuZGlyZWN0cnk7
IGkrKykgew0KCQkJc3ZfZmlsZXMgPiBjb25mLm1heF9maWxlcyA/IChmaWxlcyA9IGNvbmYubWF4
X2ZpbGVzKSA6IChmaWxlcyA9IHN2X2ZpbGVzKTsNCgkJCXN2X2ZpbGVzIC09IGNvbmYubWF4X2Zp
bGVzOw0KCQkJc25wcmludGYocGF0aCwgUEFUSF9NQVgsICIlcy8lZCIsIGRpcmVjdHJ5LCBpKTsN
CgkJCWNoZGlyKHBhdGgpOw0KCQkJbGxfdXRpbWUoZmlsZXMpOw0KCQl9DQoJfQ0KCWdldHRpbWVv
ZmRheSAoJnN0b3AsIE5VTEwpOw0KCXVuc2V0X3NpZ2Fscm0oKTsNCg0KCXNlYyA9IChkb3VibGUp
KGVfdGltZShzdGFydCwgc3RvcCkpIC8gMTAwMDAwMC4wIC8gY29uZi5maWxlczsNCglwcmludGYo
InV0aW1lIDogJWxmIHNlYyAsIDEgZmlsZSB1dGltZSAgIGZvciAlbGYgc2VjXG4iLCAoZG91Ymxl
KShlX3RpbWUoc3RhcnQsIHN0b3ApKSAvIDEwMDAwMDAuMCwgc2VjKTsNCn0NCg0Kdm9pZCB1bmxp
bmtfb3AoY29uc3QgY2hhciAqZGlyZWN0cnkpDQp7DQoJaW50IGksIGZpbGVzLCBzdl9maWxlczsN
CgljaGFyIHBhdGhbUEFUSF9NQVggKyAxXTsNCglkb3VibGUgc2VjOw0KCXN0cnVjdCB0aW1ldmFs
IHN0YXJ0LCBzdG9wOw0KDQoJY29uZi5lbnRyeSA9IDA7DQoJY29uZi50b3RhbCA9IDA7DQoJc3Zf
ZmlsZXMgPSBjb25mLmZpbGVzOw0KCXNldF9zaWdhbHJtKCk7DQoJZ2V0dGltZW9mZGF5ICgmc3Rh
cnQsIE5VTEwpOw0KCWdldHRpbWVvZmRheSAoJmdfcnRpbWUsIE5VTEwpOw0KDQoJaWYgKGNvbmYu
ZGlyZWN0cnkgPT0gMCkgew0KCQlzbnByaW50ZihwYXRoLCBQQVRIX01BWCwgIiVzIiwgZGlyZWN0
cnkpOw0KCQljaGRpcihwYXRoKTsNCgkJbGxfdW5saW5rKHN2X2ZpbGVzKTsNCgl9IGVsc2Ugew0K
CQlmb3IgKGkgPSAwOyBpIDwgY29uZi5kaXJlY3RyeTsgaSsrKSB7DQoJCQlzdl9maWxlcyA+IGNv
bmYubWF4X2ZpbGVzID8gKGZpbGVzID0gY29uZi5tYXhfZmlsZXMpIDogKGZpbGVzID0gc3ZfZmls
ZXMpOw0KCQkJc3ZfZmlsZXMgLT0gY29uZi5tYXhfZmlsZXM7DQoJCQlzbnByaW50ZihwYXRoLCBQ
QVRIX01BWCwgIiVzLyVkIiwgZGlyZWN0cnksIGkpOw0KCQkJY2hkaXIocGF0aCk7DQoJCQlsbF91
bmxpbmsoZmlsZXMpOw0KCQl9DQoJfQ0KCWdldHRpbWVvZmRheSAoJnN0b3AsIE5VTEwpOw0KCXVu
c2V0X3NpZ2Fscm0oKTsNCg0KCXNlYyA9IChkb3VibGUpKGVfdGltZShzdGFydCwgc3RvcCkpIC8g
MTAwMDAwMC4wIC8gY29uZi5maWxlczsNCglwcmludGYoInVubGluazogJWxmIHNlYyAsIDEgZmls
ZSB1bmxpbmsgZm9yICVsZiBzZWNcbiIsIChkb3VibGUpKGVfdGltZShzdGFydCwgc3RvcCkpIC8g
MTAwMDAwMC4wLCBzZWMpOw0KfQ0KDQp2b2lkIG1rZGlyX29wKGNvbnN0IGNoYXIgKmRpcmVjdHJ5
KQ0Kew0KCWludCBzdl9maWxlczsNCgljaGFyIHBhdGhbUEFUSF9NQVggKyAxXTsNCglkb3VibGUg
c2VjOw0KCXN0cnVjdCB0aW1ldmFsIHN0YXJ0LCBzdG9wOw0KDQoJY29uZi5lbnRyeSA9IDA7DQoJ
Y29uZi50b3RhbCA9IDA7DQoJc3ZfZmlsZXMgPSBjb25mLmZpbGVzOw0KCXNldF9zaWdhbHJtKCk7
DQoJZ2V0dGltZW9mZGF5ICgmc3RhcnQsIE5VTEwpOw0KCWdldHRpbWVvZmRheSAoJmdfcnRpbWUs
IE5VTEwpOw0KDQoJc25wcmludGYocGF0aCwgUEFUSF9NQVgsICIlcyIsIGRpcmVjdHJ5KTsNCglj
aGRpcihwYXRoKTsNCglsbF9ta2RpcigpOw0KDQoJZ2V0dGltZW9mZGF5ICgmc3RvcCwgTlVMTCk7
DQoJdW5zZXRfc2lnYWxybSgpOw0KDQoJc2VjID0gKGRvdWJsZSkoZV90aW1lKHN0YXJ0LCBzdG9w
KSkgLyAxMDAwMDAwLjAgLyBjb25mLmZpbGVzOw0KCXByaW50ZigibWtkaXIgOiAlbGYgc2VjICwg
MSBmaWxlIG1rZGlyICBmb3IgJWxmIHNlY1xuIiwgKGRvdWJsZSkoZV90aW1lKHN0YXJ0LCBzdG9w
KSkgLyAxMDAwMDAwLjAsIHNlYyk7DQp9DQoNCnZvaWQgcm1kaXJfb3AoY29uc3QgY2hhciAqZGly
ZWN0cnkpDQp7DQoJaW50IHN2X2ZpbGVzOw0KCWNoYXIgcGF0aFtQQVRIX01BWCArIDFdOw0KCWRv
dWJsZSBzZWM7DQoJc3RydWN0IHRpbWV2YWwgc3RhcnQsIHN0b3A7DQoNCgljb25mLmVudHJ5ID0g
MDsNCgljb25mLnRvdGFsID0gMDsNCglzdl9maWxlcyA9IGNvbmYuZmlsZXM7DQoJc2V0X3NpZ2Fs
cm0oKTsNCglnZXR0aW1lb2ZkYXkgKCZzdGFydCwgTlVMTCk7DQoJZ2V0dGltZW9mZGF5ICgmZ19y
dGltZSwgTlVMTCk7DQoNCglzbnByaW50ZihwYXRoLCBQQVRIX01BWCwgIiVzIiwgZGlyZWN0cnkp
Ow0KCWNoZGlyKHBhdGgpOw0KCWxsX3JtZGlyKCk7DQoNCglnZXR0aW1lb2ZkYXkgKCZzdG9wLCBO
VUxMKTsNCgl1bnNldF9zaWdhbHJtKCk7DQoNCglzZWMgPSAoZG91YmxlKShlX3RpbWUoc3RhcnQs
IHN0b3ApKSAvIDEwMDAwMDAuMCAvIGNvbmYuZmlsZXM7DQoJcHJpbnRmKCJybWRpciA6ICVsZiBz
ZWMgLCAxIGZpbGUgcm1kaXIgIGZvciAlbGYgc2VjXG4iLCAoZG91YmxlKShlX3RpbWUoc3RhcnQs
IHN0b3ApKSAvIDEwMDAwMDAuMCwgc2VjKTsNCn0NCg0Kdm9pZCBwcmludCh2b2lkKQ0Kew0KCWlu
dCBpLCBqOw0KCXByaW50ZigiZmlsZSAgICAgICAgY3JlYXQgICAgICAgb3BlbiAgICAgICAgdXRp
bWUgICAgICAgc3RhdCAgICAgICAgdW5saW5rXG4iKTsNCglmb3IgKGkgPSAwOyBpIDwgS0VFUF9G
SUxFOyBpKyspIHsNCgkJcHJpbnRmKCIlMTAuMGxmICIsIHRhYmxlW2ldWzBdKTsNCgkJZm9yIChq
ID0gMTsgaiA8IENIRUNLX0VOVFJZOyBqKyspIHsNCgkJCXByaW50ZigiJTEwLjJsZiAiLCB0YWJs
ZVtpXVtqXSk7DQoJCX0NCgkJcHJpbnRmKCJcbiIpOw0KCX0NCn0NCg0KLyogbWFpbiAqLw0KaW50
IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkNCnsNCglpbnQgYywgaSwgajsNCgljaGFyIGRp
cmVjdHJ5W1BBVEhfTUFYICsgMV07DQoJY2hhciAqcmVhbHBhdGhfcHRyOw0KCXVuc2lnbmVkIGlu
dCBzdWJtaXQgPSBNS19BTEw7DQoNCglfX2xpbnV4ZnNfaW5pdCgpOw0KCXN0cm5jcHkoZGlyZWN0
cnksICIuL1wwIiwgUEFUSF9NQVgpOw0KDQoJZm9yIChpID0gMDsgaSA8IEtFRVBfRklMRTsgaSsr
KSB7DQoJCWZvciAoaiA9IDA7IGogPCBDSEVDS19FTlRSWTsgaisrKSB7DQoJCQl0YWJsZVtpXVtq
XSA9IDA7DQoJCX0NCgkJdGFibGVbaV1bMF0gPSAoZG91YmxlKSBpICogY29uZi5tb2RpczsNCgl9
DQoNCgl3aGlsZSAoKGMgPSBnZXRvcHQoYXJnYywgYXJndiwgImQ6Zjp4OnQ6bDp3Om1jb3N1cnAi
KSkgIT0gRU9GKSB7DQoJCXN3aXRjaCAoYykgew0KCQljYXNlICdkJzoNCgkJCXN0cm5jcHkoZGly
ZWN0cnksIG9wdGFyZywgUEFUSF9NQVgpOw0KCQkJYnJlYWs7DQoJCWNhc2UgJ2YnOg0KCQkJY29u
Zi5maWxlcyA9IGF0b2kob3B0YXJnKTsNCgkJCWlmIChjb25mLmZpbGVzIDwgMCkgew0KCQkJCUJl
cnJvcihFSU5WQUwpOw0KCQkJfQ0KCQkJYnJlYWs7DQoJCWNhc2UgJ3gnOg0KCQkJY29uZi5tYXhf
ZmlsZXMgPSBhdG9pKG9wdGFyZyk7DQoJCQlpZiAoY29uZi5tYXhfZmlsZXMgPCAwKSB7DQoJCQkJ
QmVycm9yKEVJTlZBTCk7DQoJCQl9DQoJCQlicmVhazsNCgkJY2FzZSAndCc6DQoJCQljb25mLnRp
bWVfb3V0ID0gYXRvaShvcHRhcmcpOw0KCQkJaWYgKGNvbmYudGltZV9vdXQgPCAwKSB7DQoJCQkJ
QmVycm9yKEVJTlZBTCk7DQoJCQl9DQoJCQlicmVhazsNCgkJY2FzZSAnbCc6DQoJCQljb25mLmxv
b3BzID0gYXRvaShvcHRhcmcpOw0KCQkJaWYgKGNvbmYubG9vcHMgPCAwKSB7DQoJCQkJQmVycm9y
KEVJTlZBTCk7DQoJCQl9DQoJCQlicmVhazsNCgkJY2FzZSAndyc6DQoJCQljb25mLndfc2l6ZSA9
IGF0b2kob3B0YXJnKTsNCgkJCWlmIChjb25mLndfc2l6ZSA8IDApIHsNCgkJCQlCZXJyb3IoRUlO
VkFMKTsNCgkJCX0NCgkJCXdfYnVmID0gKGNoYXIgKiltYWxsb2MoY29uZi53X3NpemUpOw0KCQkJ
aWYgKCF3X2J1Zikgew0KCQkJCUJlcnJvcihlcnJubyk7DQoJCQl9DQoJCQlicmVhazsNCgkJY2Fz
ZSAnbSc6DQoJCQlzdWJtaXQgfD0gTUtfTUtESVI7DQoJCQlicmVhazsNCgkJY2FzZSAnYyc6DQoJ
CQlzdWJtaXQgfD0gTUtfQ1JFQVRFOw0KCQkJYnJlYWs7DQoJCWNhc2UgJ28nOg0KCQkJc3VibWl0
IHw9IE1LX09QRU47DQoJCQlicmVhazsNCgkJY2FzZSAncCc6DQoJCQlzdWJtaXQgfD0gTUtfVVRJ
TUU7DQoJCQlicmVhazsNCgkJY2FzZSAncyc6DQoJCQlzdWJtaXQgfD0gTUtfU1RBVDsNCgkJCWJy
ZWFrOw0KCQljYXNlICd1JzoNCgkJCXN1Ym1pdCB8PSBNS19VTkxJTks7DQoJCQlicmVhazsNCgkJ
Y2FzZSAncic6DQoJCQlzdWJtaXQgfD0gTUtfUk1ESVI7DQoJCQlicmVhazsNCgkJZGVmYXVsdDoN
CgkJCUJmb3JtKCk7DQoJCX0NCgl9DQoNCglpZiAoY29uZi5tYXhfZmlsZXMgPiAwKSB7DQoJCWNv
bmYuZGlyZWN0cnkgPSBjb25mLmZpbGVzIC8gY29uZi5tYXhfZmlsZXM7DQoJCWNvbmYubW9kaXMg
PSBjb25mLmZpbGVzIC8gS0VFUF9GSUxFOw0KCX0gZWxzZSB7DQoJCUJlcnJvcihFSU5WQUwpOw0K
CX0NCg0KCWZvciAoaSA9IDA7IGkgPCBLRUVQX0ZJTEU7IGkrKykgew0KCQlmb3IgKGogPSAwOyBq
IDwgQ0hFQ0tfRU5UUlk7IGorKykgew0KCQkJdGFibGVbaV1bal0gPSAwOw0KCQl9DQoJCXRhYmxl
W2ldWzBdID0gKGRvdWJsZSkgKGkgKyAxKSAqIGNvbmYubW9kaXM7DQoJfQ0KDQoJcmVhbHBhdGhf
cHRyID0gcmVhbHBhdGgoZGlyZWN0cnksIE5VTEwpOw0KCWlmIChyZWFscGF0aF9wdHIgPT0gTlVM
TCkgew0KCQlCZXJyb3IoZXJybm8pOw0KCX0NCg0KCXByaW50ZigibWtmYm10ICVkIGRpcmVjdHJ5
ICVkIGZpbGVzICwgb25lIGRpcmVjdHJ5ICUiUFJJdTY0IiBmaWxlc1xuIiwNCgkJY29uZi5kaXJl
Y3RyeSwgY29uZi5maWxlcywgY29uZi5tYXhfZmlsZXMpOw0KCXByaW50ZigibWFrZSBmaWxlcyBm
b3IgJXNcblxuIiwgcmVhbHBhdGhfcHRyKTsNCg0KCWZvciAoaSA9IDA7IGkgPCBjb25mLmxvb3Bz
OyBpKyspIHsNCgkJaWYgKHN1Ym1pdCA9PSBNS19BTEwgfHwgc3VibWl0ICYgTUtfTUtESVIpIHsN
CgkJCW1rZGlyX29wKHJlYWxwYXRoX3B0cik7DQoJCX0NCgkJaWYgKHN1Ym1pdCA9PSBNS19BTEwg
fHwgc3VibWl0ICYgTUtfQ1JFQVRFKSB7DQoJCQljcmVhdF9vcChyZWFscGF0aF9wdHIpOw0KCQl9
DQoJCWlmIChzdWJtaXQgPT0gTUtfQUxMIHx8IHN1Ym1pdCAmIE1LX09QRU4pIHsNCgkJCW9wZW5f
b3AocmVhbHBhdGhfcHRyKTsNCgkJfQ0KCQlpZiAoc3VibWl0ID09IE1LX0FMTCB8fCBzdWJtaXQg
JiBNS19VVElNRSkgew0KCQkJdXRpbWVfb3AocmVhbHBhdGhfcHRyKTsNCgkJfQ0KCQlpZiAoc3Vi
bWl0ID09IE1LX0FMTCB8fCBzdWJtaXQgJiBNS19TVEFUKSB7DQoJCQlzdGF0X29wKHJlYWxwYXRo
X3B0cik7DQoJCX0NCgkJaWYgKHN1Ym1pdCA9PSBNS19BTEwgfHwgc3VibWl0ICYgTUtfVU5MSU5L
KSB7DQoJCQl1bmxpbmtfb3AocmVhbHBhdGhfcHRyKTsNCgkJfQ0KCQlpZiAoc3VibWl0ID09IE1L
X0FMTCB8fCBzdWJtaXQgJiBNS19STURJUikgew0KCQkJcm1kaXJfb3AocmVhbHBhdGhfcHRyKTsN
CgkJfQ0KCQlwcmludCgpOw0KCX0NCglyZXR1cm4gMDsNCn0NCg==

--Multipart=_Thu__19_Feb_2009_17_45_54_+0900_T0q2AAeFF9ljf9TJ--
