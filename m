Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55149 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbBLN0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 08:26:16 -0500
Received: from mfilter29-d.gandi.net (mfilter29-d.gandi.net [217.70.178.160])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 9F7B91720EF
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 14:26:14 +0100 (CET)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter29-d.gandi.net (mfilter29-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id OxfQDWkOfjtu for <linux-btrfs@vger.kernel.org>;
	Thu, 12 Feb 2015 14:26:13 +0100 (CET)
Received: from zafu.localnet (AMontpellier-656-1-271-215.w92-133.abo.wanadoo.fr [92.133.139.215])
	(Authenticated sender: michel@bouissou.net)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 171DE17209D
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 14:26:13 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS RAID-1 leaf size change scenario
Date: Thu, 12 Feb 2015 14:26:09 +0100
Message-ID: <11865500.KaKfdqacBs@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a BTRFS RAID-1 FS made from 2x 2TB SATA mechanical drives.

It was created a while ago, with defaults by the time of 4K leaf sizes.

It also contains *lots* of subvols and snapshots.

It has become very slow over time, and I know that BTRFS performs better with 
the new 16K leaf sizes.

I know that I cannot dynamically change the leaf size, but I'm wondering if 
the following could be feasible (and how to ?)

1/ Could I first pull a disk out of the current RAID-1 config, losing redundancy 
without breaking anything else ?

2/ Then reset the removed HD, and create onto it a new BTRFS FS with 16K leaf 
size ?

3/ Then is there a ways I could "btrfs send | btrfs receive" a complete volume 
including its subvolumes and snapshots,or is this impossible (and would I 
rather have to create the receiving volumes structure manually, and use rsync) 
?

4/ Once the data are copied onto the new FS, could I reset the remaining "old" 
HD, import it into the new FS and get back to a RAID-1 config, rebuilding the 
RAID with a "balance" operation ?

(Machine's kernel is an Ubuntu 3.16.0-30 with btrfs-tools 3.14.1-1)

Many thanks for all help / lights about if this is feasible / how to do it 
without losing my data...

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

