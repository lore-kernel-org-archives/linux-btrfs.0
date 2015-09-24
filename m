Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36196 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbbIXSKJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 14:10:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZfAy5-0004Xz-56
	for linux-btrfs@vger.kernel.org; Thu, 24 Sep 2015 20:10:05 +0200
Received: from 92.243.181.209 ([92.243.181.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 20:10:05 +0200
Received: from matwey.kornilov by 92.243.181.209 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 20:10:05 +0200
To: linux-btrfs@vger.kernel.org
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Subject: btrfs: obtain block checksums from user space
Date: Thu, 24 Sep 2015 21:06:32 +0300
Message-ID: <mu1e38$io1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

I would like to read the list of the checksums for the specific file
stored onto btrfs filesystem. I think I could use the checksums in the
manner like rsync does, but safe both CPU (because csums are already
calculated for the file) and I/O (because I don't need to reread all the
file from the hard drive).

I've looked through linux kernel sources and not found appropriate ioctl
to do this. Frankly speaking, I've not found good documentations for all
available btrfs ioctls.

