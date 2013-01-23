Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18832 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3AWHyw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 02:54:52 -0500
Date: Wed, 23 Jan 2013 15:51:57 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com,
        dave@jikos.cz, kitayama@cl.bb4u.ne.jp, miaox@cn.fujitsu.com
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
Message-ID: <20130123075155.GE17162@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
 <CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
 <CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 11:41:19AM -0600, Mitch Harder wrote:
> On Thu, Jan 17, 2013 at 8:42 AM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
> > On Wed, Jan 16, 2013 at 6:36 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >> This comes from one of btrfs's project ideas,
> >> As we defragment files, we break any sharing from other snapshots.
> >> The balancing code will preserve the sharing, and defrag needs to grow this
> >> as well.
[...]
> >
> > I've been testing this patch on a 3.7.2 kernel merged with the
> > for-linus branch for the 3.8_rc kernels, and I'm seeing the following
> > error:
> >
> 
> I've reproduced the error with CONFIG_DEBUG_LIST enabled, which shows
> some problem with an entry in the list.
> 
> [59312.260441] ------------[ cut here ]------------
> [59312.260454] WARNING: at lib/list_debug.c:62 __list_del_entry+0x8d/0x98()
> [59312.260458] Hardware name: OptiPlex 745
> [59312.260461] list_del corruption. next->prev should be
> ffff88006511c438, but was dead000000200200

LIST_POISON2 -> (000000200200)
So we can know that the next one is deleted from the list even _earlier_
than the current one is.

Any other messages before this warning complains?

thanks,
liubo

