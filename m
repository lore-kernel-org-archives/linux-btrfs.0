Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27927 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682AbcAHBoL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jan 2016 20:44:11 -0500
Subject: Re: Broken RAID6, segfault on chunk-recover
To: Abe <ml-btrfs@zeroloop.net>, <linux-btrfs@vger.kernel.org>
References: <568A7460.6070607@zeroloop.net>
 <9e61601b1589f0fd9381dc9cf0232e0e@mail.zeroloop.net>
 <568E94CA.4070907@zeroloop.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <568F13FD.90605@cn.fujitsu.com>
Date: Fri, 8 Jan 2016 09:42:21 +0800
MIME-Version: 1.0
In-Reply-To: <568E94CA.4070907@zeroloop.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Abe wrote on 2016/01/07 17:39 +0100:
> No wonder why chunck-recover crashed, superblocks are valid but they all
> contain a bogus chunk_root, it exceeds the total_bytes !
> So all I need it to find where that btree root is on disk, right?
>
> Problem is almost every tool from btrfs-progs is unusuable because they
> try to read the chunck root at first. Do you know of any alternative
> tool that could scan devices and find where roots might be?

First, you're wrong about the total_bytes and chunk_root bytenr.

Chunk_root bytenr is btrfs *logical* bytenr.
It is completely OK for logical bytenr to beyond total bytenr,

So the problem is not here.


The real problem for chunk recovery to segfault, would be that, in your 
cmds-check.c:5013, the leaf->data could be empty.

But you did give enough info or checked *leaf, so I can't determine now.

To recovery your RAID6, the possible chance lies in your superblock.

Please use run btrfs-show-super with -f -a to get full backup roots output.
Which may have a good old chunk root.

Thanks,
Qu

>
>
> All superblock copies for all devices look like this :
>
> # ./btrfs-show-super /dev/sdb1
> superblock: bytenr=65536, device=/dev/sdb1
> ---------------------------------------------------------
> csum			0x938855ef [match]
> bytenr			65536
> flags			0x1
> 			( WRITTEN )
> magic			_BHRfS_M [match]
> fsid			bec7b9a0-c56c-494e-8631-072d3f89c0c9
> label			hive
> generation		34245
> root			6766859681792
> sys_array_size		321
> chunk_root_generation	32751
> root_level		1
> chunk_root		4415566151680  <--- Impossible Offset
> chunk_root_level	1
> log_root		0
> log_root_transid	0
> log_root_level		0
> total_bytes		4096872997376  <---
> bytes_used		2438972817408
> sectorsize		4096
> nodesize		16384
> leafsize		16384
> stripesize		4096
> root_dir		6
> num_devices		8
> compat_flags		0x0
> compat_ro_flags		0x0
> incompat_flags		0x1e1
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  RAID56 |
> 			  SKINNY_METADATA )
> csum_type		0
> csum_size		4
> cache_generation	34245
> uuid_tree_generation	34245
> dev_item.uuid		ea4a089b-c88c-4a6c-80e5-b2c93f0613f5
> dev_item.fsid		bec7b9a0-c56c-494e-8631-072d3f89c0c9 [match]
> dev_item.type		0
> dev_item.total_bytes	512109125120
> dev_item.bytes_used	349754621952
> dev_item.io_align	4096
> dev_item.io_width	4096
> dev_item.sector_size	4096
> dev_item.devid		5
> dev_item.dev_group	0
> dev_item.seek_speed	0
> dev_item.bandwidth	0
> dev_item.generation	0
>
>
> Best regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


