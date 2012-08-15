Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:58654 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2HORcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 13:32:36 -0400
Received: from luuna.daevel.fr ([82.67.37.138] helo=[192.168.1.50])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1T1hSM-0000Q7-IY
	for linux-btrfs@vger.kernel.org; Wed, 15 Aug 2012 19:32:34 +0200
Message-ID: <502BDD3D.4090703@daevel.fr>
Date: Wed, 15 Aug 2012 19:32:45 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Can't umount a read-only FS ?
References: <502BDC30.8060409@daevel.fr>
In-Reply-To: <502BDC30.8060409@daevel.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15/08/2012 19:28, Olivier Bonvalet wrote:
> Hi,
> 
> I have a strange problem with a btrfs partition : after an error, btrfs was forced readonly.
> 
> So I try to umount it, to launch btrfsck, but it doesn't work :
> 


I forgot, it was set readonly after that error :

Aug 15 09:44:33 sofia kernel: [29840.510826] ------------[ cut here ]------------
Aug 15 09:44:33 sofia kernel: [29840.510850] WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0x3a/0x95 [btrfs]()
Aug 15 09:44:33 sofia kernel: [29840.510858] btrfs: Transaction aborted
Aug 15 09:44:33 sofia kernel: [29840.510860] Modules linked in: ipv6 btrfs zram(C) nf_conntrack
Aug 15 09:44:33 sofia kernel: [29840.510872] Pid: 26524, comm: btrfs Tainted: G         C   2.6.44.7-dae-xen #2
Aug 15 09:44:33 sofia kernel: [29840.510879] Call Trace:
Aug 15 09:44:33 sofia kernel: [29840.510893]  [<ffffffff8103c7cf>] ? warn_slowpath_common+0x76/0x8a
Aug 15 09:44:33 sofia kernel: [29840.510901]  [<ffffffff8103c87b>] ? warn_slowpath_fmt+0x45/0x4a
Aug 15 09:44:33 sofia kernel: [29840.510924]  [<ffffffffa0077346>] ? btrfs_alloc_delayed_item+0x13/0x3b [btrfs]
Aug 15 09:44:33 sofia kernel: [29840.510941]  [<ffffffffa00203d2>] ? __btrfs_abort_transaction+0x3a/0x95 [btrfs]
Aug 15 09:44:33 sofia kernel: [29840.510964]  [<ffffffffa0042c80>] ? btrfs_unlink_subvol+0x1cf/0x255 [btrfs]
Aug 15 09:44:33 sofia kernel: [29840.510987]  [<ffffffffa0062178>] ? btrfs_ioctl_snap_destroy+0x2e0/0x42c [btrfs]
Aug 15 09:44:33 sofia kernel: [29840.511010]  [<ffffffffa0064f8c>] ? btrfs_ioctl+0x4f6/0xfce [btrfs]
Aug 15 09:44:33 sofia kernel: [29840.511022]  [<ffffffff81021ffa>] ? do_page_fault+0x274/0x2f2
Aug 15 09:44:33 sofia kernel: [29840.511031]  [<ffffffff810d39ca>] ? vfs_ioctl+0x1e/0x31
Aug 15 09:44:33 sofia kernel: [29840.511039]  [<ffffffff810d41ba>] ? do_vfs_ioctl+0x3bd/0x3ff
Aug 15 09:44:33 sofia kernel: [29840.511046]  [<ffffffff810d4238>] ? sys_ioctl+0x3c/0x60
Aug 15 09:44:33 sofia kernel: [29840.511055]  [<ffffffff81304979>] ? system_call_fastpath+0x16/0x1b
Aug 15 09:44:33 sofia kernel: [29840.511062] ---[ end trace 17eb064ed1556a08 ]---
Aug 15 09:44:33 sofia kernel: [29840.511071] BTRFS error (device dm-1) in btrfs_unlink_subvol:3098: error 28
Aug 15 09:44:33 sofia kernel: [29840.511077] btrfs is forced readonly
Aug 15 09:44:33 sofia kernel: [29840.511083] BTRFS error (device dm-1) in btrfs_ioctl_snap_destroy:2026: error 28


then in logs I have this warnings :

