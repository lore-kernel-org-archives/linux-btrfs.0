Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56038 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab3FPGFG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Jun 2013 02:05:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Uo65I-0004jD-2p
	for linux-btrfs@vger.kernel.org; Sun, 16 Jun 2013 08:05:04 +0200
Received: from 211.238.162.10 ([211.238.162.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Jun 2013 08:05:04 +0200
Received: from timcastle by 211.238.162.10 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Jun 2013 08:05:04 +0200
To: linux-btrfs@vger.kernel.org
From: Tim Castle <timcastle@gmail.com>
Subject: btrfs balance resume + raid5/6
Date: Sun, 16 Jun 2013 06:00:10 +0000 (UTC)
Message-ID: <loom.20130616T072808-446@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings! 

I'm testing raid6, and recently added two drives. 
I haven't been able to properly resume a balance operation: the number of
total chunks is always too low.  

It seems that the balance starts and pauses properly, but always resumes
with ~7 chunks. 

Here's an example: 

vendikar tim # uname -r
3.10.0-031000rc4-generic
vendikar tim # btrfs fi sho
Label: 'bank'  uuid: 682bd1f5-1bd3-479b-8882-867dfe32375f
	Total devices 7 FS bytes used 4.70TB
	devid    4 size 1.82TB used 1.44TB path /dev/dm-9
	devid    1 size 2.73TB used 1.44TB path /dev/dm-8
	devid    5 size 2.73TB used 1.44TB path /dev/dm-7
	devid    6 size 931.51GB used 207.00GB path /dev/dm-6
	devid    2 size 2.73TB used 1.44TB path /dev/dm-5
	devid    3 size 2.73TB used 1.44TB path /dev/dm-4
	devid    7 size 931.51GB used 207.00GB path /dev/dm-3

Btrfs v0.20-rc1-324-g650e656
vendikar tim # btrfs fi df bank/
Data, RAID6: total=4.71TB, used=4.69TB
System, RAID1: total=32.00MB, used=376.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=8.00GB, used=6.54GB

vendikar tim # btrfs balance start bank/ 
vendikar tim # btrfs balance status bank/
Balance on 'bank/' is running
3 out of about 1479 chunks balanced (4 considered), 100% left

vendikar tim # btrfs balance pause bank/
vendikar tim # btrfs balance status bank/
Balance on 'bank/' is paused
4 out of about 1479 chunks balanced (4 considered), 100% left

vendikar tim # btrfs balance resume bank
vendikar tim # btrfs balance status bank/
Balance on 'bank/' is running
1 out of about 4 chunks balanced (5 considered),  75% left

All the best, 
Tim 