> [59312.260464] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel i2c_i801 tg3 snd_hda_codec iTCO_wdt snd_hwdep snd_pcm
> ppdev parport_pc sr_mod microcode floppy parport snd_page_alloc
> snd_timer snd iTCO_vendor_support lpc_ich serio_raw pcspkr ablk_helper
> cryptd lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd
> sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache
> sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
> [59312.260519] Pid: 20523, comm: btrfs-cleaner Not tainted 3.7.2-sad+ #1
> [59312.260521] Call Trace:
> [59312.260529]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
> [59312.260549]  [<ffffffffa015aa01>] ? reada_for_balance+0x187/0x218 [btrfs]
> [59312.260554]  [<ffffffff81030641>] warn_slowpath_fmt+0x46/0x48
> [59312.260566]  [<ffffffffa015aa01>] ? reada_for_balance+0x187/0x218 [btrfs]
> [59312.260570]  [<ffffffff812099e5>] __list_del_entry+0x8d/0x98
> [59312.260574]  [<ffffffff812099fe>] list_del+0xe/0x2e
> [59312.260590]  [<ffffffffa017b325>]
> btrfs_clean_old_snapshots+0x101/0x168 [btrfs]
> [59312.260605]  [<ffffffffa0173d99>] cleaner_kthread+0x5a/0xe6 [btrfs]
> [59312.260619]  [<ffffffffa0173d3f>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
> [59312.260624]  [<ffffffff8104c750>] kthread+0xba/0xc2
> [59312.260629]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [59312.260634]  [<ffffffff815f2f1c>] ret_from_fork+0x7c/0xb0
> [59312.260639]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [59312.260642] ---[ end trace 61b4cbd93690300f ]---
> [59318.623735] ------------[ cut here ]------------
> [59318.623751] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
> [59318.623755] Hardware name: OptiPlex 745
> [59318.623760] list_del corruption, ffff88006511c438->next is
> LIST_POISON1 (dead000000100100)
> [59318.623766] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel i2c_i801 tg3 snd_hda_codec iTCO_wdt snd_hwdep snd_pcm
> ppdev parport_pc sr_mod microcode floppy parport snd_page_alloc
> snd_timer snd iTCO_vendor_support lpc_ich serio_raw pcspkr ablk_helper
> cryptd lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd
> sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache
> sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
> [59318.623840] Pid: 20523, comm: btrfs-cleaner Tainted: G        W
> 3.7.2-sad+ #1
> [59318.623844] Call Trace:
> [59318.623855]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
> [59318.623878]  [<ffffffffa015aab9>] ? btrfs_free_path+0x27/0x2c [btrfs]
> [59318.623885]  [<ffffffff81030641>] warn_slowpath_fmt+0x46/0x48
> [59318.623901]  [<ffffffffa015aab9>] ? btrfs_free_path+0x27/0x2c [btrfs]
> [59318.623907]  [<ffffffff812099e5>] __list_del_entry+0x8d/0x98
> [59318.623912]  [<ffffffff812099fe>] list_del+0xe/0x2e
> [59318.623935]  [<ffffffffa017b325>]
> btrfs_clean_old_snapshots+0x101/0x168 [btrfs]
> [59318.623955]  [<ffffffffa0173d99>] cleaner_kthread+0x5a/0xe6 [btrfs]
> [59318.623975]  [<ffffffffa0173d3f>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
> [59318.623981]  [<ffffffff8104c750>] kthread+0xba/0xc2
> [59318.623988]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [59318.623994]  [<ffffffff815f2f1c>] ret_from_fork+0x7c/0xb0
> [59318.624000]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [59318.624022] ---[ end trace 61b4cbd936903010 ]---
> [59318.626394] general protection fault: 0000 [#1] SMP
> [59318.626439] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel i2c_i801 tg3 snd_hda_codec iTCO_wdt snd_hwdep snd_pcm
> ppdev parport_pc sr_mod microcode floppy parport snd_page_alloc
> snd_timer snd iTCO_vendor_support lpc_ich serio_raw pcspkr ablk_helper
> cryptd lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd
> sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache
> sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
> [59318.626832] CPU 0
> [59318.626849] Pid: 20523, comm: btrfs-cleaner Tainted: G        W
> 3.7.2-sad+ #1 Dell Inc.                 OptiPlex 745
> /0WF810
> [59318.626926] RIP: 0010:[<ffffffffa017b349>]  [<ffffffffa017b349>]
> btrfs_clean_old_snapshots+0x125/0x168 [btrfs]
> [59318.627018] RSP: 0018:ffff880078f43e38  EFLAGS: 00010206
> [59318.627054] RAX: 0005800000021000 RBX: ffff880000000000 RCX: 0000000000000008
> [59318.627098] RDX: 0000000000000000 RSI: ffff880078f43d70 RDI: ffff88006511c470
> [59318.627141] RBP: ffff880078f43e78 R08: 0000000000000000 R09: ffff88004b61c3f0
> [59318.627184] R10: 0000000000000001 R11: 0000000000000000 R12: 0000160000000000
> [59318.627228] R13: ffff880078f43e38 R14: ffff88006511c000 R15: ffff88006511c438
> [59318.627272] FS:  0000000000000000(0000) GS:ffff88007f200000(0000)
> knlGS:0000000000000000
> [59318.627322] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [59318.627358] CR2: 00007ff8b6d33375 CR3: 00000000788a0000 CR4: 00000000000007f0
> [59318.627402] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [59318.627445] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [59318.627490] Process btrfs-cleaner (pid: 20523, threadinfo
> ffff880078f42000, task ffff88007c999a80)
> [59318.627543] Stack:
> [59318.627557]  ffff88006511c438 ffff880002046438 ffff880078f43e48
> ffff880028017800
> [59318.627611]  ffff88007c999a80 ffff88007c999a80 ffff88007c999a80
> 0000000000000000
> [59318.627663]  ffff880078f43eb8 ffffffffa0173d99 ffff880028017800
> 0000000000000000
> [59318.627719] Call Trace:
> [59318.627751]  [<ffffffffa0173d99>] cleaner_kthread+0x5a/0xe6 [btrfs]
> [59318.627804]  [<ffffffffa0173d3f>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
> [59318.627853]  [<ffffffff8104c750>] kthread+0xba/0xc2
> [59318.627898]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [59318.627948]  [<ffffffff815f2f1c>] ret_from_fork+0x7c/0xb0
> [59318.627986]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [59318.628033] Code: 89 ff e8 cb e6 08 e1 4c 89 f7 e8 22 f4 03 00 49
> 8b 87 c8 fb ff ff 48 8b 80 50 01 00 00 48 8b 00 4c 01 e0 48 c1 f8 06
> 48 c1 e0 0c <0f> b6 44 18 3f 31 c9 31 d2 85 c0 7e 05 ba 01 00 00 00 31
> f6 4c
> [59318.628279] RIP  [<ffffffffa017b349>]
> btrfs_clean_old_snapshots+0x125/0x168 [btrfs]
> [59318.628295]  RSP <ffff880078f43e38>
> [59318.634447] ---[ end trace 61b4cbd936903011 ]---
