Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25500 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbLEFMl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Dec 2015 00:12:41 -0500
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any kernel
 version
To: dsterba@suse.cz
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <20151123175608.GI31035@twin.jikos.cz>
 <20151204014402.GF19589@localhost.localdomain>
 <5660F5A3.3080409@cn.fujitsu.com> <20151204141936.GH31035@suse.cz>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, bo.li.liu@oracle.com,
        linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5662723D.8090903@oracle.com>
Date: Sat, 5 Dec 2015 13:12:29 +0800
MIME-Version: 1.0
In-Reply-To: <20151204141936.GH31035@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David,

> the possibility of unloaded module that would remove the access to
> sysfs, as you point out.

  Kindly note, the patch below made /dev/btrfs-control a static node,

-----
commit 578454ff7eab61d13a26b568f99a89a2c9edc881
Author: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu May 20 18:07:20 2010 +0200

driver core: add devname module aliases to allow module on-demand 
auto-loading
------

  And here the function, check_or_load_btrfs_ko(), in the PATCH v2 2/5,
  will take care of this problem.

--------
+
+int check_or_load_btrfs_ko()
+{
+	int fd;
+
+	/*
+	 * open will load btrfs kernel module if its not loaded,
+	 * and if the kernel has CONFIG auto load set?
+	 */
+	fd = open("/dev/btrfs-control", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	close(fd);
+	return 0;
+}
+
--------

  Since now static minor number for /dev/btrfs-control is mapped to
  the btrfs kernel module, it will ensure btrfs is loaded when
  /dev/btrfs-control is accessed.

  Further, /dev/btrfs-control node is created by udevd, by reading
  the modules.devname which is either supplied/updated by the distro
  or compilation.

  For systems without udev, IMO should run mknod ..btrfs-control
  in their install script which I guess is a must.

--------
# ls -li /dev/btrfs-control
7338 crw-rw---- 1 root disk 10, 234 Dec  5 10:45 /dev/btrfs-control

# cat modules.devname | egrep btrfs
btrfs btrfs-control c10:234

# cat ./include/linux/miscdevice.h | egrep BTRFS
#define BTRFS_MINOR 234
--------

  So IMO this is not a real problem.

Thanks, Anand

