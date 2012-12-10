Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59254 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2LJWVs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Dec 2012 17:21:48 -0500
Date: Mon, 10 Dec 2012 23:21:25 +0100
From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sami.liedes@iki.fi, chris.mason@fusionio.com, sensille@gmx.net
Subject: Re: GPF in read_extent_buffer while scrubbing on
 3.7.0-rc8-00014-g27d7c2a
Message-ID: <20121210222125.GA20072@kashmir>
References: <20121206143458.GA24396@kashmir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121206143458.GA24396@kashmir>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

	Hi again,

after enabling page alloc and slub debug, I was able to capture an error
followed by the "usual" GPF.  More below.

On Thu, Dec 06, 2012 at 03:34:58PM +0100, Mathieu Chouquet-Stringer wrote:
> Using the last couple of kernels (3.6 or 3.7), scrubbing my btrfs fs (which is
> on a luks based lvm device) will always end up crashing my pc.
> [...]

The warning:
WARNING: at fs/btrfs/extent_io.c:4680 read_extent_buffer+0xee/0x120()
Hardware name: 2392CTO
Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack rfcomm bnep arc4 iwldvm mac80211 iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek coretemp kvm_intel kvm microcode uvcvideo videobuf2_vmalloc videobuf2_memops pcspkr videobuf2_core videodev btusb media i2c_i801 bluetooth snd_hda_intel snd_hda_codec cdc_ncm usbnet mii cdc_wdm cdc_acm snd_hwdep snd_seq snd_seq_device snd_pcm lpc_ich mfd_core iwlwifi cfg80211 e1000e snd_page_alloc mei snd_timer thinkpad_acpi snd soundcore rfkill uinput dm_crypt crc32c_intel nouveau ghash_clmulni_intel mxm_wmi ttm i915 i2c_algo_bit drm_kms_helper firewire_ohci drm sdhci_pci firewire_core sdhci mmc_core crc_itu_t i2c_core wmi video
Pid: 536, comm: btrfs-endio-met Not tainted 3.7.0-rc8-00039-ged23ec4 #4
Call Trace:
 [<ffffffff8104bebf>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104bf1a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff812aae9e>] read_extent_buffer+0xee/0x120
 [<ffffffff812a1bb2>] btrfs_node_key+0x22/0x30
 [<ffffffff812dd720>] __readahead_hook.isra.5+0x3a0/0x3f0
 [<ffffffff812ddb14>] btree_readahead_hook+0x24/0x40
 [<ffffffff81286069>] btree_readpage_end_io_hook+0x139/0x290
 [<ffffffff812a6ff3>] end_bio_extent_readpage+0xd3/0xa40
 [<ffffffff812853a6>] ? end_workqueue_fn+0x36/0x50
 [<ffffffff811b27ed>] bio_endio+0x1d/0x30
 [<ffffffff812853b1>] end_workqueue_fn+0x41/0x50
 [<ffffffff812b5916>] worker_loop+0x136/0x580
 [<ffffffff812b57e0>] ? btrfs_queue_worker+0x300/0x300
 [<ffffffff8106f480>] kthread+0xc0/0xd0
 [<ffffffff8106f3c0>] ? kthread_create_on_node+0x120/0x120
 [<ffffffff8168e8ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106f3c0>] ? kthread_create_on_node+0x120/0x120

gdb says it's this WARN ON:
(gdb) l *(read_extent_buffer + 0xee)
0x726e is in read_extent_buffer (fs/btrfs/extent_io.c:4680).
4675            char *kaddr;
4676            char *dst = (char *)dstv;
4677            size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
4678            unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
4679

4680            WARN_ON(start > eb->len);

4681            WARN_ON(start + len > eb->start + eb->len);
4682
4683            offset = (start_offset + start) & ((unsigned long)PAGE_CACHE_SIZE - 1);
4684

