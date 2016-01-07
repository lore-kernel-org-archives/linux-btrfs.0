Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.arkena.net ([95.81.173.75]:50624 "EHLO smtp-2.arkena.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbcAGQjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jan 2016 11:39:41 -0500
Received: from [10.201.4.47] (unknown [10.201.4.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-2.arkena.net (Postfix) with ESMTPSA id 3pbtZL5z8MzHkDZ
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 16:39:38 +0000 (UTC)
Subject: Re: Broken RAID6, segfault on chunk-recover
To: linux-btrfs@vger.kernel.org
References: <568A7460.6070607@zeroloop.net>
 <9e61601b1589f0fd9381dc9cf0232e0e@mail.zeroloop.net>
From: Abe <ml-btrfs@zeroloop.net>
Message-ID: <568E94CA.4070907@zeroloop.net>
Date: Thu, 7 Jan 2016 17:39:38 +0100
MIME-Version: 1.0
In-Reply-To: <9e61601b1589f0fd9381dc9cf0232e0e@mail.zeroloop.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No wonder why chunck-recover crashed, superblocks are valid but they all
contain a bogus chunk_root, it exceeds the total_bytes !
So all I need it to find where that btree root is on disk, right?

Problem is almost every tool from btrfs-progs is unusuable because they
try to read the chunck root at first. Do you know of any alternative
tool that could scan devices and find where roots might be?


All superblock copies for all devices look like this :

# ./btrfs-show-super /dev/sdb1
superblock: bytenr=65536, device=/dev/sdb1
---------------------------------------------------------
csum			0x938855ef [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			bec7b9a0-c56c-494e-8631-072d3f89c0c9
label			hive
generation		34245
root			6766859681792
sys_array_size		321
chunk_root_generation	32751
root_level		1
chunk_root		4415566151680  <--- Impossible Offset
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		4096872997376  <---
bytes_used		2438972817408
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		8
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x1e1
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  RAID56 |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	34245
uuid_tree_generation	34245
dev_item.uuid		ea4a089b-c88c-4a6c-80e5-b2c93f0613f5
dev_item.fsid		bec7b9a0-c56c-494e-8631-072d3f89c0c9 [match]
dev_item.type		0
dev_item.total_bytes	512109125120
dev_item.bytes_used	349754621952
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		5
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0


Best regards,
