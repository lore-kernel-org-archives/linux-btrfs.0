Return-Path: <SRS0=WqnK=PU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EF2C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 12 Jan 2019 10:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57D9D20870
	for <linux-btrfs@archiver.kernel.org>; Sat, 12 Jan 2019 10:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbfALKTS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 12 Jan 2019 05:19:18 -0500
Received: from gfuc.org ([88.99.83.187]:40454 "EHLO gfuc.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfALKTS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Jan 2019 05:19:18 -0500
Received: from [192.168.178.72] (dslb-092-075-218-113.092.075.pools.vodafone-ip.de [92.75.218.113])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by gfuc.org (Postfix) with ESMTPSA id 279351E01E3;
        Sat, 12 Jan 2019 10:19:15 +0000 (UTC)
Subject: Re: applications hang on a btrfs spanning two partitions
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de>
 <51f6646b-ca38-9b34-7061-8ab5227f00ae@suse.com>
 <2d2ac67d-3cf5-d147-f57b-785dc633821d@florianstecker.de>
 <936b36f0-bd50-3ce1-5045-69a3604d4bfd@suse.com>
 <7b4fa64b-e981-52c5-4597-40b5ea2df5b3@florianstecker.de>
 <CAJCQCtQF0DU+yAH33iSXu2NBk7TCWCUZ4STC2TExW3+dJpK-Hw@mail.gmail.com>
From:   Florian Stecker <m19@florianstecker.de>
Message-ID: <aeaf4b99-a9d5-6335-67f3-e7f851e50b32@florianstecker.de>
Date:   Sat, 12 Jan 2019 11:19:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQF0DU+yAH33iSXu2NBk7TCWCUZ4STC2TExW3+dJpK-Hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I found out a few things in the meantime:

* My IO scheduler is mq-deadline by default. When I switch it to none, 
the problem disappears
* What hangs is the call to wait_on_buffer inside wait_dev_supers, while 
waiting for superblock 0 of device 1 to be written. That is /dev/sda8, 
i.e. the one which is physically behind /dev/sda2, but has the lower 
device id

So it seems to me as if btrfs produces some strange sequence of writes 
which confuse the scheduler and cause it to hang? Could this have to do 
with the fact that the order of devids is different to the physical 
order of the partitons?

If you guys want me to, I can definitely put some printks etc. into my 
kernel. I just know too little about the code to see what information 
could be useful.

 > What do you get for:
 > mount | grep btrfs
 > btrfs insp dump-s -f /dev/sda8

$ mount | grep btrfs
/dev/sda8 on / type btrfs (rw,relatime,ssd,space_cache,subvolid=5,subvol=/)

$ btrfs insp dump-s -f /dev/sda8
superblock: bytenr=65536, device=/dev/sda8
---------------------------------------------------------
csum_type		0 (crc32c)
csum_size		4
csum			0x5a2fbdf1 [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			c4c0b512-00d3-42f2-a2e1-dcc62a2acd98
label			
generation		575201
root			622264320
sys_array_size		97
chunk_root_generation	574575
root_level		1
chunk_root		241407393792
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		243285360640
bytes_used		184232562688
sectorsize		4096
nodesize		16384
leafsize (deprecated)		16384
stripesize		4096
root_dir		6
num_devices		2
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x161
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
cache_generation	575201
uuid_tree_generation	574411
dev_item.uuid		3e8d6ecb-a595-4c6a-aae8-e6a09e5b151d
dev_item.fsid		c4c0b512-00d3-42f2-a2e1-dcc62a2acd98 [match]
dev_item.type		0
dev_item.total_bytes	187823030272
dev_item.bytes_used	183523868672
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0
sys_chunk_array[2048]:
	item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 241407361024)
		length 33554432 owner 2 stripe_len 65536 type SYSTEM
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 1 sub_stripes 1
			stripe 0 devid 2 offset 1074790400
			dev_uuid d56afd3b-d89c-4e59-8850-7dedd84900b9
backup_roots[4]:
	backup 0:
		backup_tree_root:	618283008	gen: 575198	level: 1
		backup_chunk_root:	241407393792	gen: 574575	level: 1
		backup_extent_root:	616038400	gen: 575198	level: 2
		backup_fs_root:		593952768	gen: 575198	level: 2
		backup_dev_root:	487751680	gen: 575188	level: 0
		backup_csum_root:	594149376	gen: 575198	level: 2
		backup_total_bytes:	243285360640
		backup_bytes_used:	184231972864
		backup_num_devices:	2

	backup 1:
		backup_tree_root:	613908480	gen: 575199	level: 1
		backup_chunk_root:	241407393792	gen: 574575	level: 1
		backup_extent_root:	607731712	gen: 575199	level: 2
		backup_fs_root:		622444544	gen: 575200	level: 2
		backup_dev_root:	487751680	gen: 575188	level: 0
		backup_csum_root:	603389952	gen: 575199	level: 2
		backup_total_bytes:	243285360640
		backup_bytes_used:	184232038400
		backup_num_devices:	2

	backup 2:
		backup_tree_root:	628539392	gen: 575200	level: 1
		backup_chunk_root:	241407393792	gen: 574575	level: 1
		backup_extent_root:	616103936	gen: 575200	level: 2
		backup_fs_root:		622444544	gen: 575200	level: 2
		backup_dev_root:	487751680	gen: 575188	level: 0
		backup_csum_root:	616890368	gen: 575200	level: 2
		backup_total_bytes:	243285360640
		backup_bytes_used:	184232468480
		backup_num_devices:	2

	backup 3:
		backup_tree_root:	622264320	gen: 575201	level: 1
		backup_chunk_root:	241407393792	gen: 574575	level: 1
		backup_extent_root:	617791488	gen: 575201	level: 2
		backup_fs_root:		615432192	gen: 575201	level: 2
		backup_dev_root:	487751680	gen: 575188	level: 0
		backup_csum_root:	615841792	gen: 575201	level: 2
		backup_total_bytes:	243285360640
		backup_bytes_used:	184232562688
		backup_num_devices:	2

