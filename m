Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36431 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3CVKhd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 06:37:33 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2MAbWSW024602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 10:37:33 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2MAbVBa023343
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 10:37:32 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2MAbVQH013689
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 05:37:31 -0500
Message-ID: <514C33A2.9050709@oracle.com>
Date: Fri, 22 Mar 2013 11:34:10 +0100
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Adding a non-empty subvol to a qgroup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All,

When adding a subvolume to a qgroup, pre-existing files in that 
subvolume are not counted in the referenced/exclusive space of the 
qgroup. Is this intended behavior ?

I create a subvol with one file:

   # mkfs.btrfs /dev/sdg
   # mount /dev/sdg /mnt/fulldisk
   # cd /mnt/fulldisk
   # btrfs quota enable ./
   # btrfs sub create sub1
   # dd if=/dev/zero of=sub1/file1 bs=100000 count=1
   # sync
   # btrfs qgroup show ./
   0/257 106496 106496

Now I create a new qgroup on level 1 and add the qgroup of sub1 to it :

   # btrfs qgroup create 1/0 ./
   # btrfs qgroup assign 0/257 1/0 ./
   # sync
   # btrfs fi sync ./
   # btrfs quota rescan ./
   # btrfs quota rescan ./sub1
   # btrfs qgroup show ./
   0/257 106496 106496
   1/0 0 0

The pre-existing file does not contribute to the space numbers.

Let's create a new file:

   # dd if=/dev/zero of=sub1/file2 bs=50000 count=1
   # sync
   # btrfs qgroup show ./
   0/257 159744 159744
   1/0 53248 53248

We see that only the new file is included in the space numbers.

Now I remove the first file:

   # rm -f sub1/file1
   # sync
   # btrfs qgroup show ./
   0/257 57344 57344
   1/0 -49152 -49152

The space numbers go below zero. Even if the behavior above is intended, 
the removal of the pre-existing file should not result in negative space 
numbers.

Koen.
