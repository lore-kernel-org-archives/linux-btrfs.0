Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57499 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3KGRzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 12:55:42 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 479659A06B6
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Nov 2013 10:55:42 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
CC: <quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Message-ID: <20131107175456.3802.35292@localhost.localdomain>
Subject: Re: [PATCH v3 00/17] Replace btrfs_workers with kernel workqueue based
 btrfs_workqueue_struct
Date: Thu, 7 Nov 2013 12:54:56 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Qu Wenruo (2013-11-07 00:51:50)
> Add a new btrfs_workqueue_struct which use kernel workqueue to implement
> most of the original btrfs_workers, to replace btrfs_workers.
> 
> With this patchset, redundant workqueue codes are replaced with kernel
> workqueue infrastructure, which not only reduces the code size but also the
> effort to maintain it.
> 
> More performace tests are ongoing, the result from sysbench shows minor
> improvement on the following server:
> CPU: two-way Xeon X5660
> RAM: 4G 
> HDD: SAS HDD, 150G total, 40G partition for btrfs test
> 
> Test result:
> Mode|Num_threads|block size|extra flags|performance change vs 3.11 kernel
> rndrd   1       4K      none            +1.22%
> rndrd   1       32K     none            +1.00%
> rndrd   8       32K     sync            +1.35%
> seqrd   8       4K      direct          +5.56%
> seqwr   8       4K      none            -1.26%
> seqwr   8       32K     sync            +1.20%
> 
> Changes below 1% are not mentioned.
> Overall the patchset doesn't change the performance on HDD.
> 
> Since more tests are needed, more test result are welcomed.

Thanks for working on this, it's really good to move toward a single set
of workqueues in the kernel.

Have you benchmarked with compression on?  Especially on modern
hardware, the crcs don't exercise the workqueues very much.

-chris
