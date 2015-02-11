Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45835 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbbBLEcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 23:32:55 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t1C4Wr12031873
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t1C4WrhG010528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:53 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t1C4WrED005736
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] [Not for integration, experimental] Introduce /proc/fs/btrfs/devlist
Date: Thu, 12 Feb 2015 04:32:28 +0800
Message-Id: <1423686751-5053-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 An example is easy to understand so is below.
 Output is in Python config reader module format,
 just import of this output within a python script is enough.

 Useful for
   troubleshoot/debug,
   storage based on btrfs to render info on their bui/gui and
   further btrfs-progs could be very sleek if uses this.

[fsid: 763c600a-7af6-4b8a-a421-6611de307dbf]
	seed_fsid:		e962e198-ef98-4782-ae99-d0128c9f5c37
	fs_devs_addr:		ffff880046fb4400
	num_devices:		1
	open_devices:		1
	rw_devices:		1
	missing_devices:	0
	total_rw_devices:	1633799168
	total_devices:		3
	opened:			1
	seeding:		0
	rotating:		1
	super_kobj_state:	1
	super_kobj_insysfs:	1
	device_kobj_state:	1
	device_kobj_insysfs:	1
	[[uuid: 762f7b41-419e-438a-8a58-8a90f6642c18]]
		dev_addr:	ffff880046990000
		device:		/dev/sdg
		devid:		3
		dev_root_fsid:	763c600a-7af6-4b8a-a421-6611de307dbf
		generation:	37
		total_bytes:	1633799168
		dev_totalbytes:	1633799168
		bytes_used:	234881024
		type:		0
		io_align:	4096
		io_width:	4096
		sector_size:	4096
		mode:		0x83
		writeable:	1
		in_fs_metadata:	1
		missing:	0
		can_discard:	0
		replace_tgtdev:	0
		active_pending:	0
		nobarriers:	0
		devstats_valid:	1
		bdev:		not_null
	[[seed_fsid: e962e198-ef98-4782-ae99-d0128c9f5c37]]
		sprout_fsid:		763c600a-7af6-4b8a-a421-6611de307dbf
		seed_fsid:		1c52f894-0ead-43d6-847a-d42359f78370
		fs_devs_addr:		ffff88004586a400
		num_devices:		1
		open_devices:		1
		rw_devices:		0
		missing_devices:	0
		total_rw_devices:	0
		total_devices:		2
		opened:			1
		seeding:		1
		rotating:		1
		super_kobj_state:	1
		super_kobj_insysfs:	1
		device_kobj_state:	1
		device_kobj_insysfs:	1
		[[uuid: d064a43c-e9ce-42fb-9c01-140d2bdcd528]]
			dev_addr:	ffff880046991400
			device:		/dev/sdf
			devid:		2
			dev_root_fsid:	763c600a-7af6-4b8a-a421-6611de307dbf
			generation:	27
			total_bytes:	1633799168
			dev_totalbytes:	1633799168
			bytes_used:	167772160
			type:		0
			io_align:	4096
			io_width:	4096
			sector_size:	4096
			mode:		0x81
			writeable:	0
			in_fs_metadata:	1
			missing:	0
			can_discard:	0
			replace_tgtdev:	0
			active_pending:	0
			nobarriers:	0
			devstats_valid:	0
			bdev:		not_null
	[[seed_fsid: 1c52f894-0ead-43d6-847a-d42359f78370]]
		sprout_fsid:		e962e198-ef98-4782-ae99-d0128c9f5c37
		fs_devs_addr:		ffff88004586a000
		num_devices:		1
		open_devices:		1
		rw_devices:		0
		missing_devices:	0
		total_rw_devices:	0
		total_devices:		1
		opened:			1
		seeding:		1
		rotating:		1
		super_kobj_state:	1
		super_kobj_insysfs:	1
		device_kobj_state:	1
		device_kobj_insysfs:	1
		[[uuid: 4c9b2e81-e4b9-474c-9462-cc2dcd6117d5]]
			dev_addr:	ffff880046990800
			device:		/dev/sde
			devid:		1
			dev_root_fsid:	763c600a-7af6-4b8a-a421-6611de307dbf
			generation:	5
			total_bytes:	1633796096
			dev_totalbytes:	1633796096
			bytes_used:	180092928
			type:		0
			io_align:	4096
			io_width:	4096
			sector_size:	4096
			mode:		0x81
			writeable:	0
			in_fs_metadata:	1
			missing:	0
			can_discard:	0
			replace_tgtdev:	0
			active_pending:	0
			nobarriers:	0
			devstats_valid:	0
			bdev:		not_null


V2: Added 3/3 to support for sysfs kobjects that was moved to fs_devices

Anand Jain (3):
  Btrfs: procfs-devlist: introduce procfs interface for the device list
  Btrfs: procfs-devlist: backport global rcu-string non support
  Btsfs: procfs-devlist: update the sysfs contents

 fs/btrfs/Makefile  |   2 +-
 fs/btrfs/ctree.h   |   4 ++
 fs/btrfs/procfs.c  | 153 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/super.c   |   4 ++
 fs/btrfs/volumes.h |   1 +
 5 files changed, 163 insertions(+), 1 deletion(-)
 create mode 100644 fs/btrfs/procfs.c

-- 
2.0.0.153.g79dcccc

