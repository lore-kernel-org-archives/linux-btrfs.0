Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52316 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbbD0MFm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 08:05:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ymhn5-0003cW-8Y
	for linux-btrfs@vger.kernel.org; Mon, 27 Apr 2015 14:05:35 +0200
Received: from 168.159.160.54 ([168.159.160.54])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 14:05:35 +0200
Received: from toyours_sridhar by 168.159.160.54 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 14:05:35 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs freeze/thaw when using with LVM2
Date: Mon, 27 Apr 2015 12:05:28 +0000 (UTC)
Message-ID: <loom.20150427T140306-446@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I would like to know if btrfs file system is created on LVM2 logical 
volumes, does freeze and thaw operations takes place for btrfs to make 
file system consistent??


If not is there a way (ioctl etc..) to run btrfs freeze/thaw before and 
after creating LVM2 snapshot of a btrfs file system?

Thank you in advance.

