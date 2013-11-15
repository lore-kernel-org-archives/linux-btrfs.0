Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:39386 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752476Ab3KOPEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 10:04:39 -0500
Received: from [79.135.116.105] (helo=[192.168.0.103])
	by lon-b.elastichosts.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <alin.dobre@elastichosts.com>)
	id 1VhKTY-00070H-GW
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 14:34:24 +0000
Message-ID: <528630D6.5090103@elastichosts.com>
Date: Fri, 15 Nov 2013 14:33:58 +0000
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Subvolume creation returns file exists
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

We are using btrfs filesystems in our infrastructure and, at some point 
of time, they start refusing to create new subvolumes.

Each file system is being quota initialized immediately after its 
creation (with "btrfs quota enable") and then all subfolders under the 
root directory are created as subvolumes (btrfs subvolume create). Over 
time, these subvolumes may also be deleted. What's under subvolumes are 
just various files and directories, should not be related to this problem.

After a while of using this setup, without any obvious steps to 
reproduce it, the filesystem goes into a state where the following happens:
     # btrfs subvolume create btrfs_mount/test_subvolume
     Create subvolume 'btrfs_mount/test_subvolume'
     ERROR: cannot create subvolume - File exists

In regards to data, the filesystem is pretty empty, it only has a single 
empty directory. I don't know about the metadata, at this point.

The problem goes away if we disable and re-enable the quota. It all 
seems to be some dead metadata lying around.

Next are some facts about this. Since we found that it's the ioctl call 
which returns EEXIST, the place to further track the problem down was 
into the kernel module, which assumes that the userspace tools are not 
generating the problem. Here is a high level traceback of the problem:
     ioctl.c:create_subvol() returns -EEXIST
     cgroup.c:btrfs_qgroup_inherit() returns -EEXIST
     qgroup.c:add_qgroup_item() returns -EEXIST
     ctree.c:btrfs_insert_empty_item() returns -EEXIST
     ctree.c:btrfs_search_slot() returns 0
     ctree.c:key_search() returns 0

The problem appeared before our current kernel, which is a 3.8 version 
(along with Btrfs progs v0.19), however mounting an already broken 
filesystem in a 3.12 kernel (with Btrfs progs v0.20-rc1-358-g194aa4a) 
doesn't do any better.

Any thoughts on this? We can provide you with more information, if 
needed, even the broken filesystem itself.

Cheers,
Alin.
