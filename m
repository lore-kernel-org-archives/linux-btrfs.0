Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41074 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaHXRZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 13:25:56 -0400
Received: from mfilter26-d.gandi.net (mfilter26-d.gandi.net [217.70.178.154])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 303AF41C056
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 19:25:54 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter26-d.gandi.net (mfilter26-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id TT9yR4hgizEt for <linux-btrfs@vger.kernel.org>;
	Sun, 24 Aug 2014 19:25:52 +0200 (CEST)
Received: from zafu.localnet (AMontpellier-656-1-470-118.w92-145.abo.wanadoo.fr [92.145.254.118])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id B90E341C061
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 19:25:52 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: REPORT: Still a lot of BTRFS freezes in 3.16.1-1-ARCH
Date: Sun, 24 Aug 2014 19:25:43 +0200
Message-ID: <4207113.A3bnH6gnWF@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

This is to report that I'm still having quite systematic BRTFS freezes on an 
ArchLinux running latest 3.16.1-1-ARCH kernel.

Interestingly enough, I have several latops with the exact same setup :

Arch Linux with 3.16.1-1-ARCH kernel, fully running on BTRFS (with LZO 
compression) over LVM over LUKS.

All machines have hourly BTRFS snapshots performed by SuSE « snapper » 
utility.

The difference between the laptops only relate to the disk (HD vs. SSD) and CPU 
"power".

I have :

- Intel Core I3 with mechanical 1TB Samsung HD: NEVER hangs.

- Intel Celeron CPU 1007U @ 1.50GHz with Crucial_512GB MX100 SSD: NEVER hangs.

- Asus EeePC, Intel Atom CPU N450  @ 1.66GHz with SanDisk 120 GB SSD: VERY 
OFTEN HANGS, only since 3.15 kernel, and I'm pretty sure that the hardware 
itself is OK.


It seems that the only machine on which BTRFS crashes is the one on which the 
CPU is weak & slow relatively to the SSD (so the I/O, considering compression 
and encryption, is quite surely CPU-bound).

The typical situation causing a machine crash is : Performing a lot of updates 
using "pacman -Syu".

The typical freeze happens while applying the updates (not while dowloading 
the packages).

The typical result is :

- The update process stalls.
- The rest of the machine AT FIRST seems unaffected
- After a while eventually everything that needs disk access freezes
- A fierce reboot is finally needed.

The typical outcome is :

- After reboot, a number of files belonging to the packages that were in 
process of updating, or had been updated last, appear as having a size of ZERO 
bytes (so what depends on them is typicaly broken).

(If the write to disk is ORDERED, this isn't supposed to happen, is it ??)

- Forcibly reinstalling the packages for the broken files usually fixes things 
up.

I've had this exact experience at least 5 times on this machine now, always 
exactly as described.

I've never seen any such issue on my other machines on which CPU power is 
better relatively to the disk speed...

Hope this can be of any help ?

I'm longing for a kernel fix cause I fear something could seriously break in 
the end...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

