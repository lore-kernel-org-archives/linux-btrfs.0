Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:58363 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3AYPkf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 10:40:35 -0500
Message-ID: <5102A76C.5050706@giantdisaster.de>
Date: Fri, 25 Jan 2013 16:40:28 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org,
        chris.mason@fusionio.com, JBacik@fusionio.com, dave@jikos.cz,
        kitayama@cl.bb4u.ne.jp, miaox@cn.fujitsu.com
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com> <CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com> <CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com> <20130123075155.GE17162@liubo.jp.oracle.com> <CAKcLGm97CSThaz9u0sj8BE=bMGObc6rqCsmzf0AneWfhxfZFDw@mail.gmail.com> <20130124005221.GA28406@liubo> <CAKcLGm_Casj44A3OL3hpsYAL9szb3-F+8C2fsLow9Trk_y=7dg@mail.gmail.com>
In-Reply-To: <CAKcLGm_Casj44A3OL3hpsYAL9szb3-F+8C2fsLow9Trk_y=7dg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Jan 2013 08:55:58 -0600, Mitch Harder wrote:
> On Wed, Jan 23, 2013 at 6:52 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> On Wed, Jan 23, 2013 at 10:05:04AM -0600, Mitch Harder wrote:
>>> On Wed, Jan 23, 2013 at 1:51 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>>> On Tue, Jan 22, 2013 at 11:41:19AM -0600, Mitch Harder wrote:
>>>>> On Thu, Jan 17, 2013 at 8:42 AM, Mitch Harder
>>>>> <mitch.harder@sabayonlinux.org> wrote:
>>>>>> On Wed, Jan 16, 2013 at 6:36 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>>>>>> This comes from one of btrfs's project ideas,
>>>>>>> As we defragment files, we break any sharing from other snapshots.
>>>>>>> The balancing code will preserve the sharing, and defrag needs to grow this
>>>>>>> as well.
>>>> [...]
>>>>>>
>>>>>> I've been testing this patch on a 3.7.2 kernel merged with the
>>>>>> for-linus branch for the 3.8_rc kernels, and I'm seeing the following
>>>>>> error:
[...]
> 
> I've changed up my reproducer to try some things that may hit the
> issue quicker and more reliably.
> 
> It gave me a slightly different set of warnings in dmesg, which seem
> to suggest issues in the dead_root list.
[...]
> [46769.785454] ------------[ cut here ]------------
> [46769.785471] WARNING: at lib/list_debug.c:36 __list_add+0x9d/0xba()
> [46769.785474] Hardware name: OptiPlex 745
> [46769.785478] list_add double add: new=ffff880050c27c38,
> prev=ffff880078f3e720, next=ffff880050c27c38.
> [46769.785480] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer
> tg3 sr_mod snd i2c_i801 ppdev parport_pc iTCO_wdt iTCO_vendor_support
> lpc_ich pcspkr parport floppy serio_raw microcode ablk_helper cryptd
> lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd sunrpc
> reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd
> hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
> [46769.785537] Pid: 18291, comm: btrfs-endio-wri Not tainted 3.7.4-sad-v1+ #3
> [46769.785539] Call Trace:
> [46769.785549]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
> [46769.785553]  [<ffffffff81030641>] warn_slowpath_fmt+0x46/0x48
> [46769.785558]  [<ffffffff8120987b>] __list_add+0x9d/0xba
> [46769.785586]  [<ffffffffa0179dd6>] btrfs_add_dead_root+0x42/0x56 [btrfs]
> [46769.785603]  [<ffffffffa0187b67>] btrfs_destroy_inode+0x227/0x25b [btrfs]
> [46769.785611]  [<ffffffff8111393a>] destroy_inode+0x3b/0x54
> [46769.785615]  [<ffffffff81113a9c>] evict+0x149/0x151
> [46769.785619]  [<ffffffff81114322>] iput+0x12c/0x135
> [46769.785636]  [<ffffffffa018455f>] relink_extent_backref+0x669/0x6af [btrfs]
> [46769.785642]  [<ffffffff815e9849>] ? __slab_free+0x17c/0x21b
> [46769.785658]  [<ffffffffa0184d15>] ?
> btrfs_finish_ordered_io+0x770/0x827 [btrfs]
> [46769.785674]  [<ffffffffa0184ce5>] btrfs_finish_ordered_io+0x740/0x827 [btrfs]
> [46769.785691]  [<ffffffffa0184de1>] finish_ordered_fn+0x15/0x17 [btrfs]
> [46769.785706]  [<ffffffffa019e5c9>] worker_loop+0x14c/0x493 [btrfs]
> [46769.785722]  [<ffffffffa019e47d>] ? btrfs_queue_worker+0x258/0x258 [btrfs]
> [46769.785728]  [<ffffffff8104c750>] kthread+0xba/0xc2
> [46769.785732]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [46769.785737]  [<ffffffff815f301c>] ret_from_fork+0x7c/0xb0
> [46769.785741]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [46769.785745] ---[ end trace 7528086f91b151b5 ]---
> [46799.053062] ------------[ cut here ]------------

