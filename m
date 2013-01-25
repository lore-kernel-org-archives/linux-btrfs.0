Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:35148 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3AYOz7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 09:55:59 -0500
Received: by mail-oa0-f52.google.com with SMTP id o6so451846oag.25
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 06:55:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130124005221.GA28406@liubo>
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
	<CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
	<CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com>
	<20130123075155.GE17162@liubo.jp.oracle.com>
	<CAKcLGm97CSThaz9u0sj8BE=bMGObc6rqCsmzf0AneWfhxfZFDw@mail.gmail.com>
	<20130124005221.GA28406@liubo>
Date: Fri, 25 Jan 2013 08:55:58 -0600
Message-ID: <CAKcLGm_Casj44A3OL3hpsYAL9szb3-F+8C2fsLow9Trk_y=7dg@mail.gmail.com>
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com,
        dave@jikos.cz, kitayama@cl.bb4u.ne.jp, miaox@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 6:52 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Wed, Jan 23, 2013 at 10:05:04AM -0600, Mitch Harder wrote:
>> On Wed, Jan 23, 2013 at 1:51 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> > On Tue, Jan 22, 2013 at 11:41:19AM -0600, Mitch Harder wrote:
>> >> On Thu, Jan 17, 2013 at 8:42 AM, Mitch Harder
>> >> <mitch.harder@sabayonlinux.org> wrote:
>> >> > On Wed, Jan 16, 2013 at 6:36 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> >> >> This comes from one of btrfs's project ideas,
>> >> >> As we defragment files, we break any sharing from other snapshots.
>> >> >> The balancing code will preserve the sharing, and defrag needs to grow this
>> >> >> as well.
>> > [...]
>> >> >
>> >> > I've been testing this patch on a 3.7.2 kernel merged with the
>> >> > for-linus branch for the 3.8_rc kernels, and I'm seeing the following
>> >> > error:
>> >> >
>> >>
>> >> I've reproduced the error with CONFIG_DEBUG_LIST enabled, which shows
>> >> some problem with an entry in the list.
>> >>
>> >> [59312.260441] ------------[ cut here ]------------
>> >> [59312.260454] WARNING: at lib/list_debug.c:62 __list_del_entry+0x8d/0x98()
>> >> [59312.260458] Hardware name: OptiPlex 745
>> >> [59312.260461] list_del corruption. next->prev should be
>> >> ffff88006511c438, but was dead000000200200
>> >
>> > LIST_POISON2 -> (000000200200)
>> > So we can know that the next one is deleted from the list even _earlier_
>> > than the current one is.
>> >
>> > Any other messages before this warning complains?
>> >
>>
>> Just some normal feedback from a metadata balance I had run.
>
> Well, these do fit my expectation, since balance also involves with playing with
> root_list, which may lead to the bad situation.
>
>>
>> [14057.193343] device fsid 28c688c5-7dbd-4071-b271-1bf6726d8835 devid
>> 1 transid 4 /dev/sda7
>> [14057.194438] btrfs: force lzo compression
>> [14057.194446] btrfs: enabling auto defrag
>> [14057.194449] btrfs: disk space caching is enabled
>> [14057.194452] btrfs flagging fs with big metadata feature
>> [14057.194455] btrfs: lzo incompat flag set.
>> [57508.799193] btrfs: relocating block group 14516486144 flags 4
>> [57632.178797] btrfs: found 6775 extents
>> [57633.214701] btrfs: relocating block group 11832131584 flags 4
>> [57776.400102] btrfs: found 6480 extents
>> [57777.021175] btrfs: relocating block group 10489954304 flags 4
>> [57949.182725] btrfs: found 6681 extents
>> [59312.260441] ------------[ cut here ]------------
>> [59312.260454] WARNING: at lib/list_debug.c:62 __list_del_entry+0x8d/0x98()
>> [59312.260458] Hardware name: OptiPlex 745
>> ...
>>
>> I'm going to try to wrap some debugging around the section of code in
>> btrfs_clean_old_snapshots() where the dead_roots list is spliced onto
>> the root list being processed.  The double entry may be slipping in
>> here.
>>
>> 1764         spin_lock(&fs_info->trans_lock);
>> 1765         list_splice_init(&fs_info->dead_roots, &list);
>> 1766         spin_unlock(&fs_info->trans_lock);
>
> hmm, I don't think there is anything wrong in this code.  But you can
> give it a shot anyway :)
>

I've changed up my reproducer to try some things that may hit the
issue quicker and more reliably.

It gave me a slightly different set of warnings in dmesg, which seem
to suggest issues in the dead_root list.

