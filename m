Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50923 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3BUJwd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 04:52:33 -0500
Message-ID: <5125EE8E.9010903@cn.fujitsu.com>
Date: Thu, 21 Feb 2013 17:53:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel WARNINGs on btrfs-next
References: <CAKcLGm9g-c8oJu_ZymZ+kiAb_fq219AeUNXRrw4kdQQw9gM_BQ@mail.gmail.com>
In-Reply-To: <CAKcLGm9g-c8oJu_ZymZ+kiAb_fq219AeUNXRrw4kdQQw9gM_BQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On wed, 20 Feb 2013 23:35:36 -0600, Mitch Harder wrote:
> I'm getting a series of kernel WARNING messages when testing Josef's
> btrfs-next and Chris' next branch running xfstests 083 when mounted
> with compress-force=lzo.
> 
> I'm not seeing any other indications of problems other than the
> WARNINGs on xfstests 083, so this may be some sort of false positive.
> 
> Here are the messages against Chris' -next branch (the same warnings
> are being generated against josef's branch, except against a 3.7.x
> kernel):

I sent a patch to fix this problem as a reply of this mail, could you
test it for me?

Thanks
Miao 

> 
> [  553.194991] ------------[ cut here ]------------
> [  553.195002] WARNING: at fs/btrfs/inode.c:7908
> btrfs_destroy_inode+0x67/0x25b [btrfs]()
> [  553.195043] Hardware name: OptiPlex 745
> [  553.195046] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel snd_hda_codec snd_hwdep ppdev parport_pc snd_pcm
> snd_page_alloc snd_timer snd floppy sr_mod i2c_i801 tg3 ptp iTCO_wdt
> pps_core iTCO_vendor_support ehci_pci parport lpc_ich microcode
> serio_raw pcspkr ablk_helper cryptd lrw xts gf128mul aes_x86_64
> sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
> ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
> ohci_hcd uhci_hcd ehci_hcd
> [  553.195099] Pid: 4674, comm: rm Not tainted 3.8.0-mason-next+ #1
> [  553.195102] Call Trace:
> [  553.195112]  [<ffffffff81030522>] warn_slowpath_common+0x83/0x9b
> [  553.195118]  [<ffffffff81030554>] warn_slowpath_null+0x1a/0x1c
> [  553.195135]  [<ffffffffa018d69e>] btrfs_destroy_inode+0x67/0x25b [btrfs]
> [  553.195141]  [<ffffffff8111759a>] destroy_inode+0x3b/0x54
> [  553.195145]  [<ffffffff811176fc>] evict+0x149/0x151
> [  553.195149]  [<ffffffff81117f82>] iput+0x12c/0x135
> [  553.195166]  [<ffffffffa0187f42>] ? btrfs_unlink_inode+0x38/0x40 [btrfs]
> [  553.195171]  [<ffffffff8110de10>] do_unlinkat+0x145/0x1df
> [  553.195177]  [<ffffffff81106e9f>] ? sys_newfstatat+0x2a/0x33
> [  553.195191]  [<ffffffff8110fce5>] sys_unlinkat+0x29/0x2b
> [  553.195212]  [<ffffffff81607746>] system_call_fastpath+0x1a/0x1f
> [  553.195224] ---[ end trace 0adc4db1ad1a6634 ]---
> [  553.195231] ------------[ cut here ]------------
> [  553.195247] WARNING: at fs/btrfs/inode.c:7909
> btrfs_destroy_inode+0x7e/0x25b [btrfs]()
> [  553.195249] Hardware name: OptiPlex 745
> [  553.195251] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel snd_hda_codec snd_hwdep ppdev parport_pc snd_pcm
> snd_page_alloc snd_timer snd floppy sr_mod i2c_i801 tg3 ptp iTCO_wdt
> pps_core iTCO_vendor_support ehci_pci parport lpc_ich microcode
> serio_raw pcspkr ablk_helper cryptd lrw xts gf128mul aes_x86_64
> sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
> ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
> ohci_hcd uhci_hcd ehci_hcd
> [  553.195296] Pid: 4674, comm: rm Tainted: G        W    3.8.0-mason-next+ #1
> [  553.195298] Call Trace:
> [  553.195304]  [<ffffffff81030522>] warn_slowpath_common+0x83/0x9b
> [  553.195308]  [<ffffffff81030554>] warn_slowpath_null+0x1a/0x1c
> [  553.195324]  [<ffffffffa018d6b5>] btrfs_destroy_inode+0x7e/0x25b [btrfs]
> [  553.195329]  [<ffffffff8111759a>] destroy_inode+0x3b/0x54
> [  553.195333]  [<ffffffff811176fc>] evict+0x149/0x151
> [  553.195336]  [<ffffffff81117f82>] iput+0x12c/0x135
> [  553.195352]  [<ffffffffa0187f42>] ? btrfs_unlink_inode+0x38/0x40 [btrfs]
> [  553.195356]  [<ffffffff8110de10>] do_unlinkat+0x145/0x1df
> [  553.195360]  [<ffffffff81106e9f>] ? sys_newfstatat+0x2a/0x33
> [  553.195364]  [<ffffffff8110fce5>] sys_unlinkat+0x29/0x2b
> [  553.195368]  [<ffffffff81607746>] system_call_fastpath+0x1a/0x1f
> [  553.195371] ---[ end trace 0adc4db1ad1a6635 ]---
> [  553.195373] ------------[ cut here ]------------
> [  553.195389] WARNING: at fs/btrfs/inode.c:7911
> btrfs_destroy_inode+0xae/0x25b [btrfs]()
> [  553.195391] Hardware name: OptiPlex 745
> [  553.195393] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel snd_hda_codec snd_hwdep ppdev parport_pc snd_pcm
> snd_page_alloc snd_timer snd floppy sr_mod i2c_i801 tg3 ptp iTCO_wdt
> pps_core iTCO_vendor_support ehci_pci parport lpc_ich microcode
> serio_raw pcspkr ablk_helper cryptd lrw xts gf128mul aes_x86_64
> sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
> ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
> ohci_hcd uhci_hcd ehci_hcd
> [  553.195437] Pid: 4674, comm: rm Tainted: G        W    3.8.0-mason-next+ #1
> [  553.195439] Call Trace:
> [  553.195444]  [<ffffffff81030522>] warn_slowpath_common+0x83/0x9b
> [  553.195449]  [<ffffffff81030554>] warn_slowpath_null+0x1a/0x1c
> [  553.195463]  [<ffffffffa018d6e5>] btrfs_destroy_inode+0xae/0x25b [btrfs]
> [  553.195470]  [<ffffffff8111759a>] destroy_inode+0x3b/0x54
> [  553.195474]  [<ffffffff811176fc>] evict+0x149/0x151
> [  553.195480]  [<ffffffff81117f82>] iput+0x12c/0x135
> [  553.195495]  [<ffffffffa0187f42>] ? btrfs_unlink_inode+0x38/0x40 [btrfs]
> [  553.195499]  [<ffffffff8110de10>] do_unlinkat+0x145/0x1df
> [  553.195504]  [<ffffffff81106e9f>] ? sys_newfstatat+0x2a/0x33
> [  553.195508]  [<ffffffff8110fce5>] sys_unlinkat+0x29/0x2b
> [  553.195512]  [<ffffffff81607746>] system_call_fastpath+0x1a/0x1f
> [  553.195515] ---[ end trace 0adc4db1ad1a6636 ]---
> [  553.404031] ------------[ cut here ]------------
> [  553.404068] WARNING: at fs/btrfs/extent-tree.c:4510
> btrfs_free_block_groups+0x13d/0x27e [btrfs]()
> [  553.404072] Hardware name: OptiPlex 745
> [  553.404076] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel snd_hda_codec snd_hwdep ppdev parport_pc snd_pcm
> snd_page_alloc snd_timer snd floppy sr_mod i2c_i801 tg3 ptp iTCO_wdt
> pps_core iTCO_vendor_support ehci_pci parport lpc_ich microcode
> serio_raw pcspkr ablk_helper cryptd lrw xts gf128mul aes_x86_64
> sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
> ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
> ohci_hcd uhci_hcd ehci_hcd
> [  553.404146] Pid: 4704, comm: umount Tainted: G        W
> 3.8.0-mason-next+ #1
> [  553.404149] Call Trace:
> [  553.404162]  [<ffffffff81030522>] warn_slowpath_common+0x83/0x9b
> [  553.404169]  [<ffffffff81030554>] warn_slowpath_null+0x1a/0x1c
> [  553.404188]  [<ffffffffa017159d>] btrfs_free_block_groups+0x13d/0x27e [btrfs]
> [  553.404211]  [<ffffffffa017c71a>] close_ctree+0x200/0x32f [btrfs]
> [  553.404218]  [<ffffffff81118323>] ? evict_inodes+0xd7/0xe3
> [  553.404235]  [<ffffffffa015a357>] btrfs_put_super+0x19/0x1b [btrfs]
> [  553.404242]  [<ffffffff811047e7>] generic_shutdown_super+0x59/0xd1
> [  553.404248]  [<ffffffff8111ad7a>] ? free_vfsmnt+0x17/0x3e
> [  553.404255]  [<ffffffff811048dd>] kill_anon_super+0x14/0x1f
> [  553.404270]  [<ffffffffa015a132>] btrfs_kill_super+0x17/0x89 [btrfs]
> [  553.404276]  [<ffffffff81104a44>] deactivate_locked_super+0x37/0x63
> [  553.404282]  [<ffffffff8110576a>] deactivate_super+0x3f/0x43
> [  553.404289]  [<ffffffff8111b30c>] mntput_no_expire+0x113/0x11b
> [  553.404295]  [<ffffffff8111c18b>] sys_umount+0x30a/0x33c
> [  553.404301]  [<ffffffff810415d1>] ? __set_current_blocked+0x36/0x4a
> [  553.404310]  [<ffffffff81607746>] system_call_fastpath+0x1a/0x1f
> [  553.404314] ---[ end trace 0adc4db1ad1a6637 ]---
> [  553.404317] ------------[ cut here ]------------
> [  553.404336] WARNING: at fs/btrfs/extent-tree.c:4511
> btrfs_free_block_groups+0x158/0x27e [btrfs]()
> [  553.404339] Hardware name: OptiPlex 745
> [  553.404342] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel snd_hda_codec snd_hwdep ppdev parport_pc snd_pcm
> snd_page_alloc snd_timer snd floppy sr_mod i2c_i801 tg3 ptp iTCO_wdt
> pps_core iTCO_vendor_support ehci_pci parport lpc_ich microcode
> serio_raw pcspkr ablk_helper cryptd lrw xts gf128mul aes_x86_64
> sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
> ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
> ohci_hcd uhci_hcd ehci_hcd
> [  553.404406] Pid: 4704, comm: umount Tainted: G        W
> 3.8.0-mason-next+ #1
> [  553.404409] Call Trace:
> [  553.404416]  [<ffffffff81030522>] warn_slowpath_common+0x83/0x9b
> [  553.404422]  [<ffffffff81030554>] warn_slowpath_null+0x1a/0x1c
> [  553.404441]  [<ffffffffa01715b8>] btrfs_free_block_groups+0x158/0x27e [btrfs]
> [  553.404463]  [<ffffffffa017c71a>] close_ctree+0x200/0x32f [btrfs]
> [  553.404469]  [<ffffffff81118323>] ? evict_inodes+0xd7/0xe3
> [  553.404485]  [<ffffffffa015a357>] btrfs_put_super+0x19/0x1b [btrfs]
> [  553.404491]  [<ffffffff811047e7>] generic_shutdown_super+0x59/0xd1
> [  553.404497]  [<ffffffff8111ad7a>] ? free_vfsmnt+0x17/0x3e
> [  553.404504]  [<ffffffff811048dd>] kill_anon_super+0x14/0x1f
> [  553.404519]  [<ffffffffa015a132>] btrfs_kill_super+0x17/0x89 [btrfs]
> [  553.404525]  [<ffffffff81104a44>] deactivate_locked_super+0x37/0x63
> [  553.404531]  [<ffffffff8110576a>] deactivate_super+0x3f/0x43
> [  553.404537]  [<ffffffff8111b30c>] mntput_no_expire+0x113/0x11b
> [  553.404543]  [<ffffffff8111c18b>] sys_umount+0x30a/0x33c
> [  553.404548]  [<ffffffff810415d1>] ? __set_current_blocked+0x36/0x4a
> [  553.404555]  [<ffffffff81607746>] system_call_fastpath+0x1a/0x1f
> [  553.404559] ---[ end trace 0adc4db1ad1a6638 ]---
> 
> Xfstest 083 is showing a successful completion, and I'm not seeing any
> errors using btrfsck on the partitions after the test.
> 
> For reference, here are the relevant sections of  inode.c and extent-tree.c:
> 
> inode.c:
> 
> 7901 void btrfs_destroy_inode(struct inode *inode)
> 7902 {
> 7903         struct btrfs_ordered_extent *ordered;
> 7904         struct btrfs_root *root = BTRFS_I(inode)->root;
> 7905
> 7906         WARN_ON(!hlist_empty(&inode->i_dentry));
> 7907         WARN_ON(inode->i_data.nrpages);
> 7908         WARN_ON(BTRFS_I(inode)->outstanding_extents);
> 7909         WARN_ON(BTRFS_I(inode)->reserved_extents);
> 7910         WARN_ON(BTRFS_I(inode)->delalloc_bytes);
> 7911         WARN_ON(BTRFS_I(inode)->csum_bytes);
> 
> extent-tree.c:
> 
> 4506 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
> 4507 {
> 4508         block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NULL,
> 4509                                 (u64)-1);
> 4510         WARN_ON(fs_info->delalloc_block_rsv.size > 0);
> 4511         WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
> 4512         WARN_ON(fs_info->trans_block_rsv.size > 0);
> 4513         WARN_ON(fs_info->trans_block_rsv.reserved > 0);
> 4514         WARN_ON(fs_info->chunk_block_rsv.size > 0);
> 4515         WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
> 4516         WARN_ON(fs_info->delayed_block_rsv.size > 0);
> 4517         WARN_ON(fs_info->delayed_block_rsv.reserved > 0);
> 4518 }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

