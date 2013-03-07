Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-108-0-197-17.lsanca.fios.verizon.net ([108.0.197.17]:56842
	"EHLO orca4.orcaware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3CGUY6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 15:24:58 -0500
Message-ID: <5138F798.6000104@orcaware.com>
Date: Thu, 07 Mar 2013 12:24:56 -0800
From: Blair Zajac <blair@orcaware.com>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Forwarding orphan cleanup fix(es) to 3.8 stable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It looks like [1] and [2] didn't make it into 3.8 and are not in 3.8.2, 
nor the queue [3].  Can somebody forward them to stable, if they are 
appropriate?  I think these are the proper commits:

925396e Btrfs: account for orphan inodes properly during cleanup
4a7d0f6 Btrfs: cleanup orphan reservation if truncate fails

Thanks,
Blair

[1] https://patchwork.kernel.org/patch/2083101/
[2] 
http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=4a7d0f6854c4a4ad1dba00a3b128a32d39b9a742
[3] 
http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git/tree/queue-3.8
