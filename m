Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48066 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755728AbaJ2Vzz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 17:55:55 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:50577 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XjbDe-001qk9-Vq
	for linux-btrfs@vger.kernel.org; Wed, 29 Oct 2014 15:55:55 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: [bug] allows umount before transactions complete
Message-Id: <A74CB3CB-8C39-4CEE-BAEB-E7950D246CAB@colorremedies.com>
Date: Wed, 29 Oct 2014 15:55:54 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filed bug here with more details and complete dmesg attached:
https://bugzilla.kernel.org/show_bug.cgi?id=87131

kernel-3.18.0-0.rc2.git1.1.fc22.x86_64

SUMMARY:
 After umount returning to prompt, and physical disconnected 2x devices (btrfs raid1 on raw devices), I get a backtrace with some scary messages. Here are some snippets:
[10570.371285] BTRFS: error (device sdc) in btrfs_commit_transaction:1917: errno=-5 IO failure (Error while writing out transaction)
[10570.372426] BTRFS info (device sdc): forced readonly
[10570.372432] BTRFS warning (device sdc): Skipping commit of aborted transaction.
[10570.372456] BTRFS: Transaction aborted (error -5)
[10570.372807] BTRFS: error (device sdc) in cleanup_transaction:1599: errno=-5 IO failure
[10570.373960] BTRFS info (device sdc): delayed_refs has NO entry

After reboot, kernel shows both devids have the same generation.
btrfs check comes up clean.
mount also has no complaints, and mounts rw.


Chris Murphy