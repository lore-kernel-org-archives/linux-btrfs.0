Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:55392 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbaJUS7m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 14:59:42 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id ADCCA3E0108
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 20:59:38 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: device balance times
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 21 Oct 2014 20:59:38 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI - after a failed disk and replacing it I've run a balance; it took 
almost 3 weeks to complete, for 120 GBs of data:

# time btrfs balance start -v /home
Dumping filters: flags 0x7, state 0x0, force is off
   DATA (flags 0x0): balancing
   METADATA (flags 0x0): balancing
   SYSTEM (flags 0x0): balancing
Done, had to relocate 124 out of 124 chunks

real    30131m52.873s
user    0m0.000s
sys     74m59.180s


Kernel is 3.17.0-rc7.


Filesystem is not that big, merely 124 GB used out of 1.8 TB:

/dev/sdb4                                               1.8T  124G  1.6T 
   8% /home

# btrfs fi df /home
Data, RAID1: total=121.00GiB, used=117.56GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=8.00GiB, used=4.99GiB
GlobalReserve, single: total=512.00MiB, used=0.00

# btrfs fi show /home
Label: none  uuid: 84d087aa-3a32-46da-844f-a233237cf04f
         Total devices 2 FS bytes used 122.56GiB
         devid    2 size 1.71TiB used 129.03GiB path /dev/sdb4
         devid    3 size 1.71TiB used 129.03GiB path /dev/sda4


The only special thing about this filesystem is that there are ~250 
snapshots there:

# btrfs sub list /home|wc -l
253

It's using compression:

/dev/sdb4 on /home type btrfs (rw,noatime,compress=lzo,space_cache)


Other than taking occasional backups from remote, the server is idle.

# hdparm -t /dev/sda /dev/sdb

/dev/sda:
  Timing buffered disk reads: 394 MB in  3.01 seconds = 131.03 MB/sec

/dev/sdb:
  Timing buffered disk reads: 402 MB in  3.00 seconds = 133.86 MB/sec



How long does the balance take for others with "many" snapshots?




-- 
Tomasz Chmielewski
http://www.sslrack.com

