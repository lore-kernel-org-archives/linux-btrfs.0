Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3CZXkZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 19:40:25 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2QNeMhM014087
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 23:40:23 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2QNeM7M013532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 23:40:22 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2QNeLX2004212
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 18:40:21 -0500
Message-ID: <5152311B.40908@oracle.com>
Date: Wed, 27 Mar 2013 00:36:59 +0100
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: The -c option of btrfs qgroup limit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All,

The "btrfs qgroup limit" command has an option -c which means "limit amount
of data after compression". Whether this option is specified or not, I seem
to be able to write more well-compressible data than the specified limit. I
was expecting that omitting the -c option would never allow me to write
more data than specified by the limit. Am I missing something? Which
difference in behavior should I expect from the -c option?

Koen.

---

This is what I did:

Mount a btrfs filesystem with the compress option and turn on quota:
   # mkfs.btrfs -f /dev/sdg2
   # mount -o compress /dev/sdg2 /mnt
   # cd /mnt
   # btrfs quota enable ./

Create a subvol and limit the amount of data after compression. Write some
well-compressible files:
   # btrfs subvol create subvol1
   # btrfs qgroup limit -c 3m ./subvol1
   # for i in `seq 1 5`; do
         dd if=/dev/zero of=subvol1/file$i bs=1024 count=1000;
         sync;
     done
   (no errors)
   # du -s subvol1
   5000 subvol1
We can write 5 MB of data to a file that is limited to 3 MB, which is 
normal
in this case because data from /dev/zero is very good compressible.

Create a subvol and limit the amount of data after compression. Write some
poorly compressible files:
   # btrfs subvol create subvol2
   # btrfs qgroup limit -c 3m ./subvol2
   # for i in `seq 1 5`; do
         dd if=/dev/urandom of=subvol2/file$i bs=1024 count=1000;
         sync;
     done
   dd: writing `subvol2/file4': Disk quota exceeded
   dd: opening `subvol2/file5': Disk quota exceeded
   # du -s subvol2
   3056 subvol2
Here we get quota violations, because data from /dev/urandom is poorly
compressible.

Now write some well-compressible data to a subvol that is limited without
the -c option:
   # btrfs subvol create subvol3
   # btrfs qgroup limit 3m ./subvol3
   # for i in `seq 1 5`; do
         dd if=/dev/zero of=subvol3/file$i bs=1024 count=1000;
         sync;
   done
   (no errors)
   # du -s subvol3
   5000 subvol3
We're still able to write 5 MB of data to a subvol that is limited to 3 MB.
