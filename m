Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41708 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaDYAEG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 20:04:06 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140424230704.GK7884@merlins.org>
Date: Thu, 24 Apr 2014 18:04:03 -0600
Cc: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>,
        linux-btrfs@vger.kernel.org
Message-Id: <F6EDB160-FCC5-4D1C-A5A8-AAADE5C803F6@colorremedies.com>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org> <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info> <8953EAE6-E8DD-40DC-B485-128BE7CB4BA1@colorremedies.com> <000c01cf600b$b01f6cf0$105e46d0$@petrovi.no-ip.info> <20140424230704.GK7884@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 24, 2014, at 5:07 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> 
> In 3.14 the device shows up before btrfs is loaded:
> sd 2:0:0:0: [sda] Cache data unavailable
> sd 2:0:0:0: [sda] Assuming drive cache: write through
> sd 2:0:0:0: [sda] Attached SCSI disk
> (...)
> Btrfs loaded

Same for me though, and I can boot.

[    0.693215] ata1.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[    0.693799] ata1.00: 167772160 sectors, multi 128: LBA48 NCQ (depth 31/32)
[    0.694153] ata1.00: configured for UDMA/133
[    0.695475] scsi 0:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[    0.699386] sd 0:0:0:0: [sda] 167772160 512-byte logical blocks: (85.8 GB/80.0 GiB)
[    0.699443] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.700604] sd 0:0:0:0: [sda] Write Protect is off
[    0.701151] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.701187] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.707841]  sda: sda1 sda2 sda3
[    0.709846] sd 0:0:0:0: [sda] Attached SCSI disk
(…)
[    2.380090] bio: create slab <bio-1> at 1
[    2.384645] Btrfs loaded

So I don't think the order is it. The biggest difference I'm seeing between the 3.13.11 and 3.14.1 dmesg's provided:

3.13.11:
[    1.861740] bio: create slab <bio-1> at 1
[    1.863389] Btrfs loaded

3.14.1:
[    3.949312] bio: create slab <bio-1> at 1
[    3.950942] Btrfs loaded

It's happening much later, and it's right at this point VFS complains:
[    4.182603] VFS: Cannot open root device "sda2" or unknown-block(8,2): error -38

The 8,2 message is consistent with the kernel not knowing what file system sda2 is. Seems like it's saying "I see sda2, I know you want to use it as root, but I don't know what's there - *poof*" and it panics.

If rootwait alone doesn't work, I wonder if root=uuid=2ba08fbc-4b95-46cc-b638-299f16462620 instead of root=/dev/sda2 will work along with rootwait. It should then wait for that fs uuid to become available, rather than waiting for sda2 to become available.

I vaguely recall there recently being btrfs boot problems with the module compiled in…


Chris Murphy

