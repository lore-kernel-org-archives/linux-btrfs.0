Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51958 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbbEFRrd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 13:47:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yq3Pu-0005UR-04
	for linux-btrfs@vger.kernel.org; Wed, 06 May 2015 19:47:30 +0200
Received: from c-24-5-205-109.hsd1.ca.comcast.net ([24.5.205.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 19:47:29 +0200
Received: from obiwantje by c-24-5-205-109.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 19:47:29 +0200
To: linux-btrfs@vger.kernel.org
From: TheJay <obiwantje@gmail.com>
Subject: Re: [REQ] Help to gain access to btrfsraid6 pool that won't mount
Date: Wed, 6 May 2015 17:47:24 +0000 (UTC)
Message-ID: <midk3c$ri6$5@ger.gmane.org>
References: <mi8452$i00$1@ger.gmane.org>
	<pan$bf105$8407f6ba$59e45aa$6ad3abdc@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 06 May 2015 11:55:51 +0000, Duncan wrote:

> 
> Since then, I had to use it again myself, updating my year-old personal 
> experience.  Among other things, btrfs-progs v4.0 has a new metadata 
> restore option, which should restore ownership/perms/dates as well as the 
> file data.  There's a patch to restore symlinks too, but it apparently 
> didn't make it into 4.0, so you'll have to try the integration branch or 
> apply it manually after finding it on the list.  The looping too many 
> times point apparently doesn't apply any more, at least on a full run, 
> tho it still cuts short if you use the dry-run option.  Additionally, the 
> dry-run option gave me some metadata restoration errors that a full write-
> files run didn't give me, so dry-run ends up being rather more 
> pessimistic about what can be restored than what it actually restores.

Please ignore the last post - had 2 typos in it that could confuse my problem as to where I now got stuck (btrfs-show-super instead of btrfs-find-root, btrfs-progs version)


Duncan,

Many thanks for taking the time to look at my case, and to make the effort of writing such an elaborate response - much appreciated. 
I understand the direction I should be taking, and by just reading your response have learned quite a bit already.

Unfortunately I got stranded right at the get-go, with the btrfs-find-root command not working for me. Let me share a couple of outputs, and hopefully you or others can point me where to go from here.
As a side-note, I did update to btrfs-progs 4.0 from 3.19.1 as suggested.

$ btrfs --version
btrfs-progs v4.0

$ sudo uname -a
Linux thejay-srv03 4.0.0-040000-generic #201504121935 SMP Sun Apr 12 23:36:33 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

Just for clarity - this is a btrfsraid6 pool.

$ sudo btrfs fi show /dev/sdy
warning, device 2 is missing
warning devid 2 not found already
checksum verify failed on 21200896 found 44715E95 wanted A092E323
checksum verify failed on 21200896 found 91AC994F wanted 987F5E0F
checksum verify failed on 21200896 found 44715E95 wanted A092E323
bytenr mismatch, want=21200896, have=65536
Couldn't read chunk tree
Label: 'roms03'  uuid: b0025417-4045-4c63-a432-0625b7cc41ea
	Total devices 4 FS bytes used 2.67TiB
	devid    1 size 1.36TiB used 1.36TiB path /dev/sdy
	devid    3 size 1.36TiB used 1.36TiB path /dev/sdz
	devid    4 size 1.36TiB used 1.36TiB path /dev/sdaa
	*** Some devices missing

btrfs-progs v4.0

$ sudo btrfs-find-root /dev/sdy
warning, device 2 is missing
warning devid 2 not found already
Couldn't read chunk tree
Open ctree failed


(above output is the same for the other 2 drives sdz and sdaa)

$ sudo btrfs-show-super /dev/sdy
superblock: bytenr=65536, device=/dev/sdy
---------------------------------------------------------
csum			0x8c55bcfe [match]
bytenr			65536
flags			0x1
magic			_BHRfS_M [match]
fsid			b0025417-4045-4c63-a432-0625b7cc41ea
label			roms03
generation		17310
root			1622245376
sys_array_size		290
chunk_root_generation	16372
root_level		1
chunk_root		20971520
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		6001207640064
bytes_used		2937720725504
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		4
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
cache_generation	17310
uuid_tree_generation	17310
dev_item.uuid		f39d7af1-1eec-4f99-8353-4c70371e1942
dev_item.fsid		b0025417-4045-4c63-a432-0625b7cc41ea [match]
dev_item.type		0
dev_item.total_bytes	1500301910016
dev_item.bytes_used	1500301885440
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0

----

$ sudo btrfs-show-super /dev/sdz
superblock: bytenr=65536, device=/dev/sdz
---------------------------------------------------------
csum			0xb48f16eb [match]
bytenr			65536
flags			0x1
magic			_BHRfS_M [match]
fsid			b0025417-4045-4c63-a432-0625b7cc41ea
label			roms03
generation		17310
root			1622245376
sys_array_size		290
chunk_root_generation	16372
root_level		1
chunk_root		20971520
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		6001207640064
bytes_used		2937720725504
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		4
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
cache_generation	17310
uuid_tree_generation	17310
dev_item.uuid		6560226f-a966-4699-8a9e-e7377d436cc6
dev_item.fsid		b0025417-4045-4c63-a432-0625b7cc41ea [match]
dev_item.type		0
dev_item.total_bytes	1500301910016
dev_item.bytes_used	1500300836864
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		3
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0

----

$ sudo btrfs-show-super /dev/sdaa
superblock: bytenr=65536, device=/dev/sdaa
---------------------------------------------------------
csum			0xf3cbbf1f [match]
bytenr			65536
flags			0x1
magic			_BHRfS_M [match]
fsid			b0025417-4045-4c63-a432-0625b7cc41ea
label			roms03
generation		17310
root			1622245376
sys_array_size		290
chunk_root_generation	16372
root_level		1
chunk_root		20971520
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		6001207640064
bytes_used		2937720725504
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		4
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
cache_generation	17310
uuid_tree_generation	17310
dev_item.uuid		3c026bb0-dcf0-45da-8c90-cb668323180d
dev_item.fsid		b0025417-4045-4c63-a432-0625b7cc41ea [match]
dev_item.type		0
dev_item.total_bytes	1500301910016
dev_item.bytes_used	1500300836864
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		4
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0

