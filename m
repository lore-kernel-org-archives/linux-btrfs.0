From: Christian Brunner <chb@muc.de>
Subject: Re: btrfs BUG during Ceph cosd open() syscall
Date: Thu, 27 Jan 2011 16:58:45 +0100
Message-ID: <AANLkTikV7Wzw9eP0nmMsBCA4WasY88NUheOH+MRs=Li1@mail.gmail.com>
References: <1296057606.23762.56.camel@sale659.sandia.gov>
	<1296064793.23762.70.camel@sale659.sandia.gov>
	<1296067685.23762.74.camel@sale659.sandia.gov>
	<4D407413.7030606@genome.wustl.edu>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jim Schutt <jaschut@sandia.gov>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
To: Matt Weil <mweil@genome.wustl.edu>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4D407413.7030606@genome.wustl.edu>
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs_orphan_commit_root warning is also reproducable in our ceph
environment.

Regards
Christian

2011/1/26 Matt Weil <mweil@genome.wustl.edu>:
> heavy writes as well
>
> Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496742] ------------[ cut=
 here
> ]------------
>>
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496754] WARNING: at
>> fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0xb0/0xc0()
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496756] Hardware name=
: ProLiant
>> DL380 G5
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496758] Modules linke=
d in: nfsd
>> exportfs nfs lockd nfs_acl auth_rpcgss bonding sunrpc radeon ttm
>> drm_kms_helper drm bnx2 psmouse i5000_edac usbhid lp shpchp ipmi_si
>> i2c_algo_bit hid edac_core parport ipmi_msghandler serio_raw i5k_amb=
 hpilo
>> cciss fbcon tileblit font bitblit softcursor
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496788] Pid: 2764, co=
mm: cosd
>> Not tainted 2.6.37-ceph-client #1
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496790] Call Trace:
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496797] =A0[<ffffffff=
81060dbf>]
>> warn_slowpath_common+0x7f/0xc0
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496800] =A0[<ffffffff=
81060e1a>]
>> warn_slowpath_null+0x1a/0x20
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496804] =A0[<ffffffff=
81273b70>]
>> btrfs_orphan_commit_root+0xb0/0xc0
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496807] =A0[<ffffffff=
8126f1c1>]
>> commit_fs_roots+0xa1/0x140
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496810] =A0[<ffffffff=
81270640>]
>> btrfs_commit_transaction+0x350/0x730
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496816] =A0[<ffffffff=
81082aa0>] ?
>> autoremove_wake_function+0x0/0x40
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496820] =A0[<ffffffff=
8129ec33>]
>> btrfs_mksubvol+0x363/0x380
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496823] =A0[<ffffffff=
8129ed3d>]
>> btrfs_ioctl_snap_create_transid+0xed/0x140
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496826] =A0[<ffffffff=
8129ee87>]
>> btrfs_ioctl_snap_create+0xf7/0x140
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496830] =A0[<ffffffff=
812a0dcf>]
>> btrfs_ioctl+0x61f/0xa20
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496834] =A0[<ffffffff=
811836da>] ?
>> fsnotify+0x1ea/0x320
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496839] =A0[<ffffffff=
8115ce19>]
>> do_vfs_ioctl+0xa9/0x5a0
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496842] =A0[<ffffffff=
8115d391>]
>> sys_ioctl+0x81/0xa0
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496847] =A0[<ffffffff=
8100c042>]
>> system_call_fastpath+0x16/0x1b
>> =A0Jan =A05 16:56:46 linuscs101 kernel: [ 3666.496850] ---[ end trac=
e
>> 2a6c3f752cfb5f1b ]---
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.723170] CPU 1
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.723210] Modules linke=
d in: nfsd
>> exportfs nfs lockd nfs_acl auth_rpcgss bonding sunrpc radeon ttm
>> drm_kms_helper drm bnx2 psmouse i5000_edac usbhid lp shpchp ipmi_si
>> i2c_algo_bit hid edac_core parport ipmi_msghandler serio_raw i5k_amb=
 hpilo
