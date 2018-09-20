Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56820 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731260AbeITLHy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 07:07:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8K5OWxD014793
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 05:26:18 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mgtqr8cpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 05:26:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8K5QHBH015750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 05:26:18 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8K5QHpO002779
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 05:26:17 GMT
From: anand.jain@oracle.com
Subject: Punch hole on full fs
To: linux-btrfs@vger.kernel.org
Message-ID: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
Date: Thu, 20 Sep 2018 13:26:15 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Test script [1] tries to punch hole on a full FS and it works fine as 
long as the hole size and the offset is aligned with the sectorsize and 
the extent, so that it could just drop the relevant extent to create the 
hole.

The reason why this test fails for non aligned hole size and offset is 
because, as it rightfully tries to truncate the non aligned extent at 
the front and back of the hole, it tries to create new extent which ends 
up with ENOSPC.

Any idea, how do we solve this?

xfs is fine.

[1]
cat ./punch-hole-on-full-fs
------------------------
cleanup()
{
	umount /dev/sdb > /dev/null 2>&1
	btrfs_reload
}

full_fs_setup()
{
	btrfs-dyndbg disable
	mkfs.$fs -b 200M -fq $mkfs_options /dev/sdb || exit
	mount $mount_options /dev/sdb /mnt/scratch || exit
	dd status=none if=/dev/zero of=/mnt/scratch/filler bs=512 > /dev/null 2>&1
}

test()
{
	cleanup
	full_fs_setup

	btrfs-dyndbg enable
	echo "---- fallocate -p -o 0 -l $punch_hole_size /mnt/scratch/filler ----"
	fallocate -p -o 0 -l $punch_hole_size /mnt/scratch/filler
}

fs=btrfs; mkfs_options=""; mount_options="";
[[ $1 ]] || { echo "usage: $0 <hole-len>"; exit; }
punch_hole_size=$1 && test
------------------------

./punch-hole-on-full-fs 512
-- fallocate -p -o 0 -l 512 /mnt/scratch/filler --
fallocate: /mnt/scratch/filler: fallocate failed: No space left on device

./punch-hole-on-full-fs 8000
-- fallocate -p -o 0 -l 8000 /mnt/scratch/filler --
fallocate: /mnt/scratch/filler: fallocate failed: No space left on device


Thanks, Anand
