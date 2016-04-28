Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37035 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbcD1Jta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 05:49:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aviZc-0004uh-9L
	for linux-btrfs@vger.kernel.org; Thu, 28 Apr 2016 11:49:28 +0200
Received: from 168.159.160.53 ([168.159.160.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 11:49:28 +0200
Received: from toyours_sridhar by 168.159.160.53 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 11:49:28 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: backup and restore consideration of btrfs
Date: Thu, 28 Apr 2016 09:49:14 +0000 (UTC)
Message-ID: <loom.20160428T113515-388@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs supports btrfs send and receive tools to backup subvolumes which is 
built in and good.

However considering the current storage data utilization in the industry, 
using send/receive would be very slow operation and kills lot of CUP 
cycles of source machine.

As an example, file systems such as ext3/ext4/xfs/ntfs file systems 
provides bitmap information so that backup applications can quickly backup 
used blocks and regenerate file system during recover.

Various techniques adopted around these layouts and protecting data of 
these file systems are very fast.

Off course these file systems doesn't manage any thing under FS layer. 
volume mangers such as LVM2, VXVM etc.. manages disks underneath but 
provides good snapshot capabilities to snapshot entire file system.

When it come to btrfs, only subvolume can be snap-shotted where as entire 
btrfs cannot. Also there is no way to backup subvolume as single entity 
and reuse it as individual btrfs file system with one subvolume.

In current btrfs send/receive solutions, btrfs receive does userlevel 
replay may not do image recovery to provide recovered btrfs with the 
subvolume backup.

Hope I made my point clear and would love to see btrfs providing native 
features which helps backup applications do faster backups.

