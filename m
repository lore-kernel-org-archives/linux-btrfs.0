Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47894 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbbEZIpW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 04:45:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YxAU6-0002A8-7v
	for linux-btrfs@vger.kernel.org; Tue, 26 May 2015 10:45:14 +0200
Received: from 168.159.160.61 ([168.159.160.61])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 10:45:14 +0200
Received: from toyours_sridhar by 168.159.160.61 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 10:45:14 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs on disk stability
Date: Tue, 26 May 2015 08:45:06 +0000 (UTC)
Message-ID: <loom.20150526T103943-385@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

According to btrfs wiki page, under "Stability status" it is written that

"The filesystem disk format is no longer unstable".

Does this mean if there are more I/Os are going on a btrfs file system, 
copy of entire disk (all disk blocks) gives a stable disk?

Just to elaborate more, if btrfs file system is created on 2 disks 
/dev/sda and /dev/sdb and if I start copying blocks of sda and sdb to sdc 
and sdc respectively by just opening file handlers of sda and sdb and 
mounting the new copy via /dev/sdc and /dev/sdd will give consistent file 
system??



