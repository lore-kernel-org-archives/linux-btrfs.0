Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60161 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbcEZIrt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 04:47:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b5qxE-000203-HP
	for linux-btrfs@vger.kernel.org; Thu, 26 May 2016 10:47:44 +0200
Received: from 168.159.160.62 ([168.159.160.62])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 10:47:44 +0200
Received: from toyours_sridhar by 168.159.160.62 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 10:47:44 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs on disk consistency 
Date: Thu, 26 May 2016 08:47:39 +0000 (UTC)
Message-ID: <loom.20160526T103320-318@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In traditional file systems such as ext3/ext4 when a snapshot (say with 
LVM2) is taken, all I/O are frozen and entire file system including meta 
dta is part of snapshot. 

Btrfs snapshot also managed by file system itself and btrfs snapshot is 
actually does a sub volume snapshot which makes a portion of logical 
entity can be made read only so that no I/Os happen to that tree.

Since snapshot is at sub volume level, other metadata such as extent tree, 
chunk tree, super block etc.. will still in active state and I/Os can go 
on them will not get flushed to disk (which is not required for btrfs sub 
volume snapshot).


Since btrfs is always consistent (With COW and check-sum), does it holds 
good if I copy blocks at disk level to another disk starting form 0 to end 
of disk ?
My guess is NO.


Or is there a way to freeze I/Os at btrfs level so that entire metadata is 
flushed to the disk ( all trees such as extent tree, chunk tree or what 
ever metadata of btrfs file system used at VFS layer) so that  disk to 
disk copy can be triggered so that I will be having all sub volumes are 
copied to an alternate disk which I should be able to use on another 
machine or if the original disk is gone for toss. 





