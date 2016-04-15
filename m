Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60589 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbcDOMl6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 08:41:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ar34D-0004cV-AD
	for linux-btrfs@vger.kernel.org; Fri, 15 Apr 2016 14:41:55 +0200
Received: from 168.159.160.57 ([168.159.160.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 14:41:45 +0200
Received: from toyours_sridhar by 168.159.160.57 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 14:41:45 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs-image and btrfs send related queries
Date: Fri, 15 Apr 2016 12:41:36 +0000 (UTC)
Message-ID: <loom.20160415T142724-462@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have couple of queries related to btrfs-image, btrfs send and with 
combination of two.
1)
I would like to know if a btrfs source file system is spread across more 
than 1 disks, does btrfs-image require same number of disks to create 
empty file system without files content??


2) would btrfs-image can be modified to keep only given subvolume foot 
print and related meta data to bring back file system live on destination 
disk?

   To elaborate more on this, Lets say I have 5 subvolumes on source btrfs 
and i run btrfs-image written to destination disk say /dev/sdd. In this 
process, can btrfs-image modified to just have only 1 subvolume and skipp 
other 4 subvolumes and write to destination i.. /dev/sdd so that when I 
mount /dev/sdd , I will have btrfs with only 1 subvolume with no data.

3) If 3 can successful, can btrfs-image further changed to include data of 
selected subvolume which gives files data also written to /dev/sdd which 
would be kind of a backup of a subvolume taken out of a btrfs file system 
which is having more than 1 subvolumes.



