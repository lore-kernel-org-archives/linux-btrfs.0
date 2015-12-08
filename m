Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:10986 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbbLHUqv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 15:46:51 -0500
Received: from i5.rohdewald.de (p5B3E226D.dip0.t-ipconnect.de [91.62.34.109])
	by smtp.strato.de (RZmta 37.14 DYNA|AUTH)
	with ESMTPSA id L054c7rB8KknnOE
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Tue, 8 Dec 2015 21:46:49 +0100 (CET)
Received: from i5.localnet (localhost.localdomain [127.0.0.1])
	by i5.rohdewald.de (Postfix) with ESMTP id 0D4125E08E0
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2015 21:46:49 +0100 (CET)
From: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs scrub can neither start nor cancel
Date: Tue, 08 Dec 2015 21:46:48 +0100
Message-ID: <31519331.YQjdnfjTR6@i5>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just tried this script:
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair

but I did not pass the directory where the filesystem is mounted.

Next I called it correctly: btrfs-scrub /t4
I also tried btrfs scrub start / cancel directly, but 
I am not really sure what I did in which order.

Anyway now I can neither cancel nor start btrfs scrub. Rebooting did not help.
Running unmodified Linux 4.3

It seems like scrub stopped and did not clean up. Maybe because:
Dec  8 21:07:41 s5 kernel: [17833.840868] btrfs[23746]: segfault at ffffffffffffff98 ip 00000000004079e1 sp 00007fffafa27510 error 5 in btrfs[400000+53000]

How can I now clean this up?

root@s5:~# btrfs --version
Btrfs v3.12

root@s5:~# btrfs scrub status /t4
scrub status for 700900de-e35f-4264-8f5d-1b2b249a5c3a
        scrub started at Tue Dec  8 21:05:31 2015, running for 20 seconds
        total bytes scrubbed: 3.09GiB with 0 errors

root@s5:~# btrfs scrub cancel /t4
ERROR: scrub cancel failed on /t4: not running

root@s5:~# btrfs scrub start /t4
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /t4'.
To see the status use 'btrfs scrub status [-d] /t4'.


-- 
Wolfgang
