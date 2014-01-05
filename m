Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55444 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbaAEN6D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 08:58:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzoDF-00083R-3T
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 14:57:57 +0100
Received: from 89-66-236-172.dynamic.chello.pl ([89.66.236.172])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 14:57:57 +0100
Received: from pp by 89-66-236-172.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 14:57:57 +0100
To: linux-btrfs@vger.kernel.org
From: Piotr =?iso-8859-2?q?Paw=B3ow?= <pp@siedziba.pl>
Subject: Help! - "btrfs device delete missing" running out of space
Date: Sun, 5 Jan 2014 13:57:32 +0000 (UTC)
Message-ID: <labocc$5ue$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I replaced a failed 500G disk in btrfs raid1 with 2 smaller ones - 200 
and 250GB. I started "btrfs device delete missing" command, which is 
running since friday, and it still seems far from finished.

It seems to be doing something very strange: used space on the largest 
drive is going down, while smaller drives are filling up to the brim.

I'm afraid it will soon run out of space and I don't know what to do.

The current situation is:

Label: none  uuid: cff1e711-97fe-4c1c-b8a3-6184010b5027
	Total devices 4 FS bytes used 376.66GB
	devid    4 size 172.81GB used 167.00GB path /dev/dm-16
	devid    3 size 232.88GB used 227.00GB path /dev/dm-4
	devid    2 size 452.26GB used 327.01GB path /dev/dm-0
	*** Some devices missing

According to btrfs FAQ and http://carfax.org.uk/btrfs-usage, there should 
be around 404GB of usable space in this configuration. Assuming even 
distribution, used space on each device should be accordingly: 160, 216, 
and 405. The current situation is FAR from that.

I'd be grateful for tips what do to and how to get out of this situation.

Regards

