Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41796 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbbCIXp1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 19:45:27 -0400
Received: by wiwl15 with SMTP id l15so26082898wiw.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Mar 2015 16:45:25 -0700 (PDT)
Received: from [192.168.2.7] (ipbcc33db6.dynamic.kabel-deutschland.de. [188.195.61.182])
        by mx.google.com with ESMTPSA id bx3sm30356501wjc.21.2015.03.09.16.45.24
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Mar 2015 16:45:25 -0700 (PDT)
Message-ID: <54FE3093.3020902@gmail.com>
Date: Tue, 10 Mar 2015 00:45:23 +0100
From: Sven Witterstein <sven.witterstein@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Raid10 performance issues during copy and balance, only half the
 spindles used for reading data
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have used btrfs and zfs for some years and feel pretty confident about 
their administration - and both with ther snaps and subvols saved me 
quite often.

I had to grow my 4x250GB Raid10-Backup-Array to a 6x500GB raid10-backup 
array - the slower half of 4 1TB 2.5" Spinpoint M8's. were to be 
enhanced with the slowest quarter of 2 2TB 2.5" spinpoint M9T's.

During balance or copies, the second image of the stripeset A + B | A' + 
B' is never used, thus throwing away about 40% of performance, e.g. it 
NEVER used A' + B' to read from even if 50% of the needed assembled data 
could have been read from there..., so 2 disks were maxed out, the other 
writing at about 40% their I/O capacity.

Also when rsyncing to ssd raid0 zpool (just for testing, the ssd-pool is 
the working pool, the zfs and btrfs disk pools are for backup) - only 3 
disks of 6 are read from.

As opposed, a properly set up mdadm "far or offset" + xfs and zfs itself 
use all spindles (devices) to read from and net data is delivered twice 
as fast.

I would love to see btrfs trying harder to deliver data - it slips my 
mind whether it is a missing feature in btrfs raid10 right now or a bug 
in the 3.16 lines of kernel I am using (mint rebecca on my workstation).

If anybody knows about it, or I am missing something (-m=raid10 
-d=raid10 was OK I hope when rebalancing?)
I'd like to be enlightened (when I googled it was always stated that 
btrfs would read from all spindles, but it's not the case for me...)

Sven.
