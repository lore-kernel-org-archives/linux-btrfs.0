Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:35184 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbbKZXzD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 18:55:03 -0500
Received: from [192.168.1.5] (unknown [119.224.19.150])
	by pim.lukas-pirl.de (Postfix) with ESMTPSA id 2759220BA015
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 23:55:00 +0000 (UTC)
From: Lukas Pirl <btrfs@lukas-pirl.de>
Subject: implications of mixed mode
To: linux-btrfs@vger.kernel.org
Message-ID: <56579BD1.4030401@lukas-pirl.de>
Date: Fri, 27 Nov 2015 12:54:57 +1300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

if a larger RAID file system (say disk space of 8 TB in total) is
created in mixed mode, what are the implications?

>From reading the mailing list and the Wiki, I can think of the following:

+ less hassle with "false positive" ENOSPC
- data and metadata have to have the same replication level
  forever (e.g. RAID 1)
- higher fragmentation
  (does this reduce with no(dir)atime?)
  -> more work for autodefrag

Is that roughly what is to be expected? Any implications on recovery etc.?

In the specific case, the file system usage is as follows:
* data spread over ~20 subvolumes
  * snapshotted with various frequencies
  * compression is used
* mostly archive storage
  * write once
  * read infrequently
* ~500GB of daily rsync'ed system backup

Thanks in advance,

Lukas