>> cciss fbcon tileblit font bitblit softcursor
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724006]
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724041] Pid: 2766, co=
mm: cosd
>> Tainted: G =A0 =A0 =A0 =A0W =A0 2.6.37-ceph-client #1 /ProLiant DL38=
0 G5
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724169] RIP:
>> 0010:[<ffffffff81278190>] =A0[<ffffffff81278190>] btrfs_truncate+0x5=
10/0x530
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724318] RSP:
>> 0018:ffff8803d7e1bd48 =A0EFLAGS: 00010286
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724397] RAX: 00000000=
ffffffe4
>> RBX: ffff8803dfaf1800 RCX: ffff880406ce7090
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724493] RDX: 00000000=
00000000
>> RSI: ffffea000e17d288 RDI: 0000000000000206
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724592] RBP: ffff8803=
d7e1bdd8
>> R08: 0000000000000783 R09: ffff8803d7e1bb28
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724691] R10: 00000000=
ffffffe4
>> R11: 0000000000000001 R12: ffff8803dee49f00
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724793] R13: ffff8803=
d5369c10
>> R14: ffff8803d5369a78 R15: ffff8803d5369d38
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.724899] FS:
>> =A000007f77acfb6710(0000) GS:ffff8800cfc40000(0000) knlGS:0000000000=
000000
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.725019] CS: =A00010 D=
S: 0000 ES:
>> 0000 CR0: 0000000080050033
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.725096] CR2: 00007f81=
cd5b8000
>> CR3: 00000003dfad3000 CR4: 00000000000006e0
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.725195] DR0: 00000000=
00000000
>> DR1: 0000000000000000 DR2: 0000000000000000
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.725293] DR3: 00000000=
00000000
>> DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.725392] Process cosd =
(pid:
>> 2766, threadinfo ffff8803d7e1a000, task ffff8803dfaf8000)
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.725549] =A00000000000=
000000
>> ffffffffffffffff ffff8803d5369d78 00000000000001da
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.725695] =A00000000000=
000fff
>> 00000000d5369d38 0000000000001000 0000000000000000
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.725841] =A0ffff8803d5=
369aa8
>> ffff8803d5369c10 ffff8803d7e1bdc8 0000000000000000
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.726039] =A0[<ffffffff=
81104c46>]
>> vmtruncate+0x56/0x70
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.726113] =A0[<ffffffff=
8127cece>]
>> btrfs_setattr+0x13e/0x2a0
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.726202] =A0[<ffffffff=
811652c0>]
>> notify_change+0x170/0x2e0
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.726292] =A0[<ffffffff=
8114b9b4>]
>> do_truncate+0x64/0xa0
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.726370] =A0[<ffffffff=
81156d73>] ?
>> generic_permission+0x23/0xc0
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.726460] =A0[<ffffffff=
81156bd5>] ?
>> get_write_access+0x45/0x70
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.726543] =A0[<ffffffff=
8114bb39>]
>> sys_truncate+0x149/0x150
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.726631] =A0[<ffffffff=
8100c042>]
>> system_call_fastpath+0x16/0x1b
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.727618] =A0RSP<ffff88=
03d7e1bd48>
>> =A0Jan =A05 17:07:45 linuscs101 kernel: [ 4325.748986] ---[ end trac=
e
>> 2a6c3f752cfb5f1c ]---
>
>
>
> On 1/26/11 12:48 PM, Jim Schutt wrote:
>>
>> Hi,
>>
>> On Wed, 2011-01-26 at 10:59 -0700, Jim Schutt wrote:
>>>
>>> Hi,
>>>
>>> I got this kernel BUG on a server running multiple Ceph
>>> cosd instances, during a heavy write load generated by
>>> multiple Ceph clients.
>>>
>>> The server was running the current ceph unstable kernel
>>> (a3f5274e535 in
>>> git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git)=
=2E
>>>
>>> Please let me know what other information you need to
>>> make this report useful.
>>>
>>> -- Jim
>>>
>> Here's another example.
>>
>> Again, please let me know what other information you need to
>> make this report useful.
>>
>> -- Jim
>>
>> [11199.532483] ------------[ cut here ]------------
>> [11199.536292] kernel BUG at fs/btrfs/extent-tree.c:2198!
>> [11199.536292] invalid opcode: 0000 [#1] SMP
>> [11199.536292] last sysfs file:
>> /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
>> [11199.536292] CPU 3
>> [11199.536292] Modules linked in: loop btrfs zlib_deflate ipt_MASQUE=
RADE
>> iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conn=
track
>> ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge ]
>> [11199.536292]
>> [11199.536292] Pid: 1664, comm: cosd Not tainted 2.6.37-00017-ga3f52=
74 #4
>> 0DT097/PowerEdge 1950
>> [11199.536292] RIP: 0010:[<ffffffffa0774081>] =A0[<ffffffffa0774081>=
]
>> run_clustered_refs+0x71e/0x76b [btrfs]
>> [11199.536292] RSP: 0018:ffff8801c90abb58 =A0EFLAGS: 00010282
>> [11199.536292] RAX: 00000000fffffffb RBX: 0000000000000000 RCX:
>> ffff8802262c5000
>> [11199.536292] RDX: ffff88017921e2d0 RSI: ffffea000527f690 RDI:
>> 0000000000000001
>> [11199.536292] RBP: ffff8801c90abc28 R08: ffffe8ffffccefe8 R09:
>> 0000000000000000
>> [11199.536292] R10: 0000000000000003 R11: ffff880227549e98 R12:
>> ffff880140bb8f00
>> [11199.536292] R13: 0000000000000000 R14: ffff880181eff378 R15:
>> ffff8802262c5000
>> [11199.536292] FS: =A000007f5e680fc940(0000) GS:ffff8800cfcc0000(000=
0)
>> knlGS:0000000000000000
>> [11199.536292] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [11199.536292] CR2: 00007f0e1a476260 CR3: 0000000173aa0000 CR4:
>> 00000000000006e0
>> [11199.536292] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [11199.536292] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [11199.536292] Process cosd (pid: 1664, threadinfo ffff8801c90aa000,=
 task
>> ffff8801df12d840)
>> [11199.536292] Stack:
>> [11199.536292] =A00000000000000000 0000000000000000 0000000000000001
>> 0000000000000000
>> [11199.536292] =A0ffff8801c90abc48 ffff8802262c5000 ffff8801e0a9c600
>> ffff880181eff378
>> [11199.536292] =A00000000000000000 0000002600000206 ffff880181eff380
>> 000000007921e750
>> [11199.536292] Call Trace:
>> [11199.536292] =A0[<ffffffffa0785be0>] ? btrfs_update_inode+0xc3/0xd=
3
>> [btrfs]
>> [11199.536292] =A0[<ffffffffa07741bc>] btrfs_run_delayed_refs+0xee/0=
x15e
>> [btrfs]
>> [11199.536292] =A0[<ffffffff810fa54d>] ?
>> __fsnotify_update_dcache_flags+0x22/0x56
>> [11199.536292] =A0[<ffffffffa07801d0>] __btrfs_end_transaction+0x6d/=
0x1e3
>> [btrfs]
>> [11199.536292] =A0[<ffffffffa0780372>]
>> btrfs_end_transaction_throttle+0x18/0x1a [btrfs]
>> [11199.536292] =A0[<ffffffffa07872e1>] btrfs_create+0x1a0/0x1fa [btr=
fs]
>> [11199.536292] =A0[<ffffffff810f49e2>] vfs_create+0x76/0x96
>> [11199.536292] =A0[<ffffffff810f56af>] do_last+0x24d/0x4d3
>> [11199.536292] =A0[<ffffffff810f5b16>] do_filp_open+0x1e1/0x4c5
>> [11199.536292] =A0[<ffffffff81031061>] ? should_resched+0xe/0x2f
>> [11199.536292] =A0[<ffffffff8136a638>] ? _cond_resched+0xe/0x22
>> [11199.536292] =A0[<ffffffff811aa669>] ? might_fault+0xe/0x10
>> [11199.536292] =A0[<ffffffff811aa753>] ? __strncpy_from_user+0x20/0x=
4a
>> [11199.536292] =A0[<ffffffff810e9023>] do_sys_open+0x62/0xeb
>> [11199.536292] =A0[<ffffffff810e90df>] sys_open+0x20/0x22
>> [11199.536292] =A0[<ffffffff81002c2b>] system_call_fastpath+0x16/0x1=
b
>> [11199.536292] Code: 24 08 48 8b 46 40 48 89 04 24 48 8b b5 58 ff ff=
 ff 48
