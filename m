Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-relay2.uniserve.net ([216.210.109.135]:41493 "EHLO
	smtp-relay2.uniserve.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaLaDja (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 22:39:30 -0500
Received: from webapp1.uniserve.ca ([204.239.42.114])
	by smtp-relay2.uniserve.net with esmtp (Exim 4.72)
	(envelope-from <geek@uniserve.com>)
	id 1Y69yB-00027Q-F5
	for linux-btrfs@vger.kernel.org; Tue, 30 Dec 2014 19:29:11 -0800
Message-ID: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
Date: Tue, 30 Dec 2014 19:29:10 -0800
From: Dave Stevens <geek@uniserve.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: should I use btrfs on Centos 7 for a new production server?
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a well tested and working fine Centos5-Xen system. Accumulated  
cruft from various development efforts make it desirable to redo the  
install. Currently a RAID-10 ext4 filesystem with LVM and 750G of  
storage. There's a hot spare 750 drive in the system.

I'm thinking of migrating the web sites (almost the only use of the  
server) to a spare then installing Centos-7 and btrfs, then migrating  
the sites back.

I see RH marks btrfs in C7 as a technology preview but don't  
understand what that implies for future support and a suitably stable  
basis for storage.

The demand on the system is low and not likely to change in the near  
future, storage access speeds are not likely to be dealbreakers and it  
would be nice to not need to use LVM, btrfs seems to have a better  
feature set and more intuitive command set. But I'm uncertain about  
stability. Anyone have an opinion?

Dave

-- 
"As long as politics is the shadow cast on society by big business,
the attenuation of the shadow will not change the substance."

-- John Dewey





