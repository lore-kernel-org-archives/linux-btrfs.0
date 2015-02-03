Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from edge-mail.mpi-dortmund.mpg.de ([141.5.144.14]:27641 "EHLO
	smtp.mpi-dortmund.mpg.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752418AbbBCIBg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Feb 2015 03:01:36 -0500
Message-ID: <54D07FEA.4090700@mpi-dortmund.mpg.de>
Date: Tue, 3 Feb 2015 08:59:38 +0100
From: Alexander Fieroch <alexander.fieroch@mpi-dortmund.mpg.de>
MIME-Version: 1.0
To: Tobias Holst <tobby@tobby.eu>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Duncan <1i5t5.duncan@cox.net>
Subject: Re: how to repair a damaged filesystem with btrfs raid5
References: <54C75683.80903@mpi-dortmund.mpg.de> <CAGwxe4gjxwb5OsSLHqqC5kPzKK1_ERz0_rKHL2Eu+o4CgoBFHA@mail.gmail.com>
In-Reply-To: <CAGwxe4gjxwb5OsSLHqqC5kPzKK1_ERz0_rKHL2Eu+o4CgoBFHA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="------------ms010201020400040101090205"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------ms010201020400040101090205
Content-Type: multipart/mixed;
 boundary="------------060305080203070600010005"

This is a multi-part message in MIME format.
--------------060305080203070600010005
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 03.02.2015 um 01:24 schrieb Tobias Holst:
> Hi.

Hi,

> There is a known bug when you re-plug in a missing hdd of a btrfs raid
> without wiping the device before. In worst case this results in a
> totally corrupted filesystem as it did sometimes during my tests of
> the raid6 implementation. With raid1 it may just "go back in time" to
> the point when you unplugged the device. Which is also bad but still
> no complete data loss - but in raid6 sometimes it was worse.
>=20
> Sounds like you did that (plug in the missing device without wiping)?

yes I just unplugged the device for a few seconds and re-plugged it in ag=
ain.

>=20
> Next thing is, that scrub and filesystem-check of raid5/6 is not
> implemented/completed (yet) as Duncan said. It will be (mostly)
> included in 3.19, but maybe with bugs.

Unfortunately a filesystem check is still not working with kernel 3.19rc6=
 and btrfs 3.18.1:

# btrfs check --repair /dev/mapper/crypt-3=20
enabling repair mode
Checking filesystem on /dev/mapper/crypt-3
UUID: 504c2850-3977-4340-8849-18dd3ac2e5e4
checking extents
Check tree block failed, want=3D165396480, have=3D5385177728513973313
Check tree block failed, want=3D165396480, have=3D5385177728513973313
Check tree block failed, want=3D165396480, have=3D65536
Check tree block failed, want=3D165396480, have=3D5385177728513973313
Check tree block failed, want=3D165396480, have=3D5385177728513973313
read block failed check_tree_block
Check tree block failed, want=3D165740544, have=3D6895225932619678086
Check tree block failed, want=3D165740544, have=3D6895225932619678086
Check tree block failed, want=3D165740544, have=3D65536
Check tree block failed, want=3D165740544, have=3D6895225932619678086
Check tree block failed, want=3D165740544, have=3D6895225932619678086
read block failed check_tree_block
Check tree block failed, want=3D165756928, have=3D13399486021073017810
Check tree block failed, want=3D165756928, have=3D13399486021073017810
Check tree block failed, want=3D165756928, have=3D65536
Check tree block failed, want=3D165756928, have=3D13399486021073017810
Check tree block failed, want=3D165756928, have=3D13399486021073017810
read block failed check_tree_block
Check tree block failed, want=3D165773312, have=3D12571697019259051064
Check tree block failed, want=3D165773312, have=3D12571697019259051064
Check tree block failed, want=3D165773312, have=3D65536
Check tree block failed, want=3D165773312, have=3D12571697019259051064
Check tree block failed, want=3D165773312, have=3D12571697019259051064
read block failed check_tree_block
Check tree block failed, want=3D165789696, have=3D4069002570438424782
Check tree block failed, want=3D165789696, have=3D4069002570438424782
Check tree block failed, want=3D165789696, have=3D65536
Check tree block failed, want=3D165789696, have=3D4069002570438424782
Check tree block failed, want=3D165789696, have=3D4069002570438424782
read block failed check_tree_block
Check tree block failed, want=3D165838848, have=3D9612508092910615774
Check tree block failed, want=3D165838848, have=3D9612508092910615774
Check tree block failed, want=3D165838848, have=3D65536
Check tree block failed, want=3D165838848, have=3D9612508092910615774
Check tree block failed, want=3D165838848, have=3D9612508092910615774
read block failed check_tree_block
ref mismatch on [99516416 16384] extent item 1, found 0
failed to repair damaged filesystem, aborting

> You may try to do a balance instead of a scrub as this should read and
> check your data and then write it back. This worked for me most of the
> time during my personal raid6 stability and stress tests.

I tried a balance and got a btrfs error trace in syslog as well as severa=
l sata errors (complete syslog is attached):

[ 1835.914430] ------------[ cut here ]------------
[ 1835.914468] WARNING: CPU: 3 PID: 15995 at /home/kernel/COD/linux/fs/bt=
rfs/inode.c:923 cow_file_range+0x44c/0x460 [btrfs]()
[ 1835.914470] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos j=
fs xfs libcrc32c snd_hda_codec_analog snd_hda_codec_generic snd_hda_intel=
 coretemp ppdev snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_ti=
mer kvm_intel kvm snd soundcore dcdbas mei_me mei serio_raw mac_hid parpo=
rt_pc lpc_ich 8250_fintek shpchp parport btrfs xor raid6_pq xts gf128mul =
dm_crypt amdkfd amd_iommu_v2 radeon hid_generic i2c_algo_bit e1000e ttm u=
as drm_kms_helper usbhid ahci sata_sil usb_storage psmouse ptp hid libahc=
i drm pps_core pata_acpi
[ 1835.914511] CPU: 3 PID: 15995 Comm: btrfs Not tainted 3.19.0-031900rc6=
-generic #201501261152
[ 1835.914513] Hardware name: Dell Inc. OptiPlex 755                 /0GM=
819, BIOS A22 06/11/2012
[ 1835.914514]  000000000000039b ffff8800a784b2f8 ffffffff817c4584 000000=
0000000007
[ 1835.914517]  0000000000000000 ffff8800a784b338 ffffffff81076df7 000000=
0000000004
[ 1835.914520]  00000000ffffffea ffff8800b056c6d0 0000000000000000 000000=
0000080000
[ 1835.914523] Call Trace:
[ 1835.914530]  [<ffffffff817c4584>] dump_stack+0x45/0x57
[ 1835.914535]  [<ffffffff81076df7>] warn_slowpath_common+0x97/0xe0
[ 1835.914538]  [<ffffffff81076e5a>] warn_slowpath_null+0x1a/0x20
[ 1835.914554]  [<ffffffffc073e5ec>] cow_file_range+0x44c/0x460 [btrfs]
[ 1835.914572]  [<ffffffffc0758d35>] ? free_extent_buffer+0x35/0x40 [btrf=
s]
[ 1835.914588]  [<ffffffffc073ea9b>] run_delalloc_nocow+0x49b/0xae0 [btrf=
s]
[ 1835.914605]  [<ffffffffc073f26e>] run_delalloc_range+0x18e/0x1b0 [btrf=
s]
[ 1835.914622]  [<ffffffffc07550a4>] writepage_delalloc.isra.33+0xf4/0x17=
0 [btrfs]
[ 1835.914639]  [<ffffffffc07576ff>] __extent_writepage+0xcf/0x280 [btrfs=
]
[ 1835.914643]  [<ffffffff811b6f70>] ? SyS_msync+0x230/0x230
[ 1835.914661]  [<ffffffffc0757b6a>] extent_write_cache_pages.isra.26.con=
stprop.39+0x2ba/0x420 [btrfs]
[ 1835.914679]  [<ffffffffc07581ce>] extent_writepages+0x4e/0x70 [btrfs]
[ 1835.914694]  [<ffffffffc073c400>] ? btrfs_submit_direct+0x1b0/0x1b0 [b=
trfs]
[ 1835.914710]  [<ffffffffc0738758>] btrfs_writepages+0x28/0x30 [btrfs]
[ 1835.914714]  [<ffffffff81188a00>] do_writepages+0x20/0x40
[ 1835.914717]  [<ffffffff8117dd99>] __filemap_fdatawrite_range+0x59/0x60=

[ 1835.914719]  [<ffffffff8117e5c3>] filemap_fdatawrite_range+0x13/0x20
[ 1835.914735]  [<ffffffffc074bedb>] btrfs_fdatawrite_range+0x2b/0x70 [bt=
rfs]
[ 1835.914753]  [<ffffffffc07517ac>] btrfs_wait_ordered_range+0x4c/0x150 =
[btrfs]
[ 1835.914770]  [<ffffffffc077c70c>] __btrfs_write_out_cache+0x39c/0x4b0 =
[btrfs]
[ 1835.914788]  [<ffffffffc077cb5f>] btrfs_write_out_cache+0x9f/0x100 [bt=
rfs]
[ 1835.914802]  [<ffffffffc0725492>] btrfs_write_dirty_block_groups+0x252=
/0x290 [btrfs]
[ 1835.914817]  [<ffffffffc07af4ad>] update_cowonly_root+0x42/0xa8 [btrfs=
]
[ 1835.914832]  [<ffffffffc07af666>] commit_cowonly_roots+0x153/0x1b5 [bt=
rfs]
[ 1835.914847]  [<ffffffffc073625d>] btrfs_commit_transaction+0x4bd/0xa70=
 [btrfs]
[ 1835.914865]  [<ffffffffc078a6d5>] prepare_to_merge+0x1f5/0x230 [btrfs]=

[ 1835.914882]  [<ffffffffc078a9fa>] relocate_block_group+0x2ea/0x510 [bt=
rfs]
[ 1835.914899]  [<ffffffffc078add0>] btrfs_relocate_block_group+0x1b0/0x2=
d0 [btrfs]
[ 1835.914917]  [<ffffffffc0760b1b>] btrfs_relocate_chunk.isra.75+0x4b/0x=
d0 [btrfs]
[ 1835.914934]  [<ffffffffc0761f58>] __btrfs_balance+0x348/0x460 [btrfs]
[ 1835.914951]  [<ffffffffc0762425>] btrfs_balance+0x3b5/0x5d0 [btrfs]
[ 1835.914969]  [<ffffffffc076e36c>] btrfs_ioctl_balance+0x1cc/0x530 [btr=
fs]
[ 1835.914986]  [<ffffffffc077033e>] btrfs_ioctl+0x69e/0xb20 [btrfs]
[ 1835.914989]  [<ffffffff811b3848>] ? do_brk+0x258/0x330
[ 1835.914993]  [<ffffffff81207475>] do_vfs_ioctl+0x75/0x320
[ 1835.914996]  [<ffffffff812077b1>] SyS_ioctl+0x91/0xb0
[ 1835.915000]  [<ffffffff817d18ad>] system_call_fastpath+0x16/0x1b
[ 1835.915002] ---[ end trace 42ee65a1e517ce93 ]---

After this I cannot umount the filesystem anymore. I get new errors in sy=
slog:

[ 3000.196039] INFO: task kworker/u16:0:15873 blocked for more than 120 s=
econds.
[ 3000.198122]       Tainted: G        W      3.19.0-031900rc6-generic #2=
01501261152
[ 3000.200199] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[ 3000.202298] kworker/u16:0   D ffff880213cbbcc8     0 15873      2 0x00=
000000
[ 3000.202341] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helpe=
r [btrfs]
[ 3000.202344]  ffff880213cbbcc8 ffff880213cbbc78 ffff880213cbbfd8 000000=
00000141c0
[ 3000.202349]  ffff8800b98e3100 ffff88022992e220 ffff880214f744b0 ffff88=
0213cbbcd8
[ 3000.202353]  ffff8801f0c6b850 ffff8801f0c6b8d8 0000000000000000 ffff88=
00365f9df0
[ 3000.202357] Call Trace:
[ 3000.202366]  [<ffffffff817cd6b9>] schedule+0x29/0x70
[ 3000.202392]  [<ffffffffc0751305>] btrfs_start_ordered_extent+0x115/0x1=
40 [btrfs]
[ 3000.202399]  [<ffffffff810a068c>] ? ttwu_do_wakeup+0x2c/0x100
[ 3000.202403]  [<ffffffff810b7440>] ? prepare_to_wait_event+0x100/0x100
[ 3000.202429]  [<ffffffffc0751359>] btrfs_run_ordered_extent_work+0x29/0=
x40 [btrfs]
[ 3000.202455]  [<ffffffffc076720e>] normal_work_helper+0x7e/0x1b0 [btrfs=
]
[ 3000.202481]  [<ffffffffc0767392>] btrfs_flush_delalloc_helper+0x12/0x2=
0 [btrfs]
[ 3000.202486]  [<ffffffff8108f6dd>] process_one_work+0x14d/0x460
[ 3000.202490]  [<ffffffff810900bb>] worker_thread+0x11b/0x3f0
[ 3000.202495]  [<ffffffff8108ffa0>] ? create_worker+0x1e0/0x1e0
[ 3000.202499]  [<ffffffff81095cc9>] kthread+0xc9/0xe0
[ 3000.202503]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.202508]  [<ffffffff817d17fc>] ret_from_fork+0x7c/0xb0
[ 3000.202512]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.202516] INFO: task kworker/u16:2:15945 blocked for more than 120 s=
econds.
[ 3000.204622]       Tainted: G        W      3.19.0-031900rc6-generic #2=
01501261152
[ 3000.206720] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[ 3000.208825] kworker/u16:2   D ffff8800adf13cc8     0 15945      2 0x00=
000000
[ 3000.208856] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helpe=
r [btrfs]
[ 3000.208859]  ffff8800adf13cc8 ffff8800adf13c78 ffff8800adf13fd8 000000=
00000141c0
[ 3000.208863]  ffff8800b98e3100 ffff8800bad88000 ffff880229929d70 ffff88=
00adf13cd8
[ 3000.208867]  ffff8801f0c6b9f8 ffff8801f0c6ba80 0000000000000000 ffff88=
00365f9df0
[ 3000.208871] Call Trace:
[ 3000.208876]  [<ffffffff817cd6b9>] schedule+0x29/0x70
[ 3000.208901]  [<ffffffffc0751305>] btrfs_start_ordered_extent+0x115/0x1=
40 [btrfs]
[ 3000.208914]  [<ffffffff810a068c>] ? ttwu_do_wakeup+0x2c/0x100
[ 3000.208920]  [<ffffffff810b7440>] ? prepare_to_wait_event+0x100/0x100
[ 3000.208945]  [<ffffffffc0751359>] btrfs_run_ordered_extent_work+0x29/0=
x40 [btrfs]
[ 3000.208971]  [<ffffffffc076720e>] normal_work_helper+0x7e/0x1b0 [btrfs=
]
[ 3000.208996]  [<ffffffffc0767392>] btrfs_flush_delalloc_helper+0x12/0x2=
0 [btrfs]
[ 3000.209001]  [<ffffffff8108f6dd>] process_one_work+0x14d/0x460
[ 3000.209005]  [<ffffffff810900bb>] worker_thread+0x11b/0x3f0
[ 3000.209009]  [<ffffffff8108ffa0>] ? create_worker+0x1e0/0x1e0
[ 3000.209013]  [<ffffffff81095cc9>] kthread+0xc9/0xe0
[ 3000.209017]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.209022]  [<ffffffff817d17fc>] ret_from_fork+0x7c/0xb0
[ 3000.209026]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.209029] INFO: task kworker/u16:6:15951 blocked for more than 120 s=
econds.
[ 3000.211143]       Tainted: G        W      3.19.0-031900rc6-generic #2=
01501261152
[ 3000.213270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[ 3000.215403] kworker/u16:6   D ffff8800acdcbcc8     0 15951      2 0x00=
000000
[ 3000.215431] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helpe=
r [btrfs]
[ 3000.215434]  ffff8800acdcbcc8 ffff8800acdcbc78 ffff8800acdcbfd8 000000=
00000141c0
[ 3000.215438]  ffff8800b98e3100 ffff880214f744b0 ffff8800bad8e220 ffff88=
00acdcbcd8
[ 3000.215442]  ffff88009b6d6470 ffff88009b6d64f8 0000000000000000 ffff88=
00365f9df0
[ 3000.215446] Call Trace:
[ 3000.215450]  [<ffffffff817cd6b9>] schedule+0x29/0x70
[ 3000.215475]  [<ffffffffc0751305>] btrfs_start_ordered_extent+0x115/0x1=
40 [btrfs]
[ 3000.215480]  [<ffffffff810a068c>] ? ttwu_do_wakeup+0x2c/0x100
[ 3000.215484]  [<ffffffff810b7440>] ? prepare_to_wait_event+0x100/0x100
[ 3000.215509]  [<ffffffffc0751359>] btrfs_run_ordered_extent_work+0x29/0=
x40 [btrfs]
[ 3000.215534]  [<ffffffffc076720e>] normal_work_helper+0x7e/0x1b0 [btrfs=
]
[ 3000.215560]  [<ffffffffc0767392>] btrfs_flush_delalloc_helper+0x12/0x2=
0 [btrfs]
[ 3000.215564]  [<ffffffff8108f6dd>] process_one_work+0x14d/0x460
[ 3000.215569]  [<ffffffff810900bb>] worker_thread+0x11b/0x3f0
[ 3000.215573]  [<ffffffff8108ffa0>] ? create_worker+0x1e0/0x1e0
[ 3000.215577]  [<ffffffff81095cc9>] kthread+0xc9/0xe0
[ 3000.215581]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.215586]  [<ffffffff817d17fc>] ret_from_fork+0x7c/0xb0
[ 3000.215590]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.215593] INFO: task kworker/u16:7:15952 blocked for more than 120 s=
econds.
[ 3000.217734]       Tainted: G        W      3.19.0-031900rc6-generic #2=
01501261152
[ 3000.219857] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[ 3000.221989] kworker/u16:7   D ffff8800997bfcc8     0 15952      2 0x00=
000000
[ 3000.222019] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helpe=
r [btrfs]
[ 3000.222021]  ffff8800997bfcc8 ffff8800997bfc78 ffff8800997bffd8 000000=
00000141c0
[ 3000.222025]  ffff8800b98e3100 ffff880229929d70 ffff88022992e220 ffff88=
00997bfcd8
[ 3000.222029]  ffff8801f0c6bd48 ffff8801f0c6bdd0 0000000000000000 ffff88=
00365f9df0
[ 3000.222033] Call Trace:
[ 3000.222038]  [<ffffffff817cd6b9>] schedule+0x29/0x70
[ 3000.222070]  [<ffffffffc0751305>] btrfs_start_ordered_extent+0x115/0x1=
40 [btrfs]
[ 3000.222076]  [<ffffffff810a068c>] ? ttwu_do_wakeup+0x2c/0x100
[ 3000.222079]  [<ffffffff810b7440>] ? prepare_to_wait_event+0x100/0x100
[ 3000.222105]  [<ffffffffc0751359>] btrfs_run_ordered_extent_work+0x29/0=
x40 [btrfs]
[ 3000.222130]  [<ffffffffc076720e>] normal_work_helper+0x7e/0x1b0 [btrfs=
]
[ 3000.222156]  [<ffffffffc0767392>] btrfs_flush_delalloc_helper+0x12/0x2=
0 [btrfs]
[ 3000.222160]  [<ffffffff8108f6dd>] process_one_work+0x14d/0x460
[ 3000.222164]  [<ffffffff810900bb>] worker_thread+0x11b/0x3f0
[ 3000.222169]  [<ffffffff8108ffa0>] ? create_worker+0x1e0/0x1e0
[ 3000.222172]  [<ffffffff81095cc9>] kthread+0xc9/0xe0
[ 3000.222177]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.222181]  [<ffffffff817d17fc>] ret_from_fork+0x7c/0xb0
[ 3000.222185]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.222191] INFO: task kworker/u16:1:16059 blocked for more than 120 s=
econds.
[ 3000.224322]       Tainted: G        W      3.19.0-031900rc6-generic #2=
01501261152
[ 3000.226463] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[ 3000.228612] kworker/u16:1   D ffff8801c903fcc8     0 16059      2 0x00=
000000
[ 3000.228643] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helpe=
r [btrfs]
[ 3000.228646]  ffff8801c903fcc8 ffff8801c903fc78 ffff8801c903ffd8 000000=
00000141c0
[ 3000.228650]  ffff8800b98e3100 ffff88022d253110 ffff8800bad88000 ffff88=
01c903fcd8
[ 3000.228654]  ffff8801f0c6bba0 ffff8801f0c6bc28 0000000000000000 ffff88=
00365f9df0
[ 3000.228658] Call Trace:
[ 3000.228663]  [<ffffffff817cd6b9>] schedule+0x29/0x70
[ 3000.228688]  [<ffffffffc0751305>] btrfs_start_ordered_extent+0x115/0x1=
40 [btrfs]
[ 3000.228692]  [<ffffffff810a068c>] ? ttwu_do_wakeup+0x2c/0x100
[ 3000.228696]  [<ffffffff810b7440>] ? prepare_to_wait_event+0x100/0x100
[ 3000.228721]  [<ffffffffc0751359>] btrfs_run_ordered_extent_work+0x29/0=
x40 [btrfs]
[ 3000.228754]  [<ffffffffc076720e>] normal_work_helper+0x7e/0x1b0 [btrfs=
]
[ 3000.228784]  [<ffffffffc0767392>] btrfs_flush_delalloc_helper+0x12/0x2=
0 [btrfs]
[ 3000.228789]  [<ffffffff8108f6dd>] process_one_work+0x14d/0x460
[ 3000.228793]  [<ffffffff810900bb>] worker_thread+0x11b/0x3f0
[ 3000.228797]  [<ffffffff8108ffa0>] ? create_worker+0x1e0/0x1e0
[ 3000.228801]  [<ffffffff81095cc9>] kthread+0xc9/0xe0
[ 3000.228805]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.228810]  [<ffffffff817d17fc>] ret_from_fork+0x7c/0xb0
[ 3000.228814]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.228818] INFO: task kworker/u16:3:16076 blocked for more than 120 s=
econds.
[ 3000.230960]       Tainted: G        W      3.19.0-031900rc6-generic #2=
01501261152
[ 3000.233105] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[ 3000.235269] kworker/u16:3   D ffff8801d48d7cc8     0 16076      2 0x00=
000000
[ 3000.235297] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helpe=
r [btrfs]
[ 3000.235299]  ffff8801d48d7cc8 ffff8801d48d7c78 ffff8801d48d7fd8 000000=
00000141c0
[ 3000.235303]  ffff8800b98e3100 ffff88022e6209d0 ffff88022d253110 ffff88=
01d48d7cd8
[ 3000.235307]  ffff8801f0c6b500 ffff8801f0c6b588 0000000000000000 ffff88=
00365f9df0
[ 3000.235311] Call Trace:
[ 3000.235316]  [<ffffffff817cd6b9>] schedule+0x29/0x70
[ 3000.235341]  [<ffffffffc0751305>] btrfs_start_ordered_extent+0x115/0x1=
40 [btrfs]
[ 3000.235346]  [<ffffffff810a4007>] ? wake_up_process+0x27/0x50
[ 3000.235350]  [<ffffffff810b7440>] ? prepare_to_wait_event+0x100/0x100
[ 3000.235375]  [<ffffffffc0751359>] btrfs_run_ordered_extent_work+0x29/0=
x40 [btrfs]
[ 3000.235401]  [<ffffffffc07672d2>] normal_work_helper+0x142/0x1b0 [btrf=
s]
[ 3000.235426]  [<ffffffffc0767392>] btrfs_flush_delalloc_helper+0x12/0x2=
0 [btrfs]
[ 3000.235431]  [<ffffffff8108f6dd>] process_one_work+0x14d/0x460
[ 3000.235435]  [<ffffffff810900bb>] worker_thread+0x11b/0x3f0
[ 3000.235439]  [<ffffffff8108ffa0>] ? create_worker+0x1e0/0x1e0
[ 3000.235443]  [<ffffffff81095cc9>] kthread+0xc9/0xe0
[ 3000.235447]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.235452]  [<ffffffff817d17fc>] ret_from_fork+0x7c/0xb0
[ 3000.235456]  [<ffffffff81095c00>] ? flush_kthread_worker+0x90/0x90
[ 3000.235459] INFO: task umount:16078 blocked for more than 120 seconds.=

