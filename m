Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41109 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3F2KtI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 06:49:08 -0400
Date: Sat, 29 Jun 2013 18:48:59 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130629104858.GB7849@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372386339-32599-1-git-send-email-bo.li.liu@oracle.com>
 <20130628170821.GY4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130628170821.GY4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 28, 2013 at 01:08:21PM -0400, Josef Bacik wrote:
> On Fri, Jun 28, 2013 at 10:25:39AM +0800, Liu Bo wrote:
> > Several users reported this crash of NULL pointer or general protection,
> > the story is that we add a rbtree for speedup ulist iteration, and we
> > use krealloc() to address ulist growth, and krealloc() use memcpy to copy
> > old data to new memory area, so it's OK for an array as it doesn't use
> > pointers while it's not OK for a rbtree as it uses pointers.
> > 
> > So krealloc() will mess up our rbtree and it ends up with crash.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: fix an use-after-free bug and a finger error(Thanks Zach and Josef).
> > 
> 
> Is this supposed to fix this bug?
> 
> [ 1215.561033] ------------[ cut here ]------------
> [ 1215.561064] kernel BUG at fs/btrfs/ctree.c:1183!
> [ 1215.561087] invalid opcode: 0000 [#1] PREEMPT SMP
> [ 1215.561114] Modules linked in: btrfs raid6_pq zlib_deflate xor libcrc32c ebtable_nat ebtables ipt_MASQUERADE
> iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle bridge stp llc lockd be2iscsi iscsi_boot_sysfs bnx2i cnic uio
> cxgb4
> i cxgb4 cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ip6t_REJECT nf_conntrack_ipv6 ib_core
> nf_defrag_ipv6 ib_addr nf_conntrack_ipv4 iscsi_tcp nf_defrag_ipv4 xt_state nf_conntrack libiscsi_tcp ip6table_filter
> libisc
> si ip6_tables scsi_transport_iscsi snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
> snd_seq snd_seq_device snd_pcm vhost_net snd_timer macvtap snd macvlan tun virtio_net soundcore kvm_amd sunrpc kvm
> snd_page
> _alloc sp5100_tco edac_core microcode pcspkr serio_raw k10temp edac_mce_amd i2c_piix4 r8169 mii iomemory_vsl(OF) floppy
> firewire_ohci firewire_core ata_generic pata_acpi crc_itu_t pata_via radeon ttm drm_kms_helper drm i2c_algo_bit i2c_c
> ore
> [ 1215.561585] CPU 1
> [ 1215.561597] Pid: 28188, comm: btrfs-endio-wri Tainted: GF          O 3.9.0+ #9 To Be Filled By O.E.M. To Be Filled By
> O.E.M./890FX Deluxe5
> [ 1215.561649] RIP: 0010:[<ffffffffa06f529b>]  [<ffffffffa06f529b>] __tree_mod_log_rewind+0x26b/0x270 [btrfs]
> [ 1215.561706] RSP: 0018:ffff8803b7529828  EFLAGS: 00010293
> [ 1215.561729] RAX: 0000000000000000 RBX: ffff8803b42d5960 RCX: ffff8803b75297c8
> [ 1215.561759] RDX: 000000000002577d RSI: 0000000000000921 RDI: ffff8803b3e92440
> [ 1215.561788] RBP: ffff8803b7529858 R08: 0000000000001000 R09: ffff8803b75297d8
> [ 1215.561818] R10: 0000000000001bbb R11: 0000000000000000 R12: ffff8803b630ddc0
> [ 1215.561848] R13: 0000000000000044 R14: ffff8803b3e92540 R15: 00017add00000000
> [ 1215.561878] FS:  00007f9ba1ce7700(0000) GS:ffff88043fc40000(0000) knlGS:0000000000000000
> [ 1215.561911] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1215.561936] CR2: 00007fa4a6148d90 CR3: 0000000427ff7000 CR4: 00000000000007e0
> [ 1215.561965] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1215.561995] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1215.562025] Process btrfs-endio-wri (pid: 28188, threadinfo ffff8803b7528000, task ffff8803eb5a97d0)
> [ 1215.562063] Stack:
> [ 1215.562073]  ffff88042998e1c0 ffff880000000000 ffff88042998e1c0 ffff8803c41b8000
> [ 1215.562109]  ffff8803b43c4e20 0000000000000001 ffff8803b7529908 ffffffffa06fda47
> [ 1215.562146]  ffff8803b7694458 00017add00000000 ffff8803b7529888 ffff8803b42d5960
> [ 1215.562182] Call Trace:
> [ 1215.562200]  [<ffffffffa06fda47>] btrfs_search_old_slot+0x757/0xa40 [btrfs]
> [ 1215.562237]  [<ffffffffa0779fcd>] __resolve_indirect_refs+0x11d/0x670 [btrfs]
> [ 1215.562273]  [<ffffffffa077ab4c>] find_parent_nodes+0x1fc/0xe90 [btrfs]
> [ 1215.562307]  [<ffffffffa077b879>] btrfs_find_all_roots+0x99/0x100 [btrfs]
> [ 1215.562341]  [<ffffffffa07240b0>] ? btrfs_submit_direct+0x680/0x680 [btrfs]
> [ 1215.562376]  [<ffffffffa077c224>] iterate_extent_inodes+0x144/0x2f0 [btrfs]
> [ 1215.562412]  [<ffffffffa077c462>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
> [ 1215.562449]  [<ffffffffa07240b0>] ? btrfs_submit_direct+0x680/0x680 [btrfs]
> [ 1215.562484]  [<ffffffffa07214f8>] record_extent_backrefs+0x78/0xf0 [btrfs]
> [ 1215.562519]  [<ffffffffa072bac6>] btrfs_finish_ordered_io+0x156/0x9d0 [btrfs]
> [ 1215.562556]  [<ffffffffa072c355>] finish_ordered_fn+0x15/0x20 [btrfs]
> [ 1215.562589]  [<ffffffffa074d96a>] worker_loop+0x16a/0x570 [btrfs]
> [ 1215.562618]  [<ffffffff8108f348>] ? __wake_up_common+0x58/0x90
> [ 1215.562649]  [<ffffffffa074d800>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
> [ 1215.562680]  [<ffffffff81086c10>] kthread+0xc0/0xd0
> [ 1215.562703]  [<ffffffff81650000>] ? acpi_processor_add+0xcb/0x47d
> [ 1215.562731]  [<ffffffff81086b50>] ? flush_kthread_worker+0xb0/0xb0
> [ 1215.562758]  [<ffffffff8166452c>] ret_from_fork+0x7c/0xb0
> [ 1215.562783]  [<ffffffff81086b50>] ? flush_kthread_worker+0xb0/0xb0
> [ 1215.562809] Code: c1 49 63 46 58 48 89 c2 48 c1 e2 05 48 8d 54 10 65 49 63 46 2c 48 89 c6 48 c1 e6 05 48 8d 74 30 65
> e8 0a c7 04 00 e9 9d fe ff ff <0f> 0b 0f 0b 90 66 66 66 66 90 55 48 b8 00 00 00 00 00 16 00 00
> [ 1215.562987] RIP  [<ffffffffa06f529b>] __tree_mod_log_rewind+0x26b/0x270 [btrfs]
> [ 1215.563023]  RSP <ffff8803b7529828>
> [ 1215.571784] ---[ end trace 89bb18f7414e2e9e ]---
> 
> Cause if so it didn't fix it :).  If not just ignore me.  Thanks,
> 
> Josef

It's not, but I'm curious how you run into this one, could you please
show the steps?

- liubo
