Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47873 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbbC3U7R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 16:59:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YcgmB-0006Ot-OB
	for linux-btrfs@vger.kernel.org; Mon, 30 Mar 2015 22:59:15 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 22:59:15 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 22:59:15 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: ERROR: error removing the device '/dev/sdXN' - Inappropriate ioctl
 for device
Date: Mon, 30 Mar 2015 21:59:05 +0100
Message-ID: <mfcdep$d97$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Help welcomed...


Trying to delete one device from a btrfs raid1 across 3 devices gives
for my example:


btrfs device delete /dev/sdf5 /mnt/data2

ERROR: error removing the device '/dev/sdf5' - Inappropriate ioctl for
device


That part of the filesystem is:

Label: 'btrfs_data2'  uuid: 3aaee716-b98b-4c86-ba5a-53456994f152
        Total devices 3 FS bytes used 192.45GiB
        devid    1 size 206.47GiB used 206.02GiB path /dev/sdb5
        devid    2 size 206.47GiB used 206.47GiB path /dev/sdd5
        devid    3 size 206.47GiB used 206.47GiB path /dev/sdf5


All on: 3.14.10-gentoo


Before I do a mega-yank-up to the 3.18 kernel, is the above a known
problem or am I missing something?


(Device delete needed due to that device throwing sector errors :-( )

Thanks,
Martin

