Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33606 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab3HSJjD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 05:39:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VBLvR-0002jJ-Rq
	for linux-btrfs@vger.kernel.org; Mon, 19 Aug 2013 11:39:01 +0200
Received: from dyndsl-080-228-186-133.ewe-ip-backbone.de ([80.228.186.133])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 11:39:01 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-186-133.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 11:39:01 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Extreme performance loss since 3.9
Date: Mon, 19 Aug 2013 11:38:48 +0200
Message-ID: <9m59ea-ql1.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list!

During 3.9 I had dead-lock problems with autodefrag. The system either froze 
or showed some kernel oopses randomly while working with the system. So I 
turned off autodefrag and the problem was cured.

But that radically slowed my system down over time. My desktop programs now 
take almost 10 times as long to start in comparision to 3.8 and beginning of 
3.9 before I hit the bug. This also affects opening file dialogs, browsing 
directories with the graphical filebrowser, hell: Even right-click menus 
sometimes take ages to open while the harddisk LED happily brightens my 
room.

I have a three device btrfs filesystem (rotational, 3x 1TB) with non-forced 
lzo compression. Before, startup of KDE programs was almost immediatly after 
clicking on the icons - even after login.

Now, since 3.10 the freeze bug seems to be fixed and I turned autodefrag 
back on. But the performance simply does not return (I did not expect the 
effect to be immediatly). Then, I've turned on skinny extent which made a 
little subjective difference. But still the system is far from the 
performance before I turned off autodefrag.

I'm not sure if there is still some performance regression bug in 3.10 or if 
I have to run some defragmentation. I've run a defrag on each directory with

find / -xdev -type d -print0 | xargs -0 btrfs fi defrag -v

and it helped (apparently only) a little but after a few days of usage the 
system returns to its newly developed slowness. :-(

I've changed nr_requests in the I/O scheduler to 4096 which also gives a 
subjective small speed boost during I/O intensive loads. The system has 16 
GB of memory with at least 8 GB cached most of the time. So it is no memory 
pressure problem.

Unfortunatly, the defrag process does not finish. Somewhere in the process 
the system hard freezes with no chance to get a backtrace from kernel. At 
least it works for almost the complete filesystem so it should be 
sufficient.

A friend of mine with a single SSD reports similar slowdown issues lately 
and it makes him almost wanting to return to Ext4.

My btrfs system was so blazing fast in the beginning, and now when it starts 
to get older (almost 2 years now), it comes to a crawl. And it started with 
turning off autodefrag and never returned to its old speed when I turned it 
back on.

I'm not doing any snapshots on this system which would explain increased 
fragmentation.

Are there any known issues? Are there suggestions how to investigate or fix 
it?

Mount options:
/dev/sda3 on / type btrfs (rw,relatime,compress=lzo,space_cache,autodefrag)

Label: 'system'  uuid: d2bb232a-2e8f-4951-8bcc-97e237f1b536
        Total devices 3 FS bytes used 1.07TB
        devid    3 size 927.26GB used 428.03GB path /dev/sdc3
        devid    2 size 927.26GB used 428.03GB path /dev/sdb3
        devid    1 size 927.26GB used 429.07GB path /dev/sda3

Data, RAID0: total=1.15TB, used=1.06TB
System, RAID1: total=64.00MB, used=96.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=56.00GB, used=4.46GB


Thanks,
Kai