[ 3000.237630]       Tainted: G        W      3.19.0-031900rc6-generic #2=
01501261152
[ 3000.239788] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[ 3000.241955] umount          D ffff8801beac3b58     0 16078   1623 0x00=
000000
[ 3000.241962]  ffff8801beac3b58 ffff8801beac3b28 ffff8801beac3fd8 000000=
00000141c0
[ 3000.241966]  ffff8800b98e3100 ffff88022e620000 ffff88022d2513a0 ffff88=
01beac3b48
[ 3000.241970]  ffff88009b6d6590 7fffffffffffffff 7fffffffffffffff ffff88=
022d2513a0
[ 3000.241974] Call Trace:
[ 3000.241979]  [<ffffffff817cd6b9>] schedule+0x29/0x70
[ 3000.241983]  [<ffffffff817d0445>] schedule_timeout+0x1b5/0x210
[ 3000.241987]  [<ffffffff810a4007>] ? wake_up_process+0x27/0x50
[ 3000.241991]  [<ffffffff817cebc7>] wait_for_completion+0xa7/0x160
[ 3000.241996]  [<ffffffff810a3fa0>] ? try_to_wake_up+0x2a0/0x2a0
[ 3000.242021]  [<ffffffffc0750fca>] btrfs_wait_ordered_extents+0x20a/0x2=
50 [btrfs]
[ 3000.242055]  [<ffffffffc0751138>] btrfs_wait_ordered_roots+0x128/0x1e0=
 [btrfs]
