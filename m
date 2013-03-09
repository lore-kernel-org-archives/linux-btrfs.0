Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56591 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3CIMEm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Mar 2013 07:04:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UEIWN-0001uB-BU
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 13:05:03 +0100
Received: from 195.238.191.47 ([195.238.191.47])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2013 13:05:03 +0100
Received: from mr.swasher by 195.238.191.47 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2013 13:05:03 +0100
To: linux-btrfs@vger.kernel.org
From: Swasher <mr.swasher@gmail.com>
Subject: Balance terminating
Date: Sat, 9 Mar 2013 12:03:07 +0000 (UTC)
Message-ID: <loom.20130309T124930-192@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, i'm started balancing on my raid0:

$ btrfs fi show
Label: none  uuid: efdcd026-f5f0-49e7-a173-8eb777018119
        Total devices 3 FS bytes used 4.57TB
        devid    3 size 1.82TB used 1.82TB path /dev/sdd
        devid    1 size 1.82TB used 1.82TB path /dev/sdc
        devid    2 size 1.82TB used 1.82TB path /dev/sdb

Btrfs Btrfs v0.19

After it, I'm start watch for progress via 'balance status', and I can see how 
progress run. But only for 83% left. 

I'm wait few hours and try cancel it with 'balance cancel'.
More than 12 hours had passed, but balance stalled in this state:

$ btrfs fi balance status /mnt/raid/  
Balance on '/mnt/raid/' is running, cancel requested
386 out of about 2231 chunks balanced (387 considered),  83% left

Question: Can I'm safetly reboot server? Or should I do something else?


