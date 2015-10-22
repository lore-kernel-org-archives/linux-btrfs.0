Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51192 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbbJVIlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 04:41:17 -0400
Received: from merkaba.localnet (unknown [91.221.105.244])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id C9B391FB
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 10:41:15 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: [4.3-rc4] scrubbing aborts before finishing
Date: Thu, 22 Oct 2015 10:41:15 +0200
Message-ID: <16063727.bYixifcRQC@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I get this:

merkaba:~> btrfs scrub status -d /       
scrub status for […]
scrub device /dev/mapper/sata-debian (id 1) history
        scrub started at Thu Oct 22 10:05:49 2015 and was aborted after 00:00:00
        total bytes scrubbed: 0.00B with 0 errors
scrub device /dev/dm-2 (id 2) history
        scrub started at Thu Oct 22 10:05:49 2015 and was aborted after 00:01:30
        total bytes scrubbed: 23.81GiB with 0 errors

For / scrub aborts for sata SSD immediately.

For /home scrub aborts for both SSDs at some time.

merkaba:~> btrfs scrub status -d /home
scrub status for […]
scrub device /dev/mapper/msata-home (id 1) history
        scrub started at Thu Oct 22 10:09:37 2015 and was aborted after 00:01:31
        total bytes scrubbed: 22.03GiB with 0 errors
scrub device /dev/dm-3 (id 2) history
        scrub started at Thu Oct 22 10:09:37 2015 and was aborted after 00:03:34
        total bytes scrubbed: 53.30GiB with 0 errors

Also single volume BTRFS is affected:

merkaba:~> btrfs scrub status /daten
scrub status for […]
        scrub started at Thu Oct 22 10:36:38 2015 and was aborted after 00:00:00
        total bytes scrubbed: 0.00B with 0 errors


No errors in dmesg, btrfs device stat or smartctl -a.

Any known issue?

Thanks,
-- 
Martin
