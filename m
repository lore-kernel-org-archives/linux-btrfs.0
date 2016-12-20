Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36073 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754639AbcLTHzL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 02:55:11 -0500
Received: by mail-lf0-f68.google.com with SMTP id o20so9567168lfg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 23:55:07 -0800 (PST)
Subject: Re: Help please: BTRFS fs crashed due to bad removal of USB drive, no
 help from recovery procedures
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
From: =?utf-8?B?SmFyaSBTZXBww6Rsw6Q=?= <lihamakaroonilaatikko@gmail.com>
In-Reply-To: <trinity-65b0bf95-1288-4044-9bd4-c47299bb96c4-1482173054794@3capp-mailcom-bs02>
Date: Tue, 20 Dec 2016 09:55:04 +0200
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D3373265-0EB0-45A5-B951-2368186D1AAB@gmail.com>
References: <66A9C2C6-028F-466B-9EFF-F06BF3FB4694@gmail.com>
 <trinity-2653fb5f-aa88-4ece-bced-51dee466d428-1482006464623@3capp-mailcom-bs11>
 <5A6A5345-FD05-402C-A003-7C742007F94D@gmail.com>
 <trinity-65b0bf95-1288-4044-9bd4-c47299bb96c4-1482173054794@3capp-mailcom-bs02>
To: Xin Zhou <xin.zhou@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Xin Zhou <xin.zhou@gmx.com> kirjoitti 19.12.2016 kello 20.44:
> 
> Hi Jari,
> 
> The message shows:
>> [ 135.446260] BTRFS error (device sdb1): superblock contains fatal errors
> 
> So according this info, before trying to run repair / rescue procedure, would you like to show the 0,1,2 superblock status?
> 
btrfs-show-super /dev/sdb1 -i 0 to 2

