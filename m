Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.bluemoose.org.uk ([217.169.27.91]:41538 "EHLO
	mail.bluemoose.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaDAM4K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Apr 2014 08:56:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.bluemoose.org.uk (Postfix) with ESMTP id 1DC6958174
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Apr 2014 13:56:09 +0100 (BST)
Received: from mail.bluemoose.org.uk ([127.0.0.1])
	by localhost (mailtest.bluemoose.org.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OFiPlnaJ7MbB for <linux-btrfs@vger.kernel.org>;
	Tue,  1 Apr 2014 13:56:07 +0100 (BST)
Received: from SSW747599C (ssw747599c.sims.cranfield.ac.uk [138.250.107.38])
	(Authenticated sender: kim@bluemoose.org.uk)
	by mail.bluemoose.org.uk (Postfix) with ESMTPSA id BC217580F9
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Apr 2014 13:56:07 +0100 (BST)
From: <kim-btrfs@bluemoose.org.uk>
To: <linux-btrfs@vger.kernel.org>
Subject: BTRFS hangs - possibly NFS related?
Date: Tue, 1 Apr 2014 13:56:06 +0100
Message-ID: <019301cf4da9$bf837930$3e8a6b90$@bluemoose.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apologies if this is known, but I've been lurking a while on the list and
not seen anything similar - and I'm running out of ideas on what to do next
to debug it.

Small HP microserver box, running Debian, EXT4 system disk plus 4 disk BTRFS
array shared over NFS (nfs-kernel-server) and SMB - the disks recently moved
from a different box where they've been running faultlessly for months,
although that didn't use NFS.

Under reasonable combined NFS and SMB load with only a couple of clients,
the shares lock up, load average on server and clients goes high and stays
high (10-12) and stays there.     Apparently not actually CPU and there's
little if any disk activity on the server.

Killing NFS and/or Samba sometimes helps, but it's always back when the load
comes back on. Chased round NFS and Samba options, then find that when the
clients hang it's unresponsive on the server directly to the disk.

Notice  a "btrfs-transacti" process hung in "d".    As are all the NFS
processes:

3779 ?        S<     0:00 [nfsd4]
3780 ?        S<     0:00 [nfsd4_callbacks]
3782 ?        D      0:27 [nfsd]
3783 ?        D      0:27 [nfsd]
3784 ?        D      0:28 [nfsd]
3785 ?        D      0:26 [nfsd]

"sync" instantly unsticks everything and it all works again for another
couple of minutes, when it locks up again, same symptoms.     Nothing
apparently written to kern.log or dmesg, which has been the frustration all
through - I don't know where to find the culprit!

As a band-aid I've put 
btrfs filesystem sync /mnt/btrfs

In the crontab once a minute which is actually working just fine  and has
been all morning - every 5 minutes was not enough.

Any recommendations on where I can look next, or any known holes I've fallen
in.?  Do I need to force NFS clients to sync in their mount options?


Background:
Kernel - 3.13-1-amd64 #1 SMP Debian 3.13.7-1 (2014-03-25)    AMD N54L with
10GB RAM.

##################################################
        Total devices 4 FS bytes used 848.88GiB
        devid    2 size 465.76GiB used 319.03GiB path /dev/sdc
        devid    4 size 465.76GiB used 319.00GiB path /dev/sda
        devid    5 size 455.76GiB used 309.03GiB path /dev/sdb2
        devid    6 size 931.51GiB used 785.00GiB path /dev/sdd

##################################################
Data, RAID1: total=864.00GiB, used=847.86GiB
System, RAID1: total=32.00MiB, used=128.00KiB
Metadata, RAID1: total=2.00GiB, used=1009.93MiB

A "scrub" passes without finding any errors.      

There are a couple of VM images with light traffic which do fragment a
little but I manually defrag those every day so often and I haven't had any
problems there - it certainly isn't thrashing.



Cheers
Kim

