Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50019 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3JEMGF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Oct 2013 08:06:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VSQcV-00089f-UE
	for linux-btrfs@vger.kernel.org; Sat, 05 Oct 2013 14:06:03 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 14:06:03 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 14:06:03 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: ASM1083 rev01 PCIe to PCI Bridge chip (Was: Corrupt btrfs filesystem
 recovery... (Due to *sata* errors))
Date: Sat, 05 Oct 2013 13:05:54 +0100
Message-ID: <l2ovap$je5$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <l27agq$u5a$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/09/13 20:26, Martin wrote:
> AMD
> E-450 APU with Radeon(tm) HD Graphics AuthenticAMD GNU/Linux

Just in case someone else stumbles across this thread due to a related
problem for my particular motherboard...


There appears to be a fatal hardware bug for the interrupt line deassert
for a PCIe to PCI Bridge chip:

ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge (rev 01)

See the thread on https://lkml.org/lkml/2012/1/30/216

For that chip, the interrupt line is not always deasserted for PCI
interrupts. The hardware fault appears to be fixed in ASM1083 rev 03.
Unfortunately, there is no useful OS workaround possible for rev 01.

Hence, the PCI interrupts are unusable for ASM1083 rev01 ? :-(


In brief, this means that the PCI card slots on the motherboard cannot
be used for any hardware that might generate an interrupt. That means
pretty much all normal PCI cards. (The PCIe card slots are fine.)

For my own example, there does not appear to be any other devices using
that bridge chip. The only concern is for the sound chip but I happen to
never use sound on that system and so that is disabled.


The problem is listed in syslog/dmesg by lines such as:

kernel: irq 16: nobody cared (try booting with the "irqpoll" option)
kernel: Disabling IRQ #16


Unfortunately, the HDDs and network interfaces also use that irq or "irg
17" (which can also be affected). Losing the irq will badly slow down
your system and can cause data corruption for heavy use of the HDD.



Use:
lspci | grep -i ASM1083

to see if you have that chip and if so, what revision.

To see if you have any irqpoll messages, use:
grep -ia irqpoll /var/log/messages

To list what devices use what interrupts, use either of:
grep -ia ' irq ' /var/log/messages
cat /proc/interrupts



Note that there should no longer be any ASM1083 rev01 chips being
supplied by now. (ASM1083 rev03 chips have been seen in products.)

Hope that helps for that bit of obscurity!
Martin

