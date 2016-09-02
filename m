Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43190 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932360AbcIBTel (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 15:34:41 -0400
Date: Fri, 2 Sep 2016 12:33:30 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: detect corruption when non-root leaf has zero
 item
Message-ID: <20160902193330.GA28360@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1470286628-4123-1-git-send-email-bo.li.liu@oracle.com>
 <1471990978-27124-1-git-send-email-bo.li.liu@oracle.com>
 <fe9b1bde-9069-b75f-eb53-83b729cde711@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fe9b1bde-9069-b75f-eb53-83b729cde711@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Sep 02, 2016 at 01:26:10AM -0400, Jeff Mahoney wrote:
> On 8/23/16 6:22 PM, Liu Bo wrote:
> > Right now we treat leaf which has zero item as a valid one
> > because we could have an empty tree, that is, a root that is
> > also a leaf without any item, however, in the same case but
> > when the leaf is not a root, we can end up with hitting the
> > BUG_ON(1) in btrfs_extend_item() called by
> > setup_inline_extent_backref().
> > 
> > This makes us check the situation as a corruption if leaf is
> > not its own root.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: fix code style.
> > 
> >  fs/btrfs/disk-io.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index a5a22be..8df7e73 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -559,8 +559,29 @@ static noinline int check_leaf(struct btrfs_root *root,
> >  	u32 nritems = btrfs_header_nritems(leaf);
> >  	int slot;
> >  
> > -	if (nritems == 0)
> > +	if (nritems == 0) {
> > +		struct btrfs_root *check_root;
> > +
> > +		key.objectid = btrfs_header_owner(leaf);
> > +		key.type = BTRFS_ROOT_ITEM_KEY;
> > +		key.offset = (u64)-1;
> > +
> > +		check_root = btrfs_get_fs_root(root->fs_info, &key, false);
> > +		/*
> > +		 * The only reason we also check NULL here is that during
> > +		 * open_ctree() some roots has not yet been set up.
> > +		 */
> > +		if (!IS_ERR_OR_NULL(check_root)) {
> > +			/* if leaf is the root, then it's fine */
> > +			if (leaf->start !=
> > +			    btrfs_root_bytenr(&check_root->root_item)) {
> > +				CORRUPT("non-root leaf's nritems is 0",
> > +					leaf, root, 0);
> > +				return -EIO;
> > +			}
> > +		}
> >  		return 0;
> > +	}
> >  
> >  	/* Check the 0 item */
> >  	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=
> > 
> 
> Hi Liu -
> 
> This is causing probs with integrity checking turned on.

Thanks a lot for the report, just sent a fix, with which it doesn't panic any
more here.

Luckily it doesn't panic without integrity checking, otherwise we kind of
screw up every btrfs.

Thanks,

-liubo

> 
> [  124.716069] ------------[ cut here ]------------
> [  124.725914] kernel BUG at fs/btrfs/ctree.h:3396!
> [  124.739316] invalid opcode: 0000 [#1] PREEMPT SMP
> [  124.746888] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache iscsi_ibft iscsi_boot_sysfs af_packet ipmi_ssif igb ptp pps_core dca sp5100_tco fjes acpi_cpufreq shpchp i2c_piix4 kvm_amd kvm k10temp tpm_infineon tpm_tis tpm_tis_core ipmi_si button pcspkr serio_raw ipmi_msghandler tpm irqbypass nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_mod btrfs xor zlib_deflate ohci_pci raid6_pq ohci_hcd ehci_pci ata_generic ehci_hcd mgag200 i2c_algo_bit drm_kms_helper usbcore syscopyarea pata_atiixp sysfillrect sysimgblt usb_common fb_sys_fops ttm drm sg
> [  124.815657] CPU: 9 PID: 2972 Comm: mount Not tainted 4.8.0-rc4-vanilla+ #18
> [  124.826173] Hardware name: HP ProLiant DL165 G7, BIOS O37 10/17/2012
> [  124.836043] task: ffff88033b450200 task.stack: ffff880337a70000
> [  124.845445] RIP: 0010:[<ffffffffa0424171>]  [<ffffffffa0424171>] assfail.constprop.60+0x1e/0x20 [btrfs]
> [  124.858936] RSP: 0018:ffff880337a73570  EFLAGS: 00010292
> [  124.867793] RAX: 0000000000000076 RBX: ffff8804376ef250 RCX: ffffffff81c52f08
> [  124.878735] RDX: 0000000000000001 RSI: 0000000000000286 RDI: 0000000000000286
> [  124.889661] RBP: ffff880337a73570 R08: 000000000000041a R09: 0000000000000000
> [  124.900597] R10: 0000000000000003 R11: 0000000000000006 R12: ffff880337f97800
> [  124.911563] R13: 0000000000000007 R14: 0000000000000000 R15: ffff880435024000
> [  124.922522] FS:  00007fa4662c1840(0000) GS:ffff88043fc40000(0000) knlGS:0000000000000000
> [  124.934581] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  124.944015] CR2: 00007ff68dcd2095 CR3: 000000033ae32000 CR4: 00000000000006e0
> [  124.955036] Stack:
> [  124.960294]  ffff880337a73598 ffffffffa038fb04 ffff8804376ef250 ffff88043b45ebd0
> [  124.971723]  ffff88042c6225a0 ffff880337a73618 ffffffffa036a5f1 0000000000000000
> [  124.983186]  0000000000000000 ffff880100000000 ffff880337a736d8 ffff88043b45ebd0
> [  124.994675] Call Trace:
> [  125.000638]  [<ffffffffa038fb04>] btrfs_mark_buffer_dirty+0xf4/0x120 [btrfs]
> [  125.011816]  [<ffffffffa036a5f1>] __btrfs_cow_block+0x311/0x5a0 [btrfs]
> [  125.022524]  [<ffffffffa036aa36>] btrfs_cow_block+0x136/0x210 [btrfs]
> [  125.033025]  [<ffffffffa036e4ba>] btrfs_search_slot+0x1ea/0x960 [btrfs]
> [  125.043731]  [<ffffffffa0389636>] btrfs_del_csums+0xd6/0x2b0 [btrfs]
> [  125.054169]  [<ffffffffa03bbf5b>] ? free_extent_buffer+0x4b/0x90 [btrfs]
> [  125.064999]  [<ffffffffa03776f5>] __btrfs_free_extent.isra.72+0x675/0xc60 [btrfs]
> [  125.076739]  [<ffffffffa037bcb7>] __btrfs_run_delayed_refs.constprop.81+0x467/0x12b0 [btrfs]
> [  125.089591]  [<ffffffffa03b15c9>] ? btrfs_get_token_32+0x59/0xe0 [btrfs]
> [  125.100486]  [<ffffffffa037fa23>] btrfs_run_delayed_refs+0x93/0x2a0 [btrfs]
> [  125.111676]  [<ffffffffa03842a9>] btrfs_start_dirty_block_groups+0x299/0x410 [btrfs]
> [  125.123752]  [<ffffffffa03966d5>] btrfs_commit_transaction+0x155/0xae0 [btrfs]
> [  125.135289]  [<ffffffffa03c27b9>] btrfs_create_uuid_tree+0x59/0x130 [btrfs]
> [  125.146532]  [<ffffffffa039386d>] open_ctree+0x266d/0x2860 [btrfs]
> [  125.156916]  [<ffffffffa0366ab4>] btrfs_mount+0xca4/0xec0 [btrfs]
> [  125.167162]  [<ffffffff813cd4ae>] ? find_next_zero_bit+0x1e/0x20
> [  125.177329]  [<ffffffff811bedfe>] ? pcpu_next_unpop+0x3e/0x50
> [  125.187204]  [<ffffffff813cd489>] ? find_next_bit+0x19/0x20
> [  125.196875]  [<ffffffff81227aa9>] mount_fs+0x39/0x160
> [  125.205958]  [<ffffffff811c0035>] ? __alloc_percpu+0x15/0x20
> [  125.215737]  [<ffffffff81243767>] vfs_kern_mount+0x67/0x110
> [  125.225456]  [<ffffffffa0365f9b>] btrfs_mount+0x18b/0xec0 [btrfs]
> [  125.235721]  [<ffffffff813cd4ae>] ? find_next_zero_bit+0x1e/0x20
> [  125.245827]  [<ffffffff81227aa9>] mount_fs+0x39/0x160
> [  125.254789]  [<ffffffff811c0035>] ? __alloc_percpu+0x15/0x20
> [  125.264359]  [<ffffffff81243767>] vfs_kern_mount+0x67/0x110
> [  125.273734]  [<ffffffff81246461>] do_mount+0x1c1/0xbe0
> [  125.282527]  [<ffffffff81247163>] SyS_mount+0x83/0xd0
> [  125.291119]  [<ffffffff816fee76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
> [  125.301200] Code: 88 00 00 00 31 c0 eb 03 83 c8 ff 5d c3 55 89 f1 48 c7 c2 20 eb 42 a0 48 89 fe 31 c0 48 c7 c7 70 eb 42 a0 48 89 e5 e8 97 2a d7 e0 <0f> 0b 55 89 f1 48 c7 c2 68 f8 42 a0 48 89 fe 31 c0 48 c7 c7 58
> [  125.328902] RIP  [<ffffffffa0424171>] assfail.constprop.60+0x1e/0x20 [btrfs]
> [  125.339842]  RSP <ffff880337a73570>
> [  125.361059] ---[ end trace e840015104025162 ]---
> 
> -Jeff
> 
> -- 
> Jeff Mahoney
> SUSE Labs
> 