[43925.656065] device fsid a8f6fadb-3022-4c01-b369-f1f3f638c052 devid
1 transid 310 /dev/sda7
[43925.658062] btrfs: force lzo compression
[43925.658072] btrfs: enabling auto defrag
[43925.658075] btrfs: disk space caching is enabled
[43925.658078] btrfs: lzo incompat flag set.
[44503.421293] btrfs: unlinked 1 orphans
[44898.287365] btrfs: unlinked 1 orphans
[45080.641383] btrfs: unlinked 1 orphans
[45250.063773] btrfs: unlinked 1 orphans
[46223.387355] btrfs: unlinked 1 orphans
[46476.473944] btrfs: unlinked 1 orphans
[46499.665615] btrfs: unlinked 1 orphans
[46769.785454] ------------[ cut here ]------------
[46769.785471] WARNING: at lib/list_debug.c:36 __list_add+0x9d/0xba()
[46769.785474] Hardware name: OptiPlex 745
[46769.785478] list_add double add: new=ffff880050c27c38,
prev=ffff880078f3e720, next=ffff880050c27c38.
[46769.785480] Modules linked in: ipv6 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer
tg3 sr_mod snd i2c_i801 ppdev parport_pc iTCO_wdt iTCO_vendor_support
lpc_ich pcspkr parport floppy serio_raw microcode ablk_helper cryptd
lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd sunrpc
reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd
hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
[46769.785537] Pid: 18291, comm: btrfs-endio-wri Not tainted 3.7.4-sad-v1+ #3
[46769.785539] Call Trace:
[46769.785549]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
[46769.785553]  [<ffffffff81030641>] warn_slowpath_fmt+0x46/0x48
[46769.785558]  [<ffffffff8120987b>] __list_add+0x9d/0xba
[46769.785586]  [<ffffffffa0179dd6>] btrfs_add_dead_root+0x42/0x56 [btrfs]
[46769.785603]  [<ffffffffa0187b67>] btrfs_destroy_inode+0x227/0x25b [btrfs]
[46769.785611]  [<ffffffff8111393a>] destroy_inode+0x3b/0x54
[46769.785615]  [<ffffffff81113a9c>] evict+0x149/0x151
[46769.785619]  [<ffffffff81114322>] iput+0x12c/0x135
[46769.785636]  [<ffffffffa018455f>] relink_extent_backref+0x669/0x6af [btrfs]
[46769.785642]  [<ffffffff815e9849>] ? __slab_free+0x17c/0x21b
[46769.785658]  [<ffffffffa0184d15>] ?
btrfs_finish_ordered_io+0x770/0x827 [btrfs]
[46769.785674]  [<ffffffffa0184ce5>] btrfs_finish_ordered_io+0x740/0x827 [btrfs]
[46769.785691]  [<ffffffffa0184de1>] finish_ordered_fn+0x15/0x17 [btrfs]
[46769.785706]  [<ffffffffa019e5c9>] worker_loop+0x14c/0x493 [btrfs]
[46769.785722]  [<ffffffffa019e47d>] ? btrfs_queue_worker+0x258/0x258 [btrfs]
[46769.785728]  [<ffffffff8104c750>] kthread+0xba/0xc2
[46769.785732]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[46769.785737]  [<ffffffff815f301c>] ret_from_fork+0x7c/0xb0
[46769.785741]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[46769.785745] ---[ end trace 7528086f91b151b5 ]---
[46799.053062] ------------[ cut here ]------------
[46799.053078] WARNING: at lib/list_debug.c:62 __list_del_entry+0x8d/0x98()
[46799.053082] Hardware name: OptiPlex 745
[46799.053087] list_del corruption. next->prev should be
ffff880050c27c38, but was ffff8800057fde38
[46799.053090] Modules linked in: ipv6 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer
tg3 sr_mod snd i2c_i801 ppdev parport_pc iTCO_wdt iTCO_vendor_support
lpc_ich pcspkr parport floppy serio_raw microcode ablk_helper cryptd
lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd sunrpc
reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd
hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
[46799.053163] Pid: 18210, comm: btrfs-cleaner Tainted: G        W
3.7.4-sad-v1+ #3
[46799.053166] Call Trace:
[46799.053180]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
[46799.053184]  [<ffffffff81030641>] warn_slowpath_fmt+0x46/0x48
[46799.053190]  [<ffffffff810ab4e9>] ? __trace_bprintk+0x48/0x4a
[46799.053194]  [<ffffffff812097a5>] __list_del_entry+0x8d/0x98
[46799.053198]  [<ffffffff812097be>] list_del+0xe/0x2e
[46799.053220]  [<ffffffffa017b2f5>]
btrfs_clean_old_snapshots+0xed/0x150 [btrfs]
[46799.053235]  [<ffffffffa0173d7d>] cleaner_kthread+0x5a/0xe6 [btrfs]
[46799.053249]  [<ffffffffa0173d23>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
[46799.053254]  [<ffffffff8104c750>] kthread+0xba/0xc2
[46799.053259]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[46799.053264]  [<ffffffff815f301c>] ret_from_fork+0x7c/0xb0
[46799.053269]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[46799.053272] ---[ end trace 7528086f91b151b6 ]---
[46811.162649] ------------[ cut here ]------------
[46811.162665] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
[46811.162669] Hardware name: OptiPlex 745
[46811.162674] list_del corruption, ffff880050c27c38->next is
LIST_POISON1 (dead000000100100)
[46811.162678] Modules linked in: ipv6 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer
tg3 sr_mod snd i2c_i801 ppdev parport_pc iTCO_wdt iTCO_vendor_support
lpc_ich pcspkr parport floppy serio_raw microcode ablk_helper cryptd
lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd sunrpc
reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd
hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
[46811.162750] Pid: 18210, comm: btrfs-cleaner Tainted: G        W
3.7.4-sad-v1+ #3
[46811.162754] Call Trace:
[46811.162764]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
[46811.162771]  [<ffffffff81030641>] warn_slowpath_fmt+0x46/0x48
[46811.162779]  [<ffffffff810ab4e9>] ? __trace_bprintk+0x48/0x4a
[46811.162785]  [<ffffffff812097a5>] __list_del_entry+0x8d/0x98
[46811.162791]  [<ffffffff812097be>] list_del+0xe/0x2e
[46811.162820]  [<ffffffffa017b2f5>]
btrfs_clean_old_snapshots+0xed/0x150 [btrfs]
[46811.162841]  [<ffffffffa0173d7d>] cleaner_kthread+0x5a/0xe6 [btrfs]
[46811.162862]  [<ffffffffa0173d23>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
[46811.162869]  [<ffffffff8104c750>] kthread+0xba/0xc2
[46811.162875]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[46811.162882]  [<ffffffff815f301c>] ret_from_fork+0x7c/0xb0
[46811.162888]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[46811.162892] ---[ end trace 7528086f91b151b7 ]---
[46811.162904] BUG: unable to handle kernel paging request at 0000000047c5a000
[46811.163003] IP: [<ffffffffa017b30b>]
btrfs_clean_old_snapshots+0x103/0x150 [btrfs]
[46811.163003] PGD 0
[46811.163003] Oops: 0000 [#1] SMP
[46811.163003] Modules linked in: ipv6 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer
tg3 sr_mod snd i2c_i801 ppdev parport_pc iTCO_wdt iTCO_vendor_support
lpc_ich pcspkr parport floppy serio_raw microcode ablk_helper cryptd
lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd sunrpc
reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd
hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
[46811.163003] CPU 0
[46811.163003] Pid: 18210, comm: btrfs-cleaner Tainted: G        W
3.7.4-sad-v1+ #3 Dell Inc.                 OptiPlex 745
 /0WF810
[46811.163003] RIP: 0010:[<ffffffffa017b30b>]  [<ffffffffa017b30b>]
btrfs_clean_old_snapshots+0x103/0x150 [btrfs]
[46811.163003] RSP: 0018:ffff8800057fde38  EFLAGS: 00010296
[46811.163003] RAX: 0000000047c5a000 RBX: ffff880050c27800 RCX: 0000000000000008
[46811.163003] RDX: 0000000000000000 RSI: ffff8800057fdd70 RDI: ffff880050c27c70
[46811.163003] RBP: ffff8800057fde78 R08: 0000000000000000 R09: 0000000000000283
[46811.163003] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880000000000
[46811.163003] R13: 0000160000000000 R14: ffff8800057fde38 R15: ffff880050c27c38
[46811.163003] FS:  0000000000000000(0000) GS:ffff88007f200000(0000)
knlGS:0000000000000000
[46811.163003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[46811.163003] CR2: 0000000047c5a000 CR3: 000000003f270000 CR4: 00000000000007f0
[46811.163003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[46811.163003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[46811.163003] Process btrfs-cleaner (pid: 18210, threadinfo
ffff8800057fc000, task ffff88007c030d40)
[46811.163003] Stack:
[46811.163003]  ffff880050c27c38 ffff88001f488438 ffff8800057fde48
ffff88002d15b800
[46811.163003]  ffff88007c030d40 ffff88007c030d40 ffff88007c030d40
0000000000000000
[46811.163003]  ffff8800057fdeb8 ffffffffa0173d7d ffff88002d15b800
0000000000000000
[46811.163003] Call Trace:
[46811.163003]  [<ffffffffa0173d7d>] cleaner_kthread+0x5a/0xe6 [btrfs]
[46811.163003]  [<ffffffffa0173d23>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
[46811.163003]  [<ffffffff8104c750>] kthread+0xba/0xc2
[46811.163003]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[46811.163003]  [<ffffffff815f301c>] ret_from_fork+0x7c/0xb0
[46811.163003]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[46811.163003] Code: c7 c7 d5 b2 17 a0 31 c0 e8 b4 01 f3 e0 4c 89 ff
e8 bb e4 08 e1 48 89 df e8 f2 f5 03 00 49 8b 87 c8 fb ff ff 48 8b 80
50 01 00 00 <48> 8b 00 4c 01 e8 48 c1 f8 06 48 c1 e0 0c 42 0f b6 44 20
3f 31
[46811.163003] RIP  [<ffffffffa017b30b>]
btrfs_clean_old_snapshots+0x103/0x150 [btrfs]
[46811.163003]  RSP <ffff8800057fde38>
[46811.163003] CR2: 0000000047c5a000
[46811.238512] ---[ end trace 7528086f91b151b8 ]---