[ 3000.242076]  [<ffffffffc0703e91>] btrfs_sync_fs+0x51/0x150 [btrfs]
[ 3000.242082]  [<ffffffff81224e70>] __sync_filesystem+0x30/0x60
[ 3000.242086]  [<ffffffff81224f1b>] sync_filesystem+0x4b/0x70
[ 3000.242091]  [<ffffffff811f6dcb>] generic_shutdown_super+0x3b/0x110
[ 3000.242096]  [<ffffffff8118d88d>] ? unregister_shrinker+0x5d/0x70
[ 3000.242100]  [<ffffffff811f6f36>] kill_anon_super+0x16/0x30
[ 3000.242118]  [<ffffffffc070710e>] btrfs_kill_super+0x1e/0x130 [btrfs]
[ 3000.242123]  [<ffffffff811f7129>] deactivate_locked_super+0x59/0x80
[ 3000.242127]  [<ffffffff811f7dee>] deactivate_super+0x4e/0x70
[ 3000.242132]  [<ffffffff812138d3>] cleanup_mnt+0x43/0x90
[ 3000.242136]  [<ffffffff81213972>] __cleanup_mnt+0x12/0x20
[ 3000.242139]  [<ffffffff81093dff>] task_work_run+0xaf/0xf0
[ 3000.242145]  [<ffffffff81015077>] do_notify_resume+0xc7/0xd0
[ 3000.242149]  [<ffffffff817d1b4f>] int_signal+0x12/0x17

