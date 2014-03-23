Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58552 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaCWOwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 10:52:49 -0400
Received: from mfilter2-d.gandi.net (mfilter2-d.gandi.net [217.70.178.140])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id BD1E141C056
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 15:52:46 +0100 (CET)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter2-d.gandi.net (mfilter2-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id lTZPZTZJqsWC for <linux-btrfs@vger.kernel.org>;
	Sun, 23 Mar 2014 15:52:45 +0100 (CET)
Received: from tethys.localnet (AMontpellier-256-1-48-52.w90-28.abo.wanadoo.fr [90.28.15.52])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 138C541C051
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 15:52:44 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Rebalance makes BTRFS 10x slower
Date: Sun, 23 Mar 2014 15:51:34 +0100
Message-ID: <4392627.HWimVooIO4@tethys>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

# uname -r
3.13.6-1-ARCH
# btrfs --version
Btrfs v3.12

After having read the recent discussion about rebalance, I ran it for a test 
on my laptop with a 1TB HD, which current situation (after rebalance) is :

# btrfs fi sh
Label: TETHYS  uuid: 9a1ca6f4-1c1b-4a62-a84b-b388066084dc
        Total devices 1 FS bytes used 575.56GiB
        devid    1 size 845.00GiB used 580.06GiB path /dev/dm-3

Label: BOOT  uuid: 6a16d133-4b99-47b2-876f-148a8266f58f
        Total devices 1 FS bytes used 67.99MiB
        devid    1 size 1.00GiB used 144.00MiB path /dev/dm-0

Btrfs v3.12

# btrfs fi df /
Data, single: total=574.00GiB, used=573.60GiB
System, DUP: total=32.00MiB, used=72.00KiB
Metadata, DUP: total=3.00GiB, used=1.96GiB

# df -h /boot /
Sys. de fichiers Taille Utilisé Dispo Uti% Monté sur
/dev/dm-0          1,0G     68M  924M   7% /boot
/dev/dm-3          845G    578G  266G  69% /


The rebalance for the biggest BTRFS took about 19 hours.

I was expecting either a speed improvement after rebalance, or no noticeable 
effect, but I am extremely disappointed to see that now (and after having 
rebooted), my system has become slow like hell, takes at least 10x longer to 
boot and operate, to the point it has become hardly usable :-(

I would have thought a rebalance would have improved the filesystem 
organization, looks like it's the absolute contrary :-(

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

