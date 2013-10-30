Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from avasout03.plus.net ([84.93.230.244]:39118 "EHLO
	avasout03.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3J3MVW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Oct 2013 08:21:22 -0400
Message-ID: <5270F854.7090402@mipmip.org>
Date: Wed, 30 Oct 2013 12:15:16 +0000
From: Mike Arnautov <mla@mipmip.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Metadata reservation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have just moved some partitions on two Linux (Mageia 3) boxes to btrfs 
(call the boxes A and B). In both cases only a part of one physical disk 
can be allocated to btrfs.

On box A, the btrfs partition size is 419 GB and the resulting usable 
space is 418 GB with 1GB reserved by btrfs for metadata.

However, on box B, where the partition size is 388 GB, reserved metadata 
amounts to 128 GB (!), leaving just 266 GB for data.

I've now done box B twice. Once using btrfs-convert and once by 
reverting to ext4, and using KDE control centre to change the type of 
the partition to btrfs, restoring the data from backups. In both cases 
metadata reservation amount to 128 GB -- about 30% of the disk.

Any suggestions on (a) what the cause might be and (b) how to improve 
things?

Thanks in advance,

-- 
Mike Arnautov
mailto:mla@mipmip.org
http://mipmip.org
