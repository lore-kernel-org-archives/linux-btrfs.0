Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0200.smtp25.com ([174.37.170.200]:55600 "EHLO
	mail0200.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbbJJPMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 11:12:22 -0400
From: covici@ccs.covici.com
To: =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FHolger=5FHoffst=3Dc3=3Da4tte=3F=3D?=
	<holger.hoffstaette@googlemail.com>
cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs says no errors, but booting gives lots of errors
In-reply-to: <56191CC2.9000505@googlemail.com>
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Date: Sat, 10 Oct 2015 10:41:48 -0400
Message-ID: <11640.1444488108@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte <holger.hoffstaette@googlemail.com> wrote:

> On 10/10/15 14:46, covici@ccs.covici.com wrote:
> > Hi.  I am having lots of btrfs troubles  -- I am using a 4.1.9 kernel
> 
> Just FYI, both 4.1.9 and .10 have serious regressions in the network layer
> that *will*  lock up the whole machine, either after a few minutes or a
> few hours (when idle). Try 4.2.x or (also more btrfs fixes) or 4.1.8 (OK).
> 
> However, as for your problem at hand:
> 
> [   33.911258] ccs kernel: WARNING: CPU: 0 PID: 825 at fs/sync.c:55 sync_filesystem+0x26/0x95()
> [   33.911773] ccs kernel: Modules linked in: hid_logitech_hidpp hid_logitech_dj usbhid ata_generic pata_acpi btrfs xor uas usb_storage raid6_pq crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel cryptd ehci_pci xhci_pci xhci_hcd ehci_hcd ahci libahci pata_marvell libata usbcore usb_common dm_mirror dm_region_hash dm_log dm_mod zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zavl(PO) ipv6 autofs4
> [   33.913500] ccs kernel: CPU: 0 PID: 825 Comm: mount Tainted: P           O    4.1.9-gentoo-r1 #2
> [   33.914053] ccs kernel: Hardware name: Supermicro C7P67/C7P67, BIOS 4.6.4 07/01/2011
> [   33.914602] ccs kernel:  0000000000000009 ffff88007fabbbf8 ffffffff81457f11 0000000080000000
> [   33.915167] ccs kernel:  0000000000000000 ffff88007fabbc38 ffffffff81045b50 ffff880400000001
> [   33.915734] ccs kernel:  ffffffff81168a98 ffff880425a0d800 ffff880425a0d800 0000000000000000
> [   33.916287] ccs kernel: Call Trace:
> [   33.916823] ccs kernel:  [<ffffffff81457f11>] dump_stack+0x4f/0x7b
> [   33.917353] ccs kernel:  [<ffffffff81045b50>] warn_slowpath_common+0xa1/0xbb
> [   33.917876] ccs kernel:  [<ffffffff81168a98>] ? sync_filesystem+0x26/0x95
> [   33.918386] ccs kernel:  [<ffffffff81045c0d>] warn_slowpath_null+0x1a/0x1c
> [   33.918897] ccs kernel:  [<ffffffff81168a98>] sync_filesystem+0x26/0x95
> [   33.919408] ccs kernel:  [<ffffffffa0649cd0>] btrfs_remount+0x88/0x412 [btrfs]
> 
> It looks like the problem fixed here: https://lkml.org/lkml/2015/4/8/17
> 
> This also went into 4.2, though you should be able to patch it (and the rest
> of this 3-part series) into 4.1.x if you're comfortable with that.

Thanks, maybe I will try the 4.2, but what about the strange things that
are going on, are they all caused by that kernel error?

Also, I could not run 4.2 at all when I tried it the other day, it would
boot up, but after about a minute it went completely bonkers, so I
backed off to the 4.1.9 as it may be supported somewhat long term --
there is a .10 already.

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
