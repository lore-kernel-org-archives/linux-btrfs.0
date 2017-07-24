Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:29740 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751822AbdGXL1h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 07:27:37 -0400
Received: from mordor.fritz.box (xd932dc59.dyn.telefonica.de [217.50.220.89])
        by smtp.strato.de (RZmta 41.1 DYNA|AUTH)
        with ESMTPSA id Y09037t6OBRame1
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Mon, 24 Jul 2017 13:27:36 +0200 (CEST)
Message-ID: <1500895655.2781.6.camel@cloud.haefemeier.eu>
Subject: Best Practice: Add new device to RAID1 pool
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: linux-btrfs@vger.kernel.org
Date: Mon, 24 Jul 2017 13:27:35 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have a multi-device pool (three discs) as RAID1. Now I want to add a
new disc to increase the pool. I followed the description on https://bt
rfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices and
used 'btrfs add <device> <btrfs path>'. After that I called a balance
for rebalancing the RAID1 using 'btrfs balance start <btrfs path>'. 
Is that anything or should I need to call a resize (for example) or
anything else? Or do I need to specify filter/profile parameters for
balancing?
I am a little bit confused because the balance command is running since
12 hours and only 3GB of data are touched. This would mean the whole
balance process (new disc has 8TB) would run a long, long time... and
is using one cpu by 100%.
Thanks for your help and time.
Bye
	Frank