>> 8b bd 60 ff ff ff e8 61 e7 ff ff eb 08 0f 0b eb fe 0f 0b eb fe 85 c0=
 74
>> 04<0f> =A00b eb fe 4c 89 e7 e8 65 ae ff ff 48 8b bd 70 ff ff ff
>> [11199.536292] RIP =A0[<ffffffffa0774081>] run_clustered_refs+0x71e/=
0x76b
>> [btrfs]
>> [11199.536292] =A0RSP<ffff8801c90abb58>
>> [11199.905250] ---[ end trace b0dead1e7c3dbf7b ]---
>> Jan 26 11:40:32 an1 [11199.532483] ------------[ cut here ]---------=
---
>> Jan 26 11:40:33 an1 [11199.536292] invalid opcode: 0000 [#1] SMP
>> Jan 26 11:40:33 an1 [11199.536292] last sysfs file:
>> /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
>> Jan 26 11:40:38 an1 [11199.536292] Stack:
>> Jan 26 11:40:38 an1 [11199.536292] Call Trace:
>> Jan 26 11:40:40 an1 [11199.536292] Code: 24 08 48 8b 46 40 48 89 04 =
24 48
>> 8b b5 58 ff ff ff 48 8b bd 60 ff ff ff e8 61 e7 ff ff eb 08 0f 0b eb=
 fe 0f
>> 0b eb fe 85 c0 74 04<0f> =A00b eb fe 4c 89 e7 e8 65 ae ff ff 4
>> [11212.699541] btrfs: sdm2 checksum verify failed on 31928320 wanted
>> 237BEA0B found F7B13C5E level 0
>> [11212.709895] btrfs: sdm2 checksum verify failed on 31928320 wanted
>> 237BEA0B found F7B13C5E level 0
>> [11212.719737] btrfs: sdm2 checksum verify failed on 31928320 wanted
>> 237BEA0B found F7B13C5E level 0
>> [11212.729433] ------------[ cut here ]------------
>> [11212.730394] kernel BUG at fs/btrfs/extent-tree.c:5789!
>> [11212.734157] invalid opcode: 0000 [#2] SMP
>> [11212.734157] last sysfs file:
>> /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
>> [11212.734157] CPU 3
>> [11212.734157] Modules linked in: loop btrfs zlib_deflate ipt_MASQUE=
RADE
>> iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conn=
track
>> ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge ]
>> [11212.734157]
>> [11212.734157] Pid: 27662, comm: btrfs-cleaner Tainted: G =A0 =A0 =A0=
D
>> 2.6.37-00017-ga3f5274 #4 0DT097/PowerEdge 1950
>> [11212.734157] RIP: 0010:[<ffffffffa0773452>] =A0[<ffffffffa0773452>=
]
>> reada_walk_down+0x18c/0x249 [btrfs]
>> [11212.734157] RSP: 0018:ffff880227539be0 =A0EFLAGS: 00010282
>> [11212.734157] RAX: 00000000fffffffb RBX: ffff8801cd50d750 RCX:
>> ffff88020b993000
>> [11212.734157] RDX: ffff88017921e3f0 RSI: ffffea000527f690 RDI:
>> 0000000100000090
>> [11212.734157] RBP: ffff880227539c80 R08: ffffe8ffffccefe8 R09:
>> 0000000000000000
>> [11212.734157] R10: 0000000100a68468 R11: ffff880227549e98 R12:
>> ffff8801d83c3000
>> [11212.734157] R13: 0000000000000040 R14: ffff88020b993000 R15:
>> 00000000000000e0
>> [11212.734157] FS: =A00000000000000000(0000) GS:ffff8800cfcc0000(000=
0)
>> knlGS:0000000000000000
>> [11212.734157] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [11212.734157] CR2: 0000000000b92de8 CR3: 000000020e5b3000 CR4:
>> 00000000000006e0
>> [11212.734157] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [11212.734157] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [11212.734157] Process btrfs-cleaner (pid: 27662, threadinfo
>> ffff880227538000, task ffff88020ebc0000)
>> [11212.734157] Stack:
>> [11212.734157] =A0ffff880227539bf0 0000000400000000 ffff8801cd50d750
>> ffff8801e0a9ca00
>> [11212.734157] =A000000000024cd000 000010000000006b ffff88021527f880
>> 0000000100000001
>> [11212.734157] =A0ffff880227539c50 ffffffffa079c6bc ffff880225c96198
>> ffff8801b0cf9aa8
>> [11212.734157] Call Trace:
>> [11212.734157] =A0[<ffffffffa079c6bc>] ? extent_buffer_uptodate+0x6c=
/0x8a
>> [btrfs]
>> [11212.734157] =A0[<ffffffffa0775d62>] do_walk_down+0x25b/0x395 [btr=
fs]
>> [11212.734157] =A0[<ffffffffa076db1f>] ? btrfs_header_generation+0x1=
f/0x25
>> [btrfs]
>> [11212.734157] =A0[<ffffffffa0771268>] ? walk_down_proc+0x10a/0x1d0 =
[btrfs]
>> [11212.734157] =A0[<ffffffffa0775f1d>] walk_down_tree+0x81/0xac [btr=
fs]
>> [11212.734157] =A0[<ffffffffa077636f>] btrfs_drop_snapshot+0x2aa/0x4=
67
>> [btrfs]
>> [11212.734157] =A0[<ffffffff81031049>] ? need_resched+0x23/0x2d
>> [11212.734157] =A0[<ffffffff81031061>] ? should_resched+0xe/0x2f
>> [11212.734157] =A0[<ffffffffa077d080>] ? cleaner_kthread+0x0/0x16b [=
btrfs]
>> [11212.734157] =A0[<ffffffffa077f24d>] btrfs_clean_old_snapshots+0xe=
e/0x10c
>> [btrfs]
>> [11212.734157] =A0[<ffffffffa077d177>] cleaner_kthread+0xf7/0x16b [b=
trfs]
>> [11212.734157] =A0[<ffffffff8105b11e>] kthread+0x72/0x7a
>> [11212.734157] =A0[<ffffffff810039d4>] kernel_thread_helper+0x4/0x10
>> [11212.734157] =A0[<ffffffff8105b0ac>] ? kthread+0x0/0x7a
>> [11212.734157] =A0[<ffffffff810039d0>] ? kernel_thread_helper+0x0/0x=
10
>> [11212.734157] Code: 01 00 00 0f 86 bb 00 00 00 8b 4d 8c 48 8b 55 80=
 4c 8d
>> 4d c0 48 8b bd 78 ff ff ff 4c 8d 45 c8 4c 89 f6 e8 ec da ff ff 85 c0=
 74
>> 04<0f> =A00b eb fe 48 8b 45 c8 48 85 c0 75 04 0f 0b eb fe 41 83
>> [11212.734157] RIP =A0[<ffffffffa0773452>] reada_walk_down+0x18c/0x2=
49
>> [btrfs]
>> [11212.734157] =A0RSP<ffff880227539be0>
>> [11213.101484] ---[ end trace b0dead1e7c3dbf7c ]---
>> Jan 26 11:40:45 an1 [11212.729433] ------------[ cut here ]---------=
---
>> Jan 26 11:40:45 an1 [11212.734157] invalid opcode: 0000 [#2] SMP
>> Jan 26 11:40:45 an1 [11212.734157] last sysfs file:
>> /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
>> Jan 26 11:40:46 an1 [11212.734157] Stack:
>> Jan 26 11:40:46 an1 [11212.734157] Call Trace:
>> Jan 26 11:40:46 an1 [11212.734157] Code: 01 00 00 0f 86 bb 00 00 00 =
8b 4d
>> 8c 48 8b 55 80 4c 8d 4d c0 48 8b bd 78 ff ff ff 4c 8d 45 c8 4c 89 f6=
 e8 ec
>> da ff ff 85 c0 74 04<0f> =A00b eb fe 48 8b 45 c8 48 85 c0 75 0
>>
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe ceph-devel=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
