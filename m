Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37008 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaAETBB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 14:01:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzswT-0006rD-RQ
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 20:00:57 +0100
Received: from 89-66-236-172.dynamic.chello.pl ([89.66.236.172])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 20:00:57 +0100
Received: from pp by 89-66-236-172.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 20:00:57 +0100
To: linux-btrfs@vger.kernel.org
From: Piotr =?iso-8859-2?q?Paw=B3ow?= <pp@siedziba.pl>
Subject: Re: Help! - "btrfs device delete missing" running out of space
Date: Sun, 5 Jan 2014 19:00:34 +0000 (UTC)
Message-ID: <laca4i$7lq$1@ger.gmane.org>
References: <labocc$5ue$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> distribution, used space on each device should be accordingly: 160, 
> 216, and 405.

The last number should be 376, I copied the wrong one. Anyway, I deleted 
as much data as possible, which probably won't help in the end, but at 
the moment it's still going. Meanwhile, I made a script to replicate this 
problem:

http://pastebin.com/W2c2pJYp

On kernel 3.12.6 the output is:

-------

WARNING! - Btrfs v0.20-rc1 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/loop1 id 2
fs created label (null) on /dev/loop0
	nodesize 4096 leafsize 4096 sectorsize 4096 size 40.00GB
Btrfs v0.20-rc1
17000+0 records in
17000+0 records out
17825792000 bytes (18 GB) copied, 533,571 s, 33,4 MB/s
Label: none  uuid: f8a01060-94c2-4665-b5ff-f134f9b6ad9b
	Total devices 2 FS bytes used 16.63GB
	devid    2 size 20.00GB used 18.01GB path /dev/loop1
	devid    1 size 20.00GB used 18.03GB path /dev/loop0

Btrfs v0.20-rc1
ERROR: error removing the device 'missing' - No space left on device
Label: none  uuid: f8a01060-94c2-4665-b5ff-f134f9b6ad9b
	Total devices 4 FS bytes used 16.62GB
	devid    4 size 10.00GB used 9.03GB path /dev/loop3
	devid    3 size 10.00GB used 9.25GB path /dev/loop2
	devid    1 size 20.00GB used 12.31GB path /dev/loop0
	*** Some devices missing

Btrfs v0.20-rc1

-------

The "delete missing" logic is pretty much broken, at least in this case. 
Instead of just replicating the data to other drives, it moves some of 
the data which fills up smaller drives and it fails with "No space left 
on device" error.

Regards

