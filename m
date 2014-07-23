Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42364 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750930AbaGWBwL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 21:52:11 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49365 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X9lj0-002IuJ-Ll
	for linux-btrfs@vger.kernel.org; Tue, 22 Jul 2014 19:52:10 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BUGS: bogus out of space reported when mounted raid1 degraded, btrfs replace failure, then oops
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
Date: Tue, 22 Jul 2014 19:52:09 -0600
Message-Id: <39C6221B-35AB-49FC-AD46-4641BFE16D63@colorremedies.com>
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Interesting, if I remove /dev/sdc (the hdd), then this command works:

[root@localhost ~]# mount -o degraded,recovery /dev/sdb /mnt
[root@localhost ~]# btrfs replace status /mnt
72.1% done, 0 write errs, 0 uncorr. read errs
72.1% done, 0 write errs, 0 uncorr. read errs^C

## above command hangs, but cancels with control-c

[root@localhost ~]# btrfs replace cancel /mnt
[root@localhost ~]# btrfs replace status /mnt
Started on 22.Jul 16:10:37, canceled on 22.Jul 19:41:23 at 0.0%, 0 write errs, 0 uncorr. read errs
[root@localhost ~]# btrfs balance start -dconvert=single -mconvert=single /mnt -f
Done, had to relocate 10 out of 10 chunks
[root@localhost ~]# btrfs fi show
Label: 'Rawhide2'  uuid: f857c336-b8f5-4f5d-9500-a705ee1b6977
	Total devices 2 FS bytes used 6.39GiB
	devid    1 size 12.58GiB used 7.03GiB path /dev/sdb
	*** Some devices missing

Btrfs v3.14.2
[root@localhost ~]# btrfs fi df /mnt
Data, single: total=6.00GiB, used=5.99GiB
System, single: total=32.00MiB, used=32.00KiB
Metadata, single: total=1.00GiB, used=412.00MiB
unknown, single: total=160.00MiB, used=0.00
[root@localhost ~]# btrfs device delete missing /mnt
[root@localhost ~]# btrfs fi show
Label: 'Rawhide2'  uuid: f857c336-b8f5-4f5d-9500-a705ee1b6977
	Total devices 1 FS bytes used 6.39GiB
	devid    1 size 12.58GiB used 7.03GiB path /dev/sdb

Btrfs v3.14.2

So it's recovered and back to normal.


Chris Murphy