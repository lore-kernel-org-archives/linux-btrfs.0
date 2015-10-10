Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:60958
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbJJOMV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 10:12:21 -0400
Subject: Re: btrfs says no errors, but booting gives lots of errors
To: covici@ccs.covici.com, linux-btrfs@vger.kernel.org
References: <8042.1444481164@ccs.covici.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56191CC2.9000505@googlemail.com>
Date: Sat, 10 Oct 2015 16:12:18 +0200
MIME-Version: 1.0
In-Reply-To: <8042.1444481164@ccs.covici.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/15 14:46, covici@ccs.covici.com wrote:
> Hi.  I am having lots of btrfs troubles  -- I am using a 4.1.9 kernel

Just FYI, both 4.1.9 and .10 have serious regressions in the network layer
that *will*  lock up the whole machine, either after a few minutes or a
few hours (when idle). Try 4.2.x or (also more btrfs fixes) or 4.1.8 (OK).

However, as for your problem at hand:

[   33.911258] ccs kernel: WARNING: CPU: 0 PID: 825 at fs/sync.c:55 sync_filesystem+0x26/0x95()
[   33.911773] ccs kernel: Modules linked in: hid_logitech_hidpp hid_logitech_dj usbhid ata_generic pata_acpi btrfs xor uas usb_storage raid6_pq crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel cryptd ehci_pci xhci_pci xhci_hcd ehci_hcd ahci libahci pata_marvell libata usbcore usb_common dm_mirror dm_region_hash dm_log dm_mod zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zavl(PO) ipv6 autofs4
[   33.913500] ccs kernel: CPU: 0 PID: 825 Comm: mount Tainted: P           O    4.1.9-gentoo-r1 #2
[   33.914053] ccs kernel: Hardware name: Supermicro C7P67/C7P67, BIOS 4.6.4 07/01/2011
[   33.914602] ccs kernel:  0000000000000009 ffff88007fabbbf8 ffffffff81457f11 0000000080000000
[   33.915167] ccs kernel:  0000000000000000 ffff88007fabbc38 ffffffff81045b50 ffff880400000001
[   33.915734] ccs kernel:  ffffffff81168a98 ffff880425a0d800 ffff880425a0d800 0000000000000000
[   33.916287] ccs kernel: Call Trace:
[   33.916823] ccs kernel:  [<ffffffff81457f11>] dump_stack+0x4f/0x7b
[   33.917353] ccs kernel:  [<ffffffff81045b50>] warn_slowpath_common+0xa1/0xbb
[   33.917876] ccs kernel:  [<ffffffff81168a98>] ? sync_filesystem+0x26/0x95
[   33.918386] ccs kernel:  [<ffffffff81045c0d>] warn_slowpath_null+0x1a/0x1c
[   33.918897] ccs kernel:  [<ffffffff81168a98>] sync_filesystem+0x26/0x95
[   33.919408] ccs kernel:  [<ffffffffa0649cd0>] btrfs_remount+0x88/0x412 [btrfs]

It looks like the problem fixed here: https://lkml.org/lkml/2015/4/8/17

This also went into 4.2, though you should be able to patch it (and the rest
of this 3-part series) into 4.1.x if you're comfortable with that.

hth,
Holger

