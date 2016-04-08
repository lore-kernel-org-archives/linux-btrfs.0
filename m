Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43963 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbcDHLBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 07:01:06 -0400
Received: from merkaba.localnet (ppp-93-104-55-137.dynamic.mnet-online.de [93.104.55.137])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 22C6224A
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Apr 2016 13:01:04 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send/receive using generation number as source
Date: Fri, 08 Apr 2016 13:01:03 +0200
Message-ID: <7303236.im7zcVY3uK@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

As far as I understood, for differential btrfs send/receive – I didn´t use it 
yet – I need to keep a snapshot on the source device to then tell btrfs send 
to send the differences between the snapshot and the current state.

Now the BTRFS filesystems on my SSDs are often quite full, thus I do not keep 
any snapshots except for one during rsync or borgbackup script run-time.

Is it possible to tell btrfs send to use generation number xyz to calculate 
the difference? This way, I wouldn´t have to keep a snapshot around, I 
believe.

I bet not, at the time cause -c wants a snapshot. Ah and it wants a snapshot 
of the same state on the destination as well. Well on the destination I let 
the script make a snapshot after the backup so… what I would need is to 
remember the generation number of the source snapshot that the script creates 
to backup from and then tell btrfs send that generation number + the 
destination snapshots.

Well, or get larger SSDs or get rid of some data on them.

Thanks,
-- 
Martin
