Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60378 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbbDVLTm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 07:19:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yksgj-0004PC-77
	for linux-btrfs@vger.kernel.org; Wed, 22 Apr 2015 13:19:29 +0200
Received: from 168.159.160.58 ([168.159.160.58])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 13:19:29 +0200
Received: from toyours_sridhar by 168.159.160.58 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 13:19:29 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs snapshot root level and for subvolumes
Date: Wed, 22 Apr 2015 11:19:19 +0000 (UTC)
Message-ID: <loom.20150422T130823-598@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I btrfs file system created with one device /dev/sdb and mounted under 
/btrfs1.

created one file /btrfs1/errno.h, one directory /btrfs1/dir1 and 
2 subvolumes /btrfs1/subvol1 and /btrfs/subvol2

create directories and files under subvolume /btrfs1/subvol1.
Nothing inside /btrfs1/subvol2.

Below is tree representation of the file system.

#cd /btrfs1
#tree /btrfs1
 - errno.h
  -dir1
     - file1
     - file2
  -subvol1
     -dir1
       -file1
     -file2

  -subvol2


at root level of /btrfs1, i have one file errno.h, dir1, and 2 
subvolumes subvol1, subvol2.

When I create snapshot for subvol1 (say snap_subvol1), I can able to see 
all files and directories of subvol1 are showed in /btrfs1/snap_subvol1

But when I create snapshot at btrfs1 level by using below command
"btrfs subvolume snapshot /btrfs1 /btrfs1/root_snap"

and see contents of /btrfs1/root_snap, I can able to see all root level 
files and directories but cannot find any files and directories inside 
subvol1.

My question is can't we take btrfs root level snapshot and get snapshot  
of everything under root file system ??
Is btrfs subvolume snapshot is only to take subvolume snapshot?

If it so, is there a way to take snapshot at root level? (in this case 
/btrfs1)

I am just confused how subvolume snapshot work in this case.

