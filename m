Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:50646 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab3I2HsR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Sep 2013 03:48:17 -0400
Received: from [2002:5c20:f13a::1] (helo=nerv.dolda2000.com)
	by moltke.seatribe.se with esmtp (Exim 4.72)
	(envelope-from <fredrik@dolda2000.com>)
	id 1VQBCR-0003lC-Se
	for linux-btrfs@vger.kernel.org; Sun, 29 Sep 2013 09:13:52 +0200
Received: from [2002:5c20:f13a:200:ca60:ff:fe16:97ac] ([IPv6:2002:5c20:f13a:200:ca60:ff:fe16:97ac])
	(authenticated bits=0)
	by nerv.dolda2000.com (8.14.3/8.14.3/Debian-9.4) with ESMTP id r8T7DlPe005133
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 09:13:50 +0200
Date: Sun, 29 Sep 2013 09:13:47 +0200 (CEST)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: linux-btrfs@vger.kernel.org
Subject: Progress of device deletion?
Message-ID: <alpine.DEB.2.10.1309290902050.24007@shack.dolda2000.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

Is there a way to find out what "btrfs device delete" is doing, and how 
far it has come? I know there's no "status" command, but I'm thinking it 
might be possible to obtain something via some other channel, such as 
"btrfs fi df" and "btrfs fi show", which I have been using to try and 
figure out what is happening.

In this context, I've been trying to remove two drives from a filesystem 
of four, using the following command:

btrfs dev del /dev/sdg1 /dev/sdh1 /home/pub

It has been running for almost 36 hours by now, however, and I'm kinda 
wondering what's happening. :)

I've been trying to monitor it using "btrfs fi df /home/pub" and "btrfs fi 
show". Before starting to remove the devices, they gave the following 
output:

$ sudo btrfs fi df /home/pub
Data, RAID0: total=10.9TB, used=3.35TB
System, RAID1: total=32.00MB, used=200.00KB
Metadata, RAID1: total=5.00GB, used=3.68GB

$ sudo btrfs fi show
Label: none  uuid: 40d346bb-2c77-4a78-8803-1e441bf0aff7
         Total devices 4 FS bytes used 3.35TB
         devid    5 size 2.73TB used 2.71TB path /dev/sdh1
         devid    4 size 2.73TB used 2.71TB path /dev/sdg1
         devid    3 size 2.73TB used 2.71GB path /dev/sdd1
         devid    2 size 2.73TB used 2.71GB path /dev/sde1

The Data part of the "df" output has since been decreasing (which I have 
been using as sign of progress), but only until it hit 3.36 TB:

$ sudo btrfs fi df /home/pub/video/
Data, RAID0: total=3.36TB, used=3.35TB
System, RAID1: total=32.00MB, used=200.00KB
Metadata, RAID1: total=5.00GB, used=3.68GB

It has been sitting there for quite some hours by now. "show", on its 
hand, displays the following:

$ sudo btrfs fi show
Label: none  uuid: 40d346bb-2c77-4a78-8803-1e441bf0aff7
         Total devices 4 FS bytes used 3.35TB
         devid    5 size 2.73TB used 965.00GB path /dev/sdh1
         devid    4 size 2.73TB used 2.71TB path /dev/sdg1
         devid    3 size 2.73TB used 968.03GB path /dev/sdd1
         devid    2 size 2.73TB used 969.03GB path /dev/sde1

This I find quite weird. Why is the usage of sdd1 and sde1 decreasing, 
when those are not the disks I'm trying to remove, while sdg1 sits there 
at its original usage, when it is one of those I have requested to have 
removed? By the way, since the Data part hit 3.36TB, those usages of sdd1, 
sde1 and sdh1 have been fluctuating up and down between around 850GB up to 
around those values shown right now.

Is there any way I can find out what's going on?

--
Fredrik Tolf
