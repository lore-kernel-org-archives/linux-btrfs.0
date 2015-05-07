Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34676 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbbEGIoo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 May 2015 04:44:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YqHQA-0005YR-9m
	for linux-btrfs@vger.kernel.org; Thu, 07 May 2015 10:44:42 +0200
Received: from 168.159.160.53 ([168.159.160.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 10:44:42 +0200
Received: from toyours_sridhar by 168.159.160.53 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 10:44:42 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: strange behavior btrfs copy
Date: Thu, 7 May 2015 08:44:35 +0000 (UTC)
Message-ID: <loom.20150507T103552-598@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs file system /b1 on /dev/sdb with 2 subvolumes and 2 
snapshots of them.

I have written a code which takes 2 disks as input source: /dev/sdb and 
destination as /dev/sdc and copies entire disk in 512 byte chunks to 
desination /dev/sdc.

my source btrfs /dev/sdb is mounted /b1 currently and mount command show 
the same.

I ran above program and it is successful. and now everything in /dev/sdb 
is copied to /dev/sdc

but after this when I run mount command at CLI, i am seeing strange 
behaviour and output show /dev/sdc is mounted on /b1.

Some how it changes device from /dev/sdb to /dev/sdc on the fliy.

I also tried to cd to /b1 (which make /b1 is in use) and ran same 
program, still after copy from /dev/sdb to /dev/sdc, mount shows 
/dev/sdc is mounted on /b1


what could be the reason for this?

does btrfs do any polling or something?

since /dev/sdb and /dev/sdc contains same data, i can mount /dev/sdc 
independently.


