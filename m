From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add compability for kernels >=2.6.27-rc1
Date: Thu, 31 Jul 2008 20:27:01 +0100
Message-ID: <1217532421.3454.291.camel@pmac.infradead.org>
References: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net>
	 <20080730195628.GP20055@kernel.dk>
	 <1217448700.20239.30.camel@think.oraclecorp.com>
	 <20080730201333.GR20055@kernel.dk>
	 <1217450622.20239.32.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Sven Wegener <sven.wegener@stealer.net>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1217450622.20239.32.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-30 at 16:43 -0400, Chris Mason wrote:
> On Wed, 2008-07-30 at 22:13 +0200, Jens Axboe wrote:
> 
> [ rcu page cache ]
> 
> > > > For btrfs's usage, it should be safe with a simple rcu_read_lock(), if
> > > > the return is referenced safely.
> > > > 
> > > 
> > > This btrfs code is basically a find_get_page without the get.  It should
> > > only be called when I know I already have a reference on the page.
> > 
> > Then it's definitely safe ;-)
> > 
> 
> Yeah, I'm testing on the latest git now and it all seems ok.  I'll push
> this out, thanks Sven.

Seems to crash for me with Linus' current tree. I thought it was
something to do with my fixes for NFS export, but now I've hooked up a
serial console and managed to catch it, I suspect not...

