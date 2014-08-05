Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:54140 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608AbaHEHkm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 03:40:42 -0400
Received: from mailgw82.hrz.uni-giessen.de by merkurneu.hrz.uni-giessen.de with ESMTP for linux-btrfs@vger.kernel.org; Tue, 5 Aug 2014 09:25:31 +0200
Received: from merkur.hrz.uni-giessen.de (merkur.hrz.uni-giessen.de [134.176.2.12])
	by mailgw82.hrz.uni-giessen.de (Postfix) with ESMTP id 5080D4800081
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Aug 2014 09:25:14 +0200 (CEST)
Received: from [134.176.2.12] by merkur.hrz.uni-giessen.de with ESMTP for linux-btrfs@vger.kernel.org; Tue, 5 Aug 2014 09:25:14 +0200
Message-Id: <53E086D9.3080806@computational.bio.uni-giessen.de>
Date: Tue, 05 Aug 2014 09:25:13 +0200
From: Burkhard Linke <Burkhard.Linke@computational.bio.uni-giessen.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Changing the sector size of the underlying storage
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been using a btrfs volume in a NFS server for some time, based in 
iscsi storage with 4k sectors. Due to problems with NFS I've decided to 
drop iscsi and make the iscsi target server (standard x86 box with raid 
drive) a secondary NFS server.

This requires mounting the btrfs volume directly on the new NFS server. 
The raid array (linux md raid 6) reports the raid drive as a 512b sector 
size drive. Mounting the btrfs volume fails with an "already mounted" 
error message; running "btrfs check" also does not recognize the volume. 
"btrfs fi show" shows the correct information about the volume, 
"btrfs-show-super" also prints the correct information from the 
superblock. It also indicates that the volume assumes 4k sectors. I was 
finally able to mount the volume using a loopback device. A subsequent 
scrub run show no errors at all, so the volume itself is ok.

The questions are:

- Is btrfs dependent on the sector size of the underlying storage?
- Is it possible to change the sector size, e.g. after migrating a 
volume to a different storage?

Output of btrfs-show-super:
superblock: bytenr=65536, device=/dev/vg00/secondary_nas
---------------------------------------------------------
csum            0xb9f1cb2f [match]
bytenr            65536
flags            0x1
magic            _BHRfS_M [match]
fsid            41eea530-05a9-4af4-9c23-a12d99ec64d0
label            secondary
generation        108373
root            13237056634880
sys_array_size        129
chunk_root_generation    108362
root_level        1
chunk_root        13272016519168
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
total_bytes        32985348833280
bytes_used        13287498846208
sectorsize        4096
nodesize        16384
leafsize        16384
stripesize        4096
root_dir        6
num_devices        1
compat_flags        0x0
compat_ro_flags        0x0
incompat_flags        0x61
csum_type        0
csum_size        4
cache_generation    108373
uuid_tree_generation    108373
dev_item.uuid        3b80d2e0-3cd7-46fd-b9be-f0c318e0ec75
dev_item.fsid        41eea530-05a9-4af4-9c23-a12d99ec64d0 [match]
dev_item.type        0
dev_item.total_bytes    32985348833280
dev_item.bytes_used    13315547856896
dev_item.io_align    4096
dev_item.io_width    4096
dev_item.sector_size    4096
dev_item.devid        1
dev_item.dev_group    0
dev_item.seek_speed    0
dev_item.bandwidth    0
dev_item.generation    0

I can live with the current setup for the moment, but using the loopback 
device may have an impact on performance, so I'm looking for the easiest 
way to mount the volume without any workaround

Best regards,
Burkhard Linke

-- 
Dr. rer. nat. Burkhard Linke
Bioinformatics and Systems Biology
Justus-Liebig-University Giessen
35392 Giessen, Germany
Phone: (+49) (0)641 9935810

