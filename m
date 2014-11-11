Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:54166 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbaKKSH2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 13:07:28 -0500
Message-ID: <5462505D.3000105@pobox.com>
Date: Tue, 11 Nov 2014 10:07:25 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Florian Bruhin <me@the-compiler.org>, linux-btrfs@vger.kernel.org
Subject: Re: open_ctree failed after ATA errors
References: <20141111155153.GZ5944@lupin>
In-Reply-To: <20141111155153.GZ5944@lupin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The below is a hard disk going bad or other systematic problem at the 
hardware level (controller card, interrupt conflict, etc).

In fact, given "ata6.00: irq_stat 0x08000000, interface fatal error" its 
pretty much a smoking gun about your controller.

Since you just upgraded your kernel I'd check to make sure you have the 
correct chipset and controller card selected. Look at /proc/interrupts 
and see if the controller is sharing an interrupt with some other device 
that could be crossing it up. Play with your MSI/MSI-X settings (if they 
are in use try disabling them).

I'd also actvate SMART and get the smart tools (e.g. "smartmontools" in 
gentoo, so probably something similar for your distro) and check the 
drive health.

So the stack is
Application ->
  File System ->
   Device Mapper ->
    Encryption ->
     Controller ->
      Wiring ->
       Drive

You are seeing write failures in the controller->wiring->drive section 
somewhere.

Cryptsetup is succeeding because the open operation is read-only. That 
is cryptsetup reads the LUKS block (first 4k of the partition) and does 
the key work and device mapper setup completely in memory without 
writing to the physical media at all.

Another possible area is if you ever resized the physical partitions but 
didn't properly resize the cryptsetup layer with "cryptsetup resize", 
but that woudl be unlikly to affect multiple drives (unless the mistake 
was symmetric, e.g. you did it to both drives).

Basically your problem is _way_ below the BTRFS level, but BTRFS is the 
first layer thats actually trying to write to the drives so it's the 
first level client to fail.


On 11/11/2014 07:51 AM, Florian Bruhin wrote:
>      ata6.00: exception Emask 0x10 SAct 0x40000 SErr 0x400000 action 0x6 frozen
>      ata6.00: irq_stat 0x08000000, interface fatal error
>      ata6: SError: { Handshk }
>      ata6.00: failed command: WRITE FPDMA QUEUED
>      ata6.00: cmd 61/08:90:e8:29:85/01:00:03:00:00/40 tag 18 ncq 135168 out
>               res 40/00:94:e8:29:85/00:00:03:00:00/40 Emask 0x10 (ATA bus error)
>      ata6.00: status: { DRDY }
>      ata6: hard resetting link
>      ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>      ata6.00: configured for UDMA/133
>      ata6: EH complete
>      ata6.00: exception Emask 0x10 SAct 0x800000 SErr 0x400000 action 0x6 frozen
>      ata6.00: irq_stat 0x08000000, interface fatal error
>      ata6: SError: { Handshk }
>      ata6.00: failed command: WRITE FPDMA QUEUED
>      ata6.00: cmd 61/00:b8:f0:2a:85/02:00:03:00:00/40 tag 23 ncq 262144 out
>               res 40/00:bc:f0:2a:85/00:00:03:00:00/40 Emask 0x10 (ATA bus error)
>      ata6.00: status: { DRDY }
>      ata6: hard resetting link
>      ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>      ata6.00: configured for UDMA/133
>      ata6: EH complete



