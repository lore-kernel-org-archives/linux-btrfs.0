Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37219 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbbFURNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Jun 2015 13:13:17 -0400
Received: from mfilter45-d.gandi.net (mfilter45-d.gandi.net [217.70.178.176])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id E0179172074
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2015 19:13:15 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([IPv6:::ffff:217.70.183.196])
	by mfilter45-d.gandi.net (mfilter45-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id Em0pn0ubYUak for <linux-btrfs@vger.kernel.org>;
	Sun, 21 Jun 2015 19:13:14 +0200 (CEST)
Received: from zafu.localnet (AMontpellier-656-1-387-187.w90-0.abo.wanadoo.fr [90.0.115.187])
	(Authenticated sender: michel@bouissou.net)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 8E01A172081
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2015 19:13:14 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Is there a "nossd" option ?
Date: Sun, 21 Jun 2015 19:13:10 +0200
Message-ID: <1586648.BNplRrhkhg@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Running a 3.19 Ubuntu kernel,

I'm currently budling a RAID-1 BTRFS set for which every underlying device is 
a LUKS-encrypted device itself built out of a bcache device comprised of a 
mechanical HD partition + an SSD cache partition.

Looks like it's working.

BUT I see that BTRFS decides by itself to mount with the "ssd" option as  
bcache makes it think the device is not "rotational".

However I feel that a mechanical HD plus SSD bcache should probably not be 
"SSD-optimized" as the underlying storage is indeed mechanical and bcache 
already manages the SSD part optimization by itself - and I'm afraid the "SSD 
optimization" could actually cause the mechanical storage to end up being much 
more fragmented than it should...

So the question is : Is there a mount option such as "nossd" that I could use 
to inhibit the automatic SSD "choice" that BTRFS makes ?

TIA, kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
