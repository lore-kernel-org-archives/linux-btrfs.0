Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab3HPITG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 04:19:06 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7G8J45I032377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 04:19:04 -0400
Received: from dhcp-1-102.brq.redhat.com (dhcp-1-102.brq.redhat.com [10.34.1.102])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7G8J2Jf003006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 04:19:04 -0400
Date: Fri, 16 Aug 2013 10:19:02 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: How btrfs resize should work ?
Message-ID: <alpine.LFD.2.00.1308161011160.1968@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am working on system storage manager (ssm) trying to implement
btrfs resize correctly, however I have some troubles with it.


# mkfs.btrfs /dev/sda /dev/sdb
# mount /dev/sda /mnt/test

# btrfs filesystem show
failed to open /dev/sr0: No medium found
Label: none  uuid: 8dce5578-a2bc-416e-96fd-16a2f4f770b7
	Total devices 2 FS bytes used 28.00KB
	devid    2 size 50.00GB used 2.01GB path /dev/sdb
	devid    1 size 100.00GB used 2.03GB path /dev/sda

Btrfs v0.20-rc1

# btrfs filesystem resize 3G /mnt/test


# sync
# btrfs filesystem show
failed to open /dev/sr0: No medium found
Label: none  uuid: 8dce5578-a2bc-416e-96fd-16a2f4f770b7
	Total devices 2 FS bytes used 796.00KB
	devid    2 size 50.00GB used 2.01GB path /dev/sdb
	devid    1 size 3.00GB used 2.03GB path /dev/sda

So it appears that it only resized part of the file system which
lies on /dev/sda to 3G. This behavior is confusing as hell, is this
really desirable behaviour ?

I do understand that you're able to specify devid to resize, however
without devid specification this kind of does not make any sense. dm
get it right, and it also has several different policies on handling
this stuff and it was not easy to get this right. Is btrfs going to
fix this somehow, it does it expect user to take care of this (I
hope not). Because currently ssm is not able to resize btrfs
correctly.

Thanks!
-Lukas
