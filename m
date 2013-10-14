Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:27964 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757893Ab3JNUDT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:19 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:54813 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VVoMG-003zFN-BC
	for linux-btrfs@vger.kernel.org; Mon, 14 Oct 2013 14:03:16 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: mountinfo discrepancy, subvol vs subvolid
Message-Id: <90643ECD-0237-4F71-B751-67DC5B1A13D0@colorremedies.com>
Date: Mon, 14 Oct 2013 14:03:14 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When mounting a subvolume by name, mountinfo shows the name of the subvolume. When mounting a subvolume using subvolid it does not. Seems like a problem when trying to determine what is mounted.


-o subvol=<name>

# cat /proc/self/mountinfo | grep vda
43 34 0:29 /home /home rw,relatime shared:29 - btrfs /dev/vda1 rw,seclabel,space_cache
44 34 0:29 /boot /boot rw,relatime shared:30 - btrfs /dev/vda1 rw,seclabel,space_cache

-o subvolid=<number>


#cat /proc/self/mountinfo
43 34 0:29 / /home rw,relatime shared:29 - btrfs /dev/vda1 rw,seclabel,space_cache
44 34 0:29 / /boot rw,relatime shared:30 - btrfs /dev/vda1 rw,seclabel,space_cache


By changing default subvolume to the ID of home subvolume, then mounting with no options:

43 34 0:29 / /home rw,relatime shared:29 - btrfs /dev/vda1 rw,seclabel,space_cache


It seems the subvolid, and changed default subvolume behaviors are problematic, trying to determine what is mounted. I'd expect in all cases this should return a full path name, or a subvolume ID. 


kernel 3.11.4-301.fc20.x86_64
btrfs-progs-0.20.rc1.20130917git194aa4a-1.fc20.x86_64

Chris Murphy