superblock: bytenr=65536, device=/dev/sdb1
---------------------------------------------------------
csum			0x73d698e5 [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			82651f91-4989-415b-bd83-ae830f12608c
label			share
generation		75016
root			29851648
sys_array_size		0
chunk_root_generation	75016
root_level		1
chunk_root		20971520
chunk_root_level	0
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		536869842944
bytes_used		294473035776
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x161
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	75012
uuid_tree_generation	75012
dev_item.uuid		108c02c0-9812-428e-8f90-23bdf88e11bf
dev_item.fsid		82651f91-4989-415b-bd83-ae830f12608c [match]
dev_item.type		0
dev_item.total_bytes	536869842944
dev_item.bytes_used	440259313664
dev_item.io_align	0
dev_item.io_width	0
dev_item.sector_size	0
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0

superblock: bytenr=67108864, device=/dev/sdb1
---------------------------------------------------------
csum			0xd3b7b02b [match]
bytenr			67108864
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			82651f91-4989-415b-bd83-ae830f12608c
label			share
generation		75016
root			29851648
sys_array_size		0
chunk_root_generation	75016
root_level		1
chunk_root		20971520
chunk_root_level	0
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		536869842944
bytes_used		294473035776
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x161
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	75012
uuid_tree_generation	75012
dev_item.uuid		108c02c0-9812-428e-8f90-23bdf88e11bf
dev_item.fsid		82651f91-4989-415b-bd83-ae830f12608c [match]
dev_item.type		0
dev_item.total_bytes	536869842944
dev_item.bytes_used	440259313664
dev_item.io_align	0
dev_item.io_width	0
dev_item.sector_size	0
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0

superblock: bytenr=274877906944, device=/dev/sdb1
---------------------------------------------------------
csum			0x2e30e61a [match]
bytenr			274877906944
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			82651f91-4989-415b-bd83-ae830f12608c
label			share
generation		75016
root			29851648
sys_array_size		0
chunk_root_generation	75016
root_level		1
chunk_root		20971520
chunk_root_level	0
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		536869842944
bytes_used		294473035776
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		1
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x161
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	75012
uuid_tree_generation	75012
dev_item.uuid		108c02c0-9812-428e-8f90-23bdf88e11bf
dev_item.fsid		82651f91-4989-415b-bd83-ae830f12608c [match]
dev_item.type		0
dev_item.total_bytes	536869842944
dev_item.bytes_used	440259313664
dev_item.io_align	0
dev_item.io_width	0
dev_item.sector_size	0
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0


Regards,

Jari

> Regards,
> Xin
>  
>  
> 
> Sent: Monday, December 19, 2016 at 2:32 AM
> From: "Jari Seppälä" <lihamakaroonilaatikko@gmail.com>
> To: linux-btrfs@vger.kernel.org
> Cc: "Xin Zhou" <xin.zhou@gmx.com>
> Subject: Re: Help please: BTRFS fs crashed due to bad removal of USB drive, no help from recovery procedures
> Xin Zhou <xin.zhou@gmx.com> kirjoitti 17.12.2016 kello 22.27:
>> 
>> Hi Jari,
>> 
>> Similar with other file system, btrfs has copies of super blocks.
>> Try to run "man btrfs check", "man btrfs rescue" and related commands for more details.
>> Regards,
>> Xin
> 
> Hi Xin,
> 
> I did follow all recovery procedures from man and wiki pages. Tools do not help as they thing there is no BTRFS fs anymore. However if I try to reformat the device I get:
> 
> btrfs-progs v4.4
> See http://btrfs.wiki.kernel.org for more information.
> /dev/sdb1 appears to contain an existing filesystem (btrfs).
> 
> So, recovery tools seem to thing there is no btrfs filesystem. Mkfs seems to thing there is.
> 
> What I have tried:
> btrfsck /dev/sdb1
> mount -t btrfs -o ro /dev/sdb1 /mnt/share/
> mount -t btrfs -o ro,recovery /dev/sdb1 /mnt/share/
> mount -t btrfs -o roootflags=recovery,nospace_cache /dev/sdb1 /mnt/share/
> mount -t btrfs -o rootflags=recovery,nospace_cache /dev/sdb1 /mnt/share/
> mount -t btrfs -o rootflags=recovery,nospace_cache,clear_cache /dev/sdb1 /mnt/share/
> mount -t btrfs -o ro,rootflags=recovery,nospace_cache,clear_cache /dev/sdb1 /mnt/share/
> btrfs restore /dev/sdb1 /target/device
> btrfs rescue zero-log /dev/sdb1
> btrfsck --init-csum-tree /dev/sdb1
> btrfsck --fix-crc /dev/sdb1
> btrfsck --check-data-csum /dev/sdb1
> btrfs rescue chunk-recover /dev/sdb1
> btrfs rescue super-recover /dev/sdb1
> btrfs rescue zero-log /dev/sdb1
> 
> No help whatsoever.
> 
> Jari
> 
>> 
>> 
>> 
>> Sent: Saturday, December 17, 2016 at 2:06 AM
>> From: "Jari Seppälä" <lihamakaroonilaatikko@gmail.com>
>> To: linux-btrfs@vger.kernel.org
>> Subject: Help please: BTRFS fs crashed due to bad removal of USB drive, no help from recovery procedures
>> Syslog tells:
>> [ 135.446222] BTRFS error (device sdb1): system chunk array too small 0 < 97
>> [ 135.446260] BTRFS error (device sdb1): superblock contains fatal errors
>> [ 135.462544] BTRFS error (device sdb1): open_ctree failed
>> 
>> What have been done:
>> * All "btrfs rescue" options
>> 
>> Info on system
>> * fs on external SSD via USB
>> * kernel 4.9.0 (tried with 4.8.13)
>> * btrfs-tools 4.4
>> * Mythbuntu (Ubuntu) 16.04.1 LTS with latest fixes 2012-12-16
>> 
>> Any help appreciated. Around 300G of TV recordings on the drive, which of course will eventually come as replays.
>> 
>> Jari
>> --
>> *** Jari Seppälä
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html[http://vger.kernel.org/majordomo-info.html]
> 

--
*** Jari Seppälä


