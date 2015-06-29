Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:41073 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbbF2Imt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 04:42:49 -0400
Received: from mfilter20-d.gandi.net (mfilter20-d.gandi.net [217.70.178.148])
	by relay6-d.mail.gandi.net (Postfix) with ESMTP id 0AD1AFB8D6
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 10:42:48 +0200 (CEST)
Received: from relay6-d.mail.gandi.net ([217.70.183.198])
	by mfilter20-d.gandi.net (mfilter20-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id GwRSr4i4lB6h for <linux-btrfs@vger.kernel.org>;
	Mon, 29 Jun 2015 10:42:15 +0200 (CEST)
Received: from zafu.localnet (AMontpellier-656-1-305-139.w86-202.abo.wanadoo.fr [86.202.105.139])
	(Authenticated sender: michel@bouissou.net)
	by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 5266DFB8A1
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 10:42:15 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Scrub errors but no errors ?!?
Date: Mon, 29 Jun 2015 10:42:14 +0200
Message-ID: <3095967.p5MQJjsH62@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Using kernel 3.19 on Ubuntu 15.04

I have a BTRFS Raid-1 FS made from 2 Luks-encrypted devices, each one built 
atop a bcache device.

The machine runs smoothly from this setup.

When I scrub said FS, it ends by spitting a message on console stating that 
"Scrub found errors but corrected them"

However if I then type :

# btrfs scrub stat /
scrub status for 53a35066-1a7b-4fe1-9f94-a923a7f9e3af
        scrub started at Sun Jun 28 11:17:50 2015 and finished after 30657 
seconds
        total bytes scrubbed: 3.01TiB with 0 errors

# btrfs dev stat /
[/dev/mapper/c_b].write_io_errs   0
[/dev/mapper/c_b].read_io_errs    0
[/dev/mapper/c_b].flush_io_errs   0
[/dev/mapper/c_b].corruption_errs 0
[/dev/mapper/c_b].generation_errs 0
[/dev/mapper/c_a].write_io_errs   0
[/dev/mapper/c_a].read_io_errs    0
[/dev/mapper/c_a].flush_io_errs   0
[/dev/mapper/c_a].corruption_errs 0
[/dev/mapper/c_a].generation_errs 0

...How comes ?

TIA for any insight.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

