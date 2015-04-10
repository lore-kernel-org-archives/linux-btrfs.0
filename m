Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32831 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbbDJG7I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Apr 2015 02:59:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YgSuA-0002cH-Et
	for linux-btrfs@vger.kernel.org; Fri, 10 Apr 2015 08:59:06 +0200
Received: from 168.159.160.58 ([168.159.160.58])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2015 08:59:06 +0200
Received: from toyours_sridhar by 168.159.160.58 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2015 08:59:06 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs: identify only used blocks (both metadata and data) of subvolume or entire root partition.
Date: Fri, 10 Apr 2015 06:58:59 +0000 (UTC)
Message-ID: <loom.20150410T085749-489@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I looking for a way to collect all metadata and data blocks associated 
with a subvolume or entire btrfs and recreate the same by dumping all 
blocks on newly allocated disks and bring the file system back assuming 
same number of disks are provided.

Example is say for ext3/ext4 using the information of used block bit map 
information in each block group, I can Identify all used blocks of the 
ext3/ext4 partition and simply copy all blocks.
Above will contains all metadata + data blocks (only used)
For a 10 Gb disk and say only 2 gb is used, using above, I can collect all 
2bg blocks.

Thank I can simply dump those blocks to a destination partition and 
recreate the partition. 

In the same way I am looking something similar for btrfs. 

Could anybody let me know is there a way to do this or something similar I 
can work it out.

