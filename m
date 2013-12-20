Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57895 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3LTMmk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 07:42:40 -0500
MIME-Version: 1.0
In-Reply-To: <1387483201.23881.2.camel@ret.masoncoding.com>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
 <1387483201.23881.2.camel@ret.masoncoding.com>
From: =?UTF-8?Q?F=C3=A1bio_Pfeifer?= <fmpfeifer@gmail.com>
Date: Fri, 20 Dec 2013 10:42:18 -0200
Message-ID: <CABtk0xRbO9BthbOGHGg3cO4H5CZYeDwb_H4gAmspMiKSZMNZtQ@mail.gmail.com>
Subject: Re: btrfs on bcache
To: Chris Mason <clm@fb.com>
Cc: "eab@gmx.ch" <eab@gmx.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I put the "WARN_ON(1);" after the printk lines (incomplete page read
and incomplete page write) in extent_io.c.

here some call traces:

[   19.509497] incomplete page read in btrfs with offset 2560 and length 1536
[   19.509500] ------------[ cut here ]------------
[   19.509528] WARNING: CPU: 2 PID: 220 at fs/btrfs/extent_io.c:2441
end_bio_extent_readpage+0x788/0xc20 [btrfs]()
[   19.509530] Modules linked in: cdc_acm fuse iTCO_wdt
iTCO_vendor_support snd_hda_codec_analog coretemp kvm_intel kvm raid1
ext4 crc16 md_mod mbcache jbd2 microcode nvidia(PO) psmouse pcspkr
evdev serio_raw i2c_i801 lpc_ich i2c_core snd_hda_intel sky2 skge
i82975x_edac button asus_atk0110 snd_hda_codec snd_hwdep shpchp
snd_pcm snd_page_alloc snd_timer acpi_cpufreq snd edac_core soundcore
processor vboxdrv(O) sr_mod cdrom ata_generic pata_acpi hid_generic
usbhid hid usb_storage sd_mod pata_marvell firewire_ohci uhci_hcd ahci
ehci_pci firewire_core ata_piix libahci crc_itu_t ehci_hcd libata
scsi_mod usbcore usb_common btrfs crc32c libcrc32c xor raid6_pq bcache
[   19.509578] CPU: 2 PID: 220 Comm: btrfs-endio-met Tainted: P
W  O 3.12.5-1-ARCH #1
[   19.509580] Hardware name: System manufacturer System Product
Name/P5WDG2 WS Pro, BIOS 0905    03/06/2008
[   19.509581]  0000000000000009 ffff880231a63cb0 ffffffff814ee37b
0000000000000000
[   19.509585]  ffff880231a63ce8 ffffffff81062bcd ffffea00085eaec0
0000000000000000
[   19.509587]  ffff8802320cc9c0 0000000000000000 ffff880233b0e000
ffff880231a63cf8
[   19.509590] Call Trace:
[   19.509596]  [<ffffffff814ee37b>] dump_stack+0x54/0x8d
[   19.509601]  [<ffffffff81062bcd>] warn_slowpath_common+0x7d/0xa0
[   19.509603]  [<ffffffff81062caa>] warn_slowpath_null+0x1a/0x20
[   19.509614]  [<ffffffffa00b7ba8>] end_bio_extent_readpage+0x788/0xc20 [btrfs]
[   19.509617]  [<ffffffff8107010b>] ? lock_timer_base.isra.35+0x2b/0x50
[   19.509619]  [<ffffffff8106f660>] ? detach_if_pending+0x120/0x120
[   19.509623]  [<ffffffff811d98dd>] bio_endio+0x1d/0x30
[   19.509632]  [<ffffffffa0090227>] end_workqueue_fn+0x37/0x40 [btrfs]
[   19.509642]  [<ffffffffa00c6b1e>] worker_loop+0x14e/0x560 [btrfs]
[   19.509646]  [<ffffffff810952b2>] ? default_wake_function+0x12/0x20
[   19.509656]  [<ffffffffa00c69d0>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[   19.509672]  [<ffffffff81084fe0>] kthread+0xc0/0xd0
[   19.509677]  [<ffffffff81084f20>] ? kthread_create_on_node+0x120/0x120
[   19.509680]  [<ffffffff814fce7c>] ret_from_fork+0x7c/0xb0
[   19.509683]  [<ffffffff81084f20>] ? kthread_create_on_node+0x120/0x120
[   19.509687] ---[ end trace bbc8d0d088375446 ]---
[   25.592100] incomplete page read in btrfs with offset 2560 and length 1536
[   25.592105] ------------[ cut here ]------------
[   25.592141] WARNING: CPU: 0 PID: 442 at fs/btrfs/extent_io.c:2441
end_bio_extent_readpage+0x788/0xc20 [btrfs]()
[   25.592143] Modules linked in: cdc_acm fuse iTCO_wdt
iTCO_vendor_support snd_hda_codec_analog coretemp kvm_intel kvm raid1
ext4 crc16 md_mod mbcache jbd2 microcode nvidia(PO) psmouse pcspkr
evdev serio_raw i2c_i801 lpc_ich i2c_core snd_hda_intel sky2 skge
i82975x_edac button asus_atk0110 snd_hda_codec snd_hwdep shpchp
snd_pcm snd_page_alloc snd_timer acpi_cpufreq snd edac_core soundcore
processor vboxdrv(O) sr_mod cdrom ata_generic pata_acpi hid_generic
usbhid hid usb_storage sd_mod pata_marvell firewire_ohci uhci_hcd ahci
ehci_pci firewire_core ata_piix libahci crc_itu_t ehci_hcd libata
scsi_mod usbcore usb_common btrfs crc32c libcrc32c xor raid6_pq bcache
[   25.592205] CPU: 0 PID: 442 Comm: btrfs-endio-met Tainted: P
W  O 3.12.5-1-ARCH #1
[   25.592208] Hardware name: System manufacturer System Product
Name/P5WDG2 WS Pro, BIOS 0905    03/06/2008
[   25.592211]  0000000000000009 ffff880229773cb0 ffffffff814ee37b
0000000000000000
[   25.592216]  ffff880229773ce8 ffffffff81062bcd ffffea0002a20a80
0000000000000000
[   25.592220]  ffff88022d3ab180 0000000000000000 ffff88022d326000
ffff880229773cf8
[   25.592225] Call Trace:
[   25.592234]  [<ffffffff814ee37b>] dump_stack+0x54/0x8d
[   25.592240]  [<ffffffff81062bcd>] warn_slowpath_common+0x7d/0xa0
[   25.592245]  [<ffffffff81062caa>] warn_slowpath_null+0x1a/0x20
[   25.592262]  [<ffffffffa00b7ba8>] end_bio_extent_readpage+0x788/0xc20 [btrfs]
[   25.592267]  [<ffffffff810701ef>] ? try_to_del_timer_sync+0x4f/0x70
[   25.592271]  [<ffffffff81070262>] ? del_timer_sync+0x52/0x60
[   25.592275]  [<ffffffff8106f660>] ? detach_if_pending+0x120/0x120
[   25.592280]  [<ffffffff811d98dd>] bio_endio+0x1d/0x30
[   25.592296]  [<ffffffffa0090227>] end_workqueue_fn+0x37/0x40 [btrfs]
[   25.592312]  [<ffffffffa00c6b1e>] worker_loop+0x14e/0x560 [btrfs]
[   25.592318]  [<ffffffff810952b2>] ? default_wake_function+0x12/0x20
[   25.592335]  [<ffffffffa00c69d0>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[   25.592350]  [<ffffffff81084fe0>] kthread+0xc0/0xd0
[   25.592353]  [<ffffffff81084f20>] ? kthread_create_on_node+0x120/0x120
[   25.592356]  [<ffffffff814fce7c>] ret_from_fork+0x7c/0xb0
[   25.592359]  [<ffffffff81084f20>] ? kthread_create_on_node+0x120/0x120
[   25.592360] ---[ end trace bbc8d0d088375447 ]---

thanks,

Fabio Pfeifer

2013/12/19 Chris Mason <clm@fb.com>:
> On Wed, 2013-12-18 at 18:17 +0100, eb wrote:
>> I've recently setup a system (Kernel 3.12.5-1-ARCH) which is layered as follows:
>>
>> /dev/sdb3 - cache0 (80 GB Intel SSD)
>> /dev/sdc1 - backing device (2 TB WD HDD)
>>
>> sdb3+sdc1 => /dev/bcache0
>>
>> On /dev/bcache0, there's a btrfs filesystem with 2 subvolumes, mounted
>> as / and /home. What's been bothering me are the following entries in
>> my kernel log:
>>
>> [13811.845540] incomplete page write in btrfs with offset 1536 and length 2560
>> [13870.326639] incomplete page write in btrfs with offset 3072 and length 1024
>>
>> The offset/length values are always either 1536/2560 or 3072/1024,
>> they sum up nicely to 4K. There are 607 of those in there as I am
>> writing this, the machine has been up 18 hours and been under no
>> particular I/O strain (it's a desktop).
>
> Btrfs shouldn't be setting the offset on the bios.  Are you able to add
> a WARN_ON to the message that prints this so we can see the stack trace?
>
> Could you please cc the bcache and btrfs list together?
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
