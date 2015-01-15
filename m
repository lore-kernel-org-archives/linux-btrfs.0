Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:41391 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbAOT7U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 14:59:20 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id C4576156AC
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 19:54:12 +0000 (GMT)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id bwQYXNdfbm6J for <linux-btrfs@vger.kernel.org>;
	Thu, 15 Jan 2015 19:54:10 +0000 (GMT)
Message-ID: <54B81AE2.7050902@pocock.pro>
Date: Thu, 15 Jan 2015 20:54:10 +0100
From: Daniel Pocock <daniel@pocock.pro>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: BtrFs on drives with error recovery control / TLER?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi,

Can anybody comment on how BtrFs (particularly RAID1 mirroring)
interacts with drives that offer error recovery control (or TLER in WDC
terms)?

I generally prefer to buy this type of drive for any serious data
storage purposes

I notice ZFS gets a mention in the Wikipedia article about the topic:
http://en.wikipedia.org/wiki/Error_recovery_control

Should BtrFs be mentioned there too?

Regards,

Daniel
