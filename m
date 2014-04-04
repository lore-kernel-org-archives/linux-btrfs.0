Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from locke.effortlessis.com ([208.53.66.14]:53607 "EHLO
	locke.effortlessis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaDDA0x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Apr 2014 20:26:53 -0400
Received: from tesla.schoolpathways.com (173-166-236-97-sacramento.hfc.comcastbusiness.net [173.166.236.97])
	by locke.effortlessis.com (Postfix) with ESMTPSA id BB11C44F9D
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Apr 2014 00:26:47 +0000 (UTC)
Message-ID: <533DFC46.8020704@benjamindsmith.com>
Date: Thu, 03 Apr 2014 17:26:46 -0700
From: Lists <lists@benjamindsmith.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Hard restart required
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Trying out BTRFS today for the first time after a few false starts with 
three drives configured raid1. I'm using Oracle Linux 6/64 with all 
updates applied on unremarkable hardware. (cast off Dell Core2 desktop, 
2 GB RAM, no known problems) Here's what it looks like:

[root@oracle ~]# btrfs filesystem show
Label: none  uuid: bdaf3d87-f992-4a89-9e2b-41de0b5ff909
     Total devices 3 FS bytes used 448.82MB
     devid    2 size 1.36TB used 167.01GB path /dev/sdc
     devid    3 size 1.82TB used 167.01GB path /dev/sdd
     devid    1 size 931.51GB used 2.02GB path /dev/sdb

It hard locked and required a power-off system restart. Is this 
atypical? Here's what did it, this should be OK?

# mount -U bdaf3d87-f992-4a89-9e2b-41de0b5ff909 /media/btrfs;

UUID should work, right? Why else have a UUID if not? Currently, I'm 
using below in /etc/fstab, but this is not preferred since I'm expecting 
hard disks to come and go in my eventual use case - I'm rather certain 
that /dev/sdc will not be the correct drive to mount at some point:

/dev/sdc    /backups/spfs     btrfs noatime,subvol=spfs,compress    0 0


Thanks,

-Ben
