Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24071 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab3LTPqh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 10:46:37 -0500
From: Chris Mason <clm@fb.com>
To: "fmpfeifer@gmail.com" <fmpfeifer@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "eab@gmx.ch" <eab@gmx.ch>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: btrfs on bcache
Date: Fri, 20 Dec 2013 15:46:30 +0000
Message-ID: <1387554401.9407.0.camel@ret.masoncoding.com>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
	 <1387483201.23881.2.camel@ret.masoncoding.com>
	 <CABtk0xRbO9BthbOGHGg3cO4H5CZYeDwb_H4gAmspMiKSZMNZtQ@mail.gmail.com>
In-Reply-To: <CABtk0xRbO9BthbOGHGg3cO4H5CZYeDwb_H4gAmspMiKSZMNZtQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2013-12-20 at 10:42 -0200, F+AOE-bio Pfeifer wrote:
+AD4- Hello,
+AD4- 
+AD4- I put the +ACI-WARN+AF8-ON(1)+ADsAIg- after the printk lines (incomplete page read
+AD4- and incomplete page write) in extent+AF8-io.c.
+AD4- 
+AD4- here some call traces:
+AD4- 
+AD4- +AFs-   19.509497+AF0- incomplete page read in btrfs with offset 2560 and length 1536
+AD4- +AFs-   19.509500+AF0- ------------+AFs- cut here +AF0-------------
+AD4- +AFs-   19.509528+AF0- WARNING: CPU: 2 PID: 220 at fs/btrfs/extent+AF8-io.c:2441
+AD4- end+AF8-bio+AF8-extent+AF8-readpage+-0x788/0xc20 +AFs-btrfs+AF0-()
+AD4- +AFs-   19.509530+AF0- Modules linked in: cdc+AF8-acm fuse iTCO+AF8-wdt
+AD4- iTCO+AF8-vendor+AF8-support snd+AF8-hda+AF8-codec+AF8-analog coretemp kvm+AF8-intel kvm raid1
+AD4- ext4 crc16 md+AF8-mod mbcache jbd2 microcode nvidia(PO) psmouse pcspkr
+AD4- evdev serio+AF8-raw i2c+AF8-i801 lpc+AF8-ich i2c+AF8-core snd+AF8-hda+AF8-intel sky2 skge
+AD4- i82975x+AF8-edac button asus+AF8-atk0110 snd+AF8-hda+AF8-codec snd+AF8-hwdep shpchp
+AD4- snd+AF8-pcm snd+AF8-page+AF8-alloc snd+AF8-timer acpi+AF8-cpufreq snd edac+AF8-core soundcore
+AD4- processor vboxdrv(O) sr+AF8-mod cdrom ata+AF8-generic pata+AF8-acpi hid+AF8-generic
+AD4- usbhid hid usb+AF8-storage sd+AF8-mod pata+AF8-marvell firewire+AF8-ohci uhci+AF8-hcd ahci
+AD4- ehci+AF8-pci firewire+AF8-core ata+AF8-piix libahci crc+AF8-itu+AF8-t ehci+AF8-hcd libata
+AD4- scsi+AF8-mod usbcore usb+AF8-common btrfs crc32c libcrc32c xor raid6+AF8-pq bcache
+AD4- +AFs-   19.509578+AF0- CPU: 2 PID: 220 Comm: btrfs-endio-met Tainted: P
+AD4- W  O 3.12.5-1-ARCH +ACM-1
+AD4- +AFs-   19.509580+AF0- Hardware name: System manufacturer System Product
+AD4- Name/P5WDG2 WS Pro, BIOS 0905    03/06/2008
+AD4- +AFs-   19.509581+AF0-  0000000000000009 ffff880231a63cb0 ffffffff814ee37b
+AD4- 0000000000000000
+AD4- +AFs-   19.509585+AF0-  ffff880231a63ce8 ffffffff81062bcd ffffea00085eaec0
+AD4- 0000000000000000
+AD4- +AFs-   19.509587+AF0-  ffff8802320cc9c0 0000000000000000 ffff880233b0e000
+AD4- ffff880231a63cf8
+AD4- +AFs-   19.509590+AF0- Call Trace:
+AD4- +AFs-   19.509596+AF0-  +AFsAPA-ffffffff814ee37b+AD4AXQ- dump+AF8-stack+-0x54/0x8d
+AD4- +AFs-   19.509601+AF0-  +AFsAPA-ffffffff81062bcd+AD4AXQ- warn+AF8-slowpath+AF8-common+-0x7d/0xa0
+AD4- +AFs-   19.509603+AF0-  +AFsAPA-ffffffff81062caa+AD4AXQ- warn+AF8-slowpath+AF8-null+-0x1a/0x20
+AD4- +AFs-   19.509614+AF0-  +AFsAPA-ffffffffa00b7ba8+AD4AXQ- end+AF8-bio+AF8-extent+AF8-readpage+-0x788/0xc20 +AFs-btrfs+AF0-

This should mean that bcache is either failing to read some blocks
properly or is fiddling with the bv+AF8-len/bv+AF8-offset fields.

Could someone from bcache comment?

-chris