The GPF which follows right after is:
general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack rfcomm bnep arc4 iwldvm mac80211 iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek coretemp kvm_intel kvm microcode uvcvideo videobuf2_vmalloc videobuf2_memops pcspkr videobuf2_core videodev btusb media i2c_i801 bluetooth snd_hda_intel snd_hda_codec cdc_ncm usbnet mii cdc_wdm cdc_acm snd_hwdep snd_seq snd_seq_device snd_pcm lpc_ich mfd_core iwlwifi cfg80211 e1000e snd_page_alloc mei snd_timer thinkpad_acpi snd soundcore rfkill uinput dm_crypt crc32c_intel nouveau ghash_clmulni_intel mxm_wmi ttm i915 i2c_algo_bit drm_kms_helper firewire_ohci drm sdhci_pci firewire_core sdhci mmc_core crc_itu_t i2c_core wmi video
CPU 1 
Pid: 536, comm: btrfs-endio-met Tainted: G        W    3.7.0-rc8-00039-ged23ec4 #4 LENOVO 2392CTO/2392CTO
RIP: 0010:[<ffffffff8136c756>]  [<ffffffff8136c756>] memcpy+0x6/0x110
RSP: 0018:ffff8804215a9b70  EFLAGS: 00010207
RAX: ffff8804215a9c57 RBX: 0000000000000011 RCX: 0000000000000011
RDX: 0000000000000011 RSI: 0005080000000003 RDI: ffff8804215a9c57
RBP: ffff8804215a9bb8 R08: 0000000000000000 R09: 0000000000000486
R10: 0000000000000001 R11: 0000000000aaaaaa R12: ffff8804215a9c68
R13: ffff8803f4c5cfc0 R14: 0000000000000048 R15: 0000000000000011
FS:  0000000000000000(0000) GS:ffff88043e240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe992197000 CR3: 0000000001c0b000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-endio-met (pid: 536, threadinfo ffff8804215a8000, task ffff8804224eb0e0)
Stack:
 ffffffff812aae73 ffff8804105ea000 0000000000008003 0000000000001000
 ffff8804215a9c20 00000000000003dd ffff88041232a7c0 ffff8804215a9c20
 aeb3f3fe4e814d8e ffff8804215a9bc8 ffffffff812a1bb2 ffff8804215a9c98
Call Trace:
 [<ffffffff812aae73>] ? read_extent_buffer+0xc3/0x120
 [<ffffffff812a1bb2>] btrfs_node_key+0x22/0x30
 [<ffffffff812dd720>] __readahead_hook.isra.5+0x3a0/0x3f0
 [<ffffffff812ddb14>] btree_readahead_hook+0x24/0x40
 [<ffffffff81286069>] btree_readpage_end_io_hook+0x139/0x290
 [<ffffffff812a6ff3>] end_bio_extent_readpage+0xd3/0xa40
 [<ffffffff812853a6>] ? end_workqueue_fn+0x36/0x50
 [<ffffffff811b27ed>] bio_endio+0x1d/0x30
 [<ffffffff812853b1>] end_workqueue_fn+0x41/0x50
 [<ffffffff812b5916>] worker_loop+0x136/0x580
 [<ffffffff812b57e0>] ? btrfs_queue_worker+0x300/0x300
 [<ffffffff8106f480>] kthread+0xc0/0xd0
 [<ffffffff8106f3c0>] ? kthread_create_on_node+0x120/0x120
 [<ffffffff8168e8ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106f3c0>] ? kthread_create_on_node+0x120/0x120
Code: 74 13 48 8b 43 58 48 2b 43 50 88 43 4e 48 83 c4 08 5b 5d c3 90 e8 eb fb ff ff eb e6 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 <f3> a4 c3 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 
RIP  [<ffffffff8136c756>] memcpy+0x6/0x110
 RSP <ffff8804215a9b70>

memcpy is called from here:
(gdb) l *(read_extent_buffer + 0xc3)
0x7243 is in read_extent_buffer (fs/btrfs/extent_io.c:4694).
4689                    kaddr = page_address(page);
4690                    memcpy(dst, kaddr + offset, cur);
4691
4692                    dst += cur;
4693                    len -= cur;
4694                    offset = 0;
4695                    i++;
4696            }
4697    }
4698

Any idea what to do next?  If you think I should be adding debug printk
statements, feel free to send them my way.

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
