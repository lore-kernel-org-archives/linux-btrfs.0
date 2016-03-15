Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34302 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbcCOOkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 10:40:05 -0400
Received: by mail-wm0-f51.google.com with SMTP id p65so147762819wmp.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 07:40:04 -0700 (PDT)
Received: from mariuss-mbp.intern (p57806b71.dip0.t-ipconnect.de. [87.128.107.113])
        by smtp.gmail.com with ESMTPSA id gt7sm27302906wjc.1.2016.03.15.07.40.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Mar 2016 07:40:02 -0700 (PDT)
From: =?utf-8?Q?Marius_R=C3=A4sener?= <m.raesener@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: raid 10 recovery
Message-Id: <3F4C0992-2328-41B9-9705-3ED1A21BBCA3@gmail.com>
Date: Tue, 15 Mar 2016 15:40:01 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey List,

I have a raid10 on a rockstor machine (centOS based "4.3.3-1.el7.elrepo.x86_64“) where one drive threw SMART errors.

So I tried to replace them.

1. mount in degraded worked
2. start replace with the new drive (btrfs replace start 4 /dev/sdf /mnt2/pool_name) worked fine first too
3. shutdown (from shutdown command and then after some minutes power off since it doesn’t happen anything anymore)

4. I can’t mount anymore and restart the procedure

here some logs:

[root@rockstor ~]# dmesg | tail
[ 2039.773261] BTRFS info (device sde): btrfs: use no compression
[ 2039.773265] BTRFS info (device sde): disk space caching is enabled
[ 2039.773266] BTRFS: has skinny extents
[ 2039.775221] BTRFS: failed to read chunk tree on sde
[ 2039.785544] BTRFS: open_ctree failed
[ 2039.892750] BTRFS info (device sde): btrfs: use no compression
[ 2039.892758] BTRFS info (device sde): disk space caching is enabled
[ 2039.892761] BTRFS: has skinny extents
[ 2039.894223] BTRFS: failed to read chunk tree on sde
[ 2039.909454] BTRFS: open_ctree failed

###########################
###########################
###########################

[root@rockstor ~]# btrfs fi sh
Label: 'rockstor_rockstor'  uuid: 43308bee-a17f-4b11-9bbf-e9bd3fcc7b6f
	Total devices 2 FS bytes used 1.44GiB
	devid    1 size 110.88GiB used 3.02GiB path /dev/sda3
	devid    2 size 1.82TiB used 0.00B path /dev/sdf

warning, device 4 is missing
warning devid 4 not found already
Label: 'waldpark'  uuid: bc36f340-8b89-421e-9288-b573457ed7de
	Total devices 4 FS bytes used 1.38TiB
	devid    1 size 1.82TiB used 708.01GiB path /dev/sdc
	devid    2 size 1.82TiB used 708.01GiB path /dev/sdd
	devid    3 size 1.82TiB used 707.54GiB path /dev/sde
	*** Some devices missing

###########################
###########################
###########################

[root@rockstor ~]# btrfs-show-super /dev/sdc
superblock: bytenr=65536, device=/dev/sdc
---------------------------------------------------------
csum			0x81ca0c6d [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			bc36f340-8b89-421e-9288-b573457ed7de
label			waldpark
generation		949
root			1288110080
sys_array_size		290
chunk_root_generation	902
root_level		1
chunk_root		1519382429696
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		8001595736064
bytes_used		1517774807040
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		4
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x161
			( MIXED_BACKREF |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
csum_type		0
csum_size		4
cache_generation	949
uuid_tree_generation	949
dev_item.uuid		e6ede03b-2432-4d75-ad85-399730ce0bc9
dev_item.fsid		bc36f340-8b89-421e-9288-b573457ed7de [match]
dev_item.type		0
dev_item.total_bytes	2000398934016
dev_item.bytes_used	760217600000
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0

###########################
###########################
###########################

[root@rockstor ~]# mount -o degraded /dev/sdc /mnt2/waldpark
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

###########################
###########################
###########################

[root@rockstor ~]# btrfs check /dev/sdc
warning, device 4 is missing
warning devid 4 not found already
Checking filesystem on /dev/sdc
UUID: bc36f340-8b89-421e-9288-b573457ed7de
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
checking quota groups
Ignoring qgroup relation key 258
Ignoring qgroup relation key 965
Ignoring qgroup relation key 966
Ignoring qgroup relation key 967
Ignoring qgroup relation key 567172078071971841
Ignoring qgroup relation key 567172078071971841
Ignoring qgroup relation key 567172078071971841
Ignoring qgroup relation key 567172078071971841
found 1517403873988 bytes used err is 0
total csum bytes: 1479836856
total tree bytes: 2050932736
total fs tree bytes: 451002368
total extent tree bytes: 51707904
btree space waste bytes: 112210244
file data blocks allocated: 1680396222464
 referenced 1666725031936
extent buffer leak: start 1136508928 len 16384
extent buffer leak: start 1130315776 len 16384
extent buffer leak: start 1230094336 len 16384
extent buffer leak: start 1689272320 len 16384
extent buffer leak: start 1689436160 len 16384