Well, the issue that I had reported on IRC some days ago which looks similar (the top part of the call trace is similar: iput -> evict -> destroy_inode -> btrfs_destroy_inode -> btrfs_add_dead_root -> list_add which warns in list_add in your case and crashes in my case) was without Liu Bo's "snapshot-aware defrag" patch. A 3.8.0-rc4 kernel and nothing else.

The reproducer was to create and destroy subvolumes and snapshots. I used btrfs-receive to fill them with data. The crash happened on umount. Every time.

del_fs_roots() is attempting to empty the dead_roots list, and via btrfs_destroy_inode() deeper in the call stack they are added back to the dead_roots list.

BUG: unable to handle kernel paging request at ffff88042503b830
IP: [<ffffffff814532b7>] __list_add+0x17/0xd0
PGD 1e0c063 PUD bf58e067 PMD bf6b7067 PTE 800000042503b160
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: btrfs bonding raid1 mpt2sas scsi_transport_sas raid_class
CPU 2
Pid: 10259, comm: umount Not tainted 3.8.0-rc4+ #16 Supermicro X8SIL/X8SIL
RIP: 0010:[<ffffffff814532b7>]  [<ffffffff814532b7>] __list_add+0x17/0xd0
RSP: 0018:ffff8802f67a1bd8  EFLAGS: 00010286
RAX: ffff880425b7c560 RBX: ffff880423ca2828 RCX: 0000000000000001
RDX: ffff88042503b828 RSI: ffff8804257794c0 RDI: ffff880423ca2828
RBP: ffff8802f67a1bf8 R08: 0000000000077850 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff880423ca2000
R13: ffff880423ca2898 R14: 0000000000000000 R15: ffff8802f67a1d30
FS:  00007f6e89bba740(0000) GS:ffff88042ea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88042503b830 CR3: 000000029a56c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 10259, threadinfo ffff8802f67a0000, task ffff880425b7c560)
Stack:
 ffffffffa00a414f ffff880423ca2000 ffff880423ca2000 ffff880423ca2898
 ffff8802f67a1c18 ffffffffa00a4170 ffff88042a60c1f8 ffff88042a60c1f8
 ffff8802f67a1c48 ffffffffa00b3180 ffff88042a60c1f8 ffff88042a60c280
Call Trace:
 [<ffffffffa00a414f>] ? btrfs_add_dead_root+0x1f/0x60 [btrfs]
 [<ffffffffa00a4170>] btrfs_add_dead_root+0x40/0x60 [btrfs]
 [<ffffffffa00b3180>] btrfs_destroy_inode+0x1d0/0x2d0 [btrfs]
 [<ffffffff811b5d17>] destroy_inode+0x37/0x60
 [<ffffffff811b5e4d>] evict+0x10d/0x1a0
 [<ffffffff811b65f5>] iput+0x105/0x190
 [<ffffffffa009bd68>] free_fs_root+0x18/0x90 [btrfs]
 [<ffffffffa009f1ab>] btrfs_free_fs_root+0x7b/0x90 [btrfs]
 [<ffffffffa009f26f>] del_fs_roots+0xaf/0xf0 [btrfs]
 [<ffffffffa00a0bc6>] close_ctree+0x1c6/0x300 [btrfs]
 [<ffffffff811b6a7c>] ? evict_inodes+0xec/0x100
 [<ffffffffa00763a4>] btrfs_put_super+0x14/0x20 [btrfs]
 [<ffffffff8119dfcc>] generic_shutdown_super+0x5c/0xe0
 [<ffffffff8119e0e1>] kill_anon_super+0x11/0x20
 [<ffffffffa007a3a5>] btrfs_kill_super+0x15/0x90 [btrfs]
 [<ffffffff8119f111>] ? deactivate_super+0x41/0x70
 [<ffffffff8119e4dd>] deactivate_locked_super+0x3d/0x70
 [<ffffffff8119f119>] deactivate_super+0x49/0x70
 [<ffffffff811ba772>] mntput_no_expire+0xd2/0x130
 [<ffffffff811bb621>] sys_umount+0x71/0x390
 [<ffffffff81983012>] system_call_fastpath+0x16/0x1b
Code: 48 83 c4 08 5b 5d c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <4c> 8b 42 08 49 89 f5 49 89 d4 49 39 f0 75 31 4d 8b 45 00 4d 39
RIP  [<ffffffff814532b7>] __list_add+0x17/0xd0
 RSP <ffff8802f67a1bd8>
CR2: ffff88042503b830
---[ end trace 5e44f1afc74751aa ]---