After a reboot the filesystem is still damaged, not repairable with a fil=
esystem check but accessible.

> But maybe
> your filesystem has already been corrupted...
> Give it a try :)

Yea, no problem. It's just to test the current stability of raid5 and may=
be to find bugs for you developers.

Regards,
Alexander

> Regards
> Tobias


--------------060305080203070600010005
Content-Type: application/gzip;
 name="dmesg.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.log.gz"

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
BNnQMftf0gGUao11AQA=
--------------060305080203070600010005--

--------------ms010201020400040101090205
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPaTCC
BNUwggO9oAMCAQICCFBOxvU9EbRkMA0GCSqGSIb3DQEBCwUAMHExCzAJBgNVBAYTAkRFMRww
GgYDVQQKExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3Qg
Q2VudGVyMSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0xNDA3MjIx
MjA4MjZaFw0xOTA3MDkyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVy
ZWluMRAwDgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwg
LSBHMDEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9
YuluTO2U1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2Q
RdDtoAB6fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/B
CaL2a869080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7Pb
D8URwoqDoZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs
6qcLmPkhnSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjggGGMIIBgjAOBgNVHQ8BAf8EBAMCAQYw
HQYDVR0OBBYEFEm3xs/oPR9/6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJ
ei0XbAqzK50zMBIGA1UdEwEB/wQIMAYBAf8CAQIwYgYDVR0gBFswWTARBg8rBgEEAYGtIYIs
AQEEAgIwEQYPKwYBBAGBrSGCLAEBBAMAMBEGDysGAQQBga0hgiwBAQQDATAPBg0rBgEEAYGt
IYIsAQEEMA0GCysGAQQBga0hgiweMD4GA1UdHwQ3MDUwM6AxoC+GLWh0dHA6Ly9wa2kwMzM2
LnRlbGVzZWMuZGUvcmwvRFRfUk9PVF9DQV8yLmNybDB4BggrBgEFBQcBAQRsMGowLAYIKwYB
BQUHMAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMDoGCCsGAQUFBzAChi5o
dHRwOi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9EVF9ST09UX0NBXzIuY2VyMA0GCSqGSIb3
DQEBCwUAA4IBAQBjICj9nCGGcr45Rlk5MiW8qQGbDczKfUGchm0KbiyzE1l1sTOSG2EnFv/D
stU1gvuEKgFJvWa7Zi+ywgZdbj9u4wFaW8pDY1yVtuExpx/VB19N5mWCTjL5w3x6S81NXHTu
IfJ1AuxSPtLJatOQI25JZzW+f01WpOzML8+3oZeocj7JvEDWWqQIPda8gsO3tzKOsSyOam23
NQIZz/U5RFhjpyQAELC7/E6vbi84u6VXST/YblBvLJeW3B1GmmWJz67M8uXZn1OzPqEvkqnY
C8aEHwTG6x7on321e6UC8STFJGMRNMxakyAqeYg6JUKQqWU7fIbTEhUjKfws2sw5W1QXMIIF
NTCCBB2gAwIBAgIHF6QkimvBUDANBgkqhkiG9w0BAQsFADBaMQswCQYDVQQGEwJERTETMBEG
A1UEChMKREZOLVZlcmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVp
biBQQ0EgR2xvYmFsIC0gRzAxMB4XDTE0MDUyNzE0NTM0NloXDTE5MDcwOTIzNTkwMFowXjEL
MAkGA1UEBhMCREUxIDAeBgNVBAoTF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MQ8wDQYDVQQD
EwZNUEcgQ0ExHDAaBgkqhkiG9w0BCQEWDW1wZy1jYUBtcGcuZGUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDYUXKeoNTLgkGwbani4rlua5jzlzISfHnaj/5qS+mojQqA/eYa
0bGucylV5hyQuyJz7d4gRckdhMDV8DZIxERUIsFlXFj6HGHjaZjlhIHbo4S12GjLhTH5YZ37
O7MHVw0L/JhhzUIxESM1ZfRT/xLqhz2idJYjT98W9OFvzPgT0yrdieMzkLUz5X/fpY8MuyYB
gxnddBJRw6ZtlhdCml4F8Q35pSb8J2qANiwuJVu3WCTgL/ydo3eA8vDieMMZ7O+L1wAnCzBb
HAjJ5H6xU1B7mlwmu7V3pToKPgcWmlO0HcTpa68McNTGGiY8pO0/Rn1fXkqDYf8z0lPdWUWx
bM1RAgMBAAGjggH6MIIB9jASBgNVHRMBAf8ECDAGAQH/AgEBMA4GA1UdDwEB/wQEAwIBBjAR
BgNVHSAECjAIMAYGBFUdIAAwHQYDVR0OBBYEFALWHm4Jq79YZacKPEgzYdHOfcNbMB8GA1Ud
IwQYMBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5kMBgGA1UdEQQRMA+BDW1wZy1jYUBtcGcuZGUw
gYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290
LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2ds
b2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIHXBggrBgEFBQcBAQSByjCBxzAzBggr
BgEFBQcwAYYnaHR0cDovL29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEcGCCsG
AQUFBzAChjtodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jYWNl
cnQvY2FjZXJ0LmNydDBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9i
YWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAD/c
d8LT8GRsriCROVmv9Ojss/K0uhmahZ17jQdZuPg4/1R9XYBdW3yym4ZIYWvb7YvdjngbXWIP
5s/Kr3hSZH63dFzwV/8V6n7e56XKc9729bQduTnAs++YTxUUy05pFna47Nv9BCbiS5ETXUKZ
PMIJA01XwA7yXkFP+bRdmJRsFn8weKbjnOE1dm64tX6upfP1N8hWkGfsIwyO2N47STHrv0/V
PlHhKxYdLWQ07qbE1p/IvQWymISQewLBjmO72gWB4ocGA2fTrD73wn29X4ZsR1Hn05xi6PLQ
06HQOxGRrS9eED0UQoHYzf1F0a3o+zY6OnyNacCmd4VrYGdStBwwggVTMIIEO6ADAgECAgcU
go1i01P7MA0GCSqGSIb3DQEBBQUAMF4xCzAJBgNVBAYTAkRFMSAwHgYDVQQKExdNYXgtUGxh
bmNrLUdlc2VsbHNjaGFmdDEPMA0GA1UEAxMGTVBHIENBMRwwGgYJKoZIhvcNAQkBFg1tcGct
Y2FAbXBnLmRlMB4XDTEyMDkyNjE0MjMxNFoXDTE1MDkyNjE0MjMxNFowgYUxCzAJBgNVBAYT
AkRFMSAwHgYDVQQKExdNYXgtUGxhbmNrLUdlc2VsbHNjaGFmdDE4MDYGA1UECxMvTWF4LVBs
YW5jay1JbnN0aXR1dCBmdWVyIG1vbGVrdWxhcmUgUGh5c2lvbG9naWUxGjAYBgNVBAMTEUFs
ZXhhbmRlciBGaWVyb2NoMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwa2MAiqz
3RqSvu7P+JnA0eWnZuEp5+97ayE14l5+d66zATlfqtuvYGDaMewqKdUYUxGgODKnBfeyh6KI
4Dd5oZAghhfT8uHNPPftzpicYKbglfNmVhU2T3nib0bq57+uwung808GTzAO7wJec4p1krsZ
IewridXEDurMgt0j/m9aYg6zZqaHJw08B/zHJ4oOodQp7sGQTJhJqCNI16JPS2wwmkD5N2Sj
aKMw3o7t0ierCkMvOica7eEr9hy9KQZ/Xtyki3YkPEbWwAuh1AbpeYm4jYNUgiD4WUzD6EKf
rlfo3naZotQWyCGBbYgc7HVIWAfdo3UXL15yz5rTExOR9wIDAQABo4IB7DCCAegwLwYDVR0g
BCgwJjARBg8rBgEEAYGtIYIsAQEEAgMwEQYPKwYBBAGBrSGCLAIBBAIDMAkGA1UdEwQCMAAw
CwYDVR0PBAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU
qRyldeLl5khFE6n7ELYOUV6Ahh0wHwYDVR0jBBgwFoAUAtYebgmrv1hlpwo8SDNh0c59w1sw
MAYDVR0RBCkwJ4ElYWxleGFuZGVyLmZpZXJvY2hAbXBpLWRvcnRtdW5kLm1wZy5kZTB3BgNV
HR8EcDBuMDWgM6Axhi9odHRwOi8vY2RwMS5wY2EuZGZuLmRlL21wZy1jYS9wdWIvY3JsL2Nh
Y3JsLmNybDA1oDOgMYYvaHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctY2EvcHViL2NybC9j
YWNybC5jcmwwgZIGCCsGAQUFBwEBBIGFMIGCMD8GCCsGAQUFBzAChjNodHRwOi8vY2RwMS5w
Y2EuZGZuLmRlL21wZy1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwPwYIKwYBBQUHMAKGM2h0
dHA6Ly9jZHAyLnBjYS5kZm4uZGUvbXBnLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkq
hkiG9w0BAQUFAAOCAQEAa0pbCJIuSl/UvO+ajRmnbWn0726WrLd0muoKzLaaunmLPvk0Gb/g
1IKTWNOOer4i3vKXuhbPU63N2VLsIRwN8rDTm9tg2oVkTb9t2CpDsBVPsVE4Y4PMbF72RmFr
doYVjL1e3ul+Y+s4hUBpAfAd8UJdqOgg3xsXWErN8PxO+atgMUkMAvLFH/mUXxQMQ/m1gWC9
z5HXhyvxmEaNQeudf4JPScYky+5UnDTREkbTIIlYPQHeUThOvD27RRDLU0yrbdWE0heen2ML
+oeYTg53FT+PwFXNUQ44KLIXdCNJri839hjy0Hrqk8JC+jFhjAj9Td/GQIulEZVnWUTt1o+W
mTGCA1UwggNRAgEBMGkwXjELMAkGA1UEBhMCREUxIDAeBgNVBAoTF01heC1QbGFuY2stR2Vz
ZWxsc2NoYWZ0MQ8wDQYDVQQDEwZNUEcgQ0ExHDAaBgkqhkiG9w0BCQEWDW1wZy1jYUBtcGcu
ZGUCBxSCjWLTU/swCQYFKw4DAhoFAKCCAcEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMTUwMjAzMDc1OTM4WjAjBgkqhkiG9w0BCQQxFgQUexrdmHjfwHB3
aiOp2Yb7RIHiZtkwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzAN
BggqhkiG9w0DAgIBKDB4BgkrBgEEAYI3EAQxazBpMF4xCzAJBgNVBAYTAkRFMSAwHgYDVQQK
ExdNYXgtUGxhbmNrLUdlc2VsbHNjaGFmdDEPMA0GA1UEAxMGTVBHIENBMRwwGgYJKoZIhvcN
AQkBFg1tcGctY2FAbXBnLmRlAgcUgo1i01P7MHoGCyqGSIb3DQEJEAILMWugaTBeMQswCQYD
VQQGEwJERTEgMB4GA1UEChMXTWF4LVBsYW5jay1HZXNlbGxzY2hhZnQxDzANBgNVBAMTBk1Q
RyBDQTEcMBoGCSqGSIb3DQEJARYNbXBnLWNhQG1wZy5kZQIHFIKNYtNT+zANBgkqhkiG9w0B
AQEFAASCAQCuM7s9Q7QXSeGf/izHz7UshblxLiaDATu+r5QXtd1dNQQwZEvM2rZiXS1Q65ba
EfRj/I8y7h4pMnQg0NCdU0bD4bhxobeolzrvJ06hwstD1c5hifwgMqcdZMhnR+9FWRCKvguF
L9G8VqrdbQO7rEHYsl7KU6PMY1/wIfRlOnsupsPJ+uBuJKU1qOZDnyqTE7dn1hKEXbr3tRtb
Ty8MkHXzWUzeqvWcLfCvPfpUOJI+j+5q6A2f8aHfWb2JC95DRExyYhPDYm9i0ti3gP8PND8g
a4uy+WilAgffWmPc8IpOhoDDekrpBRbMw8QcxPnYMPead1Gpv6/Qm2ahZw5PhB0FAAAAAAAA

--------------ms010201020400040101090205--
