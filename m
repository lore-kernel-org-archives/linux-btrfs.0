Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29271 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbbCEK1S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 05:27:18 -0500
Date: Thu, 5 Mar 2015 18:27:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs oops while mounting fuzzed btrfs image
Message-ID: <20150305102701.GE4147@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20150305070933.GB17015@dhcp-13-216.nay.redhat.com>
 <20150305094611.GA4147@localhost.localdomain>
 <20150305101354.GC17015@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150305101354.GC17015@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 05, 2015 at 06:13:54PM +0800, Eryu Guan wrote:
> On Thu, Mar 05, 2015 at 05:46:12PM +0800, Liu Bo wrote:
> > On Thu, Mar 05, 2015 at 03:09:33PM +0800, Eryu Guan wrote:
> > > Hi,
> > > 
> > > I was testing btrfs with fsfuzzer and encountered a divide error on
> > > mount, kernel version 3.19 and 4.0-rc1.
> > > 
> > > I found a similar bug on kernel bugzilla
> > > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=88611
> > > 
> > > Please find the fuzzed btrfs image in the buzilla, and the following
> > > command will reproduce:
> > > 
> > > mount -o loop btrfs.img /mnt/btrfs
> > 
> > A divide by 0 oops.
> > 
> > My printk shows that a raid56 chunk has a negative map->length, so we need to find out
> > how fsfuzzer made that.  Can you share your script so that we can
> > reproduce the oops?
> 
> You can download fsfuzzer from here:
> 
> http://people.redhat.com/sgrubb/files/fsfuzzer-0.7.tar.gz
> 
> What it does is simply writing random garbage to the first 10% of the
> fs image. You can take a look at fsfuzz and mangle.c

Will take a look, but I guess writing the first 10% of fs image may mess up fs's super block,
if it does then we can do nothing about it except throwing a WARNING_ONCE().

Thanks,

-liubo

> 
> Thanks,
> Eryu
> > 
> > Thanks,
> > 
> > -liubo
> > 
> > > 
> > > Thanks,
> > > Eryu Guan
> > > 
> > > [  309.200469] loop: module loaded
> > > [  309.372689] BTRFS: device fsid 1c0ed5d6-550d-4010-b1b4-ce1828270713 devid 1 transid 4 /dev/loop0
> > > [  309.384037] BTRFS: super block crcs don't match, older mkfs detected
> > > [  309.385449] BTRFS info (device loop0): disk space caching is enabled
> > > [  309.390429] divide error: 0000 [#1] SMP
> > > [  309.390791] Modules linked in: loop btrfs xor raid6_pq ppdev parport_pc i2c_piix4 parport virtio_balloon pcspkr i2c_core serio_raw xfs sd_mod ata_generic pata_acpi virtio_pci virtio virtio_ring floppy ata_piix libata 8139too 8139cp mii
> > > [  309.391373] CPU: 2 PID: 1855 Comm: mount Not tainted 3.19.0 #15
> > > [  309.391373] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> > > [  309.391373] task: ffff880035068d70 ti: ffff8800360f0000 task.ti: ffff8800360f0000
> > > [  309.391373] RIP: 0010:[<ffffffffa03073a6>]  [<ffffffffa03073a6>] __btrfs_map_block+0x176/0x1180 [btrfs]
> > > [  309.391373] RSP: 0018:ffff8800360f38f8  EFLAGS: 00010206
> > > [  309.391373] RAX: 0000000000020000 RBX: 0000000000020000 RCX: 000000d9000000a9
> > > [  309.391373] RDX: 0000000000000000 RSI: 00000000c1400000 RDI: ffffffff8f018100
> > > [  309.391373] RBP: ffff8800360f39e8 R08: 0000000000000000 R09: 0000000000000001
> > > [  309.391373] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000020000
> > > [  309.391373] R13: ffff8802157e56c0 R14: 0000000000020000 R15: 000000008f018100
> > > [  309.391373] FS:  00007fcf592eb880(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
> > > [  309.391373] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  309.391373] CR2: 00007f9e367fc034 CR3: 0000000035e6e000 CR4: 00000000000006e0
> > > [  309.391373] Stack:
> > > [  309.391373]  0000000000001000 ffff880212fc6a68 0000000000000000 ffff880211a98040
> > > [  309.391373]  ffff8800360f3928 ffffffff812eb7be ffff8800360f3988 ffffffffa0300a82
> > > [  309.391373]  ffff8800360f3a50 ffff880035e7f000 0000000000000000 ffff880035e7ff60
> > > [  309.391373] Call Trace:
> > > [  309.391373]  [<ffffffff812eb7be>] ? bio_add_page+0x5e/0x70
> > > [  309.391373]  [<ffffffffa0300a82>] ? submit_extent_page.isra.34+0xe2/0x1d0 [btrfs]
> > > [  309.406845]  [<ffffffffa0302a20>] ? btrfs_create_repair_bio+0x110/0x110 [btrfs]
> > > [  309.406845]  [<ffffffffa030d8d6>] btrfs_map_bio+0x96/0x550 [btrfs]
> > > [  309.406845]  [<ffffffff811d10b1>] ? kmem_cache_alloc+0x1a1/0x220
> > > [  309.406845]  [<ffffffffa02d9fca>] btree_submit_bio_hook+0x5a/0x100 [btrfs]
> > > [  309.406845]  [<ffffffffa02fcc38>] submit_one_bio+0x68/0xa0 [btrfs]
> > > [  309.406845]  [<ffffffffa0304ab0>] read_extent_buffer_pages+0x270/0x330 [btrfs]
> > > [  309.406845]  [<ffffffffa02d7120>] ? free_root_pointers+0x60/0x60 [btrfs]
> > > [  309.406845]  [<ffffffffa02d8393>] btree_read_extent_buffer_pages.constprop.52+0xb3/0x120 [btrfs]
> > > [  309.406845]  [<ffffffffa02da270>] read_tree_block+0x40/0x70 [btrfs]
> > > [  309.406845]  [<ffffffffa02ddcdc>] open_ctree+0x143c/0x2140 [btrfs]
> > > [  309.406845]  [<ffffffffa02b333e>] btrfs_mount+0x76e/0x900 [btrfs]
> > > [  309.406845]  [<ffffffff81197604>] ? pcpu_alloc+0x364/0x680
> > > [  309.406845]  [<ffffffff811f2e09>] mount_fs+0x39/0x1b0
> > > [  309.406845]  [<ffffffff81197955>] ? __alloc_percpu+0x15/0x20
> > > [  309.406845]  [<ffffffff8120ea0b>] vfs_kern_mount+0x6b/0x110
> > > [  309.406845]  [<ffffffff812117fc>] do_mount+0x22c/0xb60
> > > [  309.406845]  [<ffffffff811926e6>] ? memdup_user+0x46/0x80
> > > [  309.406845]  [<ffffffff81212472>] SyS_mount+0xa2/0x110
> > > [  309.406845]  [<ffffffff816b76e9>] system_call_fastpath+0x12/0x17
> > > [  309.406845] Code: 23 10 00 00 48 81 c4 c8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 45 89 c8 31 d2 41 29 c0 48 89 d8 4d 63 c0 4c 0f af c7 45 89 c2 <49> f7 f2 4c 0f af c0 f7 c1 f8 01 00 00 4c 89 85 70 ff ff ff 0f
> > > [  309.406845] RIP  [<ffffffffa03073a6>] __btrfs_map_block+0x176/0x1180 [btrfs]
> > > [  309.406845]  RSP <ffff8800360f38f8>
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