BUG: unable to handle kernel paging request at ffff880107c2aa00
IP: [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c [btrfs]
PGD 202063 PUD c067 PMD 10a844163 PTE 8000000107c2a160
Oops: 0000 [1] SMP DEBUG_PAGEALLOC
CPU 3 
Modules linked in: btrfs libcrc32c nfsd lockd nfs_acl auth_rpcgss exportfs mtdram jffs2 mtd zlib_deflate i915 drm bridge stp bnep rfcomm l2cap bluetooth fuse sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_log dm_multipath dm_mod snd_pcsp snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device sr_mod cdrom snd_pcm_oss snd_mixer_oss firewire_ohci firewire_core snd_pcm floppy i2c_i801 i2c_core snd_timer pata_marvell crc_itu_t iTCO_wdt e1000e snd_hwdep snd_page_alloc ata_generic iTCO_vendor_support pata_acpi snd soundcore ahci ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: jffs2]
Pid: 3273, comm: btrfs Tainted: G        W 2.6.27-rc1 #1
RIP: 0010:[<ffffffffa03e73bc>]  [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c [btrfs]
RSP: 0018:ffff88010e581e10  EFLAGS: 00010082
RAX: 0000000000000002 RBX: ffff880107c2aae0 RCX: 0000000000000001
RDX: 0000000000000005 RSI: ffff880107c2aae0 RDI: ffffffff810644db
RBP: ffff88010e581e80 R08: ffff88010e581cb0 R09: ffff88000000d000
R10: 0000000000000002 R11: ffff88010e581d30 R12: ffff880107c2aa08
R13: ffff880107c2a9f8 R14: 0000000000080000 R15: ffffe200063eb920
FS:  0000000000000000(0000) GS:ffff880127c41e10(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff880107c2aa00 CR3: 000000010b5b0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 3273, threadinfo ffff88010e580000, task ffff88010b190000)
Stack:  ffff88010b58e540 0000000000001000 ffff88010c60f1d8 0000000181065346
 ffff88010a995d70 ffff88010c60f1b8 0000000000080000 0000000000000282
 000000010e581e90 0000000000000000 ffff88010b5ff620 ffff88010b58e540
Call Trace:
 [<ffffffff810f1aa4>] bio_endio+0x2f/0x31
 [<ffffffffa03d0bbf>] end_workqueue_fn+0x108/0x114 [btrfs]
 [<ffffffffa03ebdc8>] worker_loop+0x6b/0x14e [btrfs]
 [<ffffffffa03ebd5d>] ? worker_loop+0x0/0x14e [btrfs]
 [<ffffffff81057b34>] kthread+0x4e/0x7b
 [<ffffffff81011849>] child_rip+0xa/0x11
 [<ffffffff81010b5e>] ? restore_args+0x0/0x30
 [<ffffffff81057ae6>] ? kthread+0x0/0x7b
 [<ffffffff8101183f>] ? child_rip+0x0/0x11


Code: de e8 15 d5 ff ff 4c 39 75 c0 74 1a 73 13 be d5 05 00 00 48 c7 c7 fc fd 3e a0 e8 1c c5 c5 e0 eb 05 4d 85 e4 75 a4 4d 85 ed 74 19 <49> 8b 45 08 48 ff c0 4c 39 f0 75 0a 41 f6 85 80 00 00 00 02 75 
RIP  [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c [btrfs]
 RSP <ffff88010e581e10>
CR2: ffff880107c2aa00
---[ end trace 4eaa2a86a8e2da22 ]---
BUG: unable to handle kernel paging request at ffff880107ced918
IP: [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c [btrfs]
PGD 202063 PUD c067 PMD 10a844163 PTE 8000000107ced160
Oops: 0000 [2] SMP DEBUG_PAGEALLOC
CPU 3 
Modules linked in: btrfs libcrc32c nfsd lockd nfs_acl auth_rpcgss exportfs mtdram jffs2 mtd zlib_deflate i915 drm bridge stp bnep rfcomm l2cap bluetooth fuse sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_log dm_multipath dm_mod snd_pcsp snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device sr_mod cdrom snd_pcm_oss snd_mixer_oss firewire_ohci firewire_core snd_pcm floppy i2c_i801 i2c_core snd_timer pata_marvell crc_itu_t iTCO_wdt e1000e snd_hwdep snd_page_alloc ata_generic iTCO_vendor_support pata_acpi snd soundcore ahci ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: jffs2]
Pid: 3274, comm: btrfs Tainted: G      D W 2.6.27-rc1 #1
RIP: 0010:[<ffffffffa03e73bc>]  [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c [btrfs]
RSP: 0018:ffff88010b95fe10  EFLAGS: 00010082
RAX: 0000000000000002 RBX: ffff880107ced9f8 RCX: 0000000000000001
RDX: 0000000000000005 RSI: ffff880107ced9f8 RDI: ffffffff810644db
RBP: ffff88010b95fe80 R08: ffff88010b95fcb0 R09: ffff88000000d000
R10: 0000000000000002 R11: ffff88010b95fd30 R12: ffff880107ced920
R13: ffff880107ced910 R14: 0000000000080000 R15: ffffe20006321d20
FS:  0000000000000000(0000) GS:ffff880127c41e10(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff880107ced918 CR3: 000000010b5b0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 3274, threadinfo ffff88010b95e000, task ffff88010b192580)
Stack:  ffff88010a879240 0000000000001000 ffff88010c7a71d8 0000000181065346
 ffff88010a9e3b70 ffff88010c7a71b8 0000000000080000 0000000000000282
 000000010b95fe90 0000000000000000 ffff88010e59d8c0 ffff88010a879240
Call Trace:
 [<ffffffff810f1aa4>] bio_endio+0x2f/0x31
 [<ffffffffa03d0bbf>] end_workqueue_fn+0x108/0x114 [btrfs]
 [<ffffffffa03ebdc8>] worker_loop+0x6b/0x14e [btrfs]
 [<ffffffffa03ebd5d>] ? worker_loop+0x0/0x14e [btrfs]
 [<ffffffff81057b34>] kthread+0x4e/0x7b
 [<ffffffff81011849>] child_rip+0xa/0x11
 [<ffffffff81010b5e>] ? restore_args+0x0/0x30
 [<ffffffff81057ae6>] ? kthread+0x0/0x7b
 [<ffffffff8101183f>] ? child_rip+0x0/0x11


Code: de e8 15 d5 ff ff 4c 39 75 c0 74 1a 73 13 be d5 05 00 00 48 c7 c7 fc fd 3e a0 e8 1c c5 c5 e0 eb 05 4d 85 e4 75 a4 4d 85 ed 74 19 <49> 8b 45 08 48 ff c0 4c 39 f0 75 0a 41 f6 85 80 00 00 00 02 75 
RIP  [<ffffffffa03e73bc>] end_bio_extent_writepage+0x1f4/0x29c [btrfs]
 RSP <ffff88010b95fe10>
CR2: ffff880107ced918
---[ end trace 4eaa2a86a8e2da22 ]---


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



