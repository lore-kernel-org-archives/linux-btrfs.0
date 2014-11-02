Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39367 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaKBKnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Nov 2014 05:43:08 -0500
Received: from mfilter32-d.gandi.net (mfilter32-d.gandi.net [217.70.178.163])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id BA9B7172074
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Nov 2014 11:43:05 +0100 (CET)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter32-d.gandi.net (mfilter32-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id hMEGS4djH+Iq for <linux-btrfs@vger.kernel.org>;
	Sun,  2 Nov 2014 11:43:04 +0100 (CET)
Received: from zafu.localnet (AMontpellier-656-1-1-137.w81-251.abo.wanadoo.fr [81.251.92.137])
	(Authenticated sender: michel@bouissou.net)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 5B0D117207C
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Nov 2014 11:43:04 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Kernel 3.17.2 and RO snapshots
Date: Sun, 02 Nov 2014 11:42:58 +0100
Message-ID: <1798985.8i0FJtRps5@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I'm a little lost with latest kernel issues, and would like to know if the 
"data corruption" with RO snapshots is fixed in 3.17.2, or not yet ?

Also about this issuse, I'd like to know if :

- Data corruption occurs when creating RO snapshots,

- Or if it can occur with just using a FS that already has RO snapshots ?

- Or if it can occur when deleting existing RO snapshots with 3.17 ?

Which means : If I have mistakenty upgraded to 3.17.2 a system containing RO 
snapshots and cannot downgrade (big distro and drivers mess...), what is the 
safest way to go ?

And if data corruption occurs, should I expect it to affect snapshots only, or 
the whole system ?

TIA for any insight.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