Aug 15 09:51:42 sofia kernel: [30269.723855] ------------[ cut here ]------------
Aug 15 09:51:42 sofia kernel: [30269.723893] WARNING: at fs/btrfs/inode.c:6954 btrfs_destroy_inode+0x64/0x26c [btrfs]()
Aug 15 09:51:42 sofia kernel: [30269.723905] Modules linked in: ipv6 btrfs zram(C) nf_conntrack
Aug 15 09:51:42 sofia kernel: [30269.723920] Pid: 27751, comm: ssh Tainted: G        WC   2.6.44.7-dae-xen #2
Aug 15 09:51:42 sofia kernel: [30269.723928] Call Trace:
Aug 15 09:51:42 sofia kernel: [30269.723939]  [<ffffffff8103c7cf>] ? warn_slowpath_common+0x76/0x8a
Aug 15 09:51:42 sofia kernel: [30269.723975]  [<ffffffffa004678f>] ? btrfs_destroy_inode+0x64/0x26c [btrfs]
Aug 15 09:51:42 sofia kernel: [30269.724010]  [<ffffffffa004672b>] ? btrfs_alloc_inode+0x1d9/0x1d9 [btrfs]
Aug 15 09:51:42 sofia kernel: [30269.724052]  [<ffffffff810d9943>] ? dispose_list+0x27/0x31
Aug 15 09:51:42 sofia kernel: [30269.724066]  [<ffffffff810da65e>] ? prune_icache_sb+0x2a7/0x2c2
Aug 15 09:51:42 sofia kernel: [30269.724086]  [<ffffffff810c99e1>] ? prune_super+0xcb/0x138
Aug 15 09:51:42 sofia kernel: [30269.724104]  [<ffffffff8110276f>] ? do_raw_spin_unlock.constprop.9+0xc/0xf
Aug 15 09:51:42 sofia kernel: [30269.724124]  [<ffffffff8109b7d4>] ? shrink_slab+0x120/0x19d
Aug 15 09:51:42 sofia kernel: [30269.724139]  [<ffffffff8109d46f>] ? do_try_to_free_pages+0x251/0x3ba
Aug 15 09:51:42 sofia kernel: [30269.724156]  [<ffffffff8109d648>] ? try_to_free_pages+0x70/0x75
Aug 15 09:51:42 sofia kernel: [30269.724172]  [<ffffffff81097368>] ? __alloc_pages_nodemask+0x4bf/0x773
Aug 15 09:51:42 sofia kernel: [30269.724191]  [<ffffffff812fff66>] ? kmalloc_large_node+0x4f/0x7f
Aug 15 09:51:42 sofia kernel: [30269.724204]  [<ffffffff8126a4e1>] ? __alloc_skb+0x6b/0x135
Aug 15 09:51:42 sofia kernel: [30269.724218]  [<ffffffff81269103>] ? sock_alloc_send_pskb+0xc7/0x2b5
Aug 15 09:51:42 sofia kernel: [30269.724234]  [<ffffffff81005e67>] ? get_phys_to_machine+0x12/0x5d
Aug 15 09:51:42 sofia kernel: [30269.724251]  [<ffffffff81003b2a>] ? mfn_to_pfn.part.24+0x52/0x77
Aug 15 09:51:42 sofia kernel: [30269.724271]  [<ffffffff812db414>] ? unix_stream_sendmsg+0x113/0x2b8
Aug 15 09:51:42 sofia kernel: [30269.724289]  [<ffffffff8109557b>] ? get_pageblock_flags_group+0x30/0x64
Aug 15 09:51:42 sofia kernel: [30269.724302]  [<ffffffff81263de0>] ? sock_aio_write+0xa3/0xbf
Aug 15 09:51:42 sofia kernel: [30269.724316]  [<ffffffff81099e12>] ? release_pages+0x120/0x12f
Aug 15 09:51:42 sofia kernel: [30269.724335]  [<ffffffff810c6ec2>] ? do_sync_write+0xae/0xe6
Aug 15 09:51:42 sofia kernel: [30269.724347]  [<ffffffff810bf739>] ? kmem_cache_free+0x11/0x69
Aug 15 09:51:42 sofia kernel: [30269.724361]  [<ffffffff810aaed7>] ? remove_vma+0x5c/0x63
Aug 15 09:51:42 sofia kernel: [30269.724371]  [<ffffffff810ac047>] ? do_munmap+0x2a7/0x2cf
Aug 15 09:51:42 sofia kernel: [30269.724385]  [<ffffffff810c7634>] ? vfs_write+0x9d/0xf8
Aug 15 09:51:42 sofia kernel: [30269.724396]  [<ffffffff810c782f>] ? sys_write+0x3e/0x6d
Aug 15 09:51:42 sofia kernel: [30269.724409]  [<ffffffff81304979>] ? system_call_fastpath+0x16/0x1b
Aug 15 09:51:42 sofia kernel: [30269.724421] ---[ end trace 17eb064ed1556a09 ]---
Aug 15 09:51:42 sofia kernel: [30269.724428] ------------[ cut here ]------------
Aug 15 09:51:42 sofia kernel: [30269.724456] WARNING: at fs/btrfs/inode.c:6955 btrfs_destroy_inode+0x7b/0x26c [btrfs]()
Aug 15 09:51:42 sofia kernel: [30269.724470] Modules linked in: ipv6 btrfs zram(C) nf_conntrack
Aug 15 09:51:42 sofia kernel: [30269.724487] Pid: 27751, comm: ssh Tainted: G        WC   2.6.44.7-dae-xen #2
Aug 15 09:51:42 sofia kernel: [30269.724499] Call Trace:
Aug 15 09:51:42 sofia kernel: [30269.724508]  [<ffffffff8103c7cf>] ? warn_slowpath_common+0x76/0x8a
Aug 15 09:51:42 sofia kernel: [30269.724536]  [<ffffffffa00467a6>] ? btrfs_destroy_inode+0x7b/0x26c [btrfs]
Aug 15 09:51:42 sofia kernel: [30269.724569]  [<ffffffffa004672b>] ? btrfs_alloc_inode+0x1d9/0x1d9 [btrfs]
Aug 15 09:51:42 sofia kernel: [30269.724582]  [<ffffffff810d9943>] ? dispose_list+0x27/0x31
Aug 15 09:51:42 sofia kernel: [30269.724591]  [<ffffffff810da65e>] ? prune_icache_sb+0x2a7/0x2c2
Aug 15 09:51:42 sofia kernel: [30269.724602]  [<ffffffff810c99e1>] ? prune_super+0xcb/0x138
Aug 15 09:51:42 sofia kernel: [30269.724611]  [<ffffffff8110276f>] ? do_raw_spin_unlock.constprop.9+0xc/0xf
Aug 15 09:51:42 sofia kernel: [30269.724622]  [<ffffffff8109b7d4>] ? shrink_slab+0x120/0x19d
Aug 15 09:51:42 sofia kernel: [30269.724632]  [<ffffffff8109d46f>] ? do_try_to_free_pages+0x251/0x3ba
Aug 15 09:51:42 sofia kernel: [30269.724643]  [<ffffffff8109d648>] ? try_to_free_pages+0x70/0x75
Aug 15 09:51:42 sofia kernel: [30269.724663]  [<ffffffff81097368>] ? __alloc_pages_nodemask+0x4bf/0x773
Aug 15 09:51:42 sofia kernel: [30269.724734]  [<ffffffff812fff66>] ? kmalloc_large_node+0x4f/0x7f
Aug 15 09:51:42 sofia kernel: [30269.724747]  [<ffffffff8126a4e1>] ? __alloc_skb+0x6b/0x135
Aug 15 09:51:42 sofia kernel: [30269.724758]  [<ffffffff81269103>] ? sock_alloc_send_pskb+0xc7/0x2b5
Aug 15 09:51:42 sofia kernel: [30269.724775]  [<ffffffff81005e67>] ? get_phys_to_machine+0x12/0x5d
Aug 15 09:51:42 sofia kernel: [30269.724786]  [<ffffffff81003b2a>] ? mfn_to_pfn.part.24+0x52/0x77
Aug 15 09:51:42 sofia kernel: [30269.724797]  [<ffffffff812db414>] ? unix_stream_sendmsg+0x113/0x2b8
Aug 15 09:51:42 sofia kernel: [30269.724805]  [<ffffffff8109557b>] ? get_pageblock_flags_group+0x30/0x64
Aug 15 09:51:42 sofia kernel: [30269.724813]  [<ffffffff81263de0>] ? sock_aio_write+0xa3/0xbf
Aug 15 09:51:42 sofia kernel: [30269.724819]  [<ffffffff81099e12>] ? release_pages+0x120/0x12f
Aug 15 09:51:42 sofia kernel: [30269.724827]  [<ffffffff810c6ec2>] ? do_sync_write+0xae/0xe6
Aug 15 09:51:42 sofia kernel: [30269.724834]  [<ffffffff810bf739>] ? kmem_cache_free+0x11/0x69
Aug 15 09:51:42 sofia kernel: [30269.724840]  [<ffffffff810aaed7>] ? remove_vma+0x5c/0x63
Aug 15 09:51:42 sofia kernel: [30269.724846]  [<ffffffff810ac047>] ? do_munmap+0x2a7/0x2cf
Aug 15 09:51:42 sofia kernel: [30269.724852]  [<ffffffff810c7634>] ? vfs_write+0x9d/0xf8
Aug 15 09:51:42 sofia kernel: [30269.724859]  [<ffffffff810c782f>] ? sys_write+0x3e/0x6d
Aug 15 09:51:42 sofia kernel: [30269.724865]  [<ffffffff81304979>] ? system_call_fastpath+0x16/0x1b
Aug 15 09:51:42 sofia kernel: [30269.724871] ---[ end trace 17eb064ed1556a0a ]---
Aug 15 09:51:42 sofia kernel: [30269.724876] ------------[ cut here ]------------
Aug 15 09:51:42 sofia kernel: [30269.724896] WARNING: at fs/btrfs/inode.c:6957 btrfs_destroy_inode+0xab/0x26c [btrfs]()
Aug 15 09:51:42 sofia kernel: [30269.724903] Modules linked in: ipv6 btrfs zram(C) nf_conntrack
Aug 15 09:51:42 sofia kernel: [30269.724914] Pid: 27751, comm: ssh Tainted: G        WC   2.6.44.7-dae-xen #2
Aug 15 09:51:42 sofia kernel: [30269.724920] Call Trace:
Aug 15 09:51:42 sofia kernel: [30269.724925]  [<ffffffff8103c7cf>] ? warn_slowpath_common+0x76/0x8a
Aug 15 09:51:42 sofia kernel: [30269.724946]  [<ffffffffa00467d6>] ? btrfs_destroy_inode+0xab/0x26c [btrfs]
Aug 15 09:51:42 sofia kernel: [30269.724966]  [<ffffffffa004672b>] ? btrfs_alloc_inode+0x1d9/0x1d9 [btrfs]
Aug 15 09:51:42 sofia kernel: [30269.724974]  [<ffffffff810d9943>] ? dispose_list+0x27/0x31
Aug 15 09:51:42 sofia kernel: [30269.724980]  [<ffffffff810da65e>] ? prune_icache_sb+0x2a7/0x2c2
Aug 15 09:51:42 sofia kernel: [30269.724987]  [<ffffffff810c99e1>] ? prune_super+0xcb/0x138
Aug 15 09:51:42 sofia kernel: [30269.724993]  [<ffffffff8110276f>] ? do_raw_spin_unlock.constprop.9+0xc/0xf
Aug 15 09:51:42 sofia kernel: [30269.725001]  [<ffffffff8109b7d4>] ? shrink_slab+0x120/0x19d
Aug 15 09:51:42 sofia kernel: [30269.725008]  [<ffffffff8109d46f>] ? do_try_to_free_pages+0x251/0x3ba
Aug 15 09:51:42 sofia kernel: [30269.725015]  [<ffffffff8109d648>] ? try_to_free_pages+0x70/0x75
Aug 15 09:51:42 sofia kernel: [30269.725023]  [<ffffffff81097368>] ? __alloc_pages_nodemask+0x4bf/0x773
Aug 15 09:51:42 sofia kernel: [30269.725030]  [<ffffffff812fff66>] ? kmalloc_large_node+0x4f/0x7f
Aug 15 09:51:42 sofia kernel: [30269.925127]  [<ffffffff8126a4e1>] ? __alloc_skb+0x6b/0x135
Aug 15 09:51:42 sofia kernel: [30269.925150]  [<ffffffff81269103>] ? sock_alloc_send_pskb+0xc7/0x2b5
Aug 15 09:51:42 sofia kernel: [30269.925171]  [<ffffffff81005e67>] ? get_phys_to_machine+0x12/0x5d
Aug 15 09:51:42 sofia kernel: [30269.925190]  [<ffffffff81003b2a>] ? mfn_to_pfn.part.24+0x52/0x77
Aug 15 09:51:42 sofia kernel: [30269.925208]  [<ffffffff812db414>] ? unix_stream_sendmsg+0x113/0x2b8
Aug 15 09:51:42 sofia kernel: [30269.925226]  [<ffffffff8109557b>] ? get_pageblock_flags_group+0x30/0x64
Aug 15 09:51:42 sofia kernel: [30269.925241]  [<ffffffff81263de0>] ? sock_aio_write+0xa3/0xbf
Aug 15 09:51:42 sofia kernel: [30269.925259]  [<ffffffff81099e12>] ? release_pages+0x120/0x12f
Aug 15 09:51:42 sofia kernel: [30269.925276]  [<ffffffff810c6ec2>] ? do_sync_write+0xae/0xe6
Aug 15 09:51:42 sofia kernel: [30269.925292]  [<ffffffff810bf739>] ? kmem_cache_free+0x11/0x69
Aug 15 09:51:42 sofia kernel: [30269.925309]  [<ffffffff810aaed7>] ? remove_vma+0x5c/0x63
Aug 15 09:51:42 sofia kernel: [30269.925323]  [<ffffffff810ac047>] ? do_munmap+0x2a7/0x2cf
Aug 15 09:51:42 sofia kernel: [30269.925339]  [<ffffffff810c7634>] ? vfs_write+0x9d/0xf8
Aug 15 09:51:42 sofia kernel: [30269.925356]  [<ffffffff810c782f>] ? sys_write+0x3e/0x6d
Aug 15 09:51:42 sofia kernel: [30269.925373]  [<ffffffff81304979>] ? system_call_fastpath+0x16/0x1b
Aug 15 09:51:42 sofia kernel: [30269.925386] ---[ end trace 17eb064ed1556a0b ]---


But nothing about the umount (some hours later).
