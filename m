Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:38529 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3LXQpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Dec 2013 11:45:18 -0500
MIME-Version: 1.0
In-Reply-To: <1387554401.9407.0.camel@ret.masoncoding.com>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
 <1387483201.23881.2.camel@ret.masoncoding.com> <CABtk0xRbO9BthbOGHGg3cO4H5CZYeDwb_H4gAmspMiKSZMNZtQ@mail.gmail.com>
 <1387554401.9407.0.camel@ret.masoncoding.com>
From: =?UTF-8?Q?F=C3=A1bio_Pfeifer?= <fmpfeifer@gmail.com>
Date: Tue, 24 Dec 2013 14:44:57 -0200
Message-ID: <CABtk0xSn3V33CuWvW4END0nH0xpvFQ_pDj-o2+WcoAxdyEssuw@mail.gmail.com>
Subject: Re: btrfs on bcache
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(resend int text only)
Some more information about this issue.

I installed my system last november (arch x86_64), with kernel 3.11.
That time I didn't see any csum error or
"incomplete page read" error. Some time later these errors started to
show up. I don't know exactly if it was in
3.11 -> 3.12 upgrade or somewhere in the 3.12 cycle. I've been using
bcache in writeback mode from the beginning.

I made some more testing:
  - tryed bcache in writethrough, writearound  and none modes;
  - tryed linux kernel 3.13-rc5

The errors didn't go away (maybe because my filesystem is already
corrupted). I didn't have time to test with kernel 3.11 again.

But lately the errors increased, and it started to make my system
unstable, and then unusable.
I had to reformat everything and recover my backups.

I don't have my / and /home in btrfs over bcache anymore, but I can
make some tests in a spare HD and SSD i have here. I'll report back
after Christmas.

thanks,

Fabio

2013/12/20 Chris Mason <clm@fb.com>:
> On Fri, 2013-12-20 at 10:42 -0200, Fábio Pfeifer wrote:
>> Hello,
>>
>> I put the "WARN_ON(1);" after the printk lines (incomplete page read
>> and incomplete page write) in extent_io.c.
>>
>> here some call traces:
>>
>> [   19.509497] incomplete page read in btrfs with offset 2560 and length 1536
>> [   19.509500] ------------[ cut here ]------------
>> [   19.509528] WARNING: CPU: 2 PID: 220 at fs/btrfs/extent_io.c:2441
>> end_bio_extent_readpage+0x788/0xc20 [btrfs]()
>> [   19.509530] Modules linked in: cdc_acm fuse iTCO_wdt
>> iTCO_vendor_support snd_hda_codec_analog coretemp kvm_intel kvm raid1
>> ext4 crc16 md_mod mbcache jbd2 microcode nvidia(PO) psmouse pcspkr
>> evdev serio_raw i2c_i801 lpc_ich i2c_core snd_hda_intel sky2 skge
>> i82975x_edac button asus_atk0110 snd_hda_codec snd_hwdep shpchp
>> snd_pcm snd_page_alloc snd_timer acpi_cpufreq snd edac_core soundcore
>> processor vboxdrv(O) sr_mod cdrom ata_generic pata_acpi hid_generic
>> usbhid hid usb_storage sd_mod pata_marvell firewire_ohci uhci_hcd ahci
>> ehci_pci firewire_core ata_piix libahci crc_itu_t ehci_hcd libata
>> scsi_mod usbcore usb_common btrfs crc32c libcrc32c xor raid6_pq bcache
>> [   19.509578] CPU: 2 PID: 220 Comm: btrfs-endio-met Tainted: P
>> W  O 3.12.5-1-ARCH #1
>> [   19.509580] Hardware name: System manufacturer System Product
>> Name/P5WDG2 WS Pro, BIOS 0905    03/06/2008
>> [   19.509581]  0000000000000009 ffff880231a63cb0 ffffffff814ee37b
>> 0000000000000000
>> [   19.509585]  ffff880231a63ce8 ffffffff81062bcd ffffea00085eaec0
>> 0000000000000000
>> [   19.509587]  ffff8802320cc9c0 0000000000000000 ffff880233b0e000
>> ffff880231a63cf8
>> [   19.509590] Call Trace:
>> [   19.509596]  [<ffffffff814ee37b>] dump_stack+0x54/0x8d
>> [   19.509601]  [<ffffffff81062bcd>] warn_slowpath_common+0x7d/0xa0
>> [   19.509603]  [<ffffffff81062caa>] warn_slowpath_null+0x1a/0x20
>> [   19.509614]  [<ffffffffa00b7ba8>] end_bio_extent_readpage+0x788/0xc20 [btrfs]
>
> This should mean that bcache is either failing to read some blocks
> properly or is fiddling with the bv_len/bv_offset fields.
>
> Could someone from bcache comment?
>
> -chris
>
